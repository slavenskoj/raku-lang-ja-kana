# Lang::JA::Kana - 日本語仮名変換ユーティリティ

**言語:** [English](README.md) • [日本語](README-jp.md)

**文書:**
- **メイン**: [English](README.md) • [日本語](README-jp.md)
- **ローマ字**: [README-Romaji.md](README-Romaji.md)
- **キリル文字**: [English](README-Kuriru-moji.md) • [Русский](README-Kuriru-moji-ru.md)
- **ハングル**: [English](README-Hangul.md) • [한국어](README-Hangul-kr.md)

## 概要

Lang::JA::Kanaは、日本語の仮名文字（ひらがな・カタカナ）とその様々な形式間での変換を行うRakuモジュールです。現代仮名、歴史的変異文字、半角文字、特殊なUnicode記号に対応しております。

## 機能

- **双方向文字変換**: ひらがなとカタカナ間のスムーズな変換
- **半角対応**: 半角カタカナ（ﾊﾝｶｸ）の変換処理
- **歴史的仮名**: 変体仮名（へんたいがな）と廃止文字への対応
- **現代拡張**: 外来音適応（ファ、ティ、ウィなど）
- **特殊記号**: 丸囲み・四角囲みカタカナの処理
- **音標解析**: 濁点・半濁点の分離と解析
- **他文字体系統合**: ローマ字、キリル文字、ハングル変換機能との連携

## インストール

```raku
use Lang::JA::Kana;
```

## 基本的な使用方法

### ひらがな ↔ カタカナ変換

```raku
use Lang::JA::Kana;

# 基本変換
say to-katakana("こんにちは");     # → コンニチハ
say to-hiragana("コンニチハ");     # → こんにちは

# 現代拡張音
say to-katakana("ふぁみりー");     # → ファミリー
say to-hiragana("ファミリー");     # → ふぁみりー

# 拗音
say to-katakana("きゃりーぱみゅぱみゅ");  # → キャリーパミュパミュ
say to-hiragana("キャリーパミュパミュ");  # → きゃりーぱみゅぱみゅ

# 混合テキスト（仮名以外はそのまま通過）
say to-katakana("Hello こんにちは World");  # → Hello コンニチハ World
say to-hiragana("Hello コンニチハ World");  # → Hello こんにちは World
```

### 半角カタカナ変換

```raku
# 半角→全角変換
say to-fullwidth-katakana("ｱｲｳｴｵ");     # → アイウエオ
say to-fullwidth-katakana("ｶﾞｷﾞｸﾞ");    # → ガギグ（濁音結合）
say to-fullwidth-katakana("ﾊﾟﾋﾟﾌﾟ");    # → パピプ（半濁音結合）

# 全角→半角変換
say to-halfwidth-katakana("アイウエオ");   # → ｱｲｳｴｵ
say to-halfwidth-katakana("ガギグ");      # → ｶﾞｷﾞｸﾞ
say to-halfwidth-katakana("パピプ");      # → ﾊﾟﾋﾟﾌﾟ

# 他の変換との統合
say to-hiragana("ｶﾀｶﾅ");               # → かたかな（半角を自動変換）
```

## 文字対応

### 標準仮名

**五十音全文字:**
```raku
# 基本母音
to-katakana("あいうえお");  # → アイウエオ

# カ行
to-katakana("かきくけこ");  # → カキクケコ
to-katakana("がぎぐげご");  # → ガギグゲゴ

# サ行
to-katakana("さしすせそ");  # → サシスセソ
to-katakana("ざじずぜぞ");  # → ザジズゼゾ

# タ行
to-katakana("たちつてと");  # → タチツテト
to-katakana("だぢづでど");  # → ダヂヅデド

# ナ行
to-katakana("なにぬねの");  # → ナニヌネノ

# ハ行
to-katakana("はひふへほ");  # → ハヒフヘホ
to-katakana("ばびぶべぼ");  # → バビブベボ（濁音）
to-katakana("ぱぴぷぺぽ");  # → パピプペポ（半濁音）

# マ行
to-katakana("まみむめも");  # → マミムメモ

# ヤ行
to-katakana("やゆよ");     # → ヤユヨ

# ラ行
to-katakana("らりるれろ");  # → ラリルレロ

# ワ行・ン
to-katakana("わゐゑをん");  # → ワヰヱヲン
```

