//
//  PromptBuilder.swift
//  sd-swiftui-original
//
//  Created by ほしょ on 2025/06/26.
//

import Foundation

struct PromptBuilder {
    static func buildConversionPrompt(input: String, for platform: PlatformType) -> String {
        let platformGuidance = platformGuidanceText(for: platform)

        return """
        あなたはアプリ間でテキストを整形するアシスタントです。
        以下の条件を守って、ユーザーが入力したテキストを\(platform.displayName)向けに変換してください。

        ■ 全体ルール
        - メンションや絵文字、マークダウンなど、すべての特殊構文はそのプラットフォームの公式仕様に厳密に準拠してください。
        - 改行や段落構造は保持し、元の文意を損なわないようにしてください。
        - MacやWindowsで使える標準絵文字はそのまま活用してください。
        - 変換先のプラットフォームで使用できない絵文字は、削除するようにしてください。

        ■ \(platform.displayName)の詳細仕様
        \(platformGuidance)

        ■ 変換対象テキスト
        \"\"\"
        \(input)
        \"\"\"
        """
    }

    private static func platformGuidanceText(for platform: PlatformType) -> String {
        switch platform {
        case .slack:
            return """
            - メンション：
              ユーザー： `@ユーザー名` の形式でメンションできます（例：`@yamada`）  
              チャンネル： `#チャンネル名` の形式でチャンネルを参照できます（例：`#general`）  
              全体宛てメンション：
                - `@here`：現在オンライン中のメンバーに通知
                - `@channel`：チャンネル内の全員に通知
                - `@everyone`：全メンバーに通知（#generalなど一部のチャンネルでのみ使用可能）

            - 絵文字：
              Slackでは `:emoji_name:` 形式で絵文字を挿入できます。標準絵文字（例：`:smile:`）に加え、
              ユーザーがアップロードした**カスタム絵文字**も使用可能です。  
              ただし、Slack外では表示できないため、他アプリ向けに変換する際は削除または標準絵文字に置換してください。

            - マークダウン（書式）対応：
              - **太字**： `*テキスト*` または `Ctrl/Cmd + B`
              - *斜体*： `_テキスト_` または `Ctrl/Cmd + I`
              - ~打ち消し線~： `~テキスト~`
              - `コード（インライン）`： `` `コード` ``（バッククォート1つ）
              - コードブロック： ``` ```複数行コード``` ```（バッククォート3つ）
              - 引用： `> 引用文`

            - その他：
              Slackのメッセージはリッチテキスト対応ですが、一部機能（見出し、リストなど）はMarkdownではなく
              エディタUIから直接入力される形式で管理されています。自動変換時は書式の互換性に注意してください。
            """


        case .discord:
            return """
            - メンション：
              ユーザーは `@ユーザー名`、ロールは `@ロール名`、チャンネルは `#チャンネル名` で表現されます。
              全体宛てメンションは `@here`（オンライン中の全員）または `@everyone`（全員）を使用します。
              Slackの `@channel` に相当する機能は `@everyone` です。

            - 絵文字：
              カスタム絵文字は `:emoji_name:` の形式で使用できます（例：`:partyparrot:`）。
              Unicode絵文字（例：🙂）も使用可能です。
              他のアプリで表示できない可能性があるため、必要に応じて削除または置換してください。

            - マークダウン対応：
              **太字** → `**テキスト**` または `__テキスト__`  
              *斜体* → `*テキスト*` または `_テキスト_`  
              __下線__ → `__テキスト__`  
              ~~取り消し線~~ → `~~テキスト~~`  
              `インラインコード` → `` `コード` ``  
              複数行コードブロック → ``` ```言語名（任意）\nコード\n``` ```
              > 引用 → `> 引用文`（複数行も可）  
              箇条書き → `-` または `*` を行頭に  
              番号付きリスト → `1.`, `2.` のように記述

            - 注意点：
              Discord では複数のマークダウンを組み合わせて使用することが可能です（例：**_太字＋斜体_**）。
              コードブロックで使用する言語名は省略可能ですが、ハイライト表示を有効にするために指定を推奨します。
            """

        case .notion:
            return """
            - メンション：
              ユーザーやページには `@表示名` の形式でメンションできます。
              SlackやDiscordのような「全体宛てメンション（@channel / @everyone）」の概念は存在しません。

            - 絵文字：
              基本的なUnicode絵文字（🙂など）は使用可能です。
              Notionでは独自のカスタム絵文字やリアクション絵文字の登録・使用はできないため、
              SlackやDiscord由来のカスタム絵文字（`:emoji_name:` 形式など）は削除または標準絵文字へ置換してください。

            - マークダウン対応：
              **太字** → `**テキスト**` または `Ctrl/Cmd + B`  
              *斜体* → `_テキスト_` または `Ctrl/Cmd + I`  
              ~~取り消し線~~ → `~テキスト~`（変換には対応しますがNotion側で明示的ショートカットなし）  
              `インラインコード` → `` `コード` `` または `Ctrl/Cmd + E`  

            - その他のフォーマット（変換対象外）：
              見出し（例：`# タイトル`）や箇条書き（例：`- 項目`）などは Notion 独自のスタイルで管理されており、
              Markdownからの完全な自動変換には対応していません。必要に応じて手動で整形してください。
            """
        }
    }
}

// MARK: - カスタム絵文字チェック＆除去
extension PromptBuilder {
    static func needsEmojiSanitization(input: String) -> Bool {
        return extractCustomEmojis(from: input).isEmpty == false
    }

    static func extractCustomEmojis(from input: String) -> [String] {
        let regex = try! NSRegularExpression(pattern: ":[a-zA-Z0-9_]+:")
        let nsrange = NSRange(input.startIndex..., in: input)
        return regex.matches(in: input, range: nsrange).map {
            String(input[Range($0.range, in: input)!])
        }
    }

    static func sanitizedInput(from input: String) -> String {
        let regex = try! NSRegularExpression(pattern: ":[a-zA-Z0-9_]+:")
        let nsrange = NSRange(input.startIndex..., in: input)
        return regex.stringByReplacingMatches(in: input, options: [], range: nsrange, withTemplate: "")
    }
}
