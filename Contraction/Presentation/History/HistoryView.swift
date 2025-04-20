//
//  HistoryView.swift
//  Contraction
//
//  Created by Nazmul Islam on 4/19/25.
//

import SwiftUI

struct HistoryView: View {
    var viewModel: HistoryViewModel

    var body: some View {
        List {
            ForEach(viewModel.sections(), id: \.id) { sectionViewModel in
                HistorySectionView(viewModel: sectionViewModel)
            }
        }
        .listStyle(.insetGrouped)
        .onAppear {
            Task {
                await viewModel.loadData()
            }
        }
    }
}

#Preview {
    HistoryView(viewModel: HistoryViewModel())
}
