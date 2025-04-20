//
//  Untitled.swift
//  Contraction
//
//  Created by Nazmul Islam on 4/20/25.
//

import SwiftUI

struct HistoryRowView: View {
    var viewModel: HistoryRowViewModel

    var body: some View {
        HStack {
            Text(viewModel.timeRangeString())
                .font(.body)
            Spacer()
            Text(viewModel.durationString())
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}
