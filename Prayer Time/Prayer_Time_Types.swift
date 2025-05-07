//
//  Prayer_Time_Types.swift
//  Prayer Time
//
//  Created by Ahmed, Ahmed on 05/05/2025.
//

struct Prayer {
    var name: String = ""
    var time: String = ""
    var icon: String = ""
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
    let imsak, fajr, sunrise, dhuhr, asr, maghrib, sunset, isha,
        midnight: String

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
