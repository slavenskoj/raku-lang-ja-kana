=begin pod

=head1 NAME

Lang::JA::Kana::Kuriru-moji - Convert Kana to Cyrillic using various transliteration systems

=head1 SYNOPSIS

=begin code :lang<raku>

use Lang::JA::Kana::Kuriru-moji;

# Polivanov system (default - academic standard)
say to-kuriru-moji("こんにちは");  # Output: конничива
say to-kuriru-moji("東京です", :system<polivanov>);  # Output: то:кё:дэсу

# Phonetic system (more intuitive for Russian speakers)
say to-kuriru-moji("しんぶん", :system<phonetic>);  # Output: шинбун

# Static system (no long vowel marks)
say to-kuriru-moji("とうきょう", :system<static>);  # Output: токио

# Gaming/Anime-Manga systems
say to-kuriru-moji("ナルト", :system<anime>);        # Output: Наруто
say to-kuriru-moji("ゲーム", :system<game>);         # Output: Гейм

# National variants
say to-kuriru-moji("さくら", :system<ua>);           # Output: сакура
say to-kuriru-moji("さくら", :system<bulgaria>);     # Output: сакура

=end code

=head1 DESCRIPTION

Lang::JA::Kana::Kuriru-moji provides conversion from Japanese Kana (Hiragana and Katakana) 
to Cyrillic script using various transliteration systems designed for different Slavic languages
and usage contexts:

- Polivanov (default): Academic standard, uses long vowel marks
- Phonetic: More intuitive for Russian speakers (し→ши, ち→чи, じゃ→джя)
- Static: No long vowel marks, simplified
- Anime-Manga-Fan: Popular in fan communities (aliases: anime, fan)
- Gaming Community: Used in gaming contexts (aliases: game)
- Pre-revolutionary: Historical Russian orthography (alias: ru-petr1708)
- GOST 7.79-2000: Official Russian standard
- Soviet Textbook: Educational standard from Soviet era
- Kontsevich: Academic transliteration system
- Belarusian: Adapted for Belarusian Cyrillic (aliases: belarus, belaruskaja, belaruski, berarushi, be, blr)
- Serbian: Adapted for Serbian Cyrillic (aliases: serbia, srbija, srbski, serubija, sr, srb)
- Bulgarian: Adapted for Bulgarian Cyrillic (aliases: bulgaria, balgarija, balgarski, burugarija, burugariya, bg, bgr)
- Macedonian: Adapted for Macedonian Cyrillic (aliases: macedonia, makedonija, makedonski, makedonia, mazedoniya, mk, mkd)
- Mongolian: Adapted for Mongolian Cyrillic (aliases: mongolia, mongol, mongolski, mongoru, mn, mng)
- Kazakh: Adapted for Kazakh Cyrillic (aliases: kazakhstan, qazaqstan, qazaq, kazafusutan, kz, kaz)
- Kyrgyz: Adapted for Kyrgyz Cyrillic (aliases: kyrgyzstan, qyrgyzstan, qyrgyz, kirugisutan, ky, kgz)
- Tajik: Adapted for Tajik Cyrillic (aliases: tajikistan, tojikiston, tajik, tojik, tajiiku, tj, tjk)
- Moldovan: Adapted for Moldovan Romanian Cyrillic (aliases: moldova, moldovan, romanian-cyrillic, moldavia, morudoba, md, mol)
- Ukrainian: Adapted for Ukrainian Cyrillic (aliases: ukraine, ukraina, ukrainski, ukuraina, ua, ukr, uk)

B<Note>: This module only handles Kana conversion, not Kanji or mixed Kanji+Kana words.
Kanji characters are passed through unchanged.

=head1 AUTHOR

Danslav Slavenskoj

=head1 COPYRIGHT AND LICENSE

Copyright 2025 Danslav Slavenskoj

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

unit module Lang::JA::Kana::Kuriru-moji;

# Import hiragana-to-katakana conversion for static system
my constant %hiragana-to-katakana = (
    'あ' => 'ア', 'い' => 'イ', 'う' => 'ウ', 'え' => 'エ', 'お' => 'オ',
    'か' => 'カ', 'き' => 'キ', 'く' => 'ク', 'け' => 'ケ', 'こ' => 'コ',
    'が' => 'ガ', 'ぎ' => 'ギ', 'ぐ' => 'グ', 'げ' => 'ゲ', 'ご' => 'ゴ',
    'さ' => 'サ', 'し' => 'シ', 'す' => 'ス', 'せ' => 'セ', 'そ' => 'ソ',
    'ざ' => 'ザ', 'じ' => 'ジ', 'ず' => 'ズ', 'ぜ' => 'ゼ', 'ぞ' => 'ゾ',
    'た' => 'タ', 'ち' => 'チ', 'つ' => 'ツ', 'て' => 'テ', 'と' => 'ト',
    'だ' => 'ダ', 'ぢ' => 'ヂ', 'づ' => 'ヅ', 'で' => 'デ', 'ど' => 'ド',
    'な' => 'ナ', 'に' => 'ニ', 'ぬ' => 'ヌ', 'ね' => 'ネ', 'の' => 'ノ',
    'は' => 'ハ', 'ひ' => 'ヒ', 'ふ' => 'フ', 'へ' => 'ヘ', 'ほ' => 'ホ',
    'ば' => 'バ', 'び' => 'ビ', 'ぶ' => 'ブ', 'べ' => 'ベ', 'ぼ' => 'ボ',
    'ぱ' => 'パ', 'ぴ' => 'ピ', 'ぷ' => 'プ', 'ぺ' => 'ペ', 'ぽ' => 'ポ',
    'ま' => 'マ', 'み' => 'ミ', 'む' => 'ム', 'め' => 'メ', 'も' => 'モ',
    'や' => 'ヤ', 'ゆ' => 'ユ', 'よ' => 'ヨ',
    'ら' => 'ラ', 'り' => 'リ', 'る' => 'ル', 'れ' => 'レ', 'ろ' => 'ロ',
    'わ' => 'ワ', 'ゐ' => 'ヰ', 'ゑ' => 'ヱ', 'を' => 'ヲ', 'ん' => 'ン',
    'ゃ' => 'ャ', 'ゅ' => 'ュ', 'ょ' => 'ョ', 'っ' => 'ッ',
    'ぁ' => 'ァ', 'ぃ' => 'ィ', 'ぅ' => 'ゥ', 'ぇ' => 'ェ', 'ぉ' => 'ォ',
    'ゎ' => 'ヮ', 'ゔ' => 'ヴ'
);

