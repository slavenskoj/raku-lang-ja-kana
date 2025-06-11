# Lang::JA::Kana - Japanese Kana Conversion Utilities

**Languages:** [English](README.md) • [日本語](README-jp.md)

**Documentation:**
- **Main**: [English](README.md) • [日本語](README-jp.md)
- **Romaji**: [README-Romaji.md](README-Romaji.md)
- **Cyrillic**: [English](README-Kuriru-moji.md) • [Русский](README-Kuriru-moji-ru.md)
- **Hangul**: [English](README-Hangul.md) • [한국어](README-Hangul-kr.md)

## Overview

Lang::JA::Kana is a Raku module for converting between different Japanese kana scripts (Hiragana and Katakana) and their various forms. It provides support for modern kana, historical variants, half-width characters, and specialized Unicode symbols.

## Features

- **Bidirectional Script Conversion**: Seamless conversion between Hiragana and Katakana
- **Half-width Support**: Handling of half-width katakana (ﾊﾝｶｸ) conversion
- **Historical Kana**: Support for Hentaigana (変体仮名) and obsolete characters
- **Modern Extensions**: Foreign sound adaptations (ファ, ティ, ウィ, etc.)
- **Specialized Symbols**: Circled and squared katakana processing
- **Sound Mark Analysis**: Diacritical mark separation and analysis
- **Cross-script Integration**: Built-in integration with Romaji, Cyrillic, and Hangul converters

## Installation

```raku
use Lang::JA::Kana;
```

## Basic Usage

### Hiragana ↔ Katakana Conversion

```raku
use Lang::JA::Kana;

# Basic conversions
say to-katakana("こんにちは");     # → コンニチハ
say to-hiragana("コンニチハ");     # → こんにちは

# With modern extensions
say to-katakana("ふぁみりー");     # → ファミリー
say to-hiragana("ファミリー");     # → ふぁみりー

# Combination sounds (拗音)
say to-katakana("きゃりーぱみゅぱみゅ");  # → キャリーパミュパミュ
say to-hiragana("キャリーパミュパミュ");  # → きゃりーぱみゅぱみゅ

# Mixed text (non-kana characters pass through unchanged)
say to-katakana("Hello こんにちは World");  # → Hello コンニチハ World
say to-hiragana("Hello コンニチハ World");  # → Hello こんにちは World
```

### Half-width Katakana Conversion

```raku
# Half-width to full-width conversion
say to-fullwidth-katakana("ｱｲｳｴｵ");     # → アイウエオ
say to-fullwidth-katakana("ｶﾞｷﾞｸﾞ");    # → ガギグ (voiced combinations)
say to-fullwidth-katakana("ﾊﾟﾋﾟﾌﾟ");    # → パピプ (semi-voiced combinations)

# Full-width to half-width conversion
say to-halfwidth-katakana("アイウエオ");   # → ｱｲｳｴｵ
say to-halfwidth-katakana("ガギグ");      # → ｶﾞｷﾞｸﾞ
say to-halfwidth-katakana("パピプ");      # → ﾊﾟﾋﾟﾌﾟ

# Integration with other conversions
say to-hiragana("ｶﾀｶﾅ");               # → かたかな (auto-converts half-width)
```

## Character Support

### Standard Kana

**All 50-sound (五十音) characters:**
```raku
# Basic vowels (母音)
to-katakana("あいうえお");  # → アイウエオ

# K-series (カ行)
to-katakana("かきくけこ");  # → カキクケコ
to-katakana("がぎぐげご");  # → ガギグゲゴ

# S-series (サ行)
to-katakana("さしすせそ");  # → サシスセソ
to-katakana("ざじずぜぞ");  # → ザジズゼゾ

# T-series (タ行)
to-katakana("たちつてと");  # → タチツテト
to-katakana("だぢづでど");  # → ダヂヅデド

# N-series (ナ行)
to-katakana("なにぬねの");  # → ナニヌネノ

# H-series (ハ行)
to-katakana("はひふへほ");  # → ハヒフヘホ
to-katakana("ばびぶべぼ");  # → バビブベボ (voiced)
to-katakana("ぱぴぷぺぽ");  # → パピプペポ (semi-voiced)

# M-series (マ行)
to-katakana("まみむめも");  # → マミムメモ

# Y-series (ヤ行)
to-katakana("やゆよ");     # → ヤユヨ

# R-series (ラ行)
to-katakana("らりるれろ");  # → ラリルレロ

# W-series (ワ行) and N
to-katakana("わゐゑをん");  # → ワヰヱヲン
```

