//
//  ContractionApp.swift
//  Contraction
//
//  Created by Nazmul Islam on 4/19/25.
//

import SwiftUI

@main
struct ContractionApp: App {

    private let viewModel = AppViewModel()

    var body: some Scene {
        WindowGroup {
            AppView(viewModel: viewModel)
        }
    }
}
