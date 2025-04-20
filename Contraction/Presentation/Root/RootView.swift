//
//  ContentView.swift
//  Contraction
//
//  Created by Nazmul Islam on 4/19/25.
//

import SwiftUI

struct RootView: View {
    var viewModel: RootViewModel

    var body: some View {
        TabView {
            MeasureView(viewModel: viewModel.measureViewModel)
                .tabItem {
                    Image(systemName: "stopwatch")
                    Text("Measure")
                }


            HistoryView(viewModel: viewModel.historyViewModel)
                .tabItem {
                    Image(systemName: "clock.arrow.circlepath")
                    Text("History")
                }
        }
    }
}

#Preview {
    let viewModel = RootViewModel.preview()
    return RootView(viewModel: viewModel)
}
