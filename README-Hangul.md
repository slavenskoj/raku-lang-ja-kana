# Lang::JA::Kana::Hangul - Japanese Kana to Korean Hangul Conversion

**Documentation:**
- **Main**: [English](README.md) • [日本語](README-jp.md)
- **Romaji**: [README-Romaji.md](README-Romaji.md)
- **Cyrillic**: [English](README-Kuriru-moji.md) • [Русский](README-Kuriru-moji-ru.md)
- **Hangul**: [English](README-Hangul.md) • [한국어](README-Hangul-kr.md)

## Overview

Lang::JA::Kana::Hangul provides comprehensive conversion from Japanese Kana (Hiragana and Katakana) to Korean Hangul script using multiple transliteration systems designed for different purposes and contexts.

## Features

- **Multiple Conversion Systems**: Four distinct systems tailored for different use cases
- **Comprehensive Character Support**: Handles all standard kana, historical kana, and modern extensions
- **Sokuon (っ) Processing**: Advanced handling of consonant doubling with system-specific rules
- **Korean Phonotactics**: Proper Korean syllable structure with initial, medial, and final consonants
- **Unicode Compliance**: Full Unicode Korean syllable block support (0xAC00-0xD7A3)

## Installation

```raku
use Lang::JA::Kana::Hangul;
```

## Basic Usage

```raku
use Lang::JA::Kana::Hangul;

# Basic conversion (Standard system - default)
say to-hangul("こんにちは");      # → 곤니치하
say to-hangul("さくら");         # → 사구라
say to-hangul("ありがとう");      # → 아리가도우

# Academic system (linguistic precision)
say to-hangul("がっこう", :system<academic>);  # → 깍코우
say to-hangul("ばっば", :system<academic>);    # → 빱빠

# Phonetic system (preserves Japanese pronunciation)
say to-hangul("ちゃちゅちょ", :system<phonetic>);  # → 치야치유치요
say to-hangul("きょう", :system<phonetic>);        # → 키요우

# Popular system (K-pop/media usage)
say to-hangul("ちゅう", :system<popular>);     # → 추우
say to-hangul("じゃじゅじょ", :system<popular>); # → 쟈쥬죠
```

## Conversion Systems

### 1. Standard System (Default)

The **Standard** system provides balanced phonetic conversion suitable for general use. It follows Korean phonological patterns while maintaining reasonable accuracy to Japanese pronunciation.

**Characteristics:**
- Balanced approach between accuracy and Korean phonological naturalness
- Standard Korean syllable structure (CV, CVC)
- Regular consonant and vowel mappings
- Appropriate for educational materials and general reference

**Examples:**
```raku
to-hangul("こんにちは");    # → 곤니치하
to-hangul("しんぶん");     # → 신분
to-hangul("がっこう");     # → 각고우
```

### 2. Academic System

The **Academic** system follows Korean linguistic conventions and academic transliteration standards. It includes special handling for consonant doubling and aspiration.

**Characteristics:**
- Linguistic precision with Korean phonological rules
- Advanced sokuon (っ) processing with consonant doubling
- Tensed consonants (ㄲ, ㄸ, ㅃ, ㅆ, ㅉ) for doubled sounds
- Aspirated consonants (ㅋ, ㅌ, ㅍ, ㅊ) in specific contexts
- Suitable for academic papers and linguistic research

**Sokuon Rules:**
- Previous syllable: Gets tensed initial consonant + final consonant
- Next syllable: Gets aspirated consonant (different) or tensed consonant (same)

**Examples:**
```raku
to-hangul("がっこう", :system<academic>);  # → 깍코우 (tensed ㄲ + aspirated ㅋ)
to-hangul("ばっば", :system<academic>);    # → 빱빠 (tensed ㅃ on both syllables)
to-hangul("さっぽろ", :system<academic>);  # → 삽포로
```

### 3. Phonetic System

The **Phonetic** system preserves Japanese pronunciation as closely as possible in Hangul, breaking down complex sounds into component parts.

**Characteristics:**
- Decomposes palatalized sounds (ちゃ → 치야, しゃ → 시야)
- Preserves Japanese phonological distinctions
- Special mappings for certain sounds (っ → 쯔 when standalone)
- Ideal for pronunciation guides and language learning

**Examples:**
```raku
to-hangul("ちゃちゅちょ", :system<phonetic>);  # → 치야치유치요
to-hangul("しゃしゅしょ", :system<phonetic>);  # → 시야시유시요
to-hangul("ちょっと", :system<phonetic>);      # → 치요쯔토
to-hangul("きょう", :system<phonetic>);        # → 키요우
```

### 4. Popular System

The **Popular** system uses conventions common in Korean pop culture, media, and entertainment contexts.

