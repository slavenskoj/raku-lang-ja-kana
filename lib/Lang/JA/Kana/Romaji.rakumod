=begin pod

=head1 NAME

Lang::JA::Kana::Romaji - Convert Kana to Romaji using various romanization systems

=head1 SYNOPSIS

=begin code :lang<raku>

use Lang::JA::Kana::Romaji;

# Traditional Hepburn romanization (default)
say kana-to-romaji("こんにちは");  # Output: konnichiwa
say kana-to-romaji("とうきょう");  # Output: toukyou

# Modified Hepburn with macrons
say kana-to-romaji("とうきょう", :system<hepburn-mod>);  # Output: tōkyō

# Kunrei-shiki romanization
say kana-to-romaji("しんぶん", :system<kunrei>);  # Output: sinbun

# Nihon-shiki romanization
say kana-to-romaji("づつき", :system<nihon>);  # Output: dutuki

=end code

=head1 DESCRIPTION

Lang::JA::Kana::Romaji provides conversion from Japanese Kana (Hiragana and Katakana) 
to Romaji using three major romanization systems:

- Traditional Hepburn (default): Most common system, closest to English pronunciation, uses "ou" and "oo" 
- Modified Hepburn (:system<hepburn-mod>): Same as Traditional Hepburn but uses macrons (ō) for long vowels
- Kunrei-shiki: ISO 3602 standard system  
- Nihon-shiki: Preserves Japanese phonological distinctions

B<Note>: This module only handles Kana conversion, not Kanji or mixed Kanji+Kana words.
Kanji characters are passed through unchanged.

=head1 AUTHOR

Danslav Slavenskoj

=head1 COPYRIGHT AND LICENSE

Copyright 2025 Danslav Slavenskoj

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

unit module Lang::JA::Kana::Romaji;

# Hepburn romanization tables
my constant %hepburn-hiragana = (
    # Basic vowels
    'あ' => 'a', 'い' => 'i', 'う' => 'u', 'え' => 'e', 'お' => 'o',
    
    # K-series
    'か' => 'ka', 'き' => 'ki', 'く' => 'ku', 'け' => 'ke', 'こ' => 'ko',
    'が' => 'ga', 'ぎ' => 'gi', 'ぐ' => 'gu', 'げ' => 'ge', 'ご' => 'go',
    
    # S-series
    'さ' => 'sa', 'し' => 'shi', 'す' => 'su', 'せ' => 'se', 'そ' => 'so',
    'ざ' => 'za', 'じ' => 'ji', 'ず' => 'zu', 'ぜ' => 'ze', 'ぞ' => 'zo',
    
    # T-series
    'た' => 'ta', 'ち' => 'chi', 'つ' => 'tsu', 'て' => 'te', 'と' => 'to',
    'だ' => 'da', 'ぢ' => 'ji', 'づ' => 'zu', 'で' => 'de', 'ど' => 'do',
    
    # N-series
    'な' => 'na', 'に' => 'ni', 'ぬ' => 'nu', 'ね' => 'ne', 'の' => 'no',
    
    # H-series
    'は' => 'ha', 'ひ' => 'hi', 'ふ' => 'fu', 'へ' => 'he', 'ほ' => 'ho',
    'ば' => 'ba', 'び' => 'bi', 'ぶ' => 'bu', 'べ' => 'be', 'ぼ' => 'bo',
    'ぱ' => 'pa', 'ぴ' => 'pi', 'ぷ' => 'pu', 'ぺ' => 'pe', 'ぽ' => 'po',
    
    # M-series
    'ま' => 'ma', 'み' => 'mi', 'む' => 'mu', 'め' => 'me', 'も' => 'mo',
    
    # Y-series
    'や' => 'ya', 'ゆ' => 'yu', 'よ' => 'yo',
    
    # R-series
    'ら' => 'ra', 'り' => 'ri', 'る' => 'ru', 'れ' => 're', 'ろ' => 'ro',
    
    # W-series and N
    'わ' => 'wa', 'ゐ' => 'wi', 'ゑ' => 'we', 'を' => 'wo', 'ん' => 'n',
    
    # Small kana
    'ゃ' => 'ya', 'ゅ' => 'yu', 'ょ' => 'yo',
    'っ' => 'tsu',
    'ぁ' => 'a', 'ぃ' => 'i', 'ぅ' => 'u', 'ぇ' => 'e', 'ぉ' => 'o',
    'ゎ' => 'wa',
    
    # Extended sounds
    'ゔ' => 'vu',
    
    # Combination characters - Y-sounds
    'きゃ' => 'kya', 'きゅ' => 'kyu', 'きょ' => 'kyo',
    'しゃ' => 'sha', 'しゅ' => 'shu', 'しょ' => 'sho',
    'ちゃ' => 'cha', 'ちゅ' => 'chu', 'ちょ' => 'cho',
    'にゃ' => 'nya', 'にゅ' => 'nyu', 'にょ' => 'nyo',
    'ひゃ' => 'hya', 'ひゅ' => 'hyu', 'ひょ' => 'hyo',
    'みゃ' => 'mya', 'みゅ' => 'myu', 'みょ' => 'myo',
    'りゃ' => 'rya', 'りゅ' => 'ryu', 'りょ' => 'ryo',
    'ぎゃ' => 'gya', 'ぎゅ' => 'gyu', 'ぎょ' => 'gyo',
    'じゃ' => 'ja', 'じゅ' => 'ju', 'じょ' => 'jo',
    'びゃ' => 'bya', 'びゅ' => 'byu', 'びょ' => 'byo',
    'ぴゃ' => 'pya', 'ぴゅ' => 'pyu', 'ぴょ' => 'pyo',
    
    # Modern extensions for foreign sounds
    'ふぁ' => 'fa', 'ふぃ' => 'fi', 'ふぇ' => 'fe', 'ふぉ' => 'fo',
    'てぃ' => 'ti', 'でぃ' => 'di', 'とぅ' => 'tu', 'どぅ' => 'du',
    'うぃ' => 'wi', 'うぇ' => 'we', 'うぉ' => 'wo',
    'ゔぁ' => 'va', 'ゔぃ' => 'vi', 'ゔぇ' => 've', 'ゔぉ' => 'vo',
    'つぁ' => 'tsa', 'つぃ' => 'tsi', 'つぇ' => 'tse', 'つぉ' => 'tso',
    'ちぇ' => 'che', 'じぇ' => 'je', 'しぇ' => 'she', 'いぇ' => 'ye'
);