### Small Kana (小文字)

```raku
# Small vowels
to-katakana("ぁぃぅぇぉ");  # → ァィゥェォ

# Small Y-sounds
to-katakana("ゃゅょ");     # → ャュョ

# Small tsu (促音)
to-katakana("っ");         # → ッ

# Small wa
to-katakana("ゎ");         # → ヮ
```

### Combination Sounds (拗音)

```raku
# Y-combinations
to-katakana("きゃきゅきょ");  # → キャキュキョ
to-katakana("しゃしゅしょ");  # → シャシュショ
to-katakana("ちゃちゅちょ");  # → チャチュチョ
to-katakana("にゃにゅにょ");  # → ニャニュニョ
to-katakana("ひゃひゅひょ");  # → ヒャヒュヒョ
to-katakana("みゃみゅみょ");  # → ミャミュミョ
to-katakana("りゃりゅりょ");  # → リャリュリョ

# Voiced Y-combinations
to-katakana("ぎゃぎゅぎょ");  # → ギャギュギョ
to-katakana("じゃじゅじょ");  # → ジャジュジョ
to-katakana("びゃびゅびょ");  # → ビャビュビョ
to-katakana("ぴゃぴゅぴょ");  # → ピャピュピョ
```

### Modern Extensions for Foreign Sounds

```raku
# F-sounds
to-katakana("ふぁふぃふぇふぉ");  # → ファフィフェフォ

# T/D-sounds
to-katakana("てぃでぃ");         # → ティディ
to-katakana("とぅどぅ");         # → トゥドゥ

# W-sounds
to-katakana("うぃうぇうぉ");     # → ウィウェウォ

# V-sounds
to-katakana("ゔぁゔぃゔぇゔぉ"); # → ヴァヴィヴェヴォ

# Kw/Gw-sounds
to-katakana("くぁくぃくぇくぉ"); # → クァクィクェクォ
to-katakana("ぐぁぐぃぐぇぐぉ"); # → グァグィグェグォ

# Ts-sounds
to-katakana("つぁつぃつぇつぉ"); # → ツァツィツェツォ

# Other combinations
to-katakana("ちぇじぇしぇいぇ"); # → チェジェシェイェ
```

### Historical and Obsolete Kana

```raku
# Historical Wi/We/Wo
to-katakana("ゐゑを");  # → ヰヱヲ

# VU sound
to-katakana("ゔ");      # → ヴ

# Digraph Yori
to-katakana("ゟ");      # → ヿ
```

## Hentaigana (変体仮名) Support

Hentaigana are historical variant forms of kana characters used before standardization. The module provides support for these Unicode characters.

### Hentaigana to Hiragana Conversion

```raku
# Basic conversion
say hentaigana-to-hiragana("𛀁𛀂𛀃");  # → あいう

# Multiple readings (some Hentaigana have ambiguous readings)
say hentaigana-to-hiragana("𛀒");      # → し・せ (can be "shi" or "se")
say hentaigana-to-hiragana("𛁆");      # → ゐ・い (can be "wi" or "i")

# Complex examples
say hentaigana-to-hiragana("𛀆𛀈𛀊");  # → かきく
```

### Hiragana to Hentaigana Conversion

```raku
# Single variant
say hiragana-to-hentaigana("る");      # → 𛁂

# Multiple variants (shows all possibilities)
say hiragana-to-hentaigana("あ");      # → 𛀁・𛄀・𛄁
say hiragana-to-hentaigana("し");      # → 𛀒・𛀖・𛂡

# With voiced marks
say hiragana-to-hentaigana("が");      # → (variants)゛
```

### Hentaigana Character Origins

Many Hentaigana derive from specific Chinese characters (kanji):

