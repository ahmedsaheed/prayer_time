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
    @State private var upComingPrayerTimeRemaining: Int?
    @StateObject var viewModel = PrayerCountdownViewModel()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some Scene {
        MenuBarExtra {
            DropDown(times: prayerTimes)
        } label: {
            HStack {
                if let timings = prayerTimes {
                    let nextPrayer: (name: String, time: String, icon: String)? = getNextPrayerTime(from: timings)
                    let nextPrayerNameAndTime = "\(nextPrayer?.name ?? "") : \(viewModel.countdownText)"
                    VStack {
                        Image(systemName: nextPrayer?.icon ?? "")
                        Text("\(nextPrayerNameAndTime)")
                    }.onAppear {
                        viewModel.startCountdown(to: nextPrayer?.time ?? "0")
                    }.onChange(of: viewModel.countdownText) { oldValue, newValue in
                        if oldValue == "00:00:00" {
                            print("Next prayer time is here")
                            // @TODO: call adhan
                            let nextPrayer: (name: String, time: String, icon: String)? = getNextPrayerTime(from: prayerTimes!)
                            viewModel.startCountdown(to: nextPrayer?.time ?? "0")
                        }
                    }
                } else {
                    Text("Fetching Prayer Times...")
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
            prayerTimes = try await fetchPrayerTimes(
                date: today,
                prayerTimes: prayerTimes
            )
            
        } catch {
            print("Error fetching prayer times: \(error)")
        }
    }

}

func Prayers(nextPrayerTime: String, name: String, time: String) -> some View {
    Text("\(name) : \(time)")
        .foregroundColor(time == nextPrayerTime ? .blue : .primary)
}

func PrayerDropDown(times: Timings? = nil) -> some View {
    HStack {
        let nextPrayer: (name: String, time: String, icon: String)? =
            getNextPrayerTime(from: times!)
        Prayers(
            nextPrayerTime: nextPrayer!.time,
            name: "Fajr",
            time: times!.fajr
        )
        Divider()
        Prayers(
            nextPrayerTime: nextPrayer!.time,
            name: "Dhuhr",
            time: times!.dhuhr
        )
        Divider()
        Prayers(nextPrayerTime: nextPrayer!.time, name: "Asr", time: times!.asr)
        Divider()
        Prayers(
            nextPrayerTime: nextPrayer!.time,
            name: "Maghrib",
            time: times!.maghrib
        )
        Divider()
        Prayers(
            nextPrayerTime: nextPrayer!.time,
            name: "Isha",
            time: times!.isha
        )

    }
}

func DropDown(times: Timings? = nil) -> some View {
    HStack {
        if let times {
            PrayerDropDown(times: times)
        }
        Divider()
        Button(action: onQuitClick) {
            Label("Open Settings", systemImage: "folder.badge.plus")
        }
        Divider()
        Button(action: onQuitClick) {
            Label("Quit", systemImage: "gear.circle")
        }
    }
}

func onQuitClick() {
    #if os(macOS)
        NSApplication.shared.terminate(nil)
    #else
        exit(EXIT_SUCCESS)
    #endif
}
