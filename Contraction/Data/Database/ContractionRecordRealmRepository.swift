//
//  RecordRepository.swift
//  Contraction
//
//  Created by Nazmul Islam on 4/19/25.
//

import Foundation
import RealmSwift

final class ContractionRecordRealmRepository: ContractionRecordRepository {

    private weak var delegate: ContractionRecordRepositoryDelegate?

    init(delegate: ContractionRecordRepositoryDelegate? = nil) {
        self.delegate = delegate
    }

    func fetchRecords() async throws -> [ContractionRecord] {
        return try readRecords()
    }

    func addRecord(_ record: ContractionRecord) async throws {
        try writeRecord(record)
        await delegate?.didAddRecord(record)
    }

    func setDelegate(_ delegate: ContractionRecordRepositoryDelegate?) {
        self.delegate = delegate
    }

    // MARK: - Private

    private func readRecords() throws -> [ContractionRecord] {
        let realm = try Realm()
        let results = realm.objects(ContractionRecordEntity.self)
        let records = results.map { $0.toModel() }
        return Array(records)
    }

    private func writeRecord(_ record: ContractionRecord) throws {
        let realm = try Realm()
        try realm.write {
            let entity = record.toEntity()
            realm.add(entity)
        }
    }
}
