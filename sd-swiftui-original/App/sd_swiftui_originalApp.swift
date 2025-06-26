//
//  sd_swiftui_originalApp.swift
//  sd-swiftui-original
//
//  Created by ほしょ on 2025/06/26.
//

import SwiftUI
import SwiftData

@main
struct sd_swiftui_originalApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [ConversionLog.self])
    }
}