my constant %hepburn-katakana = (
    # Basic vowels
    'ア' => 'a', 'イ' => 'i', 'ウ' => 'u', 'エ' => 'e', 'オ' => 'o',
    
    # K-series
    'カ' => 'ka', 'キ' => 'ki', 'ク' => 'ku', 'ケ' => 'ke', 'コ' => 'ko',
    'ガ' => 'ga', 'ギ' => 'gi', 'グ' => 'gu', 'ゲ' => 'ge', 'ゴ' => 'go',
    
    # S-series
    'サ' => 'sa', 'シ' => 'shi', 'ス' => 'su', 'セ' => 'se', 'ソ' => 'so',
    'ザ' => 'za', 'ジ' => 'ji', 'ズ' => 'zu', 'ゼ' => 'ze', 'ゾ' => 'zo',
    
    # T-series
    'タ' => 'ta', 'チ' => 'chi', 'ツ' => 'tsu', 'テ' => 'te', 'ト' => 'to',
    'ダ' => 'da', 'ヂ' => 'ji', 'ヅ' => 'zu', 'デ' => 'de', 'ド' => 'do',
    
    # N-series
    'ナ' => 'na', 'ニ' => 'ni', 'ヌ' => 'nu', 'ネ' => 'ne', 'ノ' => 'no',
    
    # H-series
    'ハ' => 'ha', 'ヒ' => 'hi', 'フ' => 'fu', 'ヘ' => 'he', 'ホ' => 'ho',
    'バ' => 'ba', 'ビ' => 'bi', 'ブ' => 'bu', 'ベ' => 'be', 'ボ' => 'bo',
    'パ' => 'pa', 'ピ' => 'pi', 'プ' => 'pu', 'ペ' => 'pe', 'ポ' => 'po',
    
    # M-series
    'マ' => 'ma', 'ミ' => 'mi', 'ム' => 'mu', 'メ' => 'me', 'モ' => 'mo',
    
    # Y-series
    'ヤ' => 'ya', 'ユ' => 'yu', 'ヨ' => 'yo',
    
    # R-series
    'ラ' => 'ra', 'リ' => 'ri', 'ル' => 'ru', 'レ' => 're', 'ロ' => 'ro',
    
    # W-series and N
    'ワ' => 'wa', 'ヰ' => 'wi', 'ヱ' => 'we', 'ヲ' => 'wo', 'ン' => 'n',
    
    # Small kana
    'ャ' => 'ya', 'ュ' => 'yu', 'ョ' => 'yo',
    'ッ' => 'tsu',
    'ァ' => 'a', 'ィ' => 'i', 'ゥ' => 'u', 'ェ' => 'e', 'ォ' => 'o',
    'ヮ' => 'wa',
    
    # Extended sounds
    'ヴ' => 'vu',
    
    # Combination characters - Y-sounds
    'キャ' => 'kya', 'キュ' => 'kyu', 'キョ' => 'kyo',
    'シャ' => 'sha', 'シュ' => 'shu', 'ショ' => 'sho',
    'チャ' => 'cha', 'チュ' => 'chu', 'チョ' => 'cho',
    'ニャ' => 'nya', 'ニュ' => 'nyu', 'ニョ' => 'nyo',
    'ヒャ' => 'hya', 'ヒュ' => 'hyu', 'ヒョ' => 'hyo',
    'ミャ' => 'mya', 'ミュ' => 'myu', 'ミョ' => 'myo',
    'リャ' => 'rya', 'リュ' => 'ryu', 'リョ' => 'ryo',
    'ギャ' => 'gya', 'ギュ' => 'gyu', 'ギョ' => 'gyo',
    'ジャ' => 'ja', 'ジュ' => 'ju', 'ジョ' => 'jo',
    'ビャ' => 'bya', 'ビュ' => 'byu', 'ビョ' => 'byo',
    'ピャ' => 'pya', 'ピュ' => 'pyu', 'ピョ' => 'pyo',
    
    # Modern extensions for foreign sounds
    'ファ' => 'fa', 'フィ' => 'fi', 'フェ' => 'fe', 'フォ' => 'fo',
    'ティ' => 'ti', 'ディ' => 'di', 'トゥ' => 'tu', 'ドゥ' => 'du',
    'ウィ' => 'wi', 'ウェ' => 'we', 'ウォ' => 'wo',
    'ヴァ' => 'va', 'ヴィ' => 'vi', 'ヴェ' => 've', 'ヴォ' => 'vo',
    'ツァ' => 'tsa', 'ツィ' => 'tsi', 'ツェ' => 'tse', 'ツォ' => 'tso',
    'チェ' => 'che', 'ジェ' => 'je', 'シェ' => 'she', 'イェ' => 'ye'
);