- **𛀁** (A): From 安 (an)
- **𛀂** (I): From 以 (i)
- **𛀃** (U): From 宇 (u)
- **𛀆** (KA): From 加 (ka)
- **𛀈** (KI): From 幾 (ki)
- **𛀐** (SA): From 左 (sa)
- **𛀒** (SHI/SE): From 之 (shi/se) - ambiguous reading
- **𛀚** (TA): From 太 (ta)
- **𛀜** (CHI): From 知 (chi)

## Sound Mark Processing

The module provides utilities for analyzing and manipulating diacritical marks (濁点・半濁点).

### Sound Mark Splitting

```raku
# Split voiced characters into base + mark
my @parts = split-sound-marks("が");
say @parts[0];  # → か (base character)
say @parts[1];  # → ゛ (voiced mark)

# Split semi-voiced characters
@parts = split-sound-marks("ぱ");
say @parts[0];  # → は (base character)
say @parts[1];  # → ゜ (semi-voiced mark)

# Regular characters return as-is
@parts = split-sound-marks("あ");
say @parts[0];  # → あ (no splitting)
```

### Practical Applications

```raku
# Analyze character composition
sub analyze-kana($char) {
    my @parts = split-sound-marks($char);
    if @parts.elems == 2 {
        say "$char = {@parts[0]} + {@parts[1]}";
    } else {
        say "$char = base character";
    }
}

analyze-kana("が");  # → が = か + ゛
analyze-kana("ぱ");  # → ぱ = は + ゜
analyze-kana("あ");  # → あ = base character
```

## Specialized Unicode Symbols

### Circled Katakana

```raku
# Convert circled katakana to components
say decircle-katakana("㋐㋑㋒");  # → アイウ
say decircle-katakana("㋕㋖㋗");  # → カキク

# Convert components to circled katakana
say encircle-katakana("アイウ");  # → ㋐㋑㋒
say encircle-katakana("カキク");  # → ㋕㋖㋗
```

### Squared Katakana (Units and Abbreviations)

```raku
# Convert squared katakana to full forms
say desquare-katakana("㌔");     # → キロ (kilo)
say desquare-katakana("㌧");     # → トン (ton)
say desquare-katakana("㍍");     # → メートル (meter)
say desquare-katakana("㍑");     # → リットル (liter)

# Convert full forms to squared katakana
say ensquare-katakana("キロ");     # → ㌔
say ensquare-katakana("メートル");  # → ㍍

# Complex examples
say desquare-katakana("㌔㍍");     # → キロメートル
say desquare-katakana("㍉㍍");     # → ミリメートル
```

**Common Squared Katakana Units:**
- ㌔ (キロ) - kilo
- ㌧ (トン) - ton  
- ㍍ (メートル) - meter
- ㍑ (リットル) - liter
- ㍉ (ミリ) - milli
- ㌢ (センチ) - centi
- ㌦ (ドル) - dollar
- ㌫ (パーセント) - percent
- ㍗ (ワット) - watt

## Cross-script Conversion Integration

The module seamlessly integrates with other script converters, automatically handling half-width conversion.

### Romaji Conversion

```raku
# Automatic half-width handling
say kana-to-romaji("ｺﾝﾆﾁﾊ");                    # → konnichiha
say kana-to-romaji("こんにちは");                 # → konnichiha

# Multiple romanization systems
say kana-to-romaji("しんぶん", :system<hepburn>);  # → shinbun
say kana-to-romaji("しんぶん", :system<kunrei>);   # → sinbun
say kana-to-romaji("しんぶん", :system<nihon>);    # → sinbun

# Sokuon (っ) handling
say kana-to-romaji("がっこう");                   # → gakkou
say kana-to-romaji("ちょっと");                   # → chotto
```

### Cyrillic Conversion

```raku
# Polivanov system (default)
say kana-to-kuriru-moji("こんにちは");              # → конничиха
say kana-to-kuriru-moji("ひらがな");               # → хирагана

# Phonetic system
say kana-to-kuriru-moji("しんぶん", :system<phonetic>);  # → шинбун
say kana-to-kuriru-moji("ちゃちゅちょ", :system<phonetic>); # → чачучо

# Slavic language variants
say kana-to-kuriru-moji("さくら", :system<ukrainian>);    # → сакура
say kana-to-kuriru-moji("さくら", :system<serbian>);      # → сакура
```

