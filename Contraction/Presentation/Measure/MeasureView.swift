//
//  HomeView.swift
//  Contraction
//
//  Created by Nazmul Islam on 4/19/25.
//

import SwiftUI

struct MeasureView: View {
    var viewModel: MeasureViewModel

    var body: some View {
        ZStack {
            VStack {
                Spacer()

                timeView

                Spacer()

                startStopButton

                Spacer()

                HStack {
                    Spacer()
                    resetButton
                    Spacer()
                    recordButton
                    Spacer()
                }

                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }

    private var timeView: some View {
        Text(viewModel.timeString())
            .font(.system(size: 50, weight: .thin, design: .monospaced))
    }


    private var startStopButton: some View {
        Button {
            viewModel.didTapStartStopButton()
        } label: {
            Text(viewModel.timerRunning() ? "Stop" : "Start")
                .frame(width: 100, height: 100)
                .background(viewModel.timerRunning() ? Color.orange : Color.green)
                .foregroundColor(.white)
                .clipShape(Circle())
        }
    }

    private var resetButton: some View {
        Button {
            viewModel.didTapResetButton()
        } label: {
            Text("Reset")
                .frame(width: 100, height: 50)
                .background(Color.red)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    private var recordButton: some View {
        Button {
            Task {
                await viewModel.didTapRecordButton()
            }
        } label: {
            Text("Record")
                .frame(width: 100, height: 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

#Preview {
    MeasureView(viewModel: MeasureViewModel())
}
