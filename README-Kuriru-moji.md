# Lang::JA::Kana::Kuriru-moji

**Documentation:**
- **Main**: [English](README.md) • [日本語](README-jp.md)
- **Romaji**: [README-Romaji.md](README-Romaji.md)
- **Cyrillic**: [English](README-Kuriru-moji.md) • [Русский](README-Kuriru-moji-ru.md)
- **Hangul**: [English](README-Hangul.md) • [한국어](README-Hangul-kr.md)

**クリル文字** - Japanese Kana to Cyrillic Transliteration Module

A comprehensive Raku module for converting Japanese Kana (Hiragana and Katakana) to Cyrillic script using various transliteration systems designed for different Slavic languages, Central Asian languages, and usage contexts.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Transliteration Systems](#transliteration-systems)
- [Usage Examples](#usage-examples)
- [System Aliases](#system-aliases)
- [Advanced Features](#advanced-features)
- [API Reference](#api-reference)
- [Contributing](#contributing)
- [License](#license)

## Features

- **17 Complete Transliteration Systems** with unique linguistic adaptations
- **85+ System Aliases** including native names and ISO codes
- **Academic Standards** (Polivanov, GOST, Kontsevich, Soviet)
- **Slavic Language Variants** (Russian, Ukrainian, Serbian, Bulgarian, Macedonian, Belarusian)
- **Central Asian Languages** (Kazakh, Kyrgyz, Mongolian, Tajik)
- **European Variants** (Moldovan Romanian Cyrillic)
- **Gaming & Anime Systems** for fan communities
- **Long Vowel Handling** with academic notation
- **Sokuon (っ) Processing** with consonant doubling
- **Modern Extensions** (ファ, ティ, ヴ sounds)
- **Historical Kana Support** (ゐゑを)

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
use Lang::JA::Kana::Kuriru-moji;

# Basic usage (Polivanov system - default)
say to-kuriru-moji("こんにちは");           # конничиха
say to-kuriru-moji("とうきょうです");       # то:кё:дэсу

# Different systems
say to-kuriru-moji("しんぶん", :system<phonetic>);    # шинбун
say to-kuriru-moji("とうきょう", :system<static>);     # тоукёу
say to-kuriru-moji("ナルト", :system<anime>);          # наруто

# Language variants
say to-kuriru-moji("さくら", :system<ukrainian>);      # сакура
say to-kuriru-moji("さくら", :system<serbian>);        # сакура
say to-kuriru-moji("さくら", :system<macedonian>);     # сакура
```

## Transliteration Systems

### Russian Academic & Historical Systems

| System | Description | Key Features |
|--------|-------------|--------------|
| **Polivanov** (default) | Academic standard | Long vowel marks (:), し→си, じゃ→дзя |
| **Phonetic** | Intuitive for Russian speakers | し→ши, じゃ→джя, ち→чи |
| **Static** | Simplified, no diacriticals | っ→(empty), ー→(empty) |
| **GOST 7.79-2000** | Official Russian standard | Based on Polivanov with modifications |
| **Soviet Textbook** | Educational standard | Phonetic base with textbook conventions |
| **Kontsevich** | Academic transliteration | ち→ти, し→си with long vowels |
| **Pre-revolutionary** (ru-petr1708) | Historical Russian | Uses і, ѣ, ѳ characters |

### Gaming & Entertainment Systems

| System | Aliases | Description |
|--------|---------|-------------|
| **Anime-Manga** | `anime`, `fan`, `anime-manga-fan` | Popular in fan communities |
| **Gaming** | `game`, `gaming-community` | Used in gaming contexts |

### Slavic Language Variants

| Language | Aliases | Unique Features |
|----------|---------|-----------------|
| **Ukrainian** | `ukraine`, `ukraina`, `ua`, `ukr`, `uk` | і instead of и, specific consonants |
| **Serbian** | `serbia`, `srbija`, `sr`, `srb`, `serubija` | џ (dzhe) character |
| **Bulgarian** | `bulgaria`, `balgarija`, `bg`, `bgr` | Phonetic base adaptation |
| **Macedonian** | `macedonia`, `makedonija`, `mk`, `makedonia`* | ќ (gje), ѓ (kje), џ (dzhe) |
| **Belarusian** | `belarus`, `belaruskaja`, `be`, `berarushi`* | ў (short u), чы/шы/жы |

### Central Asian Languages

| Language | Aliases | Unique Features |
|----------|---------|-----------------|
| **Kazakh** | `kazakhstan`, `qazaqstan`, `kz`, `kazafusutan`* | ұ (barred u), ғ (ghayn), ө (barred o) |
| **Kyrgyz** | `kyrgyzstan`, `qyrgyz`, `ky`, `kirugisutan`* | ү (straight u), ө (barred o), ң (eng) |
| **Mongolian** | `mongolia`, `mongol`, `mn`, `mongoru`* | ү (straight u), ө (barred o) |
| **Tajik** | `tajikistan`, `tojikiston`, `tj`, `tajiiku`* | ғ, қ, ҳ, ҷ Persian-adapted letters |

### European Variants

| Language | Aliases | Unique Features |
|----------|---------|-----------------|
| **Moldovan** | `moldova`, `romanian-cyrillic`, `md`, `morudoba`* | Romanian phonology in Cyrillic |

*_Asterisk indicates Japanese-based romaji aliases_

## Usage Examples

### Basic Conversion

```raku
use Lang::JA::Kana::Kuriru-moji;

# Hiragana
say to-kuriru-moji("ひらがな");        # хирагана

# Katakana  
say to-kuriru-moji("カタカナ");        # катакана

# Mixed text (non-kana passed through)
say to-kuriru-moji("Hello こんにちは World");  # Hello конничиха World
```

### System Comparisons

```raku
my $word = "じゃじゅじょ";

say "Polivanov: " ~ to-kuriru-moji($word, :system<polivanov>);  # дзядзюдзё
say "Phonetic:  " ~ to-kuriru-moji($word, :system<phonetic>);   # джяджюджё
say "Static:    " ~ to-kuriru-moji($word, :system<static>);     # зязюзё
```

### Long Vowels

```raku
# Polivanov system uses colons for long vowels
say to-kuriru-moji("がっこう", :system<polivanov>);    # гакко:
say to-kuriru-moji("とうきょう", :system<polivanov>);   # то:кё:

# Static system keeps individual sounds
say to-kuriru-moji("がっこう", :system<static>);       # гаккоу
say to-kuriru-moji("とうきょう", :system<static>);      # тоукёу
```

### Language-Specific Features

```raku
# Ukrainian uses і instead of и
say to-kuriru-moji("きみ", :system<ukrainian>);         # кімі

# Belarusian uses ў for certain sounds
say to-kuriru-moji("うた", :system<belarusian>);        # ўта

# Macedonian uses unique letters
say to-kuriru-moji("きけ", :system<macedonian>);        # ќиќе

# Tajik uses Persian-adapted letters
say to-kuriru-moji("かが", :system<tajik>);             # қаға
```

### Modern Extensions

```raku
# Foreign sound adaptations
say to-kuriru-moji("ファイル", :system<phonetic>);      # фаиру
say to-kuriru-moji("ティーム", :system<phonetic>);      # тиーму
say to-kuriru-moji("ヴァイオリン", :system<phonetic>);  # ваиорин
```

## System Aliases

### Complete Alias Reference

**Academic Systems:**
- `polivanov`, `academic`
- `phonetic`, `intuitive` 
- `static`, `simple`
- `gost2000`, `gost-7.79-2000`
- `soviet`, `soviet-textbook`
- `kontsevich`
- `ru-petr1708`

**Entertainment:**
- `anime-manga`, `anime-manga-fan`, `anime`, `fan`
- `gaming`, `gaming-community`, `game`

**Ukrainian:**
- `ukrainian`, `ukraine`, `ukraina`, `ukrainski`, `ukuraina`, `ua`, `ukr`, `uk`

**Serbian:**
- `serbian`, `serbia`, `srbija`, `srbski`, `serubija`, `sr`, `srb`

**Bulgarian:**
- `bulgarian`, `bulgaria`, `balgarija`, `balgarski`, `burugarija`, `burugariya`, `bg`, `bgr`

**Macedonian:**
- `macedonian`, `macedonia`, `makedonija`, `makedonski`, `makedonia`, `mazedoniya`, `mk`, `mkd`

**Belarusian:**
- `belarusian`, `belarus`, `belaruskaja`, `belaruski`, `berarushi`, `be`, `blr`

**Kazakh:**
- `kazakh`, `kazakhstan`, `qazaqstan`, `qazaq`, `kazafusutan`, `kz`, `kaz`

**Kyrgyz:**
- `kyrgyz`, `kyrgyzstan`, `qyrgyzstan`, `qyrgyz`, `kirugisutan`, `ky`, `kgz`

**Mongolian:**
- `mongolian`, `mongolia`, `mongol`, `mongolski`, `mongoru`, `mn`, `mng`

**Tajik:**
- `tajik`, `tajikistan`, `tojikiston`, `tojik`, `tajiiku`, `tj`, `tjk`

**Moldovan:**
- `moldovan`, `moldova`, `romanian-cyrillic`, `moldavia`, `morudoba`, `md`, `mol`

## Advanced Features

### Sokuon (っ) Handling

The module properly handles small tsu (っ/ッ) by doubling the following consonant:

```raku
say to-kuriru-moji("がっこう");     # гакко: (doubled к)
say to-kuriru-moji("ちょっと");     # тётто (doubled т)
say to-kuriru-moji("いっぱい");     # иппаи (doubled п)
```

### Long Vowel Processing

Academic systems use colon notation for long vowels:

```raku
# ー (chōonpu) extension
say to-kuriru-moji("ラーメン", :system<polivanov>);  # ра:мэн

# Vowel doubling
say to-kuriru-moji("おおきい", :system<polivanov>);  # о:ки:

# ou → о: pattern
say to-kuriru-moji("とうきょう", :system<polivanov>); # то:кё:
```

### Historical Kana Support

```raku
# Pre-war kana
say to-kuriru-moji("ゐゑを");       # вивэо
say to-kuriru-moji("ゔぁゔぃ");     # вави

# Old forms
say to-kuriru-moji("ゑいが", :system<ru-petr1708>);  # вѣига (with historical ѣ)
```

### Mixed Content Handling

Non-kana characters pass through unchanged:

```raku
say to-kuriru-moji("彼はにほんじんです");       # 彼ханихондзиндэсу
say to-kuriru-moji("Email: info@example.com"); # Email: info@example.com
say to-kuriru-moji("価格：せんえん");          # 価格：сэнэн
```

## API Reference

### Main Function

```raku
sub to-kuriru-moji(Str $text, Str :$system = 'polivanov') is export
```

**Parameters:**
- `$text` - Input text containing Japanese kana
- `:$system` - Transliteration system (default: 'polivanov')

**Returns:** String with kana converted to Cyrillic

**Example:**
```raku
my $result = to-kuriru-moji("こんにちは", :system<phonetic>);
```

### Error Handling

Unknown systems will cause the function to die with an error message:

```raku
# This will die
to-kuriru-moji("test", :system<unknown>);
# Unknown transliteration system: unknown. Use 'polivanov', 'phonetic', 'static', etc.
```

### Integration with Main Module

This module is part of the larger `Lang::JA::Kana` package:

```raku
use Lang::JA::Kana;

# Direct access
say kana-to-kuriru-moji("こんにちは");
say kana-to-kuriru-moji("さくら", :system<ukrainian>);

# Or use submodule directly
use Lang::JA::Kana::Kuriru-moji;
say to-kuriru-moji("こんにちは");
```

## Performance Considerations

- Character conversion uses hash lookups (O(1) per character)
- Multi-character combinations are processed longest-first
- Post-processing variants are applied efficiently
- Memory usage scales with input text length

## Character Coverage

### Supported Kana

**Hiragana:** All standard hiragana including:
- Basic syllabary (あ-ん)
- Voiced marks (が-ぽ)  
- Combinations (きゃ-ぴょ)
- Small variants (ぁ-ゎ)
- Historical forms (ゐゑゔ)
- Modern extensions (ふぁ-ヴォ)

**Katakana:** Complete katakana coverage including:
- Basic syllabary (ア-ン)
- Voiced marks (ガ-ポ)
- Combinations (キャ-ピョ)
- Small variants (ァ-ヮ)
- Long vowel mark (ー)
- Foreign adaptations (ファ-ヴォ)

### Unsupported Content

- **Kanji:** Passed through unchanged
- **Latin alphabet:** Passed through unchanged  
- **Numbers:** Passed through unchanged
- **Punctuation:** Passed through unchanged
- **Half-width katakana:** Must be converted to full-width first

## Linguistic Notes

### System Design Philosophy

Each transliteration system reflects different priorities:

- **Academic systems** prioritize linguistic accuracy and reversibility
- **Phonetic systems** prioritize intuitive pronunciation for speakers
- **Static systems** prioritize simplicity and consistency
- **Language variants** adapt to specific Cyrillic alphabets and phonologies

### Regional Adaptations

Language-specific variants account for:

- **Unique letters** (ў, ө, ғ, ќ, etc.)
- **Phonological differences** (palatalization patterns)
- **Orthographic conventions** (soft/hard signs usage)
- **Historical developments** (alphabet reforms)

## Testing

The module includes comprehensive tests:

```bash
# Run basic tests
raku t/01-basic.t

# Test all systems
raku test-systems.raku

# Test new systems specifically  
raku test-new-systems.raku
```

## Examples Gallery

### Poetry Translation

```raku
my $haiku = "ふるいけや\nかえるとびこむ\nみずのおと";
say to-kuriru-moji($haiku, :system<polivanov>);
# фуруикэя
# каэрутобикому
# мидзуно:то
```

### Anime/Manga Names

```raku
say to-kuriru-moji("ナルト", :system<anime>);        # наруто
say to-kuriru-moji("セーラームーン", :system<anime>); # серамун
say to-kuriru-moji("ピカチュウ", :system<gaming>);   # пикатюу
```

### Geographic Names

```raku
say to-kuriru-moji("とうきょう", :system<static>);   # тоукёу
say to-kuriru-moji("おおさか", :system<static>);     # оосака
say to-kuriru-moji("ひろしま", :system<polivanov>);  # хиросима
```

### Technical Terms

```raku
say to-kuriru-moji("コンピューター", :system<phonetic>); # конпюта
say to-kuriru-moji("インターネット", :system<static>);   # интанетто
say to-kuriru-moji("テクノロジー", :system<polivanov>);  # тэкунородзи:
```

## Contributing

Contributions are welcome. Please visit the project repository at:  
**https://github.com/slavenskoj/raku-lang-ja-kana**

We apologize for any errors and welcome suggestions for improvements.

## License

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

## See Also

- [Lang::JA::Kana](README.md) - Main module documentation
- [Lang::JA::Kana::Romaji](README-Romaji.md) - Romaji transliteration  
- [Lang::JA::Kana::Hangul](README-Hangul.md) - Hangul transliteration
- [Unicode Standard](https://unicode.org/charts/PDF/U3040.pdf) - Hiragana block
- [Unicode Standard](https://unicode.org/charts/PDF/U30A0.pdf) - Katakana block

## Authors

Danslav Slavenskoj

---