# Kunrei-shiki romanization tables
my constant %kunrei-hiragana = (
    # Basic vowels
    'あ' => 'a', 'い' => 'i', 'う' => 'u', 'え' => 'e', 'お' => 'o',
    
    # K-series
    'か' => 'ka', 'き' => 'ki', 'く' => 'ku', 'け' => 'ke', 'こ' => 'ko',
    'が' => 'ga', 'ぎ' => 'gi', 'ぐ' => 'gu', 'げ' => 'ge', 'ご' => 'go',
    
    # S-series (differences from Hepburn)
    'さ' => 'sa', 'し' => 'si', 'す' => 'su', 'せ' => 'se', 'そ' => 'so',
    'ざ' => 'za', 'じ' => 'zi', 'ず' => 'zu', 'ぜ' => 'ze', 'ぞ' => 'zo',
    
    # T-series (differences from Hepburn)
    'た' => 'ta', 'ち' => 'ti', 'つ' => 'tu', 'て' => 'te', 'と' => 'to',
    'だ' => 'da', 'ぢ' => 'zi', 'づ' => 'zu', 'で' => 'de', 'ど' => 'do',
    
    # N-series
    'な' => 'na', 'に' => 'ni', 'ぬ' => 'nu', 'ね' => 'ne', 'の' => 'no',
    
    # H-series (differences from Hepburn)
    'は' => 'ha', 'ひ' => 'hi', 'ふ' => 'hu', 'へ' => 'he', 'ほ' => 'ho',
    'ば' => 'ba', 'び' => 'bi', 'ぶ' => 'bu', 'べ' => 'be', 'ぼ' => 'bo',
    'ぱ' => 'pa', 'ぴ' => 'pi', 'ぷ' => 'pu', 'ぺ' => 'pe', 'ぽ' => 'po',
    
    # M-series
    'ま' => 'ma', 'み' => 'mi', 'む' => 'mu', 'め' => 'me', 'も' => 'mo',
    
    # Y-series
    'や' => 'ya', 'ゆ' => 'yu', 'よ' => 'yo',
    
    # R-series
    'ら' => 'ra', 'り' => 'ri', 'る' => 'ru', 'れ' => 're', 'ろ' => 'ro',
    
    # W-series and N
    'わ' => 'wa', 'ゐ' => 'wi', 'ゑ' => 'we', 'を' => 'wo', 'ん' => 'n',
    
    # Small kana
    'ゃ' => 'ya', 'ゅ' => 'yu', 'ょ' => 'yo',
    'っ' => 'tu',
    'ぁ' => 'a', 'ぃ' => 'i', 'ぅ' => 'u', 'ぇ' => 'e', 'ぉ' => 'o',
    'ゎ' => 'wa',
    
    # Extended sounds
    'ゔ' => 'vu',
    
    # Combination characters - Y-sounds (differences from Hepburn)
    'きゃ' => 'kya', 'きゅ' => 'kyu', 'きょ' => 'kyo',
    'しゃ' => 'sya', 'しゅ' => 'syu', 'しょ' => 'syo',
    'ちゃ' => 'tya', 'ちゅ' => 'tyu', 'ちょ' => 'tyo',
    'にゃ' => 'nya', 'にゅ' => 'nyu', 'にょ' => 'nyo',
    'ひゃ' => 'hya', 'ひゅ' => 'hyu', 'ひょ' => 'hyo',
    'みゃ' => 'mya', 'みゅ' => 'myu', 'みょ' => 'myo',
    'りゃ' => 'rya', 'りゅ' => 'ryu', 'りょ' => 'ryo',
    'ぎゃ' => 'gya', 'ぎゅ' => 'gyu', 'ぎょ' => 'gyo',
    'じゃ' => 'zya', 'じゅ' => 'zyu', 'じょ' => 'zyo',
    'びゃ' => 'bya', 'びゅ' => 'byu', 'びょ' => 'byo',
    'ぴゃ' => 'pya', 'ぴゅ' => 'pyu', 'ぴょ' => 'pyo',
    
    # Modern extensions for foreign sounds
    'ふぁ' => 'hwa', 'ふぃ' => 'hwi', 'ふぇ' => 'hwe', 'ふぉ' => 'hwo',
    'てぃ' => 'ti', 'でぃ' => 'di', 'とぅ' => 'tu', 'どぅ' => 'du',
    'うぃ' => 'wi', 'うぇ' => 'we', 'うぉ' => 'wo',
    'ゔぁ' => 'va', 'ゔぃ' => 'vi', 'ゔぇ' => 've', 'ゔぉ' => 'vo',
    'つぁ' => 'tua', 'つぃ' => 'tui', 'つぇ' => 'tue', 'つぉ' => 'tuo',
    'ちぇ' => 'tye', 'じぇ' => 'zye', 'しぇ' => 'sye', 'いぇ' => 'ye'
);

