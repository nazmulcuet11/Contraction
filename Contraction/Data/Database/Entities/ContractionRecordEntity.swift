//
//  ContractionRecordEntity.swift
//  Contraction
//
//  Created by Nazmul Islam on 4/20/25.
//

import Foundation
import RealmSwift

final class ContractionRecordEntity: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var start: Date = Date()
    @Persisted var end: Date = Date()

    convenience init(start: Date, end: Date) {
        self.init()
        self.start = start
        self.end = end
    }
}

extension ContractionRecord {
    func toEntity() -> ContractionRecordEntity {
        return ContractionRecordEntity(
            start: start,
            end: end
        )
    }
}

extension ContractionRecordEntity {
    func toModel() -> ContractionRecord {
        return ContractionRecord(
            id: _id.stringValue,
            start: start,
            end: end
        )
    }
}