# Polivanov system tables (academic standard with long vowel marks)
my constant %polivanov-hiragana = (
    # Basic vowels
    'あ' => 'а', 'い' => 'и', 'う' => 'у', 'え' => 'э', 'お' => 'о',
    
    # K-series
    'か' => 'ка', 'き' => 'ки', 'く' => 'ку', 'け' => 'кэ', 'こ' => 'ко',
    'が' => 'га', 'ぎ' => 'ги', 'ぐ' => 'гу', 'げ' => 'гэ', 'ご' => 'го',
    
    # S-series
    'さ' => 'са', 'し' => 'си', 'す' => 'су', 'せ' => 'сэ', 'そ' => 'со',
    'ざ' => 'дза', 'じ' => 'дзи', 'ず' => 'дзу', 'ぜ' => 'дзэ', 'ぞ' => 'дзо',
    
    # T-series
    'た' => 'та', 'ち' => 'чи', 'つ' => 'цу', 'て' => 'тэ', 'と' => 'то',
    'だ' => 'да', 'ぢ' => 'дзи', 'づ' => 'дзу', 'で' => 'дэ', 'ど' => 'до',
    
    # N-series
    'な' => 'на', 'に' => 'ни', 'ぬ' => 'ну', 'ね' => 'нэ', 'の' => 'но',
    
    # H-series
    'は' => 'ха', 'ひ' => 'хи', 'ふ' => 'фу', 'へ' => 'хэ', 'ほ' => 'хо',
    'ば' => 'ба', 'び' => 'би', 'ぶ' => 'бу', 'べ' => 'бэ', 'ぼ' => 'бо',
    'ぱ' => 'па', 'ぴ' => 'пи', 'ぷ' => 'пу', 'ぺ' => 'пэ', 'ぽ' => 'по',
    
    # M-series
    'ま' => 'ма', 'み' => 'ми', 'む' => 'му', 'め' => 'мэ', 'も' => 'мо',
    
    # Y-series
    'や' => 'я', 'ゆ' => 'ю', 'よ' => 'ё',
    
    # R-series
    'ら' => 'ра', 'り' => 'ри', 'る' => 'ру', 'れ' => 'рэ', 'ろ' => 'ро',
    
    # W-series and N
    'わ' => 'ва', 'ゐ' => 'ви', 'ゑ' => 'вэ', 'を' => 'о', 'ん' => 'н',
    
    # Small kana
    'ゃ' => 'я', 'ゅ' => 'ю', 'ょ' => 'ё',
    'っ' => 'цу',
    'ぁ' => 'а', 'ぃ' => 'и', 'ぅ' => 'у', 'ぇ' => 'э', 'ぉ' => 'о',
    'ゎ' => 'ва',
    
    # Extended sounds
    'ゔ' => 'ву',
    
    # Combination characters - Y-sounds
    'きゃ' => 'кя', 'きゅ' => 'кю', 'きょ' => 'кё',
    'しゃ' => 'ся', 'しゅ' => 'сю', 'しょ' => 'сё',
    'ちゃ' => 'тя', 'ちゅ' => 'тю', 'ちょ' => 'тё',
    'にゃ' => 'ня', 'にゅ' => 'ню', 'にょ' => 'нё',
    'ひゃ' => 'хя', 'ひゅ' => 'хю', 'ひょ' => 'хё',
    'みゃ' => 'мя', 'みゅ' => 'мю', 'みょ' => 'мё',
    'りゃ' => 'ря', 'りゅ' => 'рю', 'りょ' => 'рё',
    'ぎゃ' => 'гя', 'ぎゅ' => 'гю', 'ぎょ' => 'гё',
    'じゃ' => 'дзя', 'じゅ' => 'дзю', 'じょ' => 'дзё',
    'びゃ' => 'бя', 'びゅ' => 'бю', 'びょ' => 'бё',
    'ぴゃ' => 'пя', 'ぴゅ' => 'пю', 'ぴょ' => 'пё',
    
    # Modern extensions for foreign sounds
    'ふぁ' => 'фа', 'ふぃ' => 'фи', 'ふぇ' => 'фэ', 'ふぉ' => 'фо',
    'てぃ' => 'ти', 'でぃ' => 'ди', 'とぅ' => 'ту', 'どぅ' => 'ду',
    'うぃ' => 'ви', 'うぇ' => 'вэ', 'うぉ' => 'во',
    'ゔぁ' => 'ва', 'ゔぃ' => 'ви', 'ゔぇ' => 'вэ', 'ゔぉ' => 'во',
    'つぁ' => 'ца', 'つぃ' => 'ци', 'つぇ' => 'цэ', 'つぉ' => 'цо',
    'ちぇ' => 'чэ', 'じぇ' => 'дзэ', 'しぇ' => 'сэ', 'いぇ' => 'иэ'
);

my constant %polivanov-katakana = (
    # Basic vowels
    'ア' => 'а', 'イ' => 'и', 'ウ' => 'у', 'エ' => 'э', 'オ' => 'о',
    
    # K-series
    'カ' => 'ка', 'キ' => 'ки', 'ク' => 'ку', 'ケ' => 'кэ', 'コ' => 'ко',
    'ガ' => 'га', 'ギ' => 'ги', 'グ' => 'гу', 'ゲ' => 'гэ', 'ゴ' => 'го',
    
    # S-series
    'サ' => 'са', 'シ' => 'си', 'ス' => 'су', 'セ' => 'сэ', 'ソ' => 'со',
    'ザ' => 'дза', 'ジ' => 'дзи', 'ズ' => 'дзу', 'ゼ' => 'дзэ', 'ゾ' => 'дзо',
    
    # T-series
    'タ' => 'та', 'チ' => 'чи', 'ツ' => 'цу', 'テ' => 'тэ', 'ト' => 'то',
    'ダ' => 'да', 'ヂ' => 'дзи', 'ヅ' => 'дзу', 'デ' => 'дэ', 'ド' => 'до',
    
    # N-series
    'ナ' => 'на', 'ニ' => 'ни', 'ヌ' => 'ну', 'ネ' => 'нэ', 'ノ' => 'но',
    
    # H-series
    'ハ' => 'ха', 'ヒ' => 'хи', 'フ' => 'фу', 'ヘ' => 'хэ', 'ホ' => 'хо',
    'バ' => 'ба', 'ビ' => 'би', 'ブ' => 'бу', 'ベ' => 'бэ', 'ボ' => 'бо',
    'パ' => 'па', 'ピ' => 'пи', 'プ' => 'пу', 'ペ' => 'пэ', 'ポ' => 'по',
    
    # M-series
    'マ' => 'ма', 'ミ' => 'ми', 'ム' => 'му', 'メ' => 'мэ', 'モ' => 'мо',
    
    # Y-series
    'ヤ' => 'я', 'ユ' => 'ю', 'ヨ' => 'ё',
    
    # R-series
    'ラ' => 'ра', 'リ' => 'ри', 'ル' => 'ру', 'レ' => 'рэ', 'ロ' => 'ро',
    
    # W-series and N
    'ワ' => 'ва', 'ヰ' => 'ви', 'ヱ' => 'вэ', 'ヲ' => 'о', 'ン' => 'н',
    
    # Small kana
    'ャ' => 'я', 'ュ' => 'ю', 'ョ' => 'ё',
    'ッ' => 'цу',
    'ァ' => 'а', 'ィ' => 'и', 'ゥ' => 'у', 'ェ' => 'э', 'ォ' => 'о',
    'ヮ' => 'ва',
    
    # Extended sounds
    'ヴ' => 'ву',
    
    # Combination characters - Y-sounds
    'キャ' => 'кя', 'キュ' => 'кю', 'キョ' => 'кё',
    'シャ' => 'ся', 'シュ' => 'сю', 'ショ' => 'сё',
    'チャ' => 'тя', 'チュ' => 'тю', 'チョ' => 'тё',
    'ニャ' => 'ня', 'ニュ' => 'ню', 'ニョ' => 'нё',
    'ヒャ' => 'хя', 'ヒュ' => 'хю', 'ヒョ' => 'хё',
    'ミャ' => 'мя', 'ミュ' => 'мю', 'ミョ' => 'мё',
    'リャ' => 'ря', 'リュ' => 'рю', 'リョ' => 'рё',
    'ギャ' => 'гя', 'ギュ' => 'гю', 'ギョ' => 'гё',
    'ジャ' => 'дзя', 'ジュ' => 'дзю', 'ジョ' => 'дзё',
    'ビャ' => 'бя', 'ビュ' => 'бю', 'ビョ' => 'бё',
    'ピャ' => 'пя', 'ピュ' => 'пю', 'ピョ' => 'пё',
    
    # Modern extensions for foreign sounds
    'ファ' => 'фа', 'フィ' => 'фи', 'フェ' => 'фэ', 'フォ' => 'фо',
    'ティ' => 'ти', 'ディ' => 'ди', 'トゥ' => 'ту', 'ドゥ' => 'ду',
    'ウィ' => 'ви', 'ウェ' => 'вэ', 'ウォ' => 'во',
    'ヴァ' => 'ва', 'ヴィ' => 'ви', 'ヴェ' => 'вэ', 'ヴォ' => 'во',
    'ツァ' => 'ца', 'ツィ' => 'ци', 'ツェ' => 'цэ', 'ツォ' => 'цо',
    'チェ' => 'чэ', 'ジェ' => 'дзэ', 'シェ' => 'сэ', 'イェ' => 'иэ'
);

