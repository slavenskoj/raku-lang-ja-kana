# Lang::JA::Kana::Romaji

**Documentation:**
- **Main**: [English](README.md) • [日本語](README-jp.md)
- **Romaji**: [README-Romaji.md](README-Romaji.md)
- **Cyrillic**: [English](README-Kuriru-moji.md) • [Русский](README-Kuriru-moji-ru.md)
- **Hangul**: [English](README-Hangul.md) • [한국어](README-Hangul-kr.md)

**ローマ字** - Japanese Kana to Romaji Transliteration Module

A comprehensive Raku module for converting Japanese Kana (Hiragana and Katakana) to Romaji using the three major standardized romanization systems, each designed for different purposes and linguistic requirements.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Romanization Systems](#romanization-systems)
- [Usage Examples](#usage-examples)
- [System Comparisons](#system-comparisons)
- [Advanced Features](#advanced-features)
- [API Reference](#api-reference)
- [Character Coverage](#character-coverage)
- [Linguistic Notes](#linguistic-notes)
- [Testing](#testing)
- [Contributing](#contributing)
- [License](#license)

## Features

- **4 Romanization Systems** with distinct linguistic approaches
- **Traditional Hepburn** (default) - Most common, pronunciation-based
- **Modified Hepburn** - Academic standard with macrons for long vowels
- **Kunrei-shiki** - ISO 3602 standard, systematic approach
- **Nihon-shiki** - Preserves Japanese phonological distinctions
- **Sokuon (っ) Processing** with consonant doubling
- **Long Vowel Handling** with macron notation (Modified Hepburn)
- **Modern Extensions** (ファ, ティ, ヴ sounds)
- **Historical Kana Support** (ゐゑを)
- **Mixed Content Handling** (non-kana passed through unchanged)

## Installation

```bash
# Install from ecosystem
zef install Lang::JA::Kana

# Or clone and install locally
git clone https://github.com/your-repo/lang-ja-kana.git
cd lang-ja-kana
zef install .
```

## Quick Start

```raku
use Lang::JA::Kana::Romaji;

# Basic usage (Traditional Hepburn - default)
say romaji("こんにちは");           # konnichiha
say romaji("しんぶん");             # shinbun
say romaji("じゃじゅじょ");         # jajujo

# Different systems
say romaji("しんぶん", :system<kunrei>);      # sinbun
say romaji("ふじさん", :system<kunrei>);      # huzisan
say romaji("づつき", :system<nihon>);         # dutuki

# Modified Hepburn with macrons
say romaji("とうきょう", :system<hepburn-mod>); # tōkyō
say romaji("ラーメン", :system<hepburn-mod>);   # rāmen
```

## Romanization Systems

### Traditional Hepburn (Default)

| Feature | Description | Examples |
|---------|-------------|----------|
| **Purpose** | Most common system, closest to English pronunciation | Standard for passports, signs |
| **し/ち sounds** | shi, chi, ji | しんぶん → shinbun |
| **ふ sound** | fu | ふじさん → fujisan |
| **じゃ sounds** | ja, ju, jo | じゃじゅじょ → jajujo |
| **Long vowels** | Double letters (ou, oo) | とうきょう → toukyou |
| **Small tsu** | Doubles consonant | がっこう → gakkou |

### Modified Hepburn

| Feature | Description | Examples |
|---------|-------------|----------|
| **Purpose** | Academic standard with precise long vowel notation | Scholarly publications |
| **Base system** | Same as Traditional Hepburn | Same consonant rules |
| **Long vowels** | Macrons (ō, ū, etc.) | とうきょう → tōkyō |
| **ー extension** | Previous vowel + macron | ラーメン → rāmen |
| **Usage** | Academic, linguistic studies | Dictionaries, textbooks |

### Kunrei-shiki (Cabinet Order)

| Feature | Description | Examples |
|---------|-------------|----------|
| **Purpose** | ISO 3602 standard, systematic approach | Official Japanese government |
| **し/ち sounds** | si, ti, zi | しんぶん → sinbun |
| **ふ sound** | hu | ふじさん → huzisan |
| **じゃ sounds** | zya, zyu, zyo | じゃじゅじょ → zyazyuzyo |
| **Small tsu** | tu instead of tsu | っ → tu |
| **Consistency** | Regular sound-symbol mapping | Educational materials |

### Nihon-shiki (Japanese Style)

| Feature | Description | Examples |
|---------|-------------|----------|
| **Purpose** | Preserves all Japanese phonological distinctions | Linguistic analysis |
| **Base system** | Same as Kunrei-shiki | Same basic rules |
| **ぢ/づ preservation** | di/du vs zi/zu | づつき → dutuki |
| **Historical accuracy** | Maintains old distinctions | ぢ → di, づ → du |
| **Academic use** | Historical linguistics | Classical Japanese studies |

## Usage Examples

### Basic Conversion

```raku
use Lang::JA::Kana::Romaji;

# Hiragana
say romaji("ひらがな");        # hiragana

# Katakana  
say romaji("カタカナ");        # katakana

# Mixed text (non-kana passed through)
say romaji("Hello こんにちは World");  # Hello konnichiha World
```

### System Comparisons

```raku
my $word = "しんぶん";

say "Traditional: " ~ romaji($word);                    # shinbun
say "Kunrei:      " ~ romaji($word, :system<kunrei>);   # sinbun
say "Nihon:       " ~ romaji($word, :system<nihon>);    # sinbun

my $word2 = "じゃじゅじょ";
say "Traditional: " ~ romaji($word2);                   # jajujo
say "Kunrei:      " ~ romaji($word2, :system<kunrei>);  # zyazyuzyo
say "Nihon:       " ~ romaji($word2, :system<nihon>);   # zyazyuzyo
```

### Long Vowels

```raku
# Traditional Hepburn - double letters
say romaji("がっこう");                        # gakkou
say romaji("とうきょう");                      # toukyou

# Modified Hepburn - macrons
say romaji("がっこう", :system<hepburn-mod>);   # gakkō
say romaji("とうきょう", :system<hepburn-mod>);  # tōkyō
say romaji("ラーメン", :system<hepburn-mod>);    # rāmen
```

### Phonological Distinctions

```raku
# Nihon-shiki preserves ぢ/づ vs じ/ず distinctions
say romaji("づつき", :system<nihon>);     # dutuki
say romaji("じずく", :system<nihon>);     # zizuku

# Other systems merge them
say romaji("づつき", :system<kunrei>);    # dutuki (same as nihon for this)
say romaji("づつき");                     # zutsuki (traditional hepburn)
```

### Modern Extensions

```raku
# Foreign sound adaptations
say romaji("ファイル");          # fairu
say romaji("ティーム");          # timu
say romaji("ヴァイオリン");      # vaiorin
say romaji("ウィンドウ");        # windou
say romaji("チェック");          # chekku
```

### Historical Kana

```raku
# Pre-war kana
say romaji("ゐゑを");       # wiwewo
say romaji("ゔぁゔぃ");     # vavi

# All systems handle these consistently
say romaji("ゐゑを", :system<kunrei>);   # wiwewo
say romaji("ゐゑを", :system<nihon>);    # wiwewo
```

## System Comparisons

### Key Differences Table

| Kana | Traditional Hepburn | Modified Hepburn | Kunrei-shiki | Nihon-shiki |
|------|-------------------|------------------|--------------|-------------|
| し | shi | shi | si | si |
| ち | chi | chi | ti | ti |
| つ | tsu | tsu | tu | tu |
| ふ | fu | fu | hu | hu |
| じ | ji | ji | zi | zi |
| ぢ | ji | ji | zi | di |
| ず | zu | zu | zu | zu |
| づ | zu | zu | zu | du |
| しゃ | sha | sha | sya | sya |
| じゃ | ja | ja | zya | zya |
| っ | (double consonant) | (double consonant) | tu | tu |
| とう | tou | tō | tou | tou |
| ラー | raa | rā | raa | raa |

### Use Case Recommendations

**Traditional Hepburn** - Choose when:
- Creating content for general audiences
- Making signs, menus, tourist materials
- Prioritizing pronunciation similarity to English
- Working with non-academic applications

**Modified Hepburn** - Choose when:
- Writing academic or scholarly works
- Creating dictionaries or reference materials
- Need precise long vowel notation
- Following academic publishing standards

**Kunrei-shiki** - Choose when:
- Following ISO standards
- Creating systematic educational materials
- Working with Japanese government documents
- Need consistent, regular mapping

**Nihon-shiki** - Choose when:
- Studying historical Japanese linguistics
- Preserving phonological distinctions
- Analyzing classical Japanese texts
- Working with etymological research

## Advanced Features

### Sokuon (っ) Handling

The module properly handles small tsu (っ/ッ) by doubling the following consonant:

```raku
say romaji("がっこう");     # gakkou (doubled k)
say romaji("ちょっと");     # chotto (doubled t)
say romaji("いっぱい");     # ippai (doubled p)
say romaji("あっさり");     # assari (doubled s)
```

### Long Vowel Processing

Different systems handle long vowels differently:

```raku
# Traditional Hepburn - literal transcription
say romaji("おおきい");     # ookii
say romaji("とうきょう");   # toukyou

# Modified Hepburn - macron notation
say romaji("おおきい", :system<hepburn-mod>);   # ookī
say romaji("とうきょう", :system<hepburn-mod>); # tōkyō

# ー (chōonpu) extension
say romaji("ラーメン", :system<hepburn-mod>);   # rāmen
say romaji("コーヒー", :system<hepburn-mod>);   # kōhī
```

### Modern Sound Extensions

```raku
# ファ行 (fa-gyō) sounds
say romaji("ファミリー");    # famirii
say romaji("フィルム");      # firumu
say romaji("フェスタ");      # fesuta
say romaji("フォルダ");      # foruda

# ティ/ディ sounds
say romaji("ティーポット");  # tiipotto
say romaji("ディスク");      # disuku

# ヴ sounds (v-sounds)
say romaji("ヴァイオリン");  # vaiorin
say romaji("ヴィーナス");    # viinasu

# ツァ行 sounds
say romaji("ツァイト");      # tsaito
say romaji("ツィター");      # tsitaa
```

### Mixed Content Handling

Non-kana characters pass through unchanged:

```raku
say romaji("彼はにほんじんです");       # 彼hanihonzindesu
say romaji("Email: info@example.com"); # Email: info@example.com
say romaji("価格：せんえん");          # 価格：senen
say romaji("123 あいう ABC");          # 123 aiuuu ABC
```

## API Reference

### Main Function

```raku
sub romaji(Str $text, Str :$system = 'hepburn') is export
```

**Parameters:**
- `$text` - Input text containing Japanese kana
- `:$system` - Romanization system (optional, default: 'hepburn')

**Valid Systems:**
- `'hepburn'` | `'hep'` - Traditional Hepburn (default)
- `'hepburn-mod'` | `'hepburn-modified'` | `'modified-hepburn'` - Modified Hepburn
- `'kunrei'` | `'kunrei-shiki'` - Kunrei-shiki
- `'nihon'` | `'nihon-shiki'` - Nihon-shiki

**Returns:** String with kana converted to romaji

**Example:**
```raku
my $result = romaji("こんにちは", :system<kunrei>);
```

### Error Handling

Unknown systems will cause the function to die with an error message:

```raku
# This will die
romaji("test", :system<unknown>);
# Unknown romanization system: unknown. Use 'hepburn', 'hepburn-mod', 'kunrei', or 'nihon'.
```

### Integration with Main Module

This module is part of the larger `Lang::JA::Kana` package:

```raku
use Lang::JA::Kana;

# Direct access via main module
say kana-to-romaji("こんにちは");
say kana-to-romaji("さくら", :system<kunrei>);

# Or use submodule directly
use Lang::JA::Kana::Romaji;
say romaji("こんにちは");
```

## Character Coverage

### Supported Kana

**Hiragana:** All standard hiragana including:
- Basic syllabary (あ-ん)
- Voiced marks (が-ぽ)  
- Combinations (きゃ-ぴょ)
- Small variants (ぁ-ゎ)
- Historical forms (ゐゑ)
- Modern extensions (ふぁ-ゔぉ)

**Katakana:** Complete katakana coverage including:
- Basic syllabary (ア-ン)
- Voiced marks (ガ-ポ)
- Combinations (キャ-ピョ)
- Small variants (ァ-ヮ)
- Modern extensions (ファ-ヴォ)

### Unsupported Content

- **Kanji:** Passed through unchanged
- **Latin alphabet:** Passed through unchanged  
- **Numbers:** Passed through unchanged
- **Punctuation:** Passed through unchanged
- **Half-width katakana:** Must be converted to full-width first

## Linguistic Notes

### System Design Philosophy

Each romanization system reflects different priorities:

- **Traditional Hepburn** prioritizes intuitive pronunciation for English speakers
- **Modified Hepburn** adds academic precision with macron notation
- **Kunrei-shiki** emphasizes systematic consistency and regularity
- **Nihon-shiki** preserves all Japanese phonological distinctions

### Historical Context

**Traditional Hepburn (1867):**
- Created by James Curtis Hepburn for his Japanese-English dictionary
- Designed for English speakers learning Japanese
- Most widely used in general contexts

**Modified Hepburn (1954):**
- Standardized by the American National Standards Institute
- Adds macrons for accurate long vowel representation
- Standard in academic and reference works

**Kunrei-shiki (1954):**
- Official Japanese government standard
- Based on Japanese phonological structure
- ISO 3602 international standard

**Nihon-shiki (1885):**
- Oldest systematic romanization
- Created by Tanakadate Aikitsu
- Preserves historical phonological distinctions

### Phonological Considerations

**Sokuon (っ) Handling:**
- Represents a moraic consonant in Japanese
- Realized as consonant doubling or glottal stop
- All systems double the following consonant

**Long Vowel Representation:**
- Traditional: Literal (ou, uu, etc.)
- Modified: Macrons (ō, ū, etc.)
- Reflects different notation philosophies

**ぢ/づ vs じ/ず Distinction:**
- Modern Japanese: Pronounced identically
- Historical: Different sounds
- Nihon-shiki preserves the distinction

## Testing

The module includes comprehensive tests:

```bash
# Run basic tests
raku t/01-basic.t

# Test specific systems
raku -Ilib -e 'use Lang::JA::Kana::Romaji; say romaji("test-input", :system<system-name>)'
```

## Performance Considerations

- Character conversion uses hash lookups (O(1) per character)
- Multi-character combinations are processed longest-first
- Memory usage scales with input text length
- System selection has minimal overhead

## Examples Gallery

### Literature Translation

```raku
my $haiku = "ふるいけや\nかえるとびこむ\nみずのおと";

say "Traditional: " ~ romaji($haiku);
# huruikeya
# kaerutobiko mu
# mizunooto

say "Modified: " ~ romaji($haiku, :system<hepburn-mod>);
# huruikeya
# kaerutobiko mu
# mizunooto (same for this example)
```

### Place Names

```raku
say romaji("とうきょう");      # toukyou
say romaji("おおさか");        # oosaka
say romaji("ひろしま");        # hiroshima
say romaji("きょうと");        # kyouto

# With macrons
say romaji("とうきょう", :system<hepburn-mod>);  # tōkyō
say romaji("おおさか", :system<hepburn-mod>);    # ōsaka
```

### Technical Terms

```raku
say romaji("コンピューター");   # konpyuutaa
say romaji("インターネット");   # intaanetto
say romaji("テクノロジー");     # tekunorojii
say romaji("ソフトウェア");     # sofutowea
```

### Food and Culture

```raku
say romaji("すし");         # sushi
say romaji("らーめん");     # raamen
say romaji("てんぷら");     # tenpura
say romaji("からおけ");     # karaoke
say romaji("おりがみ");     # origami
```

## Contributing

Contributions are welcome. Please visit the project repository at:  
**https://github.com/slavenskoj/raku-lang-ja-kana**

We apologize for any errors and welcome suggestions for improvements.

## License

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

## See Also

- [Lang::JA::Kana](README.md) - Main module documentation
- [Lang::JA::Kana::Kuriru-moji](README-Kuriru-moji.md) - Cyrillic transliteration  
- [Lang::JA::Kana::Hangul](README-Hangul.md) - Hangul transliteration
- [ISO 3602](https://www.iso.org/standard/29600.html) - Kunrei-shiki standard
- [ANSI Z39.11-1972](https://www.ansi.org/) - Modified Hepburn standard

## Authors

Danslav Slavenskoj

---

**ローマ字モジュール** - bridging Japanese and Latin scripts with linguistic precision and academic rigor.