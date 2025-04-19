//
//  HomeView.swift
//  Contraction
//
//  Created by Nazmul Islam on 4/19/25.
//

import SwiftUI

@Observable
class MeasureViewModel: ObservableObject {
    private(set) var timerRunning = false

    var timeString: String {
        let hours = Int(timeElapsed) / 3600
        let minutes = (Int(timeElapsed) % 3600) / 60
        let seconds = Int(timeElapsed) % 60
        let centiseconds = Int((timeElapsed.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d:%02d.%02d", hours, minutes, seconds, centiseconds)
    }

    private var timeElapsed: TimeInterval = 0

    private var timer: Timer? = nil

    func didTapStartStopButton() {
        if timerRunning {
            stopTimer()
        } else {
            startTimer()
        }
    }

    func didTapResetButton() {
        resetTimer()
    }

    func didTapRecordButton() {
        resetTimer()
        // TODO: - Record in repository
    }


    private func startTimer() {
        timerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            self?.timeElapsed += 0.01
        }
    }

    private func stopTimer() {
        timerRunning = false
        timer?.invalidate()
        timer = nil
    }

    private func resetTimer() {
        stopTimer()
        timeElapsed = 0
    }
}

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
        Text(viewModel.timeString)
            .font(.system(size: 50, weight: .thin, design: .monospaced))
    }


    private var startStopButton: some View {
        Button {
            viewModel.didTapStartStopButton()
        } label: {
            Text(viewModel.timerRunning ? "Stop" : "Start")
                .frame(width: 100, height: 100)
                .background(viewModel.timerRunning ? Color.orange : Color.green)
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
            viewModel.didTapRecordButton()
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
