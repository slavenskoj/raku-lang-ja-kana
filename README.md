# Lang::JA::Kana

A comprehensive Raku module for converting between Hiragana and Katakana, including support for historical and obsolete kana characters.

**Repository**: https://github.com/slavenskoj/raku-lang-ja-kana

## Features

- **Complete Modern Kana Support**: All standard Hiragana and Katakana characters
- **Historical Kana**: Support for obsolete characters like `ゐ/ヰ` (wi), `ゑ/ヱ` (we), and `ゔ/ヴ` (vu)
- **Hentaigana**: Comprehensive coverage of historical variant kana characters (U+1B000-U+1B12F)
- **Modern Extensions**: Foreign sound combinations for loan words (`ファ`, `ティ`, `ヴァ`, etc.)
- **Function-based API**: Clean `to-hiragana()` and `to-katakana()` functions
- **Graceful Handling**: Only converts kana characters, leaves other text unchanged
- **Bidirectional**: Convert in both directions with full fidelity

## Installation

Place the module file in your Raku library path:

```bash
mkdir -p lib/Lang/JA
cp Kana.rakumod lib/Lang/JA/
```

## Usage

### Basic Usage

```raku
use Lang::JA::Kana;

# Using functions
say to-katakana("ひらがな");  # Output: ヒラガナ
say to-hiragana("カタカナ");  # Output: かたかな
```

### Mixed Text

The module gracefully handles mixed text, converting only kana characters:

```raku
say to-katakana("Hello こんにちは World");  # Output: Hello コンニチハ World
say to-hiragana("Hello コンニチハ World");  # Output: Hello こんにちは World
```

### Historical and Obsolete Kana

```raku
# Historical wi/we sounds (pre-1946 orthography)
say to-katakana("ゐゑ");  # Output: ヰヱ
say to-hiragana("ヰヱ");  # Output: ゐゑ

# VU sound
say to-katakana("ゔぁゔぃゔぇゔぉ");  # Output: ヴァヴィヴェヴォ
say to-hiragana("ヴァヴィヴェヴォ");  # Output: ゔぁゔぃゔぇゔぉ

# Digraph Yori
say to-katakana("ゟ");  # Output: ヿ
say to-hiragana("ヿ");  # Output: ゟ
```

### Modern Extensions for Foreign Sounds

```raku
# FA-FO sounds
say to-katakana("ふぁふぃふぇふぉ");  # Output: ファフィフェフォ
say to-hiragana("ファフィフェフォ");  # Output: ふぁふぃふぇふぉ

# TI/DI sounds
say to-katakana("てぃでぃ");  # Output: ティディ
say to-hiragana("ティディ");  # Output: てぃでぃ

# WI-WO sounds for loan words
say to-katakana("うぃうぇうぉ");  # Output: ウィウェウォ
say to-hiragana("ウィウェウォ");  # Output: うぃうぇうぉ
```

### Small Kana

```raku
# Small vowels
say to-katakana("ぁぃぅぇぉ");  # Output: ァィゥェォ
say to-hiragana("ァィゥェォ");  # Output: ぁぃぅぇぉ

# Small WA
say to-katakana("ゎ");  # Output: ヮ
say to-hiragana("ヮ");  # Output: ゎ
```

### Hentaigana (Historical Kana Variants)

```raku
# Single reading Hentaigana
say hentaigana-to-hiragana("𛀁𛀂𛀃");  # Output: あいう

# Multiple reading Hentaigana (separated by middle dots)
say hentaigana-to-hiragana("𛀒𛀓");  # Output: し・せじ・ぜ

# W-series with historical/modern readings
say hentaigana-to-hiragana("𛁆𛁇𛁈");  # Output: ゐ・いゑ・えを・お

# Complex variants with multiple interpretations
say hentaigana-to-hiragana("𛂬𛂭");  # Output: ふ・ぶ・ぷへ・べ・ぺ

# Mixed text
say hentaigana-to-hiragana("Hello 𛀁𛂚 World");  # Output: Hello あこ・き World
```

### Modern Hiragana to Hentaigana