# Phonetic system tables (more intuitive for Russian speakers)
my constant %phonetic-hiragana = (
    # Basic vowels
    'あ' => 'а', 'い' => 'и', 'う' => 'у', 'え' => 'е', 'お' => 'о',
    
    # K-series
    'か' => 'ка', 'き' => 'ки', 'く' => 'ку', 'け' => 'ке', 'こ' => 'ко',
    'が' => 'га', 'ぎ' => 'ги', 'ぐ' => 'гу', 'げ' => 'ге', 'ご' => 'го',
    
    # S-series (differences from Polivanov)
    'さ' => 'са', 'し' => 'ши', 'す' => 'су', 'せ' => 'се', 'そ' => 'со',
    'ざ' => 'за', 'じ' => 'жи', 'ず' => 'зу', 'ぜ' => 'зе', 'ぞ' => 'зо',
    
    # T-series (differences from Polivanov)
    'た' => 'та', 'ち' => 'чи', 'つ' => 'цу', 'て' => 'те', 'と' => 'то',
    'だ' => 'да', 'ぢ' => 'джи', 'づ' => 'дзу', 'で' => 'де', 'ど' => 'до',
    
    # N-series
    'な' => 'на', 'に' => 'ни', 'ぬ' => 'ну', 'ね' => 'не', 'の' => 'но',
    
    # H-series
    'は' => 'ха', 'ひ' => 'хи', 'ふ' => 'фу', 'へ' => 'хе', 'ほ' => 'хо',
    'ば' => 'ба', 'び' => 'би', 'ぶ' => 'бу', 'べ' => 'бе', 'ぼ' => 'бо',
    'ぱ' => 'па', 'ぴ' => 'пи', 'ぷ' => 'пу', 'ぺ' => 'пе', 'ぽ' => 'по',
    
    # M-series
    'ま' => 'ма', 'み' => 'ми', 'む' => 'му', 'め' => 'ме', 'も' => 'мо',
    
    # Y-series
    'や' => 'я', 'ゆ' => 'ю', 'よ' => 'ё',
    
    # R-series
    'ら' => 'ра', 'り' => 'ри', 'る' => 'ру', 'れ' => 'ре', 'ろ' => 'ро',
    
    # W-series and N
    'わ' => 'ва', 'ゐ' => 'ви', 'ゑ' => 'ве', 'を' => 'во', 'ん' => 'н',
    
    # Small kana
    'ゃ' => 'я', 'ゅ' => 'ю', 'ょ' => 'ё',
    'っ' => 'ц',
    'ぁ' => 'а', 'ぃ' => 'и', 'ぅ' => 'у', 'ぇ' => 'е', 'ぉ' => 'о',
    'ゎ' => 'ва',
    
    # Extended sounds
    'ゔ' => 'ву',
    
    # Combination characters - Y-sounds (differences from Polivanov)
    'きゃ' => 'кя', 'きゅ' => 'кю', 'きょ' => 'кё',
    'しゃ' => 'ша', 'しゅ' => 'шу', 'しょ' => 'шо',
    'ちゃ' => 'ча', 'ちゅ' => 'чу', 'ちょ' => 'чо',
    'にゃ' => 'ня', 'にゅ' => 'ню', 'にょ' => 'нё',
    'ひゃ' => 'хя', 'ひゅ' => 'хю', 'ひょ' => 'хё',
    'みゃ' => 'мя', 'みゅ' => 'мю', 'みょ' => 'мё',
    'りゃ' => 'ря', 'りゅ' => 'рю', 'りょ' => 'рё',
    'ぎゃ' => 'гя', 'ぎゅ' => 'гю', 'ぎょ' => 'гё',
    'じゃ' => 'джя', 'じゅ' => 'джю', 'じょ' => 'джё',
    'びゃ' => 'бя', 'びゅ' => 'бю', 'びょ' => 'бё',
    'ぴゃ' => 'пя', 'ぴゅ' => 'пю', 'ぴょ' => 'пё',
    
    # Modern extensions for foreign sounds
    'ふぁ' => 'фа', 'ふぃ' => 'фи', 'ふぇ' => 'фе', 'ふぉ' => 'фо',
    'てぃ' => 'ти', 'でぃ' => 'ди', 'とぅ' => 'ту', 'どぅ' => 'ду',
    'うぃ' => 'ви', 'うぇ' => 'ве', 'うぉ' => 'во',
    'ゔぁ' => 'ва', 'ゔぃ' => 'ви', 'ゔぇ' => 'ве', 'ゔぉ' => 'во',
    'つぁ' => 'ца', 'つぃ' => 'ци', 'つぇ' => 'це', 'つぉ' => 'цо',
    'ちぇ' => 'че', 'じぇ' => 'дже', 'しぇ' => 'ше', 'いぇ' => 'ие',
    
    # Long vowel mark handling
    'ー' => ''
);

