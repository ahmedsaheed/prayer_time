//
//  Prayer_TimeApp.swift
//  Prayer Time
//
//  Created by Ahmed, Ahmed on 04/05/2025.
//

import SwiftUI

@main
struct Prayer_TimeApp: App {

    @State var currentNumber: String = "1"
    @State var today: Date = Date()
    @State private var prayerTimes: Timings?

    var body: some Scene {
        MenuBarExtra {
            TextContent("Hi Dad")
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
        } label: {
            HStack {
                if let timings = prayerTimes {
                    
                    Text("Fajr: \(timings.fajr)")
                } else {
                    Text("A message")
                        .onAppear {
                            Task {
                                await loadPrayerTimes()
                            }
                        }
                }
                
            }
        }
    }

    func loadPrayerTimes() async {
        do {
            prayerTimes = try await fetchPrayerTimes(date: today, prayerTimes: prayerTimes)
        } catch {
            print("Error fetching prayer times: \(error)")
        }
    }

}

let base = "https://api.aladhan.com/v1/timingsByAddress/04-05-2025?address=Cork,Ireland&method=8&tune=2,3,4,5,2,3,4,5,-3"
func fetchPrayerTimes(
    date : Date,
    prayerTimes: Timings? = nil
) async throws -> Timings {
    
    // Only fetch data if today's date has changed
    let currentDate: Date = Date()
    
    if currentDate == date && prayerTimes != nil {
        return prayerTimes!
    }
    
    let PrayerTimeURL = URL(string: base)!
    let (data, _) = try await URLSession.shared.data(from: PrayerTimeURL)
    let decoded = try JSONDecoder().decode(PrayerTimesResponse.self, from: data)
    return decoded.data.timings
}

func TextContent(_ title: String) -> some View {
    Text(title)
        .font(.headline)
        .foregroundColor(.white)
}




struct PrayerTimesResponse: Codable {
    let code: Int
    let status: String
    let data: PrayerData
}

struct PrayerData: Codable {
    let timings: Timings
    let date: DateInfo
    let meta: MetaData
}

// Struct for prayer timings
struct Timings: Codable {
    let fajr, sunrise, dhuhr, asr, sunset, maghrib, isha, imsak, midnight,
        firstThird, lastThird: String

    enum CodingKeys: String, CodingKey {
        case fajr = "Fajr"
        case sunrise = "Sunrise"
        case dhuhr = "Dhuhr"
        case asr = "Asr"
        case sunset = "Sunset"
        case maghrib = "Maghrib"
        case isha = "Isha"
        case imsak = "Imsak"
        case midnight = "Midnight"
        case firstThird = "Firstthird"
        case lastThird = "Lastthird"
    }
}

struct DateInfo: Codable {
    let readable: String
    let timestamp: String
    let hijri: HijriDate
    let gregorian: GregorianDate
}


struct HijriDate: Codable {
    let date, format, day: String
    let weekday: TranslatedString
    let month: MonthDetails
    let year: String
    let designation: Designation
}


struct GregorianDate: Codable {
    let date, format, day: String
    let weekday: TranslatedString
    let month: MonthDetails
    let year: String
    let designation: Designation
}


struct TranslatedString: Codable {
    let en: String
}


struct MonthDetails: Codable {
    let number: Int
    let en: String
}


struct Designation: Codable {
    let abbreviated, expanded: String
}


struct MetaData: Codable {
    let latitude, longitude: Double
    let timezone: String
    let method: CalculationMethod
    let latitudeAdjustmentMethod, midnightMode, school: String
    let offset: PrayerOffset
}


struct CalculationMethod: Codable {
    let id: Int
    let name: String
    let params: MethodParams
    let location: GeoLocation
}


struct MethodParams: Codable {
    let fajr: Double
    let isha: String
    
    enum CodingKeys: String, CodingKey {
        case fajr = "Fajr"
        case isha = "Isha"
    }
}


struct GeoLocation: Codable {
    let latitude, longitude: Double
}


struct PrayerOffset: Codable {
    let imsak, fajr, sunrise, dhuhr, asr, maghrib, sunset, isha, midnight: String

    enum CodingKeys: String, CodingKey {
        case imsak = "Imsak"
        case fajr = "Fajr"
        case sunrise = "Sunrise"
        case dhuhr = "Dhuhr"
        case asr = "Asr"
        case maghrib = "Maghrib"
        case sunset = "Sunset"
        case isha = "Isha"
        case midnight = "Midnight"
    }
}