### Hangul Conversion

```raku
# Standard system (default)
say kana-to-hangul("こんにちは");                 # → 곤니치하
say kana-to-hangul("ひらがな");                  # → 히라가나

# Academic system (with consonant doubling)
say kana-to-hangul("がっこう", :system<academic>);  # → 깍코우
say kana-to-hangul("ばっば", :system<academic>);    # → 빱빠

# Phonetic system (preserves Japanese pronunciation)
say kana-to-hangul("ちゃちゅちょ", :system<phonetic>); # → 치야치유치요

# Popular system (K-pop/media usage)
say kana-to-hangul("ちゅう", :system<popular>);     # → 추우
```

## Advanced Features

### Mixed Text Processing

All functions handle mixed text gracefully, processing only kana characters:

```raku
say to-katakana("Hello こんにちは 123");           # → Hello コンニチハ 123
say to-hiragana("Hello コンニチハ 123");           # → Hello こんにちは 123
say to-fullwidth-katakana("Hello ｱｲｳ 123");      # → Hello アイウ 123
```

### Chained Conversions

```raku
# Complex conversion chains
my $text = "ｺﾝﾆﾁﾊ";                              # Half-width katakana
$text = to-fullwidth-katakana($text);              # → コンニチハ
$text = to-hiragana($text);                        # → こんにちは
say kana-to-romaji($text);                         # → konnichiha

# Historical processing
$text = "𛀆𛀈𛀊";                                  # Hentaigana
$text = hentaigana-to-hiragana($text);             # → かきく
$text = to-katakana($text);                        # → カキク
say encircle-katakana($text);                      # → ㋕㋖㋗
```

### Empty String and Edge Case Handling

```raku
say to-katakana("");                 # → "" (empty string)
say to-hiragana("");                 # → "" (empty string)
say to-fullwidth-katakana("");       # → "" (empty string)
say hentaigana-to-hiragana("");      # → "" (empty string)
```

## Character Coverage

### Unicode Ranges Supported

- **Hiragana**: U+3040-U+309F (ひらがな)
- **Katakana**: U+30A0-U+30FF (カタカナ)
- **Half-width Katakana**: U+FF61-U+FF9F (ﾊﾝｶｸ)
- **Hentaigana**: U+1B001-U+1B11E (𛀁-𛄟)
- **Circled Katakana**: U+32D0-U+32FE (㋐-㋾)
- **Squared Katakana**: U+3300-U+3357 (㌀-㍗)

### Character Count

- **Basic Hiragana/Katakana**: 46 + 25 (voiced/semi-voiced) = 71 characters
- **Small Kana**: 10 characters
- **Y-combinations**: 33 combinations
- **Modern Extensions**: 25+ foreign sound adaptations
- **Half-width Forms**: 63 characters
- **Hentaigana**: 300+ historical variants
- **Circled Katakana**: 47 symbols
- **Squared Katakana**: 88 unit abbreviations

## Performance Considerations

### Optimization Features

- **Longest-First Matching**: Multi-character combinations processed before single characters
- **Efficient Hash Lookups**: O(1) character mapping using Raku hashes
- **Minimal Regex Usage**: Direct string substitution where possible
- **Lazy Evaluation**: Conversion tables computed only when needed

### Best Practices

```raku
# Efficient: Single conversion call
my $result = to-katakana($large-text);

# Less efficient: Multiple small conversions
for @small-texts -> $text {
    $result ~= to-katakana($text);  # Consider batching
}

# Efficient: Reuse conversion results
my $katakana = to-katakana($text);
my $romaji = kana-to-romaji($katakana);  # Uses already-converted katakana
```

## Error Handling and Edge Cases

### Robust Input Processing

```raku
# Invalid or unknown characters are preserved
say to-katakana("こんにちは🎌");     # → コンニチハ🎌
say to-hiragana("カタカナ🗾");       # → かたかな🗾

# Mixed scripts handled appropriately
say to-katakana("ひらがなカタカナ");  # → ヒラガナカタカナ
say to-hiragana("カタカナひらがな");  # → かたかなひらがな

# Partial conversions work correctly
say to-fullwidth-katakana("Normal ｱｲｳ text");  # → Normal アイウ text
```

