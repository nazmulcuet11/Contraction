//
//  HistorySectionView.swift
//  Contraction
//
//  Created by Nazmul Islam on 4/20/25.
//

import SwiftUI

struct HistorySectionView: View {
    var viewModel: HistorySectionViewModel

    var body: some View {
        Section(header: Text(viewModel.title)) {
            ForEach(viewModel.rows, id: \.id) { rowViewModel in
                HistoryRowView(viewModel: rowViewModel)
            }
        }
    }
}
