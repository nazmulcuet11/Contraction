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
    private let repository: ContractionRecordRepository

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()

    init(repository: ContractionRecordRepository = .shared) {
        self.repository = repository

        Task {
            await initialize()
        }
    }

    func loadData() async {
        guard let records = try? await repository.fetchRecords() else {
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

    // MARK: - Private

    private func initialize() async {
        await repository.setDelegate(self)
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

extension HistoryViewModel {
    static func preview() -> HistoryViewModel {
        HistoryViewModel()
    }
}