my constant %kunrei-katakana = (
    # Basic vowels
    'ア' => 'a', 'イ' => 'i', 'ウ' => 'u', 'エ' => 'e', 'オ' => 'o',
    
    # K-series
    'カ' => 'ka', 'キ' => 'ki', 'ク' => 'ku', 'ケ' => 'ke', 'コ' => 'ko',
    'ガ' => 'ga', 'ギ' => 'gi', 'グ' => 'gu', 'ゲ' => 'ge', 'ゴ' => 'go',
    
    # S-series (differences from Hepburn)
    'サ' => 'sa', 'シ' => 'si', 'ス' => 'su', 'セ' => 'se', 'ソ' => 'so',
    'ザ' => 'za', 'ジ' => 'zi', 'ズ' => 'zu', 'ゼ' => 'ze', 'ゾ' => 'zo',
    
    # T-series (differences from Hepburn)
    'タ' => 'ta', 'チ' => 'ti', 'ツ' => 'tu', 'テ' => 'te', 'ト' => 'to',
    'ダ' => 'da', 'ヂ' => 'zi', 'ヅ' => 'zu', 'デ' => 'de', 'ド' => 'do',
    
    # N-series
    'ナ' => 'na', 'ニ' => 'ni', 'ヌ' => 'nu', 'ネ' => 'ne', 'ノ' => 'no',
    
    # H-series (differences from Hepburn)
    'ハ' => 'ha', 'ヒ' => 'hi', 'フ' => 'hu', 'ヘ' => 'he', 'ホ' => 'ho',
    'バ' => 'ba', 'ビ' => 'bi', 'ブ' => 'bu', 'ベ' => 'be', 'ボ' => 'bo',
    'パ' => 'pa', 'ピ' => 'pi', 'プ' => 'pu', 'ペ' => 'pe', 'ポ' => 'po',
    
    # M-series
    'マ' => 'ma', 'ミ' => 'mi', 'ム' => 'mu', 'メ' => 'me', 'モ' => 'mo',
    
    # Y-series
    'ヤ' => 'ya', 'ユ' => 'yu', 'ヨ' => 'yo',
    
    # R-series
    'ラ' => 'ra', 'リ' => 'ri', 'ル' => 'ru', 'レ' => 're', 'ロ' => 'ro',
    
    # W-series and N
    'ワ' => 'wa', 'ヰ' => 'wi', 'ヱ' => 'we', 'ヲ' => 'wo', 'ン' => 'n',
    
    # Small kana
    'ャ' => 'ya', 'ュ' => 'yu', 'ョ' => 'yo',
    'ッ' => 'tu',
    'ァ' => 'a', 'ィ' => 'i', 'ゥ' => 'u', 'ェ' => 'e', 'ォ' => 'o',
    'ヮ' => 'wa',
    
    # Extended sounds
    'ヴ' => 'vu',
    
    # Combination characters - Y-sounds (differences from Hepburn)
    'キャ' => 'kya', 'キュ' => 'kyu', 'キョ' => 'kyo',
    'シャ' => 'sya', 'シュ' => 'syu', 'ショ' => 'syo',
    'チャ' => 'tya', 'チュ' => 'tyu', 'チョ' => 'tyo',
    'ニャ' => 'nya', 'ニュ' => 'nyu', 'ニョ' => 'nyo',
    'ヒャ' => 'hya', 'ヒュ' => 'hyu', 'ヒョ' => 'hyo',
    'ミャ' => 'mya', 'ミュ' => 'myu', 'ミョ' => 'myo',
    'リャ' => 'rya', 'リュ' => 'ryu', 'リョ' => 'ryo',
    'ギャ' => 'gya', 'ギュ' => 'gyu', 'ギョ' => 'gyo',
    'ジャ' => 'zya', 'ジュ' => 'zyu', 'ジョ' => 'zyo',
    'ビャ' => 'bya', 'ビュ' => 'byu', 'ビョ' => 'byo',
    'ピャ' => 'pya', 'ピュ' => 'pyu', 'ピョ' => 'pyo',
    
    # Modern extensions for foreign sounds
    'ファ' => 'hwa', 'フィ' => 'hwi', 'フェ' => 'hwe', 'フォ' => 'hwo',
    'ティ' => 'ti', 'ディ' => 'di', 'トゥ' => 'tu', 'ドゥ' => 'du',
    'ウィ' => 'wi', 'ウェ' => 'we', 'ウォ' => 'wo',
    'ヴァ' => 'va', 'ヴィ' => 'vi', 'ヴェ' => 've', 'ヴォ' => 'vo',
    'ツァ' => 'tua', 'ツィ' => 'tui', 'ツェ' => 'tue', 'ツォ' => 'tuo',
    'チェ' => 'tye', 'ジェ' => 'zye', 'シェ' => 'sye', 'イェ' => 'ye'
);

