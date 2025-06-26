//
//  GeminiService.swift
//  sd-swiftui-original
//
//  Created by ほしょ on 2025/06/26.
//

import Foundation

struct GeminiService {
    static func format(text: String, completion: @escaping (String) -> Void) {
        let apiKey = APIKeyManager.shared.apiKey(for: .gemini)

        guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=\(apiKey)") else {
            completion("❌ URLが不正です")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": text]
                    ]
                ]
            ]
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            completion("❌ リクエストボディの生成に失敗しました: \(error.localizedDescription)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion("🔌 通信エラー: \(error.localizedDescription)")
                }
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("📡 ステータスコード: \(httpResponse.statusCode)")
            }

            if let data = data, let responseBody = String(data: data, encoding: .utf8) {
                print("📝 レスポンスボディ:\n\(responseBody)")
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion("📭 データが空です")
                }
                return
            }

            do {
                guard
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let candidates = json["candidates"] as? [[String: Any]],
                    let content = candidates.first?["content"] as? [String: Any],
                    let parts = content["parts"] as? [[String: String]],
                    let resultText = parts.first?["text"]
                else {
                    DispatchQueue.main.async {
                        let raw = String(data: data, encoding: .utf8) ?? "不明なレスポンス形式"
                        completion("❗️レスポンスの解析に失敗しました\n\(raw)")
                    }
                    return
                }

                DispatchQueue.main.async {
                    completion(resultText)
                }

            } catch {
                DispatchQueue.main.async {
                    completion("🐞 JSON解析エラー: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}
