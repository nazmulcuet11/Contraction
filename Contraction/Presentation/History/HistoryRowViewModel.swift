//
//  HistoryRowViewModel.swift
//  Contraction
//
//  Created by Nazmul Islam on 4/20/25.
//

import Foundation
import Observation

@Observable
@MainActor
final class HistoryRowViewModel: Identifiable {

    let id: String

    private var record: ContractionRecord

    init(record: ContractionRecord) {
        self.id = record.id
        self.record = record
    }

    func timeRangeString() -> String {
        return "\(Self.timeFormatter.string(from: record.start)) - \(Self.timeFormatter.string(from: record.end))"
    }

    func durationString() -> String {
        let duration = Int(record.end.timeIntervalSince(record.start))
        let hours = duration / 3600
        let minutes = (duration % 3600) / 60
        let seconds = duration % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

private extension HistoryRowViewModel {
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
}
