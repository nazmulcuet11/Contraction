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
            ForEach(viewModel.groupRecordsByDate(), id: \.key) { group in
                Section(header: Text(group.key)) {
                    ForEach(group.value, id: \.self) { record in
                        HStack {
                            Text(timeRangeString(from: record))
                                .font(.body)
                            Spacer()
                            Text(durationString(from: record))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    // Format start and end time as "HH:mm - HH:mm"
    func timeRangeString(from record: ContractionRecord) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        return "\(timeFormatter.string(from: record.start)) - \(timeFormatter.string(from: record.end))"
    }

    // Format duration as "mm:ss"
    func durationString(from record: ContractionRecord) -> String {
        let duration = Int(record.end.timeIntervalSince(record.start))
        let hours = duration / 3600
        let minutes = (duration % 3600) / 60
        let seconds = duration % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

}

#Preview {
    // Sample Data
    let sampleRecords = [
        ContractionRecord(start: Date(), end: Date().addingTimeInterval(45)),
        ContractionRecord(start: Calendar.current.date(byAdding: .hour, value: -2, to: Date())!, end: Calendar.current.date(byAdding: .minute, value: -118, to: Date())!),
        ContractionRecord(start: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, end: Calendar.current.date(byAdding: .day, value: -1, to: Date().addingTimeInterval(65))!)
    ]

    let viewModel = HistoryViewModel(records: sampleRecords)

    HistoryView(viewModel: viewModel)

//    HistoryView(viewModel: HistoryViewModel())
}