```raku
# Single variant
say hiragana-to-hentaigana("る");  # Output: 𛁂

# Multiple variants
say hiragana-to-hentaigana("あ");  # Output: 𛀁・𛄀・𛄁
say hiragana-to-hentaigana("き");  # Output: 𛀈・𛂚・𛂦

# Sound mark splitting (dakuten/handakuten)
say hiragana-to-hentaigana("が");  # Output: 𛀆・𛂥゛
say hiragana-to-hentaigana("ぱ");  # Output: 𛀩・𛂛゜

# Text conversion
say hiragana-to-hentaigana("こんにちは");  # Output: 𛀎・𛂚𛁉𛀥𛀜・𛂫𛀩・𛂛

# Mixed text
say hiragana-to-hentaigana("Hello がき World");  # Output: Hello 𛀆・𛂥゛𛀈・𛂚・𛂦 World
```

### Half-width Katakana

```raku
# Half-width to full-width conversion
say to-fullwidth-katakana("ｱｲｳｴｵ");  # Output: アイウエオ
say to-fullwidth-katakana("ｶﾀｶﾅ");   # Output: カタカナ
say to-fullwidth-katakana("Hello ｱｲｳ World");  # Output: Hello アイウ World

# Full-width to half-width conversion
say to-halfwidth-katakana("アイウエオ");  # Output: ｱｲｳｴｵ
say to-halfwidth-katakana("カタカナ");   # Output: ｶﾀｶﾅ
say to-halfwidth-katakana("Hello アイウ World");  # Output: Hello ｱｲｳ World

# Integration with existing functions (half-width automatically converted)
say Hiragana "ｶﾀｶﾅ";  # Output: かたかな
say to-hiragana("ｱｲｳｴｵ");  # Output: あいうえお

# Voiced and semi-voiced combinations
say to-fullwidth-katakana("ｶﾞｷﾞｸﾞｹﾞｺﾞ");  # Output: ガギグゲゴ
say to-fullwidth-katakana("ﾊﾟﾋﾟﾌﾟﾍﾟﾎﾟ");  # Output: パピプペポ
say to-halfwidth-katakana("ザジズゼゾダヂヅデド");  # Output: ｻﾞｼﾞｽﾞｾﾞｿﾞﾀﾞﾁﾞﾂﾞﾃﾞﾄﾞ

# Punctuation and marks
say to-fullwidth-katakana("｡､｢｣ｰ");  # Output: 。、「」ー
```

### Square Katakana (Enclosed Forms)

```raku
# Circled Katakana
say decircle-katakana("㋐㋑㋒㋓㋔");  # Output: アイウエオ
say decircle-katakana("㋕㋖㋗㋘㋙");  # Output: カキクケコ

# Square measurement units
say desquare-katakana("㌔㌘㍍");  # Output: キログラムメートル
say desquare-katakana("㍑㌦㍀");  # Output: リットルドルポンド

# Square technical terms
say desquare-katakana("㌲㌹㌾㍗");  # Output: ファラッドヘルツボルトワット

# Square building/location terms
say desquare-katakana("㌀㌱㍇");  # Output: アパートビルマンション

# Mixed text with square Katakana
say desquare-katakana("Price is ㌦100 per ㍑");  # Output: Price is ドル100 per リットル
```

### Reverse Conversions

```raku
# Katakana to circled forms
say encircle-katakana("アイウエオ");  # Output: ㋐㋑㋒㋓㋔
say encircle-katakana("カキクケコ");  # Output: ㋕㋖㋗㋘㋙

# Katakana to square forms
say ensquare-katakana("キロ グラム メートル");  # Output: ㌔ ㌘ ㍍
say ensquare-katakana("ドル ポンド");  # Output: ㌦ ㍀
say ensquare-katakana("ワット ヘルツ");  # Output: ㍗ ㌹

# Mixed text conversion
say ensquare-katakana("The price is ドル for ワット");  # Output: The price is ㌦ for ㍗

# Note: Not all characters have circled forms (e.g., ン has no circled equivalent)
say encircle-katakana("アン");  # Output: ㋐ン (only ア gets circled)
```

## API Reference

### Functions

#### `to-hiragana(Str $text) returns Str`
Converts Katakana characters in the text to Hiragana.
- **Parameter**: `$text` - String containing text to convert
- **Returns**: String with Katakana converted to Hiragana
- **Example**: `to-hiragana("カタカナ")` → `"かたかな"`

#### `to-katakana(Str $text) returns Str`
Converts Hiragana characters in the text to Katakana.
- **Parameter**: `$text` - String containing text to convert
- **Returns**: String with Hiragana converted to Katakana
- **Example**: `to-katakana("ひらがな")` → `"ヒラガナ"`

