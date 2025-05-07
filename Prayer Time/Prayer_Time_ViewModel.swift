//
//  Prayer_Time_ViewModel.swift
//  Prayer Time
//
//  Created by Ahmed, Ahmed on 07/05/2025.
//

import Foundation
import Combine
class PrayerCountdownViewModel: ObservableObject {
    @Published var countdownText: String = "--:--:--"
    private var timer: Timer?
    private var endTime: Date?

    func startCountdown(to timeString: String) {
        guard let interval = timeRemaining(until: timeString) else { return }

        endTime = Date().addingTimeInterval(interval)
        timer?.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.tick()
        }
    }

    private func tick() {
        guard let endTime = endTime else { return }

        let now = Date()
        let remaining = endTime.timeIntervalSince(now)

        if remaining <= 0 {
            timer?.invalidate()
            countdownText = "00:00:00"
        } else {
            countdownText = formatTimeRemaining(remaining)
        }
    }

    private func timeRemaining(until timeString: String) -> TimeInterval? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = .current

        let now = Date()
        guard let prayerTime = formatter.date(from: timeString) else { return nil }

        var components = Calendar.current.dateComponents([.hour, .minute], from: prayerTime)
        components.second = 0

        guard let todayPrayer = Calendar.current.date(bySettingHour: components.hour!,
                                                      minute: components.minute!,
                                                      second: 0,
                                                      of: now) else { return nil }

        var timeDiff = todayPrayer.timeIntervalSince(now)
        if timeDiff < 0 {
            if let tomorrowPrayer = Calendar.current.date(byAdding: .day, value: 1, to: todayPrayer) {
                timeDiff = tomorrowPrayer.timeIntervalSince(now)
            }
        }

        return timeDiff
    }

    private func formatTimeRemaining(_ interval: TimeInterval) -> String {
        let totalSeconds = Int(interval)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
