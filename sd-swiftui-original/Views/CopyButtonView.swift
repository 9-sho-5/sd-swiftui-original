//
//  CopyButtonView.swift
//  sd-swiftui-original
//
//  Created by ほしょ on 2025/06/27.
//

import SwiftUI

struct CopyButtonView: View {
    let contentToCopy: String

    @State private var copied = false

    var body: some View {
        Button(action: {
            UIPasteboard.general.string = contentToCopy
            copied = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                copied = false
            }
        }) {
            Label(copied ? "コピーしました" : "コピー", systemImage: copied ? "checkmark.circle" : "doc.on.doc")
                .font(.body)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(copied ? Color.green : Color.accentColor)
                .cornerRadius(12)
        }
    }
}
