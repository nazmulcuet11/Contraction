//
//  HistoryView.swift
//  Contraction
//
//  Created by Nazmul Islam on 4/19/25.
//

import SwiftUI

struct HistoryHeaderView: View {
    var viewModel: HistoryViewModel

    var body: some View {
        HStack(alignment: .center) {
            Button {
                viewModel.didTapSortButton()
            } label: {
                Label("Sort", systemImage: "arrow.up.arrow.down")
            }
            .frame(maxWidth: .infinity)

            Divider().frame(height: 36)

            Button {
                // TODO: - Implement
            } label: {
                Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical)
    }
}

struct HistoryListView: View {
    var viewModel: HistoryViewModel

    var body: some View {
        List {
            ForEach(viewModel.sections(), id: \.id) { sectionViewModel in
                HistorySectionView(viewModel: sectionViewModel)
            }
        }
        .listStyle(.insetGrouped)
    }
}

struct HistoryView: View {

    @Bindable var viewModel: HistoryViewModel

    var body: some View {
        VStack(spacing: 0) {
            HistoryHeaderView(viewModel: viewModel)
            Divider()
            HistoryListView(viewModel: viewModel)
        }
        .onAppear {
            Task {
                await viewModel.loadData()
            }
        }
        .sheet(item: $viewModel.presentedBottomSheet) { item in
            switch item {
            case .sortOption:
                SortOptionsView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    let sample = [
        ContractionRecord(
            start: Date().addingTimeInterval(-3600*24),
            end: Date().addingTimeInterval(-3540*24)
        ),
        ContractionRecord(
            start: Date().addingTimeInterval(-7200*24),
            end: Date().addingTimeInterval(-7140*24)
        ),
        ContractionRecord(
            start: Date().addingTimeInterval(-10800),
            end: Date().addingTimeInterval(-10740)
        ),
        ContractionRecord(
            start: Date().addingTimeInterval(-18000),
            end: Date().addingTimeInterval(-17930)
        ),
        ContractionRecord(
            start: Date().addingTimeInterval(-25000),
            end: Date().addingTimeInterval(-24920)
        )
    ]
    HistoryView(viewModel: HistoryViewModel(records: sample))
}