### 小書き仮名

```raku
# 小書き母音
to-katakana("ぁぃぅぇぉ");  # → ァィゥェォ

# 小書きヤ行音
to-katakana("ゃゅょ");     # → ャュョ

# 促音
to-katakana("っ");         # → ッ

# 小書きワ
to-katakana("ゎ");         # → ヮ
```

### 拗音

```raku
# ヤ行拗音
to-katakana("きゃきゅきょ");  # → キャキュキョ
to-katakana("しゃしゅしょ");  # → シャシュショ
to-katakana("ちゃちゅちょ");  # → チャチュチョ
to-katakana("にゃにゅにょ");  # → ニャニュニョ
to-katakana("ひゃひゅひょ");  # → ヒャヒュヒョ
to-katakana("みゃみゅみょ");  # → ミャミュミョ
to-katakana("りゃりゅりょ");  # → リャリュリョ

# 濁音拗音
to-katakana("ぎゃぎゅぎょ");  # → ギャギュギョ
to-katakana("じゃじゅじょ");  # → ジャジュジョ
to-katakana("びゃびゅびょ");  # → ビャビュビョ
to-katakana("ぴゃぴゅぴょ");  # → ピャピュピョ
```

### 外来音対応の現代拡張

```raku
# ファ行音
to-katakana("ふぁふぃふぇふぉ");  # → ファフィフェフォ

# ティ・ディ音
to-katakana("てぃでぃ");         # → ティディ
to-katakana("とぅどぅ");         # → トゥドゥ

# ウィ行音
to-katakana("うぃうぇうぉ");     # → ウィウェウォ

# ヴァ行音
to-katakana("ゔぁゔぃゔぇゔぉ"); # → ヴァヴィヴェヴォ

# クァ行音
to-katakana("くぁくぃくぇくぉ"); # → クァクィクェクォ
to-katakana("ぐぁぐぃぐぇぐぉ"); # → グァグィグェグォ

# ツァ行音
to-katakana("つぁつぃつぇつぉ"); # → ツァツィツェツォ

# その他の組み合わせ
to-katakana("ちぇじぇしぇいぇ"); # → チェジェシェイェ
```

### 歴史的・廃止仮名

```raku
# 歴史的ワ行
to-katakana("ゐゑを");  # → ヰヱヲ

# ヴ音
to-katakana("ゔ");      # → ヴ

# 合字ヨリ
to-katakana("ゟ");      # → ヿ
```

## 変体仮名（へんたいがな）対応

変体仮名は、文字統一以前に使用されていた仮名の歴史的変異形です。本モジュールではこれらのUnicode文字に対応しております。

### 変体仮名→ひらがな変換

```raku
# 基本変換
say hentaigana-to-hiragana("𛀁𛀂𛀃");  # → あいう

# 複数読み（一部の変体仮名は曖昧な読み方があります）
say hentaigana-to-hiragana("𛀒");      # → し・せ（「し」または「せ」）
say hentaigana-to-hiragana("𛁆");      # → ゐ・い（「ゐ」または「い」）

# 複雑な例
say hentaigana-to-hiragana("𛀆𛀈𛀊");  # → かきく
```

### ひらがな→変体仮名変換

```raku
# 単一変体
say hiragana-to-hentaigana("る");      # → 𛁂

# 複数変体（すべての可能性を表示）
say hiragana-to-hentaigana("あ");      # → 𛀁・𛄀・𛄁
say hiragana-to-hentaigana("し");      # → 𛀒・𛀖・𛂡

# 濁音付き
say hiragana-to-hentaigana("が");      # → （変体）゛
```

### 変体仮名の字源

多くの変体仮名は特定の漢字に由来しています：

- **𛀁**（あ）: 安（あん）より
- **𛀂**（い）: 以（い）より
- **𛀃**（う）: 宇（う）より
- **𛀆**（か）: 加（か）より
- **𛀈**（き）: 幾（き）より
- **𛀐**（さ）: 左（さ）より
- **𛀒**（し・せ）: 之（し・せ）より - 読み方が曖昧
- **𛀚**（た）: 太（た）より
- **𛀜**（ち）: 知（ち）より