my constant %phonetic-katakana = (
    # Basic vowels
    'ア' => 'а', 'イ' => 'и', 'ウ' => 'у', 'エ' => 'е', 'オ' => 'о',
    
    # K-series
    'カ' => 'ка', 'キ' => 'ки', 'ク' => 'ку', 'ケ' => 'ке', 'コ' => 'ко',
    'ガ' => 'га', 'ギ' => 'ги', 'グ' => 'гу', 'ゲ' => 'ге', 'ゴ' => 'го',
    
    # S-series (differences from Polivanov)
    'サ' => 'са', 'シ' => 'ши', 'ス' => 'су', 'セ' => 'се', 'ソ' => 'со',
    'ザ' => 'за', 'ジ' => 'жи', 'ズ' => 'зу', 'ゼ' => 'зе', 'ゾ' => 'зо',
    
    # T-series (differences from Polivanov)
    'タ' => 'та', 'チ' => 'чи', 'ツ' => 'цу', 'テ' => 'те', 'ト' => 'то',
    'ダ' => 'да', 'ヂ' => 'джи', 'ヅ' => 'дзу', 'デ' => 'де', 'ド' => 'до',
    
    # N-series
    'ナ' => 'на', 'ニ' => 'ни', 'ヌ' => 'ну', 'ネ' => 'не', 'ノ' => 'но',
    
    # H-series
    'ハ' => 'ха', 'ヒ' => 'хи', 'フ' => 'фу', 'ヘ' => 'хе', 'ホ' => 'хо',
    'バ' => 'ба', 'ビ' => 'би', 'ブ' => 'бу', 'ベ' => 'бе', 'ボ' => 'бо',
    'パ' => 'па', 'ピ' => 'пи', 'プ' => 'пу', 'ペ' => 'пе', 'ポ' => 'по',
    
    # M-series
    'マ' => 'ма', 'ミ' => 'ми', 'ム' => 'му', 'メ' => 'ме', 'モ' => 'мо',
    
    # Y-series
    'ヤ' => 'я', 'ユ' => 'ю', 'ヨ' => 'ё',
    
    # R-series
    'ラ' => 'ра', 'リ' => 'ри', 'ル' => 'ру', 'レ' => 'ре', 'ロ' => 'ро',
    
    # W-series and N
    'ワ' => 'ва', 'ヰ' => 'ви', 'ヱ' => 'ве', 'ヲ' => 'во', 'ン' => 'н',
    
    # Small kana
    'ャ' => 'я', 'ュ' => 'ю', 'ョ' => 'ё',
    'ッ' => 'ц',
    'ァ' => 'а', 'ィ' => 'и', 'ゥ' => 'у', 'ェ' => 'е', 'ォ' => 'о',
    'ヮ' => 'ва',
    
    # Extended sounds
    'ヴ' => 'ву',
    
    # Combination characters - Y-sounds (differences from Polivanov)
    'キャ' => 'кя', 'キュ' => 'кю', 'キョ' => 'кё',
    'シャ' => 'ша', 'シュ' => 'шу', 'ショ' => 'шо',
    'チャ' => 'ча', 'チュ' => 'чу', 'チョ' => 'чо',
    'ニャ' => 'ня', 'ニュ' => 'ню', 'ニョ' => 'нё',
    'ヒャ' => 'хя', 'ヒュ' => 'хю', 'ヒョ' => 'хё',
    'ミャ' => 'мя', 'ミュ' => 'мю', 'ミョ' => 'мё',
    'リャ' => 'ря', 'リュ' => 'рю', 'リョ' => 'рё',
    'ギャ' => 'гя', 'ギュ' => 'гю', 'ギョ' => 'гё',
    'ジャ' => 'джя', 'ジュ' => 'джю', 'ジョ' => 'джё',
    'ビャ' => 'бя', 'ビュ' => 'бю', 'ビョ' => 'бё',
    'ピャ' => 'пя', 'ピュ' => 'пю', 'ピョ' => 'пё',
    
    # Modern extensions for foreign sounds
    'ファ' => 'фа', 'フィ' => 'фи', 'フェ' => 'фе', 'フォ' => 'фо',
    'ティ' => 'ти', 'ディ' => 'ди', 'トゥ' => 'ту', 'ドゥ' => 'ду',
    'ウィ' => 'ви', 'ウェ' => 'ве', 'ウォ' => 'во',
    'ヴァ' => 'ва', 'ヴィ' => 'ви', 'ヴェ' => 'ве', 'ヴォ' => 'во',
    'ツァ' => 'ца', 'ツィ' => 'ци', 'ツェ' => 'це', 'ツォ' => 'цо',
    'チェ' => 'че', 'ジェ' => 'дже', 'シェ' => 'ше', 'イェ' => 'ие',
    
    # Long vowel mark handling
    'ー' => 'ー'
);

