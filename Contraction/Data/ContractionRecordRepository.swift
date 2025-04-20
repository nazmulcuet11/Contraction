//
//  RecordRepository.swift
//  Contraction
//
//  Created by Nazmul Islam on 4/19/25.
//

import Foundation

protocol ContractionRecordRepositoryDelegate: AnyObject {
    func didLoadRecords(_ records: [ContractionRecord]) async
    func didAddRecord(_ record: ContractionRecord) async
}

protocol ContractionRecordRepositoryProtocol {
    func fetchRecords() async throws -> [ContractionRecord]
    func addRecord(_ record: ContractionRecord) async throws
    func setDelegate(_ delegate: ContractionRecordRepositoryDelegate?) async
}

final actor ContractionRecordRepository: ContractionRecordRepositoryProtocol {
    private var records: [ContractionRecord] = []
    private var delegate: ContractionRecordRepositoryDelegate?

    func fetchRecords() async throws -> [ContractionRecord] {
        return records
    }

    func addRecord(_ record: ContractionRecord) async throws {
        records.append(record)
        await delegate?.didAddRecord(record)
        writeRecordsToDisk()
    }

    func setDelegate(_ delegate: ContractionRecordRepositoryDelegate?) {
        self.delegate = delegate
    }

    init(
        delegate: ContractionRecordRepositoryDelegate? = nil
    ) {
        self.delegate = delegate
        Task {
            await readRecordsFromDisk()
        }
    }

    // MARK: - Private

    private func loadRecordsFromDisk() async {
        self.records = readRecordsFromDisk()
        await delegate?.didLoadRecords(records)
    }

    private let encoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()

    private let decoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    private nonisolated var fileURL: URL? {
        let fileName = "contraction_records.json"
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        return fileURL
    }

    private func writeRecordsToDisk() {
        guard let fileURL else { return }
        do {

            let data = try encoder.encode(records)
            try data.write(to: fileURL)
            print("✅ JSON file written successfully to: \(fileURL)")
        } catch {
            print("❌ Failed to write JSON file: \(error)")
        }
    }

    private func readRecordsFromDisk() -> [ContractionRecord] {
        guard let fileURL else { return [] }
        do {
            let data = try Data(contentsOf: fileURL)
            let decodedRecords = try decoder.decode([ContractionRecord].self, from: data)
            return decodedRecords
        } catch {
            print("❌ Failed to read JSON file: \(error)")
            return []
        }
    }
}

final actor ContractionRecordStorage {

}

extension ContractionRecordRepository {
    static let shared = ContractionRecordRepository()
}
