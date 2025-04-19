//
//  HistoryViewModel.swift
//  Contraction
//
//  Created by Nazmul Islam on 4/19/25.
//


import Foundation
import Observation

@Observable
class HistoryViewModel {
    private(set) var records: [ContractionRecord]

    private let repository: ContractionRecordRepositoryProtocol

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()

    init(
        records: [ContractionRecord] = [],
        repository: ContractionRecordRepositoryProtocol = ContractionRecordRepository.shared
    ) {
        self.records = records
        self.repository = repository
        Task {
            await repository.setDelegate(self)
            await loadData()
        }
    }

    func groupRecordsByDate() -> [(key: String, value: [ContractionRecord])] {
        let grouped = Dictionary(grouping: records) { record in
            dateFormatter.string(from: record.start)
        }

        // Sort by date descending (newest first)
        return grouped.sorted { lhs, rhs in
            guard let lhsDate = dateFormatter.date(from: lhs.key),
                  let rhsDate = dateFormatter.date(from: rhs.key) else {
                return false
            }
            return lhsDate > rhsDate
        }
    }

    func loadData() async {
        guard let records = try? await repository.fetchRecords() else {
            return
        }
        self.records = records
    }
}

extension HistoryViewModel: ContractionRecordRepositoryDelegate {
    func didLoadRecords(_ records: [ContractionRecord]) {
        self.records = records
    }
    
    func didAddRecord(_ record: ContractionRecord) {
        records.append(record)
    }
}