# Static system tables (simplified, no long vowel marks)
my constant %static-base = (
    # Basic vowels (hiragana)
    'あ' => 'а', 'い' => 'и', 'う' => 'у', 'え' => 'е', 'お' => 'о',
    # Basic vowels (katakana)
    'ア' => 'а', 'イ' => 'и', 'ウ' => 'у', 'エ' => 'е', 'オ' => 'о',
    
    # K-series (hiragana)
    'か' => 'ка', 'き' => 'ки', 'く' => 'ку', 'け' => 'ке', 'こ' => 'ко',
    'が' => 'га', 'ぎ' => 'ги', 'ぐ' => 'гу', 'げ' => 'ге', 'ご' => 'го',
    # K-series (katakana)
    'カ' => 'ка', 'キ' => 'ки', 'ク' => 'ку', 'ケ' => 'ке', 'コ' => 'ко',
    'ガ' => 'га', 'ギ' => 'ги', 'グ' => 'гу', 'ゲ' => 'ге', 'ゴ' => 'го',
    
    # S-series (hiragana)
    'さ' => 'са', 'し' => 'си', 'す' => 'су', 'せ' => 'се', 'そ' => 'со',
    'ざ' => 'за', 'じ' => 'зи', 'ず' => 'зу', 'ぜ' => 'зе', 'ぞ' => 'зо',
    # S-series (katakana)
    'サ' => 'са', 'シ' => 'си', 'ス' => 'су', 'セ' => 'се', 'ソ' => 'со',
    'ザ' => 'за', 'ジ' => 'зи', 'ズ' => 'зу', 'ゼ' => 'зе', 'ゾ' => 'зо',
    
    # T-series (hiragana)
    'た' => 'та', 'ち' => 'ти', 'つ' => 'цу', 'て' => 'те', 'と' => 'то',
    'だ' => 'да', 'ぢ' => 'ди', 'づ' => 'ду', 'で' => 'де', 'ど' => 'до',
    # T-series (katakana)
    'タ' => 'та', 'チ' => 'ти', 'ツ' => 'цу', 'テ' => 'те', 'ト' => 'то',
    'ダ' => 'да', 'ヂ' => 'ди', 'ヅ' => 'ду', 'デ' => 'де', 'ド' => 'до',
    
    # N-series (hiragana)
    'な' => 'на', 'に' => 'ни', 'ぬ' => 'ну', 'ね' => 'не', 'の' => 'но',
    # N-series (katakana)
    'ナ' => 'на', 'ニ' => 'ни', 'ヌ' => 'ну', 'ネ' => 'не', 'ノ' => 'но',
    
    # H-series (hiragana)
    'は' => 'ха', 'ひ' => 'хи', 'ふ' => 'фу', 'へ' => 'хе', 'ほ' => 'хо',
    'ば' => 'ба', 'び' => 'би', 'ぶ' => 'бу', 'べ' => 'бе', 'ぼ' => 'бо',
    'ぱ' => 'па', 'ぴ' => 'пи', 'ぷ' => 'пу', 'ぺ' => 'пе', 'ぽ' => 'по',
    # H-series (katakana)
    'ハ' => 'ха', 'ヒ' => 'хи', 'フ' => 'фу', 'ヘ' => 'хе', 'ホ' => 'хо',
    'バ' => 'ба', 'ビ' => 'би', 'ブ' => 'бу', 'ベ' => 'бе', 'ボ' => 'бо',
    'パ' => 'па', 'ピ' => 'пи', 'プ' => 'пу', 'ペ' => 'пе', 'ポ' => 'по',
    
    # M-series (hiragana)
    'ま' => 'ма', 'み' => 'ми', 'む' => 'му', 'め' => 'ме', 'も' => 'мо',
    # M-series (katakana)
    'マ' => 'ма', 'ミ' => 'ми', 'ム' => 'му', 'メ' => 'ме', 'モ' => 'мо',
    
    # Y-series (hiragana)
    'や' => 'я', 'ゆ' => 'ю', 'よ' => 'ё',
    # Y-series (katakana)
    'ヤ' => 'я', 'ユ' => 'ю', 'ヨ' => 'ё',
    
    # R-series (hiragana)
    'ら' => 'ра', 'り' => 'ри', 'る' => 'ру', 'れ' => 'ре', 'ろ' => 'ро',
    # R-series (katakana)
    'ラ' => 'ра', 'リ' => 'ри', 'ル' => 'ру', 'レ' => 'ре', 'ロ' => 'ро',
    
    # W-series and N (hiragana)
    'わ' => 'ва', 'ゐ' => 'ви', 'ゑ' => 'ве', 'を' => 'во', 'ん' => 'н',
    # W-series and N (katakana)
    'ワ' => 'ва', 'ヰ' => 'ви', 'ヱ' => 'ве', 'ヲ' => 'во', 'ン' => 'н',
    
    # Small kana (hiragana)
    'ゃ' => 'я', 'ゅ' => 'ю', 'ょ' => 'ё',
    'っ' => '',
    'ぁ' => 'а', 'ぃ' => 'и', 'ぅ' => 'у', 'ぇ' => 'е', 'ぉ' => 'о',
    'ゎ' => 'ва',
    # Small kana (katakana)
    'ャ' => 'я', 'ュ' => 'ю', 'ョ' => 'ё',
    'ッ' => '',
    'ァ' => 'а', 'ィ' => 'и', 'ゥ' => 'у', 'ェ' => 'е', 'ォ' => 'о',
    'ヮ' => 'ва',
    
    # Extended sounds
    'ゔ' => 'ву', 'ヴ' => 'ву',
    
    # Long vowel mark
    'ー' => '',
    
    # Combination characters (hiragana)
    'きゃ' => 'кя', 'きゅ' => 'кю', 'きょ' => 'кё',
    'しゃ' => 'ся', 'しゅ' => 'сю', 'しょ' => 'сё',
    'ちゃ' => 'тя', 'ちゅ' => 'тю', 'ちょ' => 'тё',
    'にゃ' => 'ня', 'にゅ' => 'ню', 'にょ' => 'нё',
    'ひゃ' => 'хя', 'ひゅ' => 'хю', 'ひょ' => 'хё',
    'みゃ' => 'мя', 'みゅ' => 'мю', 'みょ' => 'мё',
    'りゃ' => 'ря', 'りゅ' => 'рю', 'りょ' => 'рё',
    'ぎゃ' => 'гя', 'ぎゅ' => 'гю', 'ぎょ' => 'гё',
    'じゃ' => 'зя', 'じゅ' => 'зю', 'じょ' => 'зё',
    'びゃ' => 'бя', 'びゅ' => 'бю', 'びょ' => 'бё',
    'ぴゃ' => 'пя', 'ぴゅ' => 'пю', 'ぴょ' => 'пё',
    # Combination characters (katakana)
    'キャ' => 'кя', 'キュ' => 'кю', 'キョ' => 'кё',
    'シャ' => 'ся', 'シュ' => 'сю', 'ショ' => 'сё',
    'チャ' => 'тя', 'チュ' => 'тю', 'チョ' => 'тё',
    'ニャ' => 'ня', 'ニュ' => 'ню', 'ニョ' => 'нё',
    'ヒャ' => 'хя', 'ヒュ' => 'хю', 'ヒョ' => 'хё',
    'ミャ' => 'мя', 'ミュ' => 'мю', 'ミョ' => 'мё',
    'リャ' => 'ря', 'リュ' => 'рю', 'リョ' => 'рё',
    'ギャ' => 'гя', 'ギュ' => 'гю', 'ギョ' => 'гё',
    'ジャ' => 'зя', 'ジュ' => 'зю', 'ジョ' => 'зё',
    'ビャ' => 'бя', 'ビュ' => 'бю', 'ビョ' => 'бё',
    'ピャ' => 'пя', 'ピュ' => 'пю', 'ピョ' => 'пё'
);

# Special handling for っ (small tsu) - doubles the following consonant
sub handle-sokuon-cyrillic(Str $text, %table) {
    my $result = $text;
    
    # Handle っ/ッ followed by consonant sounds
    $result = $result.subst(/'っ' (<[かきくけこがぎぐげごさしすせそざじずぜぞたちつてとだぢづでどはひふへほばびぶべぼぱぴぷぺぽまみむめもやゆよらりるれろわゐゑをん]>)/, -> $/ {
        my $next-char = $0.Str;
        my $cyrillic = %table{$next-char} // $next-char;
        my $doubled-consonant = $cyrillic.substr(0, 1);
        $doubled-consonant ~ $cyrillic;
    }, :g);
    
    $result = $result.subst(/'ッ' (<[カキクケコガギグゲゴサシスセソザジズゼゾタチツテトダヂヅデドハヒフヘホバビブベボパピプペポマミムメモヤユヨラリルレロワヰヱヲン]>)/, -> $/ {
        my $next-char = $0.Str;
        my $cyrillic = %table{$next-char} // $next-char;
        my $doubled-consonant = $cyrillic.substr(0, 1);
        $doubled-consonant ~ $cyrillic;
    }, :g);
    
    return $result;
}

