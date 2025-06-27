# 📋 Clipboard Formatter

**Clipboard Formatter** は、Slack・Discord・Notion など異なるアプリ間でのコピー＆ペーストによって発生するテキストの崩れ（改行・絵文字・マークダウン）を自動で整形する、SwiftUI 製のユーティリティアプリです。

---

## 🚀 概要

アプリ間のコピー＆ペーストで起きがちなフォーマットのズレを、アプリごとの最適な形に変換してくれるツールです。

例：

- 改行が消える
- Slack/Discord のカスタム絵文字が表示されない
- マークダウンの記法が崩れる

Clipboard Formatter では、変換先アプリに合わせて、これらを自動で整形できます。

---

## 📄 課題

アプリ間コピーでよくある以下の問題を解決します：

- **改行の消失**：貼り付け先によって改行が失われる
- **独自絵文字の表示不具合**：Slack や Discord のカスタム絵文字が他アプリで表示されない
- **マークダウンの崩れ**：アプリごとに記法が異なり、意図通りに装飾が反映されない

---

## ✨ 主な機能

### 🔧 テキストフォーマット変換

- 入力テキストを Slack / Discord / Notion 向けに最適化して変換
- プラットフォームごとの出力内容を切り替えて確認可能

### 🎭 アイコン（絵文字）処理

- Slack や Discord のカスタム絵文字（`:custom_emoji:`）を検出
- ユーザーにアラートで確認を促し、「削除」「そのまま変換」などを選択可能
- 設定で常に「削除する」モードにも変更可能

### 💾 変換履歴の保存（SwiftData）

- 変換結果とプラットフォーム名・日時を記録
- アプリ内で変換履歴を参照可能

### ⚙️ 設定機能

- 不明な絵文字の削除を有効／無効に切り替え可能
- 表示モード（ライト／ダーク／システム）も切り替え可能

---

## 📝 使い方の流れ

1. 変換元アプリ（Slack など）でテキストをコピー
2. Clipboard Formatter にペースト
3. 出力先アプリ（Notion など）を選択
4. カスタム絵文字が含まれていればアラートで確認
5. 「変換」ボタンを押して出力テキストを確認
6. コピーして目的のアプリにペースト
7. 変換履歴から過去の結果を確認可能

---

## ⚙️ 使用技術

- **SwiftUI**：アプリ UI
- **SwiftData**：変換履歴の永続化
- **AppStorage**：設定値の保持
- **UIPasteboard**：クリップボード操作
- **NavigationStack / Alert / Sheet**：モダンな UI 構成

---

## 🔧 環境構築（Gemini API キーの設定）

1. プロジェクトの `App` フォルダ内に `Config.xcconfig` ファイルを作成します。

2. 以下のように、Gemini API キーを定義してください：

```xcconfig
// App/Config.xcconfig
GEMINI_API_KEY = your_api_key_here
```

3. `Xcode` の `Build Settings > Configuration` にて、この `Config.xcconfig` を読み込むよう設定してください。

4. Swift コードからは以下のように参照します：

```swift
let apiKey = Bundle.main.infoDictionary?["GEMINI_API_KEY"] as? String
```

5. API キーの漏洩を防ぐため、`.gitignore` に追加します：

```gitignore
# Secrets
App/Config.xcconfig
```

---

## 🔮 今後の追加予定

- 太字・斜体などのマークダウン記法に対応した高度な変換
- クリップボードの自動監視
- ライブプレビュー表示
- テキストの一括変換処理

---

異なるアプリ間でも、テキストの整形ストレスをゼロに。
Clipboard Formatter で、もっと快適なコピペ体験を。
