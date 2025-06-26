//
//  ContentView.swift
//  WordList
//
//  Created by ほしょ on 2025/06/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
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
    }
}

#Preview {
    ContentView()
}
