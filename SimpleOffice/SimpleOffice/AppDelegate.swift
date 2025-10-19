//
//  AppDelegate.swift
//  SimpleOffice
//
//  Created by User on 19.10.2025.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Устанавливаем иконку приложения
        if let imagePath = Bundle.main.path(forResource: "icon5", ofType: "png"),
           let iconImage = NSImage(contentsOfFile: imagePath) {
            NSApplication.shared.applicationIconImage = iconImage
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}
