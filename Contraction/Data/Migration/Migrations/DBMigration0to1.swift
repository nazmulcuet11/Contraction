//
//  Migration0to1.swift
//  Contraction
//
//  Created by Nazmul Islam on 4/20/25.
//

import Foundation
import RealmSwift

final class DBMigration0to1: DBMigration {
    var sourceSchemaVersion: Int = 0
    var destinationSchemaVersion: Int = 1
    
    func migrate() async throws {
        let records = try readRecordsFromUserDefaults()
        try writeRecordsToDB(records)
        removeRecordsFromUserDefaults()
    }

    private func writeRecordsToDB(_ records: [ContractionRecordOld]) throws {
        let realm = try Realm()
        let objects = records.map { $0.toObject() }
        try realm.write {
            realm.add(objects)
        }
    }

    private struct ContractionRecordOld: Codable {
        let start: Date
        let end: Date

        func toObject() -> ContractionRecordEntity {
            ContractionRecordEntity(
                start: start,
                end: end
            )
        }
    }
    
    private let userDefaults = UserDefaults.standard
    
    let contractionRecordskey: String = "CONTRACTION_RECORDS"
    
    private let decoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    private func readRecordsFromUserDefaults() throws -> [ContractionRecordOld] {
        guard let jsonString = userDefaults.string(forKey: contractionRecordskey),
              let jsonData = jsonString.data(using: .utf8) else {
            return []
        }
        
        let decodedRecords = try decoder.decode([ContractionRecordOld].self, from: jsonData)
        return decodedRecords
    }

    private func removeRecordsFromUserDefaults() {
        userDefaults.removeObject(forKey: contractionRecordskey)
    }
}
