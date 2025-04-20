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
        let measureViewModel = MeasureViewModel()
        let historyViewModel = HistoryViewModel()
        let rootViewModel = RootViewModel(
            measureViewModel: measureViewModel,
            historyViewModel: historyViewModel
        )
        state = .loaded(rootViewModel)
    }
}
