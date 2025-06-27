//
//  ConvertView.swift
//  sd-swiftui-original
//
//  Created by ほしょ on 2025/06/26.
//

import SwiftUI

struct ConvertView: View {
    @State private var inputText: String = ""
    @State private var selectedPlatform: PlatformType = .slack
    @State private var showEmojiAlert = false
    @State private var convertedText: String = ""
    @State private var detectedCustomEmojis: [String] = []
    @State private var showEmptyInputAlert = false
    @FocusState private var isTextEditorFocused: Bool

    @Environment(\.modelContext) private var context

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    VStack(alignment: .leading) {
                        Label("変換先アプリケーションを選択", systemImage: "arrow.left.arrow.right.circle")
                            .foregroundColor(.gray)

                        Picker("Platform", selection: $selectedPlatform) {
                            ForEach(PlatformType.allCases, id: \.self) { platform in
                                Text(platform.displayName).tag(platform)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.bottom)
                    }

                    VStack(alignment: .leading) {
                        Label("変換するテキストを入力してください", systemImage: "info.circle")
                            .foregroundColor(.gray)

                        TextEditor(text: $inputText)
                            .focused($isTextEditorFocused)
                            .frame(height: 200)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.4)))

                        Button {
                            isTextEditorFocused = false

                            if inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                showEmptyInputAlert = true
                                return
                            }

                            if PromptBuilder.needsEmojiSanitization(input: inputText) {
                                detectedCustomEmojis = PromptBuilder.extractCustomEmojis(from: inputText)
                                showEmojiAlert = true
                            } else {
                                startConversion(input: inputText)
                            }
                        } label: {
                            Text("変換する")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .foregroundStyle(.white)
                                .background(Color.green)
                                .cornerRadius(12)
                                .padding(.top)
                        }
                    }

                    if !convertedText.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("変換結果")
                                .font(.headline)

                            Text(convertedText)
                                .font(.body)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.2))
                                )

                            CopyButtonView(contentToCopy: convertedText)
                                .padding(.top, 4)
                        }
                        .padding(.vertical)
                    }

                    Spacer()
                }
                .padding()
                .onTapGesture {
                    isTextEditorFocused = false
                }
            }
            .navigationTitle("Clipboard Formatter")
            .alert("入力が空です", isPresented: $showEmptyInputAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("変換するテキストを入力してください。")
            }
            .alert("カスタム絵文字が含まれています", isPresented: $showEmojiAlert) {
                Button("削除して変換") {
                    let cleaned = PromptBuilder.sanitizedInput(from: inputText)
                    startConversion(input: cleaned)
                }
                Button("そのまま変換") {
                    startConversion(input: inputText)
                }
                Button("キャンセル", role: .cancel) {}
            } message: {
                Text("""
SlackやDiscordのカスタム絵文字が含まれています。他のアプリで表示できない可能性があります。

検出された絵文字:
\(detectedCustomEmojis.joined(separator: ", "))
""")
            }
        }
    }

    private func startConversion(input: String) {
        convertedText = "変換中..."
        let prompt = PromptBuilder.buildConversionPrompt(input: input, for: selectedPlatform)

        GeminiService.format(text: prompt) { result in
            let log = ConversionLog(platform: selectedPlatform.rawValue, content: result)
            context.insert(log)
            convertedText = result
            copyToClipboardAsPlainText(result)
        }
    }

    private func copyToClipboardAsPlainText(_ text: String) {
        UIPasteboard.general.setValue(text, forPasteboardType: "public.utf8-plain-text")
    }
}

#Preview {
    ConvertView()
}
