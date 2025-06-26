//
//  APIKeyManager.swift
//  sd-swiftui-original
//
//  Created by ほしょ on 2025/06/26.
//

import Foundation

enum APIService: String {
    case gemini = "GEMINI_API_KEY"
}

final class APIKeyManager {
    static let shared = APIKeyManager()
    
    private init() {}

    func apiKey(for service: APIService) -> String {
        guard let keys = Bundle.main.infoDictionary?["APIKeys"] as? [String: Any], let key = keys[service.rawValue] as? String, !key.isEmpty else {
            fatalError("❌ \(service.rawValue) の API キーが APIKeys に存在しない、または空です")
        }
        return key
    }
}