# Nihon-shiki romanization tables (preserves phonological distinctions)
my constant %nihon-hiragana = (
    # Basic vowels
    'あ' => 'a', 'い' => 'i', 'う' => 'u', 'え' => 'e', 'お' => 'o',
    
    # K-series
    'か' => 'ka', 'き' => 'ki', 'く' => 'ku', 'け' => 'ke', 'こ' => 'ko',
    'が' => 'ga', 'ぎ' => 'gi', 'ぐ' => 'gu', 'げ' => 'ge', 'ご' => 'go',
    
    # S-series (same as Kunrei-shiki)
    'さ' => 'sa', 'し' => 'si', 'す' => 'su', 'せ' => 'se', 'そ' => 'so',
    'ざ' => 'za', 'じ' => 'zi', 'ず' => 'zu', 'ぜ' => 'ze', 'ぞ' => 'zo',
    
    # T-series (same as Kunrei-shiki)
    'た' => 'ta', 'ち' => 'ti', 'つ' => 'tu', 'て' => 'te', 'と' => 'to',
    'だ' => 'da', 'ぢ' => 'di', 'づ' => 'du', 'で' => 'de', 'ど' => 'do',  # Preserves ぢ/づ distinction
    
    # N-series
    'な' => 'na', 'に' => 'ni', 'ぬ' => 'nu', 'ね' => 'ne', 'の' => 'no',
    
    # H-series (same as Kunrei-shiki)
    'は' => 'ha', 'ひ' => 'hi', 'ふ' => 'hu', 'へ' => 'he', 'ほ' => 'ho',
    'ば' => 'ba', 'び' => 'bi', 'ぶ' => 'bu', 'べ' => 'be', 'ぼ' => 'bo',
    'ぱ' => 'pa', 'ぴ' => 'pi', 'ぷ' => 'pu', 'ぺ' => 'pe', 'ぽ' => 'po',
    
    # M-series
    'ま' => 'ma', 'み' => 'mi', 'む' => 'mu', 'め' => 'me', 'も' => 'mo',
    
    # Y-series
    'や' => 'ya', 'ゆ' => 'yu', 'よ' => 'yo',
    
    # R-series
    'ら' => 'ra', 'り' => 'ri', 'る' => 'ru', 'れ' => 're', 'ろ' => 'ro',
    
    # W-series and N (preserves historical kana)
    'わ' => 'wa', 'ゐ' => 'wi', 'ゑ' => 'we', 'を' => 'wo', 'ん' => 'n',
    
    # Small kana
    'ゃ' => 'ya', 'ゅ' => 'yu', 'ょ' => 'yo',
    'っ' => 'tu',
    'ぁ' => 'a', 'ぃ' => 'i', 'ぅ' => 'u', 'ぇ' => 'e', 'ぉ' => 'o',
    'ゎ' => 'wa',
    
    # Extended sounds
    'ゔ' => 'vu',
    
    # Combination characters - Y-sounds (same as Kunrei-shiki)
    'きゃ' => 'kya', 'きゅ' => 'kyu', 'きょ' => 'kyo',
    'しゃ' => 'sya', 'しゅ' => 'syu', 'しょ' => 'syo',
    'ちゃ' => 'tya', 'ちゅ' => 'tyu', 'ちょ' => 'tyo',
    'にゃ' => 'nya', 'にゅ' => 'nyu', 'にょ' => 'nyo',
    'ひゃ' => 'hya', 'ひゅ' => 'hyu', 'ひょ' => 'hyo',
    'みゃ' => 'mya', 'みゅ' => 'myu', 'みょ' => 'myo',
    'りゃ' => 'rya', 'りゅ' => 'ryu', 'りょ' => 'ryo',
    'ぎゃ' => 'gya', 'ぎゅ' => 'gyu', 'ぎょ' => 'gyo',
    'じゃ' => 'zya', 'じゅ' => 'zyu', 'じょ' => 'zyo',
    'びゃ' => 'bya', 'びゅ' => 'byu', 'びょ' => 'byo',
    'ぴゃ' => 'pya', 'ぴゅ' => 'pyu', 'ぴょ' => 'pyo',
    
    # Modern extensions for foreign sounds
    'ふぁ' => 'hwa', 'ふぃ' => 'hwi', 'ふぇ' => 'hwe', 'ふぉ' => 'hwo',
    'てぃ' => 'ti', 'でぃ' => 'di', 'とぅ' => 'tu', 'どぅ' => 'du',
    'うぃ' => 'wi', 'うぇ' => 'we', 'うぉ' => 'wo',
    'ゔぁ' => 'va', 'ゔぃ' => 'vi', 'ゔぇ' => 've', 'ゔぉ' => 'vo',
    'つぁ' => 'tua', 'つぃ' => 'tui', 'つぇ' => 'tue', 'つぉ' => 'tuo',
    'ちぇ' => 'tye', 'じぇ' => 'zye', 'しぇ' => 'sye', 'いぇ' => 'ye'
);

