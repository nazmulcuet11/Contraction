//
//  HistoryViewModel.swift
//  Contraction
//
//  Created by Nazmul Islam on 4/19/25.
//


import Foundation
import Observation

@Observable
@MainActor
class HistoryViewModel {

    private var records: [ContractionRecord] = []
    private let recordRepository: ContractionRecordRepository?

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()

    init(recordRepository: ContractionRecordRepository? = nil) {
        self.recordRepository = recordRepository
        recordRepository?.setDelegate(self)
    }

    func loadData() async {
        guard let records = try? await recordRepository?.fetchRecords() else {
            return
        }
        self.records = records
    }

    func sections() -> [HistorySectionViewModel] {
        let sortedRecords = records.sorted(by:  { $0.start > $1.start })
        let grouped = Dictionary(grouping: sortedRecords) { record in
            dateFormatter.string(from: record.start)
        }

        var sections = [HistorySectionViewModel]()
        for (title, records) in grouped {
            let rows = records.map {
                HistoryRowViewModel(record: $0)
            }
            let section = HistorySectionViewModel(
                id: title,
                title: title,
                rows: rows
            )
            sections.append(section)
        }
        return sections
    }
}

extension HistoryViewModel: ContractionRecordRepositoryDelegate {
    func didAddRecord(_ record: ContractionRecord) {
        records.append(record)
    }
}
