//
//  SettingsView.swift
//  sd-swiftui-original
//
//  Created by ほしょ on 2025/06/26.
//

import SwiftUI

enum ColorSchemeOption: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String { self.rawValue }

    var label: String {
        switch self {
        case .system: return "システムに従う"
        case .light: return "ライトモード"
        case .dark: return "ダークモード"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

struct SettingsView: View {
    @AppStorage("removeIcons") private var removeIcons = false
    @AppStorage("colorSchemeSelection") private var colorSchemeSelection: String = ColorSchemeOption.system.rawValue

    var body: some View {
        NavigationView {
            Form {
                Toggle("不明なアイコンを削除", isOn: $removeIcons)

                Picker("表示モード", selection: $colorSchemeSelection) {
                    ForEach(ColorSchemeOption.allCases) { option in
                        Text(option.label).tag(option.rawValue)
                    }
                }
            }
            .navigationTitle("設定")
        }
    }
}

