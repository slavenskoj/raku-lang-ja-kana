# Lang::JA::Kana

ひらがなとカタカナの変換を行う包括的なRakuモジュールです。歴史的・廃止されたかな文字もサポートしています。

**リポジトリ**: https://github.com/slavenskoj/raku-lang-ja-kana

## 機能

- **完全な現代かなサポート**: すべての標準ひらがな・カタカナ文字
- **歴史的かな**: `ゐ/ヰ` (wi)、`ゑ/ヱ` (we)、`ゔ/ヴ` (vu) などの廃止文字
- **変体がな**: 歴史的な異体かな文字の包括的カバレッジ (U+1B000-U+1B12F)
- **現代拡張**: 外来語用の音韻組み合わせ (`ファ`、`ティ`、`ヴァ` など)
- **関数ベースAPI**: 分かりやすい `to-hiragana()` および `to-katakana()` 関数
- **適切な処理**: かな文字のみを変換し、その他のテキストはそのまま保持
- **双方向**: 完全な忠実性を持つ双方向変換

## インストール

モジュールファイルをRakuライブラリパスに配置してください：

```bash
mkdir -p lib/Lang/JA
cp Kana.rakumod lib/Lang/JA/
```

## 使用方法

### 基本的な使用方法

```raku
use Lang::JA::Kana;

# 関数を使用
say to-katakana("ひらがな");  # 出力: ヒラガナ
say to-hiragana("カタカナ");  # 出力: かたかな
```

### 混合テキスト

モジュールは混合テキストを適切に処理し、かな文字のみを変換します：

```raku
say to-katakana("Hello こんにちは World");  # 出力: Hello コンニチハ World
say to-hiragana("Hello コンニチハ World");  # 出力: Hello こんにちは World
```

### 歴史的・廃止されたかな

```raku
# 歴史的な wi/we 音 (1946年以前の正書法)
say to-katakana("ゐゑ");  # 出力: ヰヱ
say to-hiragana("ヰヱ");  # 出力: ゐゑ

# VU音
say to-katakana("ゔぁゔぃゔぇゔぉ");  # 出力: ヴァヴィヴェヴォ
say to-hiragana("ヴァヴィヴェヴォ");  # 出力: ゔぁゔぃゔぇゔぉ

# 合字より
say to-katakana("ゟ");  # 出力: ヿ
say to-hiragana("ヿ");  # 出力: ゟ
```

### 外来語音の現代拡張

```raku
# FA-FO音
say to-katakana("ふぁふぃふぇふぉ");  # 出力: ファフィフェフォ
say to-hiragana("ファフィフェフォ");  # 出力: ふぁふぃふぇふぉ

# TI/DI音
say to-katakana("てぃでぃ");  # 出力: ティディ
say to-hiragana("ティディ");  # 出力: てぃでぃ

# 外来語用のWI-WO音
say to-katakana("うぃうぇうぉ");  # 出力: ウィウェウォ
say to-hiragana("ウィウェウォ");  # 出力: うぃうぇうぉ
```

### 小文字かな

```raku
# 小文字母音
say to-katakana("ぁぃぅぇぉ");  # 出力: ァィゥェォ
say to-hiragana("ァィゥェォ");  # 出力: ぁぃぅぇぉ

# 小文字ワ
say to-katakana("ゎ");  # 出力: ヮ
say to-hiragana("ヮ");  # 出力: ゎ
```

### 変体がな（歴史的かな異体）

```raku
# 単一読みの変体がな
say hentaigana-to-hiragana("𛀁𛀂𛀃");  # 出力: あいう

# 複数読みの変体がな（中点で区切り）
say hentaigana-to-hiragana("𛀒𛀓");  # 出力: し・せじ・ぜ

# 歴史的/現代読みを持つW系列
say hentaigana-to-hiragana("𛁆𛁇𛁈");  # 出力: ゐ・いゑ・えを・お

# 複数解釈を持つ複雑な異体
say hentaigana-to-hiragana("𛂬𛂭");  # 出力: ふ・ぶ・ぷへ・べ・ぺ

# 混合テキスト
say hentaigana-to-hiragana("Hello 𛀁𛂚 World");  # 出力: Hello あこ・き World
```

### 現代ひらがなから変体がなへ

