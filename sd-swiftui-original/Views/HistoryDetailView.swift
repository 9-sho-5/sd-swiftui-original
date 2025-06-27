//
//  HistoryDetailView.swift
//  sd-swiftui-original
//
//  Created by ほしょ on 2025/06/26.
//

import SwiftUI

struct HistoryDetailView: View {
    let log: ConversionLog

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("[\(log.platform)]")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(log.date.formatted())
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Divider()
                    Text(log.content)
                        .font(.body)
                        .padding(.top, 8)
                }
                .padding(.horizontal)
                .padding(.bottom, 100)
            }

            VStack {
                Spacer()
                CopyButtonView(contentToCopy: log.content)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
            }
        }
        .navigationTitle("詳細")
        .navigationBarTitleDisplayMode(.inline)
    }
}
