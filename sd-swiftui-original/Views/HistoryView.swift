//
//  HistoryView.swift
//  sd-swiftui-original
//
//  Created by ほしょ on 2025/06/26.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: [SortDescriptor(\ConversionLog.date, order: .reverse)]) var logs: [ConversionLog]

    var body: some View {
        List(logs) { log in
            VStack(alignment: .leading) {
                Text("[\(log.platform)]")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(log.content)
                    .lineLimit(2)
                Text(log.date.formatted())
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle("変換履歴")
    }
}