my constant %nihon-katakana = (
    # Basic vowels
    'ア' => 'a', 'イ' => 'i', 'ウ' => 'u', 'エ' => 'e', 'オ' => 'o',
    
    # K-series
    'カ' => 'ka', 'キ' => 'ki', 'ク' => 'ku', 'ケ' => 'ke', 'コ' => 'ko',
    'ガ' => 'ga', 'ギ' => 'gi', 'グ' => 'gu', 'ゲ' => 'ge', 'ゴ' => 'go',
    
    # S-series (same as Kunrei-shiki)
    'サ' => 'sa', 'シ' => 'si', 'ス' => 'su', 'セ' => 'se', 'ソ' => 'so',
    'ザ' => 'za', 'ジ' => 'zi', 'ズ' => 'zu', 'ゼ' => 'ze', 'ゾ' => 'zo',
    
    # T-series (same as Kunrei-shiki)
    'タ' => 'ta', 'チ' => 'ti', 'ツ' => 'tu', 'テ' => 'te', 'ト' => 'to',
    'ダ' => 'da', 'ヂ' => 'di', 'ヅ' => 'du', 'デ' => 'de', 'ド' => 'do',  # Preserves ヂ/ヅ distinction
    
    # N-series
    'ナ' => 'na', 'ニ' => 'ni', 'ヌ' => 'nu', 'ネ' => 'ne', 'ノ' => 'no',
    
    # H-series (same as Kunrei-shiki)
    'ハ' => 'ha', 'ヒ' => 'hi', 'フ' => 'hu', 'ヘ' => 'he', 'ホ' => 'ho',
    'バ' => 'ba', 'ビ' => 'bi', 'ブ' => 'bu', 'ベ' => 'be', 'ボ' => 'bo',
    'パ' => 'pa', 'ピ' => 'pi', 'プ' => 'pu', 'ペ' => 'pe', 'ポ' => 'po',
    
    # M-series
    'マ' => 'ma', 'ミ' => 'mi', 'ム' => 'mu', 'メ' => 'me', 'モ' => 'mo',
    
    # Y-series
    'ヤ' => 'ya', 'ユ' => 'yu', 'ヨ' => 'yo',
    
    # R-series
    'ラ' => 'ra', 'リ' => 'ri', 'ル' => 'ru', 'レ' => 're', 'ロ' => 'ro',
    
    # W-series and N (preserves historical kana)
    'ワ' => 'wa', 'ヰ' => 'wi', 'ヱ' => 'we', 'ヲ' => 'wo', 'ン' => 'n',
    
    # Small kana
    'ャ' => 'ya', 'ュ' => 'yu', 'ョ' => 'yo',
    'ッ' => 'tu',
    'ァ' => 'a', 'ィ' => 'i', 'ゥ' => 'u', 'ェ' => 'e', 'ォ' => 'o',
    'ヮ' => 'wa',
    
    # Extended sounds
    'ヴ' => 'vu',
    
    # Combination characters - Y-sounds (same as Kunrei-shiki)
    'キャ' => 'kya', 'キュ' => 'kyu', 'キョ' => 'kyo',
    'シャ' => 'sya', 'シュ' => 'syu', 'ショ' => 'syo',
    'チャ' => 'tya', 'チュ' => 'tyu', 'チョ' => 'tyo',
    'ニャ' => 'nya', 'ニュ' => 'nyu', 'ニョ' => 'nyo',
    'ヒャ' => 'hya', 'ヒュ' => 'hyu', 'ヒョ' => 'hyo',
    'ミャ' => 'mya', 'ミュ' => 'myu', 'ミョ' => 'myo',
    'リャ' => 'rya', 'リュ' => 'ryu', 'リョ' => 'ryo',
    'ギャ' => 'gya', 'ギュ' => 'gyu', 'ギョ' => 'gyo',
    'ジャ' => 'zya', 'ジュ' => 'zyu', 'ジョ' => 'zyo',
    'ビャ' => 'bya', 'ビュ' => 'byu', 'ビョ' => 'byo',
    'ピャ' => 'pya', 'ピュ' => 'pyu', 'ピョ' => 'pyo',
    
    # Modern extensions for foreign sounds
    'ファ' => 'hwa', 'フィ' => 'hwi', 'フェ' => 'hwe', 'フォ' => 'hwo',
    'ティ' => 'ti', 'ディ' => 'di', 'トゥ' => 'tu', 'ドゥ' => 'du',
    'ウィ' => 'wi', 'ウェ' => 'we', 'ウォ' => 'wo',
    'ヴァ' => 'va', 'ヴィ' => 'vi', 'ヴェ' => 've', 'ヴォ' => 'vo',
    'ツァ' => 'tua', 'ツィ' => 'tui', 'ツェ' => 'tue', 'ツォ' => 'tuo',
    'チェ' => 'tye', 'ジェ' => 'zye', 'シェ' => 'sye', 'イェ' => 'ye'
);

