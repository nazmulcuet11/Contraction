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
            .filter(filteringLogic(record:))

        let grouped = Dictionary(grouping: records) { record in
            Calendar.current.startOfDay(for: record.start)
        }

        var sections = [HistorySectionViewModel]()
        for date in grouped.keys.sorted(by: sortingLogic(lhs:rhs:)) {
            guard let records = grouped[date] else {
                continue
            }

            let rows = records
                .sorted(by: sortingLogic(lhs:rhs:))
                .map { HistoryRowViewModel(record: $0) }

            let section = HistorySectionViewModel(
                date: date,
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
    func sortingLogic(lhs: Date, rhs: Date) -> Bool {
        switch sortOptionsViewModel.selectedOption {
        case.newestFirst:
            return lhs > rhs
        case .oldestFirst:
            return lhs < rhs
        }
    }

    func sortingLogic(lhs: ContractionRecord, rhs: ContractionRecord) -> Bool {
        return sortingLogic(lhs: lhs.start, rhs: rhs.start)
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
