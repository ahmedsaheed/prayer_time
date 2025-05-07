//
//  Prayer Time Utils.swift
//  Prayer Time
//
//  Created by Ahmed, Ahmed on 05/05/2025.
//
import Foundation
import AVFoundation


let TODAY_DATE = getTodaysDate()
let DATA_SOURCE = "https://api.aladhan.com/v1/timingsByAddress/\(TODAY_DATE)?address=Cork,Ireland&method=8&tune=2,3,4,5,2,3,4,5,-3"

func getTodaysDate() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy"
    let todayString = dateFormatter.string(from: Date())
    return todayString
}

func getNextPrayerTime(from timings: Timings) -> (
    name: String, time: String, icon: String
)? {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    formatter.timeZone = TimeZone.current

    let calendar = Calendar.current
    let now = Date()

    let prayerTimes: [(String, String, String)] = [
        ("Fajr", timings.fajr, "sun.horizon.fill"),
        ("Sunrise", timings.sunrise, "sunrise.fill"),
        ("Dhuhr", timings.dhuhr, "sun.min.fill"),
        ("Asr", timings.asr, "sun.max.fill"),
        ("Maghrib", timings.maghrib, "sunset.fill"),
        ("Isha", timings.isha, "moon.star.fill"),
    ]

    for (name, timeString, icon) in prayerTimes {
        if let prayerDate = formatter.date(from: timeString) {
            // Combine today's date with the prayer time
            let prayerComponents = calendar.dateComponents(
                [.hour, .minute],
                from: prayerDate
            )
            if let todayPrayerTime = calendar.date(
                bySettingHour: prayerComponents.hour ?? 0,
                minute: prayerComponents.minute ?? 0,
                second: 0,
                of: now
            ) {
                if todayPrayerTime > now {
                    return (name, timeString, icon)
                }
            }
        }
    }

    // If all prayer times have passed, return the first one for the next day
    return prayerTimes.first
}

func fetchPrayerTimes(
    date: Date,
    prayerTimes: Timings? = nil
) async throws -> Timings {

    let currentDate: Date = Date()
    if currentDate == date && prayerTimes != nil {
        print("Returning prefetched prayer times")
        return prayerTimes!
    }
    
    print("Getting fresh data")
    let PrayerTimeURL = URL(string: DATA_SOURCE)!
    let (data, _) = try await URLSession.shared.data(from: PrayerTimeURL)
    let decoded = try JSONDecoder().decode(PrayerTimesResponse.self, from: data)
    return decoded.data.timings
}


func playSounds(_ soundFileName : String, audioPlayer: inout AVAudioPlayer) {
    guard let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: nil) else {
        fatalError("Unable to find \(soundFileName) in bundle")
    }

    do {
        audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
    } catch {
        print(error.localizedDescription)
    }
    audioPlayer.play()
}
