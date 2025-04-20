//
//  AppViewModel.swift
//  Contraction
//
//  Created by Nazmul Islam on 4/20/25.
//

import Foundation
import Observation

enum AppState {
    case loading
    case loaded(RootViewModel)
}

@Observable
@MainActor
final class AppViewModel {
    private(set) var state: AppState = .loading

    init() {
        Task {
            try await load()
        }
    }

    func load() async throws {
        let application = Application.shared

        // run db migration
        try await application.migrator.migrate()

        // build root view model
        let measureViewModel = MeasureViewModel(
            recordRepository: application.contractionRecordRepository
        )
        let historyViewModel = HistoryViewModel(
            recordRepository: application.contractionRecordRepository
        )
        let rootViewModel = RootViewModel(
            measureViewModel: measureViewModel,
            historyViewModel: historyViewModel
        )
        state = .loaded(rootViewModel)
    }
}