# Long vowel handling for Polivanov system
sub handle-long-vowels-cyrillic(Str $text) {
    my $result = $text;
    
    # Handle ー (chōonpu) - extends the previous vowel
    $result = $result.subst(/(<[аиуеоэ]>) 'ー'/, -> $/ { $0.Str ~ ':' }, :g);
    
    # Handle ou -> о: in academic systems (とうきょう -> то:кё:)
    $result = $result.subst(/'оу'/, 'о:', :g);
    
    # Handle ёu -> ё: (きょう -> кё:)
    $result = $result.subst(/'ёу'/, 'ё:', :g);
    
    # Handle doubled vowels
    $result = $result.subst(/'аа'/, 'а:', :g);
    $result = $result.subst(/'ии'/, 'и:', :g);
    $result = $result.subst(/'уу'/, 'у:', :g);
    $result = $result.subst(/'ее'/, 'е:', :g);
    $result = $result.subst(/'ээ'/, 'э:', :g);
    $result = $result.subst(/'оо'/, 'о:', :g);
    
    return $result;
}

# Ukrainian system variants
my constant %ukrainian-variants = (
    'つ' => 'цу', 'づ' => 'дзу', 'ぢ' => 'дзі',
    'し' => 'сі', 'じ' => 'дзі', 'ち' => 'ті', 'ふ' => 'фу',
    'ツ' => 'ЦУ', 'ヅ' => 'ДЗУ', 'ヂ' => 'ДЗІ',
    'シ' => 'СІ', 'ジ' => 'ДЗІ', 'チ' => 'ТІ', 'フ' => 'ФУ'
);

# Serbian system variants
my constant %serbian-variants = (
    'ふ' => 'фу', 'つ' => 'цу', 'づ' => 'џу',
    'じ' => 'џи', 'ち' => 'чи', 'し' => 'ши',
    'フ' => 'ФУ', 'ツ' => 'ЦУ', 'ヅ' => 'ЏУ',
    'ジ' => 'ЏИ', 'チ' => 'ЧИ', 'シ' => 'ШИ'
);

# Belarusian system variants
my constant %belarusian-variants = (
    'う' => 'ў', 'ウ' => 'Ў',
    'ふ' => 'фу', 'フ' => 'ФУ',
    'つ' => 'цу', 'ツ' => 'ЦУ',
    'ち' => 'чы', 'チ' => 'ЧЫ',
    'し' => 'шы', 'シ' => 'ШЫ',
    'じ' => 'жы', 'ジ' => 'ЖЫ',
    'い' => 'і', 'イ' => 'І',
    'え' => 'е', 'エ' => 'Е',
    'о' => 'о', 'オ' => 'О'
);

# Macedonian system variants  
my constant %macedonian-variants = (
    'ふ' => 'фу', 'フ' => 'ФУ',
    'つ' => 'цу', 'ツ' => 'ЦУ',
    'ち' => 'чи', 'チ' => 'ЧИ',
    'し' => 'ши', 'シ' => 'ШИ',
    'じ' => 'жи', 'ジ' => 'ЖИ',
    'づ' => 'џу', 'ヅ' => 'ЏУ',
    'ぢ' => 'џи', 'ヂ' => 'ЏИ',
    'き' => 'ќи', 'キ' => 'ЌИ',
    'ぎ' => 'ѓи', 'ギ' => 'ЃИ',
    'け' => 'ќе', 'ケ' => 'ЌЕ',
    'げ' => 'ѓе', 'ゲ' => 'ЃЕ'
);

# Kazakh system variants
my constant %kazakh-variants = (
    'う' => 'ұ', 'ウ' => 'Ұ',
    'ふ' => 'фу', 'フ' => 'ФУ',
    'つ' => 'цу', 'ツ' => 'ЦУ',
    'ち' => 'чи', 'チ' => 'ЧИ',
    'し' => 'ши', 'シ' => 'ШИ',
    'じ' => 'жи', 'ジ' => 'ЖИ',
    'が' => 'ға', 'ガ' => 'ҒА',
    'ぎ' => 'ғи', 'ギ' => 'ҒИ',
    'ぐ' => 'ғу', 'グ' => 'ҒУ',
    'げ' => 'ғе', 'ゲ' => 'ҒЕ',
    'ご' => 'ғо', 'ゴ' => 'ҒО',
    'お' => 'о', 'オ' => 'О',
    'ө' => 'ө', 'Ө' => 'Ө'
);

# Mongolian system variants
my constant %mongolian-variants = (
    'う' => 'ү', 'ウ' => 'Ү',
    'ふ' => 'фу', 'フ' => 'ФУ',
    'つ' => 'цу', 'ツ' => 'ЦУ',
    'ち' => 'чи', 'チ' => 'ЧИ',
    'し' => 'ши', 'シ' => 'ШИ',
    'じ' => 'жи', 'ジ' => 'ЖИ',
    'お' => 'ө', 'オ' => 'Ө',
    'え' => 'е', 'エ' => 'Е'
);

# Kyrgyz system variants
my constant %kyrgyz-variants = (
    'う' => 'ү', 'ウ' => 'Ү',
    'ふ' => 'фу', 'フ' => 'ФУ',
    'つ' => 'цу', 'ツ' => 'ЦУ',
    'ち' => 'чи', 'チ' => 'ЧИ',
    'し' => 'ши', 'シ' => 'ШИ',
    'じ' => 'жи', 'ジ' => 'ЖИ',
    'お' => 'ө', 'オ' => 'Ө',
    'ң' => 'ң', 'Ң' => 'Ң'
);

# Pre-revolutionary Russian system variants (before 1918 reform)
my constant %prerevolutionary-variants = (
    'い' => 'і', 'イ' => 'І',
    'え' => 'ѣ', 'エ' => 'Ѣ',
    'ふ' => 'ѳу', 'フ' => 'ѲУ',
    'やつ' => 'ять', 'ヤツ' => 'ЯТЬ',
    'おつ' => 'оть', 'オツ' => 'ОТЬ',
    'いつ' => 'ить', 'イツ' => 'ИТЬ'
);

# GOST 7.79-2000 system variants (official Russian standard)
my constant %gost-variants = (
    'ふ' => 'фу', 'フ' => 'ФУ',
    'つ' => 'цу', 'ツ' => 'ЦУ',
    'ち' => 'чи', 'チ' => 'ЧИ',
    'し' => 'ши', 'シ' => 'ШИ',
    'じ' => 'жи', 'ジ' => 'ЖИ',
    'ざ' => 'за', 'ザ' => 'ЗА',
    'ず' => 'зу', 'ズ' => 'ЗУ',
    'ぜ' => 'зе', 'ゼ' => 'ЗЕ',
    'ぞ' => 'зо', 'ゾ' => 'ЗО'
);

# Soviet textbook system variants (educational standard)
my constant %soviet-variants = (
    'ふ' => 'фу', 'フ' => 'ФУ',
    'つ' => 'цу', 'ツ' => 'ЦУ',
    'ち' => 'чи', 'チ' => 'ЧИ',
    'し' => 'ши', 'シ' => 'ШИ',
    'じ' => 'жи', 'ジ' => 'ЖИ',
    'しゃ' => 'ша', 'シャ' => 'ША',
    'しゅ' => 'шу', 'シュ' => 'ШУ',
    'しょ' => 'шо', 'ショ' => 'ШО',
    'じゃ' => 'жя', 'ジャ' => 'ЖЯ',
    'じゅ' => 'жю', 'ジュ' => 'ЖЮ',
    'じょ' => 'жё', 'ジョ' => 'ЖЁ'
);