## 音標処理

本モジュールでは、濁点・半濁点の解析と操作のためのユーティリティを提供しております。

### 音標分離

```raku
# 濁音文字を基底文字+記号に分離
my @parts = split-sound-marks("が");
say @parts[0];  # → か（基底文字）
say @parts[1];  # → ゛（濁点）

# 半濁音文字の分離
@parts = split-sound-marks("ぱ");
say @parts[0];  # → は（基底文字）
say @parts[1];  # → ゜（半濁点）

# 通常文字はそのまま
@parts = split-sound-marks("あ");
say @parts[0];  # → あ（分離なし）
```

### 実用例

```raku
# 文字構成の解析
sub analyze-kana($char) {
    my @parts = split-sound-marks($char);
    if @parts.elems == 2 {
        say "$char = {@parts[0]} + {@parts[1]}";
    } else {
        say "$char = 基底文字";
    }
}

analyze-kana("が");  # → が = か + ゛
analyze-kana("ぱ");  # → ぱ = は + ゜
analyze-kana("あ");  # → あ = 基底文字
```

## 特殊Unicode記号

### 丸囲みカタカナ

```raku
# 丸囲みカタカナを構成要素に変換
say decircle-katakana("㋐㋑㋒");  # → アイウ
say decircle-katakana("㋕㋖㋗");  # → カキク

# 構成要素を丸囲みカタカナに変換
say encircle-katakana("アイウ");  # → ㋐㋑㋒
say encircle-katakana("カキク");  # → ㋕㋖㋗
```

### 四角囲みカタカナ（単位・略語）

```raku
# 四角囲みカタカナを完全形に変換
say desquare-katakana("㌔");     # → キロ（kilo）
say desquare-katakana("㌧");     # → トン（ton）
say desquare-katakana("㍍");     # → メートル（meter）
say desquare-katakana("㍑");     # → リットル（liter）

# 完全形を四角囲みカタカナに変換
say ensquare-katakana("キロ");     # → ㌔
say ensquare-katakana("メートル");  # → ㍍

# 複雑な例
say desquare-katakana("㌔㍍");     # → キロメートル
say desquare-katakana("㍉㍍");     # → ミリメートル
```

**よく使われる四角囲みカタカナ単位:**
- ㌔（キロ）- kilo
- ㌧（トン）- ton  
- ㍍（メートル）- meter
- ㍑（リットル）- liter
- ㍉（ミリ）- milli
- ㌢（センチ）- centi
- ㌦（ドル）- dollar
- ㌫（パーセント）- percent
- ㍗（ワット）- watt

## 他文字体系変換統合

本モジュールでは、他の文字体系変換器とのシームレスな統合を提供し、半角変換を自動処理いたします。

### ローマ字変換

```raku
# 半角の自動処理
say kana-to-romaji("ｺﾝﾆﾁﾊ");                    # → konnichiha
say kana-to-romaji("こんにちは");                 # → konnichiha

# 複数のローマ字化システム
say kana-to-romaji("しんぶん", :system<hepburn>);  # → shinbun
say kana-to-romaji("しんぶん", :system<kunrei>);   # → sinbun
say kana-to-romaji("しんぶん", :system<nihon>);    # → sinbun

# 促音処理
say kana-to-romaji("がっこう");                   # → gakkou
say kana-to-romaji("ちょっと");                   # → chotto
```

### キリル文字変換

```raku
# ポリワーノフ式（既定）
say kana-to-kuriru-moji("こんにちは");              # → конничиха
say kana-to-kuriru-moji("ひらがな");               # → хирагана

# 音韻式
say kana-to-kuriru-moji("しんぶん", :system<phonetic>);  # → шинбун
say kana-to-kuriru-moji("ちゃちゅちょ", :system<phonetic>); # → чачучо

# スラブ語族変異形
say kana-to-kuriru-moji("さくら", :system<ukrainian>);    # → сакура
say kana-to-kuriru-moji("さくら", :system<serbian>);      # → сакура
```

### ハングル変換

