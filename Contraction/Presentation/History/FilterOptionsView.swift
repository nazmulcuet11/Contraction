//
//  FilterOptionsView.swift
//  Contraction
//
//  Created by Nazmul Islam on 4/20/25.
//

import SwiftUI

struct FilterOptionsView: View {

    @Bindable var viewModel: FilterOptionsViewModel

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker(selection: $viewModel.selectedOption) {
                        ForEach(FilterOption.allCases) { option in
                            Text(option.rawValue)
                                .tag(option)
                        }
                    } label: {
                        Text("Filter")
                            .font(.title3)
                            .bold()
                    }
                    .pickerStyle(.inline)
                }

                if viewModel.selectedOption == .custom {
                    DatePicker(
                        "Start Date",
                        selection: $viewModel.customStartDate,
                        in: ...viewModel.customEndDate,
                        displayedComponents: .date
                    )
                    
                    DatePicker(
                        "End Date",
                        selection: $viewModel.customEndDate,
                        in: viewModel.customStartDate...Date(),
                        displayedComponents: .date
                    )
                }
            }
        }
        .presentationDetents([.fraction(0.75)])
        .presentationDragIndicator(.visible)
    }
}