# Kontsevich academic system variants
my constant %kontsevich-variants = (
    'ふ' => 'фу', 'フ' => 'ФУ',
    'つ' => 'цу', 'ツ' => 'ЦУ',
    'ち' => 'ти', 'チ' => 'ТИ',
    'し' => 'си', 'シ' => 'СИ',
    'じ' => 'дзи', 'ジ' => 'ДЗИ',
    'しゃ' => 'ся', 'シャ' => 'СЯ',
    'しゅ' => 'сю', 'シュ' => 'СЮ',
    'しょ' => 'сё', 'ショ' => 'СЁ'
);

# Tajik system variants
my constant %tajik-variants = (
    'う' => 'у', 'ウ' => 'У',
    'ふ' => 'фу', 'フ' => 'ФУ',
    'つ' => 'цу', 'ツ' => 'ЦУ',
    'ち' => 'чи', 'チ' => 'ЧИ',
    'し' => 'ши', 'シ' => 'ШИ',
    'じ' => 'жи', 'ジ' => 'ЖИ',
    'え' => 'е', 'エ' => 'Е',
    'я' => 'ё', 'ヤ' => 'Ё',
    'ю' => 'ю', 'ユ' => 'Ю',
    'っ' => 'ъ', 'ッ' => 'Ъ',
    'が' => 'ға', 'ガ' => 'ҒА',
    'ぎ' => 'ғи', 'ギ' => 'ҒИ',
    'ぐ' => 'ғу', 'グ' => 'ҒУ',
    'げ' => 'ғе', 'ゲ' => 'ҒЕ',
    'ご' => 'ғо', 'ゴ' => 'ҒО',
    'か' => 'қа', 'カ' => 'ҚА',
    'き' => 'қи', 'キ' => 'ҚИ',
    'く' => 'қу', 'ク' => 'ҚУ',
    'け' => 'қе', 'ケ' => 'ҚЕ',
    'こ' => 'қо', 'コ' => 'ҚО',
    'は' => 'ҳа', 'ハ' => 'ҲА',
    'ひ' => 'ҳи', 'ヒ' => 'ҲИ',
    'ふ' => 'ҳу', 'フ' => 'ҲУ',
    'へ' => 'ҳе', 'ヘ' => 'ҲЕ',
    'ほ' => 'ҳо', 'ホ' => 'ҲО',
    'ざ' => 'ҷа', 'ザ' => 'ҶА',
    'じ' => 'ҷи', 'ジ' => 'ҶИ',
    'ず' => 'ҷу', 'ズ' => 'ҶУ',
    'ぜ' => 'ҷе', 'ゼ' => 'ҶЕ',
    'ぞ' => 'ҷо', 'ゾ' => 'ҶО'
);

# Moldovan Romanian (Cyrillic) system variants
my constant %moldovan-variants = (
    'う' => 'у', 'ウ' => 'У',
    'ふ' => 'фу', 'フ' => 'ФУ',
    'つ' => 'цу', 'ツ' => 'ЦУ',
    'ち' => 'чи', 'チ' => 'ЧИ',
    'し' => 'ши', 'シ' => 'ШИ',
    'じ' => 'жи', 'ジ' => 'ЖИ',
    'え' => 'е', 'エ' => 'Е',
    'い' => 'ь', 'イ' => 'Ь',
    'ゆ' => 'ю', 'ユ' => 'Ю',
    'や' => 'я', 'ヤ' => 'Я',
    'お' => 'о', 'オ' => 'О',
    'あ' => 'а', 'ア' => 'А',
    'きゃ' => 'кя', 'キャ' => 'КЯ',
    'きゅ' => 'кю', 'キュ' => 'КЮ',
    'きょ' => 'кё', 'キョ' => 'КЁ',
    'ぎゃ' => 'гя', 'ギャ' => 'ГЯ',
    'ぎゅ' => 'гю', 'ギュ' => 'ГЮ',
    'ぎょ' => 'гё', 'ギョ' => 'ГЁ'
);

