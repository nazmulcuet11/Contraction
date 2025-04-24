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
    let date: Date
    let rows: [HistoryRowViewModel]

    init(
        date: Date,
        rows: [HistoryRowViewModel]
    ) {
        self.date = date
        self.id = Self.dateFormatter.string(from: date)
        self.title = Self.dateFormatter.string(from: date)
        self.rows = rows
    }
}

private extension HistorySectionViewModel {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
}