#### `to-fullwidth-katakana(Str $text) returns Str`
Converts half-width Katakana characters to full-width Katakana.
- **Parameter**: `$text` - String containing half-width Katakana to convert
- **Returns**: String with half-width Katakana converted to full-width Katakana
- **Example**: `to-fullwidth-katakana("ｱｲｳ")` → `"アイウ"`

#### `to-halfwidth-katakana(Str $text) returns Str`
Converts full-width Katakana characters to half-width Katakana.
- **Parameter**: `$text` - String containing full-width Katakana to convert
- **Returns**: String with full-width Katakana converted to half-width Katakana
- **Example**: `to-halfwidth-katakana("アイウ")` → `"ｱｲｳ"`

#### `hentaigana-to-hiragana(Str $text) returns Str`
Converts Hentaigana (historical kana variants) to modern Hiragana. Characters with multiple possible readings are converted to a list separated by middle dots (・).
- **Parameter**: `$text` - String containing Hentaigana characters to convert
- **Returns**: String with Hentaigana converted to modern Hiragana
- **Example**: `hentaigana-to-hiragana("𛀒𛀓")` → `"し・せじ・ぜ"`

#### `hiragana-to-hentaigana(Str $text) returns Str`
Converts modern Hiragana to equivalent Hentaigana variants. Dakuten (゛) and handakuten (゜) are split from characters before conversion. Multiple variants are joined with middle dots (・).
- **Parameter**: `$text` - String containing Hiragana characters to convert
- **Returns**: String with Hiragana converted to Hentaigana variants
- **Example**: `hiragana-to-hentaigana("あが")` → `"𛀁・𛄀・𛄁𛀆・𛂥゛"`

#### `split-sound-marks(Str $char) returns List`
Splits dakuten (゛) and handakuten (゜) sound marks from kana characters.
- **Parameter**: `$char` - Single kana character
- **Returns**: List containing base character and sound mark (if present)
- **Example**: `split-sound-marks("が")` → `("か", "゛")`

#### `decircle-katakana(Str $text) returns Str`
Converts circled Katakana (㋐-㋾) into their component characters. These represent individual kana syllables enclosed in circles.
- **Parameter**: `$text` - String containing circled Katakana characters to convert
- **Returns**: String with circled Katakana converted to regular Katakana
- **Example**: `decircle-katakana("㋐㋕㋚")` → `"アカサ"`

#### `desquare-katakana(Str $text) returns Str`
Converts square Katakana (㌀-㍗) into their component characters. These represent technical terms, units, and abbreviations in square boxes.
- **Parameter**: `$text` - String containing square Katakana characters to convert
- **Returns**: String with square Katakana converted to regular Katakana
- **Example**: `desquare-katakana("㌔㌦㍍")` → `"キロドルメートル"`

#### `encircle-katakana(Str $text) returns Str`
Converts regular Katakana characters into their circled forms (㋐-㋾). Note: Not all kana have circled equivalents (e.g., ン).
- **Parameter**: `$text` - String containing Katakana characters to convert
- **Returns**: String with available Katakana converted to circled Katakana, others unchanged
- **Example**: `encircle-katakana("アカサ")` → `"㋐㋕㋚"`

#### `ensquare-katakana(Str $text) returns Str`
Converts regular Katakana technical terms into their square forms (㌀-㍗). Only predefined technical terms are converted. Processes longer terms first to avoid partial matches.
- **Parameter**: `$text` - String containing Katakana terms to convert
- **Returns**: String with recognized Katakana terms converted to square Katakana, others unchanged
- **Example**: `ensquare-katakana("キロ ドル メートル")` → `"㌔ ㌦ ㍍"`


## Supported Character Sets

### Modern Kana
- All 46 basic Hiragana/Katakana pairs
- Voiced marks (dakuten/handakuten): が-ぽ/ガ-ポ
- Combination characters: きゃ-りょ/キャ-リョ
- Small kana: ゃゅょっ/ャュョッ and ぁぃぅぇぉゎ/ァィゥェォヮ