```raku
# 標準式（既定）
say kana-to-hangul("こんにちは");                 # → 곤니치하
say kana-to-hangul("ひらがな");                  # → 히라가나

# 学術式（子音重複付き）
say kana-to-hangul("がっこう", :system<academic>);  # → 깍코우
say kana-to-hangul("ばっば", :system<academic>);    # → 빱빠

# 音韻式（日本語発音保持）
say kana-to-hangul("ちゃちゅちょ", :system<phonetic>); # → 치야치유치요

# 流行式（K-pop・メディア使用）
say kana-to-hangul("ちゅう", :system<popular>);     # → 추우
```

## 高度な機能

### 混合テキスト処理

すべての関数は混合テキストを適切に処理し、仮名文字のみを変換いたします：

```raku
say to-katakana("Hello こんにちは 123");           # → Hello コンニチハ 123
say to-hiragana("Hello コンニチハ 123");           # → Hello こんにちは 123
say to-fullwidth-katakana("Hello ｱｲｳ 123");      # → Hello アイウ 123
```

### 連鎖変換

```raku
# 複雑な変換チェーン
my $text = "ｺﾝﾆﾁﾊ";                              # 半角カタカナ
$text = to-fullwidth-katakana($text);              # → コンニチハ
$text = to-hiragana($text);                        # → こんにちは
say kana-to-romaji($text);                         # → konnichiha

# 歴史的処理
$text = "𛀆𛀈𛀊";                                  # 変体仮名
$text = hentaigana-to-hiragana($text);             # → かきく
$text = to-katakana($text);                        # → カキク
say encircle-katakana($text);                      # → ㋕㋖㋗
```

### 空文字列・境界ケース処理

```raku
say to-katakana("");                 # → ""（空文字列）
say to-hiragana("");                 # → ""（空文字列）
say to-fullwidth-katakana("");       # → ""（空文字列）
say hentaigana-to-hiragana("");      # → ""（空文字列）
```

## 文字範囲

### 対応Unicode範囲

- **ひらがな**: U+3040-U+309F（ひらがな）
- **カタカナ**: U+30A0-U+30FF（カタカナ）
- **半角カタカナ**: U+FF61-U+FF9F（ﾊﾝｶｸ）
- **変体仮名**: U+1B001-U+1B11E（𛀁-𛄟）
- **丸囲みカタカナ**: U+32D0-U+32FE（㋐-㋾）
- **四角囲みカタカナ**: U+3300-U+3357（㌀-㍗）

### 文字数

- **基本ひらがな・カタカナ**: 46 + 25（濁音・半濁音）= 71文字
- **小書き仮名**: 10文字
- **ヤ行拗音**: 33組み合わせ
- **現代拡張音**: 25+の外来音適応
- **半角形式**: 63文字
- **変体仮名**: 300+の歴史的変体
- **丸囲みカタカナ**: 47記号
- **四角囲みカタカナ**: 88単位略語

## 性能に関する考慮事項

### 最適化機能

- **最長優先マッチング**: 多文字組み合わせを単一文字より先に処理
- **効率的ハッシュ検索**: Rakuハッシュを使用したO(1)文字マッピング
- **最小正規表現使用**: 可能な限り直接文字列置換を使用
- **遅延評価**: 変換テーブルは必要時のみ計算

### 推奨事項

```raku
# 効率的: 単一変換呼び出し
my $result = to-katakana($large-text);

# 非効率: 複数の小変換
for @small-texts -> $text {
    $result ~= to-katakana($text);  # バッチ処理を検討
}

# 効率的: 変換結果の再利用
my $katakana = to-katakana($text);
my $romaji = kana-to-romaji($katakana);  # 既変換カタカナを使用
```

## エラー処理・境界ケース

### 堅牢な入力処理

```raku
# 無効・未知文字は保持
say to-katakana("こんにちは🎌");     # → コンニチハ🎌
say to-hiragana("カタカナ🗾");       # → かたかな🗾

# 混合文字体系の適切な処理
say to-katakana("ひらがなカタカナ");  # → ヒラガナカタカナ
say to-hiragana("カタカナひらがな");  # → かたかなひらがな

# 部分変換の正常動作
say to-fullwidth-katakana("Normal ｱｲｳ text");  # → Normal アイウ text
```

### 曖昧文字処理

