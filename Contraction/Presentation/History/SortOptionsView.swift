//
//  SortOptionsView.swift
//  Contraction
//
//  Created by Nazmul Islam on 4/20/25.
//

import SwiftUI

struct SortOptionsView: View {
    @Bindable var viewModel: HistoryViewModel

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker(selection: $viewModel.sortOption) {
                        Text("Newest First").tag(SortOption.newestFirst)
                        Text("Oldest First").tag(SortOption.oldestFirst)
                    } label: {
                        Text("Sort By")
                            .font(.title3)
                            .bold()
                    }
                    .pickerStyle(.inline)
                }
            }
        }
        .presentationDetents([.fraction(0.3)])
        .presentationDragIndicator(.visible)
    }
}
