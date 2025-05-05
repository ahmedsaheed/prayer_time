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
            TextContent("Quit")
        } label: {
            HStack {
                if let timings = prayerTimes {
                    let nextPrayer:
                        (name: String, time: String, icon: String)? =
                            getNextPrayerTime(from: timings)
                    let nextPrayerNameAndTime =
                        "\(nextPrayer?.name ?? "") : \(nextPrayer?.time ?? "Loading...")"
                    VStack {
                        Image(systemName: nextPrayer?.icon ?? "")
                        Text(nextPrayerNameAndTime)
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

func TextContent(_ title: String) -> some View {
    HStack {
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