### Half-width Katakana
Complete support for half-width Katakana (U+FF65-U+FF9F):
- **Basic characters**: ｱｲｳｴｵ...ﾜｦﾝ (46 basic katakana)
- **Small characters**: ｧｨｩｪｫｬｭｮｯ
- **Voiced combinations**: ｶﾞｷﾞｸﾞｹﾞｺﾞ → ガギグゲゴ (dakuten + base)
- **Semi-voiced combinations**: ﾊﾟﾋﾟﾌﾟﾍﾟﾎﾟ → パピプペポ (handakuten + base)
- **Sound marks**: ﾞ (dakuten), ﾟ (handakuten)
- **Punctuation**: ｡､｢｣ｰ → 。、「」ー
- **VU sound**: ｳﾞ → ヴ
- **Automatic integration**: Half-width input automatically converted by existing functions

### Historical Kana
- **Obsolete sounds**: ゐ/ヰ (wi), ゑ/ヱ (we)
- **VU sound**: ゔ/ヴ
- **Digraph**: ゟ/ヿ (yori)

### Hentaigana (Historical Variants)
Complete support for Unicode Hentaigana block (U+1B000-U+1B12F), including historical variant forms of all kana syllables used in classical Japanese manuscripts. Many Hentaigana characters have multiple possible readings depending on context.

### Modern Extensions
Foreign sound combinations for transcribing loan words:
- **F-sounds**: ふぁ-ふぉ/ファ-フォ
- **V-sounds**: ゔぁ-ゔぉ/ヴァ-ヴォ  
- **Extended consonants**: てぃ/ティ, でぃ/ディ, とぅ/トゥ, どぅ/ドゥ
- **W-sounds**: うぃ/ウィ, うぇ/ウェ, うぉ/ウォ
- **Other**: くぁ/クァ, ぐぁ/グァ, つぁ/ツァ, ちぇ/チェ, じぇ/ジェ, しぇ/シェ, いぇ/イェ

### Square Katakana (Enclosed Forms)
- **Circled Katakana** (U+32D0-U+32FE): ㋐-㋾ representing individual kana syllables
- **Square Katakana units** (U+3300-U+3357): ㌀-㍗ representing measurement units, currencies, and technical terms
- **Common uses**: Technical documentation, scientific texts, financial documents, architectural plans

## Character Conversion Behavior

- **Kana characters**: Converted between Hiragana and Katakana
- **Non-kana characters**: Left unchanged (Latin, numbers, punctuation, kanji, etc.)
- **Mixed text**: Only kana portions are converted
- **Unknown characters**: Passed through unchanged
- **Combination characters**: Handled as complete units (longer combinations processed first)

## Testing

Run the included test suite to verify functionality:

```bash
raku t/01-basic.t
```

The test suite covers:
- Basic conversion functionality
- Mixed text handling
- Historical/obsolete kana
- Modern extensions
- Small kana variants
- Hentaigana conversion with multiple readings
- Hiragana to Hentaigana conversion with sound mark splitting
- Circled Katakana conversion (both directions)
- Square Katakana conversion (both directions)
- Half-width Katakana conversion (both directions)
- Half-width integration with existing functions
- Edge cases

## Technical Notes

- **Unicode Support**: Full Unicode support including extended planes for Hentaigana
- **Performance**: Optimized for longer combinations first to handle multi-character sequences correctly
- **Memory Efficient**: Uses constant lookup tables
- **Thread Safe**: Pure functional implementation with immutable data structures

## Installation

### From Zef (Recommended)

```bash
zef install Lang::JA::Kana
```

### From Source

```bash
git clone https://github.com/slavenskoj/raku-lang-ja-kana.git
cd raku-lang-ja-kana
zef install .
```

## License

Copyright 2025 Danslav Slavenskoj

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests for:
- Additional historical kana variants
- Performance improvements
- Documentation enhancements
- Test coverage expansion

## See Also

- [Unicode Hiragana Block](https://unicode.org/charts/PDF/U3040.pdf) (U+3040-U+309F)
- [Unicode Katakana Block](https://unicode.org/charts/PDF/U30A0.pdf) (U+30A0-U+30FF)
- [Unicode Kana Extended-A Block](https://unicode.org/charts/PDF/U1B000.pdf) (U+1B000-U+1B0FF) - Hentaigana
- [Historical Kana Usage](https://en.wikipedia.org/wiki/Historical_kana_orthography)
- [Hentaigana](https://en.wikipedia.org/wiki/Hentaigana)