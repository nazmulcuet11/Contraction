//
//  ContractionRecordObject.swift
//  Contraction
//
//  Created by Nazmul Islam on 4/20/25.
//

import Foundation

final class ContractionRecord: Identifiable {
    let id: String
    var start: Date = Date()
    var end: Date = Date()

    init(
        id: String = UUID().uuidString,
        start: Date,
        end: Date
    ) {
        self.id = id
        self.start = start
        self.end = end
    }
}
