//
//  Untitled.swift
//  Contraction
//
//  Created by Nazmul Islam on 4/20/25.
//

import Foundation
import Observation

@Observable
@MainActor
final class HistorySectionViewModel: Identifiable {
    let id: String
    let title: String
    let rows: [HistoryRowViewModel]

    init(
        id: String,
        title: String,
        rows: [HistoryRowViewModel]
    ) {
        self.id = id
        self.title = title
        self.rows = rows
    }
}
