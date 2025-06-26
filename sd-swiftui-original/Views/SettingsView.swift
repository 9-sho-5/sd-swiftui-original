//
//  SettingsView.swift
//  sd-swiftui-original
//
//  Created by ほしょ on 2025/06/26.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("removeIcons") private var removeIcons = false

    var body: some View {
        Form {
            Toggle("不明なアイコンを削除", isOn: $removeIcons)
        }
        .navigationTitle("設定")
    }
}