**Characteristics:**
- Optimized for K-pop, anime, and media contexts
- Alternative mappings for certain sounds (ちゅ → 추, じゃ → 쟈)
- Popular romanization patterns adapted to Hangul
- Used in fan communities and entertainment media

**Examples:**
```raku
to-hangul("ちゅう", :system<popular>);         # → 추우
to-hangul("じゃじゅじょ", :system<popular>);   # → 쟈쥬죠
to-hangul("すず", :system<popular>);           # → 수주
```

## Character Support

### Basic Kana
All standard Hiragana and Katakana characters are supported:
```raku
# Vowels
to-hangul("あいうえお");  # → 아이우에오
to-hangul("アイウエオ");  # → 아이우에오

# Consonant series (K, S, T, N, H, M, Y, R, W)
to-hangul("かきくけこ");  # → 가기구게고
to-hangul("さしすせそ");  # → 사시스세소
```

### Voiced and Semi-voiced Sounds
```raku
# Voiced (濁音)
to-hangul("がぎぐげご");  # → 가기구게고
to-hangul("ざじずぜぞ");  # → 자지즈제조
to-hangul("だぢづでど");  # → 다지즈데도
to-hangul("ばびぶべぼ");  # → 바비부베보

# Semi-voiced (半濁音)
to-hangul("ぱぴぷぺぽ");  # → 파피푸페포
```

### Combination Sounds (拗音)
```raku
# Y-combinations
to-hangul("きゃきゅきょ");  # → 갸규교
to-hangul("しゃしゅしょ");  # → 샤슈쇼
to-hangul("ちゃちゅちょ");  # → 차츄쵸

# Voiced combinations
to-hangul("ぎゃぎゅぎょ");  # → 갸규교
to-hangul("じゃじゅじょ");  # → 자주조
to-hangul("びゃびゅびょ");  # → 뱌뷰뵤
```

### Modern Extensions
```ruka
# Foreign sound adaptations
to-hangul("ふぁふぃふぇふぉ");  # → 파피페포
to-hangul("てぃでぃ");         # → 티디
to-hangul("とぅどぅ");         # → 투두
to-hangul("うぃうぇうぉ");     # → 위웨워
to-hangul("ゔぁゔぃゔぇゔぉ"); # → 바비베보
```

### Historical Kana
```raku
# Historical characters
to-hangul("ゐゑを");  # → 위웨오
to-hangul("ゔ");      # → 부 (VU sound)
```

## Sokuon (っ/ッ) Processing

The small tsu (っ/ッ) represents consonant doubling and is handled differently by each system:

### Standard System
Adds final consonant to previous syllable:
```raku
to-hangul("がっこう");  # → 각고우 (ㄱ final + 고)
to-hangul("ちょっと");  # → 촛도 (ㅅ final + 도)
```

### Academic System
Advanced doubling with tensed and aspirated consonants:
```raku
to-hangul("がっこう", :system<academic>);  # → 깍코우
# が → 깍 (tensed ㄲ + final ㄱ)
# こ → 코 (aspirated ㅋ)

to-hangul("ばっば", :system<academic>);    # → 빱빠
# ば → 빱 (tensed ㅃ + final ㅂ)  
# ば → 빠 (tensed ㅃ - same consonant)
```

### Phonetic System
Processes after kana conversion, preserves pronunciation:
```raku
to-hangul("ちょっと", :system<phonetic>);  # → 치요쯔토
# っ treated as つ equivalent (쯔) in context
```

### Popular System
Simplified processing for media contexts:
```raku
to-hangul("ちょっと", :system<popular>);   # → 초토
```

## Korean Syllable Structure

The module uses proper Korean syllable structure with three components:

1. **Initial Consonant (초성)**: 19 consonants including tensed and aspirated variants
2. **Medial Vowel (중성)**: 21 vowel combinations
3. **Final Consonant (종성)**: 28 possible endings including compound consonants

### Consonant Mappings

**Basic Consonants:**
- ㄱ (g/k), ㄴ (n), ㄷ (d/t), ㄹ (r/l), ㅁ (m), ㅂ (b/p), ㅅ (s), ㅇ (ng/silent), ㅈ (j), ㅊ (ch), ㅋ (k), ㅌ (t), ㅍ (p), ㅎ (h)

**Tensed Consonants (Academic system):**
- ㄲ (kk), ㄸ (tt), ㅃ (pp), ㅆ (ss), ㅉ (jj)

**Aspirated Consonants (Academic system):**
- ㅋ (kh), ㅌ (th), ㅍ (ph), ㅊ (chh)

### Vowel Mappings

**Simple Vowels:**
- ㅏ (a), ㅓ (eo), ㅗ (o), ㅜ (u), ㅡ (eu), ㅣ (i), ㅐ (ae), ㅔ (e)