```raku
# 単一異体
say hiragana-to-hentaigana("る");  # 出力: 𛁂

# 複数異体
say hiragana-to-hentaigana("あ");  # 出力: 𛀁・𛄀・𛄁
say hiragana-to-hentaigana("き");  # 出力: 𛀈・𛂚・𛂦

# 濁点・半濁点の分割
say hiragana-to-hentaigana("が");  # 出力: 𛀆・𛂥゛
say hiragana-to-hentaigana("ぱ");  # 出力: 𛀩・𛂛゜

# テキスト変換
say hiragana-to-hentaigana("こんにちは");  # 出力: 𛀎・𛂚𛁉𛀥𛀜・𛂫𛀩・𛂛

# 混合テキスト
say hiragana-to-hentaigana("Hello がき World");  # 出力: Hello 𛀆・𛂥゛𛀈・𛂚・𛂦 World
```

### 半角カタカナ

```raku
# 半角から全角への変換
say to-fullwidth-katakana("ｱｲｳｴｵ");  # 出力: アイウエオ
say to-fullwidth-katakana("ｶﾀｶﾅ");   # 出力: カタカナ
say to-fullwidth-katakana("Hello ｱｲｳ World");  # 出力: Hello アイウ World

# 全角から半角への変換
say to-halfwidth-katakana("アイウエオ");  # 出力: ｱｲｳｴｵ
say to-halfwidth-katakana("カタカナ");   # 出力: ｶﾀｶﾅ
say to-halfwidth-katakana("Hello アイウ World");  # 出力: Hello ｱｲｳ World

# 既存関数との統合（半角は自動変換）
say to-hiragana("ｶﾀｶﾅ");  # 出力: かたかな
say to-hiragana("ｱｲｳｴｵ");  # 出力: あいうえお

# 濁音・半濁音の組み合わせ
say to-fullwidth-katakana("ｶﾞｷﾞｸﾞｹﾞｺﾞ");  # 出力: ガギグゲゴ
say to-fullwidth-katakana("ﾊﾟﾋﾟﾌﾟﾍﾟﾎﾟ");  # 出力: パピプペポ
say to-halfwidth-katakana("ザジズゼゾダヂヅデド");  # 出力: ｻﾞｼﾞｽﾞｾﾞｿﾞﾀﾞﾁﾞﾂﾞﾃﾞﾄﾞ

# 句読点・記号
say to-fullwidth-katakana("｡､｢｣ｰ");  # 出力: 。、「」ー
```

### 四角カタカナ（囲み形式）

```raku
# 丸付きカタカナ
say decircle-katakana("㋐㋑㋒㋓㋔");  # 出力: アイウエオ
say decircle-katakana("㋕㋖㋗㋘㋙");  # 出力: カキクケコ

# 四角い計測単位
say desquare-katakana("㌔㌘㍍");  # 出力: キログラムメートル
say desquare-katakana("㍑㌦㍀");  # 出力: リットルドルポンド

# 四角い技術用語
say desquare-katakana("㌲㌹㌾㍗");  # 出力: ファラッドヘルツボルトワット

# 四角い建物・場所用語
say desquare-katakana("㌀㌱㍇");  # 出力: アパートビルマンション

# 四角カタカナを含む混合テキスト
say desquare-katakana("Price is ㌦100 per ㍑");  # 出力: Price is ドル100 per リットル
```

### 逆変換

```raku
# カタカナから丸付き形式
say encircle-katakana("アイウエオ");  # 出力: ㋐㋑㋒㋓㋔
say encircle-katakana("カキクケコ");  # 出力: ㋕㋖㋗㋘㋙

# カタカナから四角形式
say ensquare-katakana("キロ グラム メートル");  # 出力: ㌔ ㌘ ㍍
say ensquare-katakana("ドル ポンド");  # 出力: ㌦ ㍀
say ensquare-katakana("ワット ヘルツ");  # 出力: ㍗ ㌹

# 混合テキスト変換
say ensquare-katakana("The price is ドル for ワット");  # 出力: The price is ㌦ for ㍗

# 注意：すべての文字に丸付き形式があるわけではありません（例：ンには丸付き形式がない）
say encircle-katakana("アン");  # 出力: ㋐ン（アのみが丸付きになる）
```

## API リファレンス

### 関数

#### `to-hiragana(Str $text) returns Str`
テキスト内のカタカナ文字をひらがなに変換します。
- **パラメータ**: `$text` - 変換するテキストを含む文字列
- **戻り値**: カタカナがひらがなに変換された文字列
- **例**: `to-hiragana("カタカナ")` → `"かたかな"`

#### `to-katakana(Str $text) returns Str`
テキスト内のひらがな文字をカタカナに変換します。
- **パラメータ**: `$text` - 変換するテキストを含む文字列
- **戻り値**: ひらがながカタカナに変換された文字列
- **例**: `to-katakana("ひらがな")` → `"ヒラガナ"`

