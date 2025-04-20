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

    func isDateWithinSelectedRange(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let now = Date()

        switch selectedOption {
        case .none:
            return true

        case .today:
            return calendar.isDateInToday(date)

        case .last7Days:
            if let sevenDaysAgo = calendar.date(
                byAdding: .day, value: -6,
                to: calendar.startOfDay(for: now)
            ) {
                return (sevenDaysAgo...now).contains(date)
            }
            return false

        case .last30Days:
            if let thirtyDaysAgo = calendar.date(
                byAdding: .day, value: -29,
                to: calendar.startOfDay(for: now)
            ) {
                return (thirtyDaysAgo...now).contains(date)
            }
            return false

        case .custom:
            let start = calendar.startOfDay(for: customStartDate)
            let end = customEndDate
            return (start...end).contains(date)
        }
    }
}