```raku
# 複数読みのある変体仮名
say hentaigana-to-hiragana("𛀒");  # → し・せ（すべての可能性を表示）

# 現代的等価がない歴史的文字は保持
say to-katakana("古い𛀁文字");      # → 古イ𛀁文字（𛀁は別途処理）
```

## 統合例

### テキスト処理パイプライン

```raku
sub normalize-japanese-text($text) {
    # ステップ1: 半角を全角に変換
    my $normalized = to-fullwidth-katakana($text);
    
    # ステップ2: 処理のためひらがなに統一
    $normalized = to-hiragana($normalized);
    
    # ステップ3: 歴史的仮名を変換
    $normalized = hentaigana-to-hiragana($normalized);
    
    # ステップ4: 略語形式を展開
    $normalized = desquare-katakana($normalized);
    $normalized = decircle-katakana($normalized);
    
    return $normalized;
}

# 使用例
my $text = "𛀁ｲｳ㌔㋖";
say normalize-japanese-text($text);  # → あいうキロキ
```

### 多言語変換

```raku
sub convert-to-all-scripts($japanese-text) {
    # 入力を正規化
    my $normalized = to-fullwidth-katakana($japanese-text);
    
    return {
        hiragana => to-hiragana($normalized),
        katakana => to-katakana($normalized),
        romaji => kana-to-romaji($normalized),
        cyrillic => kana-to-kuriru-moji($normalized),
        hangul => kana-to-hangul($normalized)
    };
}

# 使用例
my %scripts = convert-to-all-scripts("ｺﾝﾆﾁﾊ");
say %scripts<hiragana>;  # → こんにちは
say %scripts<romaji>;    # → konnichiha
say %scripts<cyrillic>;  # → конничиха
say %scripts<hangul>;    # → 곤니치하
```

## 制限事項

1. **漢字処理**: 漢字の変換は行いません
2. **文脈依存性**: 意味解析なしの純粋な文字レベル変換
3. **歴史的正確性**: 変体仮名マッピングはUnicode標準に基づき、歴史的写本に基づくものではありません
4. **地域変異**: 標準日本語に基づき、方言発音は対象外

## 用途

### 教育用途
- 日本語学習教材
- 文字変換練習
- 歴史的テキストの現代化
- Unicode文字参照

### テキスト処理
- 文書正規化
- 検索・索引システム
- レガシーテキスト変換
- 文字エンコーディング移行

### デジタル人文学
- 歴史的写本のデジタル化
- 古典日本語テキスト処理
- Unicode準拠テスト
- 文字体系進化研究

### エンターテインメント産業
- ゲームローカライゼーション
- アニメ字幕処理
- マンガテキスト変換
- ソーシャルメディアコンテンツ適応

## 貢献について

貢献を歓迎いたします。プロジェクトリポジトリをご覧ください：  
**https://github.com/slavenskoj/raku-lang-ja-kana**

何かエラーがございましたら深くお詫び申し上げます。改善のご提案をお待ちしております。

## 参考資料

### Unicode標準
- Unicode Standard Annex #15: Unicode正規化形式
- 日本語文字体系のUnicodeブロック仕様
- UnicodeコンソーシアムVarious体仮名ガイドライン

### 学術資料
- 文部科学省仮名標準化
- 歴史的仮名使用研究
- Unicodeコンソーシアム技術報告書

## バージョン履歴

- **v1.0.0**: ひらがな・カタカナ基本変換での初回リリース
- **v1.1.0**: 半角カタカナ対応追加
- **v1.2.0**: 変体仮名対応
- **v1.3.0**: 丸囲み・四角囲みカタカナユーティリティ
- **v1.4.0**: 自動半角変換付き他文字体系統合

## ライセンス

本ライブラリはフリーソフトウェアです。Artistic License 2.0の下で再配布・修正が可能です。

## 作者

Danslav Slavenskoj

---

特定の文字体系変換（ローマ字、キリル文字、ハングル）については、専用のREADMEファイルをご参照ください：
- [README-Romaji.md](README-Romaji.md) - ローマ字化システム
- [README-Kuriru-moji.md](README-Kuriru-moji.md) - キリル文字変換  
- [README-Hangul.md](README-Hangul.md) - 韓国語ハングル変換