//
//  AppView.swift
//  Contraction
//
//  Created by Nazmul Islam on 4/20/25.
//

import SwiftUI

struct AppView: View {
    var viewModel: AppViewModel

    var body: some View {
        switch viewModel.state {
        case .loading:
            LaunchView()
        case .loaded(let rootViewModel):
            RootView(viewModel: rootViewModel)
        }
    }
}
