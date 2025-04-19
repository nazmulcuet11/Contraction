//
//  ContentView.swift
//  Contraction
//
//  Created by Nazmul Islam on 4/19/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MeasureView(viewModel: MeasureViewModel())
                .tabItem {
                    Image(systemName: "stopwatch")
                    Text("Measure")
                }


            HistoryView(viewModel: HistoryViewModel())
                .tabItem {
                    Image(systemName: "clock.arrow.circlepath")
                    Text("History")
                }
        }
    }
}

#Preview {
    ContentView()
}
