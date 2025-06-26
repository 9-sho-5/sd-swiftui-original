//
//  ConversionLog.swift
//  sd-swiftui-original
//
//  Created by ほしょ on 2025/06/26.
//

import Foundation
import SwiftData

@Model
class ConversionLog {
    var id: UUID
    var platform: String
    var content: String
    var date: Date

    init(platform: String, content: String) {
        self.id = UUID()
        self.platform = platform
        self.content = content
        self.date = Date()
    }
}
