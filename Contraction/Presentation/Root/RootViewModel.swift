//
//  RootViewModel.swift
//  Contraction
//
//  Created by Nazmul Islam on 4/20/25.
//

import Foundation
import Observation

@Observable
@MainActor
final class RootViewModel {
    let measureViewModel: MeasureViewModel
    let historyViewModel: HistoryViewModel

    init(
        measureViewModel: MeasureViewModel,
        historyViewModel: HistoryViewModel
    ) {
        self.measureViewModel = measureViewModel
        self.historyViewModel = historyViewModel
    }
}

extension RootViewModel {
    static func preview() -> RootViewModel {
        RootViewModel(
            measureViewModel: MeasureViewModel(),
            historyViewModel: HistoryViewModel()
        )
    }
}