### Ambiguous Character Handling

```raku
# Hentaigana with multiple readings
say hentaigana-to-hiragana("𛀒");  # → し・せ (shows all possibilities)

# Historical characters preserved if no modern equivalent
say to-katakana("古い𛀁文字");      # → 古イ𛀁文字 (𛀁 processed separately)
```

## Integration Examples

### Text Processing Pipeline

```raku
sub normalize-japanese-text($text) {
    # Step 1: Convert half-width to full-width
    my $normalized = to-fullwidth-katakana($text);
    
    # Step 2: Standardize to hiragana for processing
    $normalized = to-hiragana($normalized);
    
    # Step 3: Convert historical kana
    $normalized = hentaigana-to-hiragana($normalized);
    
    # Step 4: Expand abbreviated forms
    $normalized = desquare-katakana($normalized);
    $normalized = decircle-katakana($normalized);
    
    return $normalized;
}

# Example usage
my $text = "𛀁ｲｳ㌔㋖";
say normalize-japanese-text($text);  # → あいうキロキ
```

### Multilingual Conversion

```raku
sub convert-to-all-scripts($japanese-text) {
    # Normalize input
    my $normalized = to-fullwidth-katakana($japanese-text);
    
    return {
        hiragana => to-hiragana($normalized),
        katakana => to-katakana($normalized),
        romaji => kana-to-romaji($normalized),
        cyrillic => kana-to-kuriru-moji($normalized),
        hangul => kana-to-hangul($normalized)
    };
}

# Example usage
my %scripts = convert-to-all-scripts("ｺﾝﾆﾁﾊ");
say %scripts<hiragana>;  # → こんにちは
say %scripts<romaji>;    # → konnichiha
say %scripts<cyrillic>;  # → конничиха
say %scripts<hangul>;    # → 곤니치하
```

## Limitations

1. **Kanji Processing**: Does not convert Kanji characters (漢字)
2. **Context Sensitivity**: Pure character-level conversion without semantic analysis
3. **Historical Accuracy**: Hentaigana mappings based on Unicode standards, not historical manuscripts
4. **Regional Variants**: Based on standard Japanese, not dialectal pronunciations

## Use Cases

### Educational Applications
- Japanese language learning materials
- Script conversion exercises
- Historical text modernization
- Unicode character reference

### Text Processing
- Document normalization
- Search and indexing systems
- Legacy text conversion
- Character encoding migration

### Digital Humanities
- Historical manuscript digitization
- Classical Japanese text processing
- Unicode compliance testing
- Script evolution research

### Entertainment Industry
- Game localization
- Anime subtitle processing  
- Manga text conversion
- Social media content adaptation

## Contributing

Contributions are welcome. Please visit the project repository at:  
**https://github.com/slavenskoj/raku-lang-ja-kana**

We apologize for any errors and welcome suggestions for improvements.

## References

### Unicode Standards
- Unicode Standard Annex #15: Unicode Normalization Forms
- Unicode block specifications for Japanese scripts
- Unicode Consortium Hentaigana guidelines

### Academic Sources
- Japanese Ministry of Education kana standardization
- Historical kana usage studies
- Unicode Consortium technical reports

## Version History

- **v1.0.0**: Initial release with basic Hiragana/Katakana conversion
- **v1.1.0**: Added half-width katakana support
- **v1.2.0**: Comprehensive Hentaigana support
- **v1.3.0**: Circled and squared katakana utilities
- **v1.4.0**: Cross-script integration with auto half-width conversion

## License

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

## Author

Danslav Slavenskoj

---

For specific script conversions (Romaji, Cyrillic, Hangul), see the specialized README files:
- [README-Romaji.md](README-Romaji.md) - Romanization systems
- [README-Kuriru-moji.md](README-Kuriru-moji.md) - Cyrillic conversion  
- [README-Hangul.md](README-Hangul.md) - Korean Hangul conversion