**Complex Vowels:**
- ㅑ (ya), ㅕ (yeo), ㅛ (yo), ㅠ (yu), ㅒ (yae), ㅖ (ye)
- ㅘ (wa), ㅙ (wae), ㅚ (oe), ㅝ (wo), ㅞ (we), ㅟ (wi), ㅢ (ui)

## System Aliases

Multiple aliases are supported for convenience:

```raku
# Standard system
to-hangul("text", :system<standard>);
to-hangul("text", :system<default>);

# Academic system  
to-hangul("text", :system<academic>);
to-hangul("text", :system<scholarly>);

# Phonetic system
to-hangul("text", :system<phonetic>);
to-hangul("text", :system<literal>);

# Popular system
to-hangul("text", :system<popular>);
to-hangul("text", :system<media>);
to-hangul("text", :system<kpop>);
```

## Advanced Features

### Mixed Text Handling
Non-kana characters are passed through unchanged:
```raku
to-hangul("Hello こんにちは World");  # → Hello 곤니치하 World
to-hangul("123 あいう ABC");         # → 123 아이우 ABC
```

### Half-width Katakana Support
Half-width katakana is automatically converted to full-width before processing:
```raku
to-hangul("ｶﾀｶﾅ");  # → 가다가나
to-hangul("ｱｲｳｴｵ"); # → 아이우에오
```

### Long Vowel Processing
Long vowels are handled according to Korean phonological patterns:
```raku
to-hangul("とうきょう");  # → 도우교우
to-hangul("おおきい");   # → 오오기이
to-hangul("ー");         # → (long vowel mark removed)
```

## Technical Implementation

### Unicode Ranges
- **Korean Syllables**: U+AC00 to U+D7A3 (가 to 힣)
- **Korean Jamo**: U+1100 to U+11FF (individual consonants/vowels)
- **Japanese Hiragana**: U+3040 to U+309F
- **Japanese Katakana**: U+30A0 to U+30FF

### Syllable Composition Algorithm
The module uses mathematical composition of Korean syllables:
```
syllable_code = 0xAC00 + (initial_index × 21 × 28) + (medial_index × 28) + final_index
```

### Performance Considerations
- Efficient pattern matching with longest-first sorting
- Unicode-compliant syllable decomposition and composition
- Optimized regex patterns for sokuon processing

## Linguistic Background

### Korean Phonological Constraints
Korean has specific phonotactic rules that influence the conversion:

1. **Syllable Structure**: Korean prefers (C)V(C) structure
2. **Consonant Clusters**: Limited consonant clusters in final position
3. **Vowel Harmony**: Considered in academic system
4. **Tensing Rules**: Applied in academic system for accuracy

### Japanese-Korean Phonological Mapping
Historical linguistic relationships inform the conversion patterns:

1. **Shared Chinese Character Readings**: Common Sino-Korean/Sino-Japanese patterns
2. **Phonological Correspondences**: Systematic sound relationships
3. **Modern Adaptations**: Contemporary borrowing patterns

## Use Cases

### Educational Applications
- Japanese language learning materials for Korean speakers
- Comparative linguistics studies
- Pronunciation guides and dictionaries

### Media and Entertainment
- K-pop artist name romanization
- Anime/manga title adaptation
- Fan community translations

### Academic Research
- Linguistic analysis and comparison
- Historical phonology studies
- Cross-cultural communication research

### Technical Applications
- Search and indexing systems
- Database normalization
- Cross-script information retrieval

## Limitations

1. **Context Sensitivity**: Some conversions may require contextual knowledge
2. **Semantic Ambiguity**: Pure phonetic conversion without semantic consideration
3. **Dialectal Variations**: Based on standard Japanese pronunciation
4. **Kanji Handling**: Does not process Chinese characters (Kanji)

## Error Handling

The module gracefully handles various input conditions:
- Invalid Unicode characters are passed through unchanged
- Unknown kana characters are preserved
- Empty strings return empty results
- Mixed scripts are processed selectively

## Contributing

Contributions are welcome. Please visit the project repository at:  
**https://github.com/slavenskoj/raku-lang-ja-kana**

We apologize for any errors and welcome suggestions for improvements.

## References

### Academic Sources
- Korean Language Society (국립국어원) romanization guidelines
- Japanese-Korean linguistic correspondence studies
- Unicode Consortium Korean block specifications

### Standards
- ISO 11941 (Korean script romanization)
- Unicode Standard Korean syllable block
- Japanese Industrial Standards (JIS) kana specifications

## Version History

- **v1.0.0**: Initial release with four conversion systems
- **v1.1.0**: Enhanced sokuon processing and academic system improvements
- **v1.2.0**: Added comprehensive character support and system aliases

## License

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

## Author

Danslav Slavenskoj

---

For more information about the complete Lang::JA::Kana module suite, see the main README.md file.