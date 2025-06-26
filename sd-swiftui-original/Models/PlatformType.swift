//
//  PlatformType.swift
//  sd-swiftui-original
//
//  Created by ほしょ on 2025/06/26.
//

import Foundation

enum PlatformType: String, CaseIterable, Identifiable, Codable {
    case slack, discord, notion

    var id: String { self.rawValue }

    var displayName: String {
        switch self {
        case .slack: return "Slack"
        case .discord: return "Discord"
        case .notion: return "Notion"
        }
    }
}