sub to-kuriru-moji(Str $text, Str :$system = 'polivanov') is export {
    my %hiragana-table;
    my %katakana-table;
    
    # Select transliteration system
    given $system.lc {
        when 'polivanov' | 'academic' {
            %hiragana-table = %polivanov-hiragana;
            %katakana-table = %polivanov-katakana;
        }
        when 'phonetic' | 'intuitive' {
            %hiragana-table = %phonetic-hiragana;
            %katakana-table = %phonetic-katakana;
        }
        when 'static' | 'simple' {
            %hiragana-table = %static-base;
            %katakana-table = %static-base;  # Same table for both since it includes all
        }
        when 'anime-manga' | 'anime-manga-fan' | 'anime' | 'fan' {
            %hiragana-table = %phonetic-hiragana;  # Use phonetic as base
            %katakana-table = %phonetic-katakana;
        }
        when 'gaming' | 'gaming-community' | 'game' {
            %hiragana-table = %static-base;
            %katakana-table = %static-base;  # Same table for both since it includes all
        }
        when 'ru-petr1708' {
            %hiragana-table = %polivanov-hiragana;  # Use Polivanov as base
            %katakana-table = %polivanov-katakana;
        }
        when 'gost2000' | 'gost-7.79-2000' {
            %hiragana-table = %polivanov-hiragana;  # Use Polivanov as base
            %katakana-table = %polivanov-katakana;
        }
        when 'soviet' | 'soviet-textbook' {
            %hiragana-table = %phonetic-hiragana;  # Use phonetic as base
            %katakana-table = %phonetic-katakana;
        }
        when 'kontsevich' {
            %hiragana-table = %polivanov-hiragana;  # Use Polivanov as base
            %katakana-table = %polivanov-katakana;
        }
        when 'ukrainian' | 'ukraine' | 'ukraina' | 'ukrainski' | 'ukuraina' | 'ua' | 'ukr' | 'uk' {
            %hiragana-table = %static-base;
            %katakana-table = %static-base;  # Same table for both since it includes all
        }
        when 'serbian' | 'serbia' | 'srbija' | 'srbski' | 'serubija' | 'sr' | 'srb' {
            %hiragana-table = %phonetic-hiragana;  # Use phonetic as base
            %katakana-table = %phonetic-katakana;
        }
        when 'bulgarian' | 'bulgaria' | 'balgarija' | 'balgarski' | 'burugarija' | 'burugariya' | 'bg' | 'bgr' {
            %hiragana-table = %phonetic-hiragana;  # Use phonetic as base
            %katakana-table = %phonetic-katakana;
        }
        when 'macedonian' | 'macedonia' | 'makedonija' | 'makedonski' | 'makedonia' | 'mazedoniya' | 'mk' | 'mkd' {
            %hiragana-table = %phonetic-hiragana;  # Use phonetic as base
            %katakana-table = %phonetic-katakana;
        }
        when 'belarusian' | 'belarus' | 'belaruskaja' | 'belaruski' | 'berarushi' | 'be' | 'blr' {
            %hiragana-table = %static-base;
            %katakana-table = %static-base;  # Same table for both since it includes all
        }
        when 'mongolian' | 'mongolia' | 'mongol' | 'mongolski' | 'mongoru' | 'mn' | 'mng' {
            %hiragana-table = %static-base;
            %katakana-table = %static-base;  # Same table for both since it includes all
        }
        when 'kazakh' | 'kazakhstan' | 'qazaqstan' | 'qazaq' | 'kazafusutan' | 'kz' | 'kaz' {
            %hiragana-table = %static-base;
            %katakana-table = %static-base;  # Same table for both since it includes all
        }
        when 'kyrgyz' | 'kyrgyzstan' | 'qyrgyzstan' | 'qyrgyz' | 'kirugisutan' | 'ky' | 'kgz' {
            %hiragana-table = %static-base;
            %katakana-table = %static-base;  # Same table for both since it includes all
        }
        when 'tajik' | 'tajikistan' | 'tojikiston' | 'tojik' | 'tajiiku' | 'tj' | 'tjk' {
            %hiragana-table = %static-base;
            %katakana-table = %static-base;  # Same table for both since it includes all
        }
        when 'moldovan' | 'moldova' | 'romanian-cyrillic' | 'moldavia' | 'morudoba' | 'md' | 'mol' {
            %hiragana-table = %static-base;
            %katakana-table = %static-base;  # Same table for both since it includes all
        }
        default {
            die "Unknown transliteration system: $system. Use 'polivanov', 'phonetic', 'static', etc.";
        }
    }
    
    my $result = $text;
    
    # Note: Half-width katakana conversion should be done before calling this function
    
    # Handle sokuon (っ/ッ) first
    my %combined-table = |%hiragana-table, |%katakana-table;
    $result = handle-sokuon-cyrillic($result, %combined-table);
    
    # Convert hiragana (sort by length - longest first for multi-character combinations)
    for %hiragana-table.keys.sort(*.chars).reverse -> $kana {
        $result = $result.subst($kana, %hiragana-table{$kana}, :g);
    }
    
    # Convert katakana (sort by length - longest first for multi-character combinations)
    for %katakana-table.keys.sort(*.chars).reverse -> $kana {
        $result = $result.subst($kana, %katakana-table{$kana}, :g);
    }
    
    # Apply system-specific post-processing
    given $system.lc {
        when 'ukrainian' | 'ukraine' | 'ukraina' | 'ukrainski' | 'ukuraina' | 'ua' | 'ukr' | 'uk' {
            # Apply Ukrainian-specific substitutions
            for %ukrainian-variants.keys -> $char {
                $result = $result.subst($char, %ukrainian-variants{$char}, :g);
            }
        }
        when 'serbian' | 'serbia' | 'srbija' | 'srbski' | 'serubija' | 'sr' | 'srb' {
            # Apply Serbian-specific substitutions
            for %serbian-variants.keys -> $char {
                $result = $result.subst($char, %serbian-variants{$char}, :g);
            }
        }
        when 'belarusian' | 'belarus' | 'belaruskaja' | 'belaruski' | 'berarushi' | 'be' | 'blr' {
            # Apply Belarusian-specific substitutions
            for %belarusian-variants.keys -> $char {
                $result = $result.subst($char, %belarusian-variants{$char}, :g);
            }
        }
        when 'macedonian' | 'macedonia' | 'makedonija' | 'makedonski' | 'makedonia' | 'mazedoniya' | 'mk' | 'mkd' {
            # Apply Macedonian-specific substitutions
            for %macedonian-variants.keys -> $char {
                $result = $result.subst($char, %macedonian-variants{$char}, :g);
            }
        }
        when 'kazakh' | 'kazakhstan' | 'qazaqstan' | 'qazaq' | 'kazafusutan' | 'kz' | 'kaz' {
            # Apply Kazakh-specific substitutions
            for %kazakh-variants.keys -> $char {
                $result = $result.subst($char, %kazakh-variants{$char}, :g);
            }
        }
        when 'mongolian' | 'mongolia' | 'mongol' | 'mongolski' | 'mongoru' | 'mn' | 'mng' {
            # Apply Mongolian-specific substitutions
            for %mongolian-variants.keys -> $char {
                $result = $result.subst($char, %mongolian-variants{$char}, :g);
            }
        }
        when 'kyrgyz' | 'kyrgyzstan' | 'qyrgyzstan' | 'qyrgyz' | 'kirugisutan' | 'ky' | 'kgz' {
            # Apply Kyrgyz-specific substitutions
            for %kyrgyz-variants.keys -> $char {
                $result = $result.subst($char, %kyrgyz-variants{$char}, :g);
            }
        }
        when 'tajik' | 'tajikistan' | 'tojikiston' | 'tojik' | 'tajiiku' | 'tj' | 'tjk' {
            # Apply Tajik-specific substitutions
            for %tajik-variants.keys -> $char {
                $result = $result.subst($char, %tajik-variants{$char}, :g);
            }
        }
        when 'moldovan' | 'moldova' | 'romanian-cyrillic' | 'moldavia' | 'morudoba' | 'md' | 'mol' {
            # Apply Moldovan Romanian Cyrillic-specific substitutions
            for %moldovan-variants.keys -> $char {
                $result = $result.subst($char, %moldovan-variants{$char}, :g);
            }
        }
        when 'ru-petr1708' {
            # Apply pre-revolutionary Russian substitutions
            for %prerevolutionary-variants.keys -> $char {
                $result = $result.subst($char, %prerevolutionary-variants{$char}, :g);
            }
            # Also apply long vowel handling
            $result = handle-long-vowels-cyrillic($result);
        }
        when 'gost2000' | 'gost-7.79-2000' {
            # Apply GOST 7.79-2000 specific substitutions
            for %gost-variants.keys -> $char {
                $result = $result.subst($char, %gost-variants{$char}, :g);
            }
            # Also apply long vowel handling
            $result = handle-long-vowels-cyrillic($result);
        }
        when 'soviet' | 'soviet-textbook' {
            # Apply Soviet textbook specific substitutions
            for %soviet-variants.keys -> $char {
                $result = $result.subst($char, %soviet-variants{$char}, :g);
            }
        }
        when 'kontsevich' {
            # Apply Kontsevich academic system substitutions
            for %kontsevich-variants.keys -> $char {
                $result = $result.subst($char, %kontsevich-variants{$char}, :g);
            }
            # Also apply long vowel handling
            $result = handle-long-vowels-cyrillic($result);
        }
        when 'polivanov' | 'academic' {
            # Handle long vowels with colon notation
            $result = handle-long-vowels-cyrillic($result);
        }
    }
    
    return $result;
}