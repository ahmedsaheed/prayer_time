//
//  AppDelegate.swift
//  Prayer Time
//
//  Created by Ahmed, Ahmed on 04/05/2025.
//

import Foundation
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusBarItem.button {
            button.action = #selector(statusBarButtonClicked(_:))
            button.target = self
            button.title = "Prayer Time"
        }
    }
    
    @objc func statusBarButtonClicked(_ sender: NSStatusBarButton) {
      print("Menu item clicked")
      // We'll implement the window handling logic here
    }
    
    
}