#### `to-fullwidth-katakana(Str $text) returns Str`
半角カタカナ文字を全角カタカナに変換します。
- **パラメータ**: `$text` - 変換する半角カタカナを含む文字列
- **戻り値**: 半角カタカナが全角カタカナに変換された文字列
- **例**: `to-fullwidth-katakana("ｱｲｳ")` → `"アイウ"`

#### `to-halfwidth-katakana(Str $text) returns Str`
全角カタカナ文字を半角カタカナに変換します。
- **パラメータ**: `$text` - 変換する全角カタカナを含む文字列
- **戻り値**: 全角カタカナが半角カタカナに変換された文字列
- **例**: `to-halfwidth-katakana("アイウ")` → `"ｱｲｳ"`

#### `hentaigana-to-hiragana(Str $text) returns Str`
変体がな（歴史的かな異体）を現代ひらがなに変換します。複数の読みがある文字は中点（・）で区切られたリストに変換されます。
- **パラメータ**: `$text` - 変換する変体がな文字を含む文字列
- **戻り値**: 変体がなが現代ひらがなに変換された文字列
- **例**: `hentaigana-to-hiragana("𛀒𛀓")` → `"し・せじ・ぜ"`

#### `hiragana-to-hentaigana(Str $text) returns Str`
現代ひらがなを同等の変体がな異体に変換します。濁点（゛）・半濁点（゜）は変換前に文字から分離されます。複数の異体は中点（・）で結合されます。
- **パラメータ**: `$text` - 変換するひらがな文字を含む文字列
- **戻り値**: ひらがなが変体がな異体に変換された文字列
- **例**: `hiragana-to-hentaigana("あが")` → `"𛀁・𛄀・𛄁𛀆・𛂥゛"`

#### `split-sound-marks(Str $char) returns List`
かな文字から濁点（゛）・半濁点（゜）の音韻記号を分離します。
- **パラメータ**: `$char` - 単一のかな文字
- **戻り値**: 基底文字と音韻記号（存在する場合）を含むリスト
- **例**: `split-sound-marks("が")` → `("か", "゛")`

#### `decircle-katakana(Str $text) returns Str`
丸付きカタカナ（㋐-㋾）をその構成文字に変換します。これらは円で囲まれた個々のかな音節を表します。
- **パラメータ**: `$text` - 変換する丸付きカタカナ文字を含む文字列
- **戻り値**: 丸付きカタカナが通常のカタカナに変換された文字列
- **例**: `decircle-katakana("㋐㋕㋚")` → `"アカサ"`

#### `desquare-katakana(Str $text) returns Str`
四角カタカナ（㌀-㍗）をその構成文字に変換します。これらは四角い箱内の技術用語、単位、略語を表します。
- **パラメータ**: `$text` - 変換する四角カタカナ文字を含む文字列
- **戻り値**: 四角カタカナが通常のカタカナに変換された文字列
- **例**: `desquare-katakana("㌔㌦㍍")` → `"キロドルメートル"`

#### `encircle-katakana(Str $text) returns Str`
通常のカタカナ文字をその丸付き形式（㋐-㋾）に変換します。注意：すべてのかなに丸付き形式があるわけではありません（例：ン）。
- **パラメータ**: `$text` - 変換するカタカナ文字を含む文字列
- **戻り値**: 利用可能なカタカナが丸付きカタカナに変換され、その他は変更されない文字列
- **例**: `encircle-katakana("アカサ")` → `"㋐㋕㋚"`

#### `ensquare-katakana(Str $text) returns Str`
通常のカタカナ技術用語をその四角形式（㌀-㍗）に変換します。事前定義された技術用語のみが変換されます。部分的な一致を避けるため、長い用語から先に処理されます。
- **パラメータ**: `$text` - 変換するカタカナ用語を含む文字列
- **戻り値**: 認識されたカタカナ用語が四角カタカナに変換され、その他は変更されない文字列
- **例**: `ensquare-katakana("キロ ドル メートル")` → `"㌔ ㌦ ㍍"`


## サポートされる文字セット

### 現代かな
- 基本46文字のひらがな/カタカナペア
- 濁音記号（濁点・半濁点）: が-ぽ/ガ-ポ
- 組み合わせ文字: きゃ-りょ/キャ-リョ
- 小文字かな: ゃゅょっ/ャュョッ および ぁぃぅぇぉゎ/ァィゥェォヮ