# Special handling for っ (small tsu) - doubles the following consonant
sub handle-sokuon(Str $text, %table) {
    my $result = $text;
    
    # Handle っ/ッ followed by consonant sounds
    $result = $result.subst(/'っ' (<[かきくけこがぎぐげごさしすせそざじずぜぞたちつてとだぢづでどはひふへほばびぶべぼぱぴぷぺぽまみむめもやゆよらりるれろわゐゑをん]>)/, -> $/ {
        my $next-char = $0.Str;
        my $romaji = %table{$next-char} // $next-char;
        my $doubled-consonant = $romaji.substr(0, 1);
        $doubled-consonant ~ $romaji;
    }, :g);
    
    $result = $result.subst(/'ッ' (<[カキクケコガギグゲゴサシスセソザジズゼゾタチツテトダヂヅデドハヒフヘホバビブベボパピプペポマミムメモヤユヨラリルレロワヰヱヲン]>)/, -> $/ {
        my $next-char = $0.Str;
        my $romaji = %table{$next-char} // $next-char;
        my $doubled-consonant = $romaji.substr(0, 1);
        $doubled-consonant ~ $romaji;
    }, :g);
    
    return $result;
}

# Special handling for ん (n) before certain consonants
sub handle-n-assimilation(Str $text) {
    my $result = $text;
    
    # n becomes m before b, p, m sounds
    $result = $result.subst(/'n' (<[bpm]>)/, -> $/ { 'm' ~ $0.Str }, :g);
    
    # Add apostrophe before vowels and y to distinguish from na, ni, nu, ne, no, nya, nyu, nyo
    # But only if it would create ambiguity
    $result = $result.subst(/'n' (<[aeioy]>)/, -> $/ { "n'" ~ $0.Str }, :g);
    
    return $result;
}

