//
//  SortOptionsView.swift
//  Contraction
//
//  Created by Nazmul Islam on 4/20/25.
//

import SwiftUI

struct SortOptionsView: View {
    @Bindable var viewModel: SortOptionsViewModel

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker(selection: $viewModel.selectedOption) {
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
