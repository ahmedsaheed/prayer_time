//
//  Prayer_TimeApp.swift
//  Prayer Time
//
//  Created by Ahmed, Ahmed on 04/05/2025.
//

import SwiftUI
import AVFoundation

@main

struct Prayer_TimeApp: App {
    @State var today: Date = Date()
    @State private var prayerTimes: Timings?
    @StateObject var viewModel = PrayerCountdownViewModel()
    @State private var prayer:Prayer = Prayer()
    @State var audioPlayer: AVAudioPlayer!
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some Scene {
        MenuBarExtra {
            DropDown(times: prayerTimes)
        } label: {
            HStack {
                if let _ = prayerTimes {
                    let nextPrayerNameAndTime = "\(prayer.name) : \(viewModel.countdownText)"
                    VStack {
                        Image(systemName: prayer.icon)
                        Text("\(nextPrayerNameAndTime)")
                    }.onAppear {
                        viewModel.startCountdown(to: prayer.time)
                    }.onChange(of: viewModel.countdownText) { oldValue, newValue in
                        if newValue == "00:00:00" {
                            print("Next prayer time is here")
                            // @TODO: call adhan - find adhan mp3
                            // playSounds("adhan.mp3", audioPlayer: &audioPlayer)
                            updateNextPrayer(time: prayerTimes!)
                            viewModel.startCountdown(to: prayer.time)
                            
                        }
//                        print("Countdown updated from: \(oldValue) to \(newValue)")
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
            updateNextPrayer(time: prayerTimes!)
        } catch {
            print("Error fetching prayer times: \(error)")
        }
    }
    
    func updateNextPrayer(time: Timings) {
        let nextInLine : (name: String, time: String, icon: String)? = getNextPrayerTime(from: prayerTimes!)
        prayer.name = nextInLine?.name ?? ""
        prayer.time = nextInLine?.time ?? ""
        prayer.icon = nextInLine?.icon ?? ""
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
