//
//  SortOptionsViewModel.swift
//  Contraction
//
//  Created by Nazmul Islam on 4/20/25.
//

import Foundation
import Observation

enum SortOption {
    case newestFirst
    case oldestFirst
}

@MainActor
@Observable
final class SortOptionsViewModel {
    var selectedOption: SortOption

    init(selectedOption: SortOption = .newestFirst) {
        self.selectedOption = selectedOption
    }
}
