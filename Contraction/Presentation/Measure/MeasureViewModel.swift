//
//  MeasureViewModel.swift
//  Contraction
//
//  Created by Nazmul Islam on 4/19/25.
//

import Combine
import Foundation
import Observation

@Observable
@MainActor
final class MeasureViewModel {

    private var timeElapsed: TimeInterval
    private var timerSubscription: AnyCancellable?
    private let recordRepository: ContractionRecordRepository

    init(
        timeElapsed: TimeInterval = 0,
        timerSubscription: AnyCancellable? = nil,
        recordRepository: ContractionRecordRepository = .shared
    ) {
        self.timeElapsed = timeElapsed
        self.timerSubscription = timerSubscription
        self.recordRepository = recordRepository
    }

    // MARK: - UI Driving

    func timerRunning() -> Bool {
        timerSubscription != nil
    }

    func timeString() -> String {
        let hours = Int(timeElapsed) / 3600
        let minutes = (Int(timeElapsed) % 3600) / 60
        let seconds = Int(timeElapsed) % 60
        let centiseconds = Int((timeElapsed.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d:%02d.%02d", hours, minutes, seconds, centiseconds)
    }

    func didTapStartStopButton() {
        if timerRunning() {
            stopTimer()
        } else {
            startTimer()
        }
    }

    func didTapResetButton() {
        resetTimer()
    }

    func didTapRecordButton() async {
        if timeElapsed > 0 {
            await saveRecord()
        }

        resetTimer()
    }

    // MARK: - Private

    private func startTimer() {
        timerSubscription = Timer.publish(every: 0.01, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.timeElapsed += 0.01
            }
    }

    private func stopTimer() {
        timerSubscription?.cancel()
        timerSubscription = nil
    }

    private func resetTimer() {
        stopTimer()
        timeElapsed = 0
    }

    private func saveRecord() async {
        let end = Date()
        let start = Date(timeInterval: -timeElapsed, since: end)
        try? await recordRepository.addRecord(
            ContractionRecord(start: start, end: Date())
        )
    }
}