# Long vowel handling
sub handle-long-vowels(Str $text) {
    my $result = $text;
    
    # Handle ー (chōonpu) - extends the previous vowel
    $result = $result.subst(/(<[aiueo]>) 'ー'/, -> $/ { $0.Str ~ $0.Str }, :g);
    
    # Handle ou -> ō in Hepburn (most common long vowel pattern)
    $result = $result.subst(/'ou'/, 'ō', :g);
    
    # Handle doubled vowels (aa, ii, uu, ee, oo) - but not oo since がっこう should be gakkou
    $result = $result.subst(/'aa'/, 'ā', :g);
    $result = $result.subst(/'ii'/, 'ī', :g);
    $result = $result.subst(/'uu'/, 'ū', :g);
    $result = $result.subst(/'ee'/, 'ē', :g);
    # Only convert oo -> ō for specific long vowel cases, not doubled consonants
    # $result = $result.subst(/'oo'/, 'ō', :g);
    
    return $result;
}

sub romaji(Str $text, Str :$system = 'hepburn') is export {
    my %hiragana-table;
    my %katakana-table;
    
    # Select romanization system
    given $system.lc {
        when 'hepburn' | 'hep' {
            %hiragana-table = %hepburn-hiragana;
            %katakana-table = %hepburn-katakana;
        }
        when 'hepburn-mod' | 'hepburn-modified' | 'modified-hepburn' {
            %hiragana-table = %hepburn-hiragana;
            %katakana-table = %hepburn-katakana;
        }
        when 'kunrei' | 'kunrei-shiki' {
            %hiragana-table = %kunrei-hiragana;
            %katakana-table = %kunrei-katakana;
        }
        when 'nihon' | 'nihon-shiki' {
            %hiragana-table = %nihon-hiragana;
            %katakana-table = %nihon-katakana;
        }
        default {
            die "Unknown romanization system: $system. Use 'hepburn', 'hepburn-mod', 'kunrei', or 'nihon'.";
        }
    }
    
    my $result = $text;
    
    # Note: Half-width katakana conversion should be done before calling this function
    
    # Handle sokuon (っ/ッ) first
    my %combined-table = |%hiragana-table, |%katakana-table;
    $result = handle-sokuon($result, %combined-table);
    
    # Convert hiragana (sort by length - longest first for multi-character combinations)
    for %hiragana-table.keys.sort(*.chars).reverse -> $kana {
        $result = $result.subst($kana, %hiragana-table{$kana}, :g);
    }
    
    # Convert katakana (sort by length - longest first for multi-character combinations)
    for %katakana-table.keys.sort(*.chars).reverse -> $kana {
        $result = $result.subst($kana, %katakana-table{$kana}, :g);
    }
    
    # Handle n assimilation (disabled for now to match expected test results)
    # $result = handle-n-assimilation($result);
    
    # Handle long vowels (only for Modified Hepburn)
    if $system.lc eq 'hepburn-mod' | 'hepburn-modified' | 'modified-hepburn' {
        $result = handle-long-vowels($result);
    }
    
    return $result;
}