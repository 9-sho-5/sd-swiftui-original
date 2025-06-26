//
//  ConvertView.swift
//  sd-swiftui-original
//
//  Created by ほしょ on 2025/06/26.
//

import SwiftUI

struct ConvertView: View {
    @State private var inputText: String = ""
    @State private var selectedPlatform: PlatformType = .notion
    @State private var showConfirmation = false
    @State private var convertedText: String = ""
    @Environment(\.modelContext) private var context

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("変換先アプリケーションを選択")
                    .font(.headline)

                Picker("Platform", selection: $selectedPlatform) {
                    ForEach(PlatformType.allCases, id: \.self) { platform in
                        Text(platform.displayName).tag(platform)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.bottom)

                TextEditor(text: $inputText)
                    .frame(height: 200)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.4)))

                Button("変換する") {
                    showConfirmation = true
                }
                .buttonStyle(.borderedProminent)
                .padding(.top)

                if !convertedText.isEmpty {
                    HStack {
                        Text(convertedText)
                            .font(.body)
                            .lineLimit(5)
                            .padding(.trailing)

                        Spacer()

                        Button(action: {
                            UIPasteboard.general.string = convertedText
                        }) {
                            Image(systemName: "doc.on.doc")
                                .imageScale(.large)
                        }
                        .padding(.trailing)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Clipboard Formatter")
            .alert("アイコンを置き換えて変換しますか？", isPresented: $showConfirmation) {
                Button("OK") {
                    convertedText = "変換中..."
                    let prompt = """
                    あなたはアプリ間でテキストを整形するアシスタントです。
                    以下の条件を守って、ユーザーが入力したテキストを \(selectedPlatform.displayName) 向けに変換してください：
                    - 受け取ったテキストを変換先アプリ上でそのまま使えるように変換してください。
                    - 変換先アプリで、変換元に依存する表現（メンションやアイコンなど）は変換先で意味が通るように変換してください。
                    - 強調やメンションなどのマークダウン表現も変換先の仕様に変換してください。
                    - 改行は維持し、視認性のあるテキストにしてください。
                    - MacやWindowsでデフォルト使用できる絵文字はそのまま使ってください。

                    テキスト:
                    \(inputText)
                    """

                    GeminiService.format(text: prompt) { result in
                        let log = ConversionLog(platform: selectedPlatform.rawValue, content: result)
                        context.insert(log)
                        convertedText = result
                        UIPasteboard.general.string = result
                    }
                }
                Button("キャンセル", role: .cancel) {}
            }
        }
    }
}

#Preview {
    ConvertView()
}
