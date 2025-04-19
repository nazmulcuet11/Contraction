//
//  Record.swift
//  Contraction
//
//  Created by Nazmul Islam on 4/19/25.
//

import Foundation

struct ContractionRecord: Codable, Hashable {
    let start: Date
    let end: Date
}

extension ContractionRecord: Identifiable {
    var id: Int { hashValue }
}
