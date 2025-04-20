//
//  HistoryViewModel.swift
//  Contraction
//
//  Created by Nazmul Islam on 4/19/25.
//


import Foundation
import Observation

enum PresentedBottomSheet: Hashable, Identifiable {
    var id: Int { hashValue }
    
    case sortOption
    case filterOption
}

@Observable
@MainActor
class HistoryViewModel {

    var presentedBottomSheet: PresentedBottomSheet?

    private(set) var sortOptionsViewModel: SortOptionsViewModel
    private(set) var filterOptionsViewModel: FilterOptionsViewModel

    private var records: [ContractionRecord] = []
    private let recordRepository: ContractionRecordRepository?

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()

    init(
        records: [ContractionRecord] = [],
        sortOptionsViewModel: SortOptionsViewModel? = nil,
        filterOptionsViewModel: FilterOptionsViewModel? = nil,
        recordRepository: ContractionRecordRepository? = nil
    ) {
        self.records = records
        self.sortOptionsViewModel = sortOptionsViewModel ?? SortOptionsViewModel()
        self.filterOptionsViewModel = filterOptionsViewModel ?? FilterOptionsViewModel()
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
        let records = self.records
            .sorted(by: sortingLogic(lhs:rhs:))
            .filter(filteringLogic(record:))

        let grouped = Dictionary(grouping: records) { record in
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

    func didTapSortButton() {
        presentedBottomSheet = .sortOption
    }

    func didTapFilterButton() {
        presentedBottomSheet = .filterOption
    }
}

private extension HistoryViewModel {
    func sortingLogic(lhs: ContractionRecord, rhs: ContractionRecord) -> Bool {
        switch sortOptionsViewModel.selectedOption {
        case.newestFirst:
            return lhs.start > rhs.start
        case .oldestFirst:
            return lhs.start < rhs.start
        }
    }

    func filteringLogic(record: ContractionRecord) -> Bool {
        return filterOptionsViewModel.isDateWithinSelectedRange(record.start)
    }
}

extension HistoryViewModel: ContractionRecordRepositoryDelegate {
    func didAddRecord(_ record: ContractionRecord) {
        records.append(record)
    }
}
