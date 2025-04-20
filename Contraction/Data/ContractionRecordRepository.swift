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

final actor ContractionRecordRepository {
    private let contractionRecordskey: String = "CONTRACTION_RECORDS"
    private let userDefaults: UserDefaults

    private var delegate: ContractionRecordRepositoryDelegate?

    init(
        userDefaults: UserDefaults = .standard,
        delegate: ContractionRecordRepositoryDelegate? = nil
    ) {
        self.userDefaults = userDefaults
        self.delegate = delegate
    }

    func fetchRecords() async throws -> [ContractionRecord] {
        try readRecordsFromDisk()
    }

    func addRecord(_ record: ContractionRecord) async throws {
        var records = try readRecordsFromDisk()
        records.append(record)
        try writeRecordsToDisk(records: records)
        await delegate?.didAddRecord(record)
    }

    func setDelegate(_ delegate: ContractionRecordRepositoryDelegate?) {
        self.delegate = delegate
    }

    // MARK: - Private

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

    private func writeRecordsToDisk(records: [ContractionRecord]) throws {
        let jsonData = try encoder.encode(records)
        let jsonString = String(data: jsonData, encoding: .utf8)
        userDefaults.set(jsonString, forKey: contractionRecordskey)
    }

    private func readRecordsFromDisk() throws -> [ContractionRecord] {
        guard let jsonString = userDefaults.string(forKey: contractionRecordskey),
              let jsonData = jsonString.data(using: .utf8) else {
            return []
        }

        let decodedRecords = try decoder.decode([ContractionRecord].self, from: jsonData)
        return decodedRecords
    }
}

final actor ContractionRecordStorage {

}

extension ContractionRecordRepository {
    static let shared = ContractionRecordRepository()
}