### 半角カタカナ
半角カタカナ（U+FF65-U+FF9F）の完全サポート：
- **基本文字**: ｱｲｳｴｵ...ﾜｦﾝ（46基本カタカナ）
- **小文字**: ｧｨｩｪｫｬｭｮｯ
- **濁音組み合わせ**: ｶﾞｷﾞｸﾞｹﾞｺﾞ → ガギグゲゴ（濁点＋基底）
- **半濁音組み合わせ**: ﾊﾟﾋﾟﾌﾟﾍﾟﾎﾟ → パピプペポ（半濁点＋基底）
- **音韻記号**: ﾞ（濁点）、ﾟ（半濁点）
- **句読点**: ｡､｢｣ｰ → 。、「」ー
- **VU音**: ｳﾞ → ヴ
- **自動統合**: 半角入力は既存関数で自動変換

### 歴史的かな
- **廃止音**: ゐ/ヰ（wi）、ゑ/ヱ（we）
- **VU音**: ゔ/ヴ
- **合字**: ゟ/ヿ（より）

### 変体がな（歴史的異体）
Unicode変体がなブロック（U+1B000-U+1B12F）の完全サポート。古典日本語写本で使用された全かな音節の歴史的異体形式を含む。多くの変体がな文字は文脈に応じて複数の読みを持ちます。

### 現代拡張
借用語転写用の外来音組み合わせ：
- **F音**: ふぁ-ふぉ/ファ-フォ
- **V音**: ゔぁ-ゔぉ/ヴァ-ヴォ  
- **拡張子音**: てぃ/ティ、でぃ/ディ、とぅ/トゥ、どぅ/ドゥ
- **W音**: うぃ/ウィ、うぇ/ウェ、うぉ/ウォ
- **その他**: くぁ/クァ、ぐぁ/グァ、つぁ/ツァ、ちぇ/チェ、じぇ/ジェ、しぇ/シェ、いぇ/イェ

### 四角カタカナ（囲み形式）
- **丸付きカタカナ**（U+32D0-U+32FE）: ㋐-㋾ 個々のかな音節を表す
- **四角カタカナ単位**（U+3300-U+3357）: ㌀-㍗ 計測単位、通貨、技術用語を表す
- **一般的用途**: 技術文書、科学文献、財務文書、建築図面

## 文字変換動作

- **かな文字**: ひらがなとカタカナ間で変換
- **非かな文字**: 変更されずそのまま（ラテン文字、数字、句読点、漢字など）
- **混合テキスト**: かな部分のみが変換される
- **未知の文字**: 変更されずそのまま通過
- **組み合わせ文字**: 完全な単位として処理（長い組み合わせから先に処理）

## テスト

付属のテストスイートを実行して機能を検証してください：

```bash
raku t/01-basic.t
```

テストスイートの内容：
- 基本変換機能
- 混合テキスト処理
- 歴史的・廃止されたかな
- 現代拡張
- 小文字かな異体
- 変体がな変換（複数読み）
- ひらがなから変体がなへの変換（音韻記号分割付き）
- 丸付きカタカナ変換（双方向）
- 四角カタカナ変換（双方向）
- 半角カタカナ変換（双方向）
- 半角と既存関数の統合
- エッジケース

## 技術的注記

- **Unicode サポート**: 変体がな用拡張平面を含む完全なUnicodeサポート
- **パフォーマンス**: 複数文字シーケンスを正しく処理するため、長い組み合わせから先に最適化
- **メモリ効率**: 定数ルックアップテーブル使用
- **スレッドセーフ**: 不変データ構造による純粋関数実装

## インストール

### Zefから（推奨）

```bash
zef install Lang::JA::Kana
```

### ソースから

```bash
git clone https://github.com/slavenskoj/raku-lang-ja-kana.git
cd raku-lang-ja-kana
zef install .
```

## ライセンス

Copyright 2025 Danslav Slavenskoj

このライブラリはフリーソフトウェアです。Artistic License 2.0の下で再配布・改変できます。

## 貢献

貢献を歓迎します！以下についてのissueやプルリクエストをお気軽に提出してください：
- 追加の歴史的かな異体
- パフォーマンス改善
- ドキュメント拡充
- テストカバレッジ拡大

## 関連項目

- [Unicode ひらがなブロック](https://unicode.org/charts/PDF/U3040.pdf)（U+3040-U+309F）
- [Unicode カタカナブロック](https://unicode.org/charts/PDF/U30A0.pdf)（U+30A0-U+30FF）
- [Unicode かな拡張Aブロック](https://unicode.org/charts/PDF/U1B000.pdf)（U+1B000-U+1B0FF）- 変体がな
- [歴史的かな遣い](https://ja.wikipedia.org/wiki/歴史的仮名遣)
- [変体がな](https://ja.wikipedia.org/wiki/変体仮名)