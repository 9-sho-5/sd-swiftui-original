//
//  FormatterService.swift
//  sd-swiftui-original
//
//  Created by ほしょ on 2025/06/26.
//

import Foundation

struct FormatterService {
    static func format(_ text: String, for platform: PlatformType) -> String {
        var result = text.replacingOccurrences(of: ":slack:", with: "💬")
        result = result.replacingOccurrences(of: ":discord:", with: "👾")
        result = result.replacingOccurrences(of: "\\r\\n|\\r|\\n", with: "\\n", options: .regularExpression)

        switch platform {
        case .slack:
            return result.replacingOccurrences(of: "**", with: "*")
        case .discord:
            return result.replacingOccurrences(of: "**", with: "__")
        case .notion:
            return result
        }
    }
}
