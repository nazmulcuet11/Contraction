//
//  FilterOptionsViewModel.swift
//  Contraction
//
//  Created by Nazmul Islam on 4/20/25.
//

import Foundation
import Observation

enum FilterOption: String, CaseIterable, Identifiable {
    case none = "None"
    case today = "Today"
    case last7Days = "Last 7 Days"
    case last30Days = "Last 30 Days"
    case custom = "Custom"

    var id: String { rawValue }
}

@MainActor
@Observable
final class FilterOptionsViewModel {
    var selectedOption: FilterOption
    var customStartDate: Date
    var customEndDate: Date

    init(
        selectedOption: FilterOption = .none,
        customStartDate: Date = Calendar.current.date(byAdding: .year, value: -1, to: Date())!,
        customEndDate: Date = Date()
    ) {
        self.selectedOption = selectedOption
        self.customStartDate = customStartDate
        self.customEndDate = customEndDate
    }
}
