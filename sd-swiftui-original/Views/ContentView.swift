//
//  ContentView.swift
//  WordList
//
//  Created by ほしょ on 2025/06/26.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("colorSchemeSelection") private var colorSchemeSelection: String = ColorSchemeOption.system.rawValue

    var body: some View {
        let selectedOption = ColorSchemeOption(rawValue: colorSchemeSelection) ?? .system

        TabView {
            ConvertView()
                .tabItem {
                    Label("変換", systemImage: "square.and.pencil")
                }

            HistoryView()
                .tabItem {
                    Label("履歴", systemImage: "clock")
                }

            SettingsView()
                .tabItem {
                    Label("設定", systemImage: "gearshape")
                }
        }
        .preferredColorScheme(selectedOption.colorScheme)
    }
}

#Preview {
    ContentView()
}
