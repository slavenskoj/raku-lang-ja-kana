=begin pod

=head1 NAME

Lang::JA::Kana - A comprehensive Raku module for converting between Hiragana and Katakana

=head1 SYNOPSIS

=begin code :lang<raku>

use Lang::JA::Kana;

# Basic conversions
say Katakana "こんにちは";  # Output: コンニチハ
say Hiragana "コンニチハ";  # Output: こんにちは

# Half-width katakana support
say to-fullwidth-katakana("ｶﾞｷﾞｸﾞ");  # Output: ガギグ
say to-halfwidth-katakana("ガギグ");     # Output: ｶﾞｷﾞｸﾞ

# Historical kana support
say hentaigana-to-hiragana("𛀁𛀂𛀃");  # Output: あいう

=end code

=head1 DESCRIPTION

Lang::JA::Kana provides comprehensive conversion between Hiragana and Katakana scripts,
including modern, historical, and half-width forms. The module supports all standard
kana characters plus historical variants (Hentaigana), obsolete characters, and
modern extensions for foreign sounds.

=head1 AUTHOR

Danslav Slavenskoj

=head1 COPYRIGHT AND LICENSE

Copyright 2025 Danslav Slavenskoj

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

unit module Lang::JA::Kana;

my constant %hiragana-to-katakana = (
    # Modern Hiragana
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
    
    # Small kana
    'ゃ' => 'ャ', 'ゅ' => 'ュ', 'ょ' => 'ョ',
    'っ' => 'ッ',
    'ぁ' => 'ァ', 'ぃ' => 'ィ', 'ぅ' => 'ゥ', 'ぇ' => 'ェ', 'ぉ' => 'ォ',
    'ゎ' => 'ヮ',
    
    # Marks
    'ー' => 'ー',
    '゛' => '゛', '゜' => '゜',
    
    # Obsolete/Historical Hiragana
    'ゟ' => 'ヿ',  # Hiragana/Katakana Digraph Yori
    'ゐ' => 'ヰ',  # WI (already included above but emphasizing it's obsolete)
    'ゑ' => 'ヱ',  # WE (already included above but emphasizing it's obsolete)
    'ゔ' => 'ヴ',  # VU
    
    # Hentaigana variants (some common ones)
    '𛀁' => '𛄁',  # Hentaigana A variant
    '𛀂' => '𛄂',  # Hentaigana I variant
    '𛀃' => '𛄃',  # Hentaigana U variant
    '𛀄' => '𛄄',  # Hentaigana E variant
    '𛀅' => '𛄅',  # Hentaigana O variant
    '𛀆' => '𛄆',  # Hentaigana KA variant
    '𛀇' => '𛄇',  # Hentaigana GA variant
    '𛀈' => '𛄈',  # Hentaigana KI variant
    '𛀉' => '𛄉',  # Hentaigana GI variant
    '𛀊' => '𛄊',  # Hentaigana KU variant
    '𛀋' => '𛄋',  # Hentaigana GU variant
    '𛀌' => '𛄌',  # Hentaigana KE variant
    '𛀍' => '𛄍',  # Hentaigana GE variant
    '𛀎' => '𛄎',  # Hentaigana KO variant
    '𛀏' => '𛄏',  # Hentaigana GO variant
    '𛀐' => '𛄐',  # Hentaigana SA variant
    '𛀑' => '𛄑',  # Hentaigana ZA variant
    '𛀒' => '𛄒',  # Hentaigana SI variant
    '𛀓' => '𛄓',  # Hentaigana ZI variant
    '𛀔' => '𛄔',  # Hentaigana SU variant
    '𛀕' => '𛄕',  # Hentaigana ZU variant
    '𛀖' => '𛄖',  # Hentaigana SE variant
    '𛀗' => '𛄗',  # Hentaigana ZE variant
    '𛀘' => '𛄘',  # Hentaigana SO variant
    '𛀙' => '𛄙',  # Hentaigana ZO variant
    '𛀚' => '𛄚',  # Hentaigana TA variant
    '𛀛' => '𛄛',  # Hentaigana DA variant
    '𛀜' => '𛄜',  # Hentaigana TI variant
    '𛀝' => '𛄝',  # Hentaigana DI variant
    '𛀞' => '𛄞',  # Hentaigana TU variant
    '𛀟' => '𛄟',  # Hentaigana DU variant
    '𛀠' => '𛄠',  # Hentaigana TE variant
    '𛀡' => '𛄡',  # Hentaigana DE variant
    '𛀢' => '𛄢',  # Hentaigana TO variant
    '𛀣' => '𛄣',  # Hentaigana DO variant
    '𛀤' => '𛄤',  # Hentaigana NA variant
    '𛀥' => '𛄥',  # Hentaigana NI variant
    '𛀦' => '𛄦',  # Hentaigana NU variant
    '𛀧' => '𛄧',  # Hentaigana NE variant
    '𛀨' => '𛄨',  # Hentaigana NO variant
    '𛀩' => '𛄩',  # Hentaigana HA variant
    '𛀪' => '𛄪',  # Hentaigana BA variant
    '𛀫' => '𛄫',  # Hentaigana PA variant
    '𛀬' => '𛄬',  # Hentaigana HI variant
    '𛀭' => '𛄭',  # Hentaigana BI variant
    '𛀮' => '𛄮',  # Hentaigana PI variant
    '𛀯' => '𛄯',  # Hentaigana HU variant
    '𛀰' => '𛄰',  # Hentaigana BU variant
    '𛀱' => '𛄱',  # Hentaigana PU variant
    '𛀲' => '𛄲',  # Hentaigana HE variant
    '𛀳' => '𛄳',  # Hentaigana BE variant
    '𛀴' => '𛄴',  # Hentaigana PE variant
    '𛀵' => '𛄵',  # Hentaigana HO variant
    '𛀶' => '𛄶',  # Hentaigana BO variant
    '𛀷' => '𛄷',  # Hentaigana PO variant
    '𛀸' => '𛄸',  # Hentaigana MA variant
    '𛀹' => '𛄹',  # Hentaigana MI variant
    '𛀺' => '𛄺',  # Hentaigana MU variant
    '𛀻' => '𛄻',  # Hentaigana ME variant
    '𛀼' => '𛄼',  # Hentaigana MO variant
    '𛀽' => '𛄽',  # Hentaigana YA variant
    '𛀾' => '𛄾',  # Hentaigana YU variant
    '𛀿' => '𛄿',  # Hentaigana YO variant
    '𛁀' => '𛅀',  # Hentaigana RA variant
    '𛁁' => '𛅁',  # Hentaigana RI variant
    '𛁂' => '𛅂',  # Hentaigana RU variant
    '𛁃' => '𛅃',  # Hentaigana RE variant
    '𛁄' => '𛅄',  # Hentaigana RO variant
    '𛁅' => '𛅅',  # Hentaigana WA variant
    '𛁆' => '𛅆',  # Hentaigana WI variant
    '𛁇' => '𛅇',  # Hentaigana WE variant
    '𛁈' => '𛅈',  # Hentaigana WO variant
    '𛁉' => '𛅉',  # Hentaigana N variant
    
    # Combinations with historical kana
    'きゃ' => 'キャ', 'きゅ' => 'キュ', 'きょ' => 'キョ',
    'しゃ' => 'シャ', 'しゅ' => 'シュ', 'しょ' => 'ショ',
    'ちゃ' => 'チャ', 'ちゅ' => 'チュ', 'ちょ' => 'チョ',
    'にゃ' => 'ニャ', 'にゅ' => 'ニュ', 'にょ' => 'ニョ',
    'ひゃ' => 'ヒャ', 'ひゅ' => 'ヒュ', 'ひょ' => 'ヒョ',
    'みゃ' => 'ミャ', 'みゅ' => 'ミュ', 'みょ' => 'ミョ',
    'りゃ' => 'リャ', 'りゅ' => 'リュ', 'りょ' => 'リョ',
    'ぎゃ' => 'ギャ', 'ぎゅ' => 'ギュ', 'ぎょ' => 'ギョ',
    'じゃ' => 'ジャ', 'じゅ' => 'ジュ', 'じょ' => 'ジョ',
    'びゃ' => 'ビャ', 'びゅ' => 'ビュ', 'びょ' => 'ビョ',
    'ぴゃ' => 'ピャ', 'ぴゅ' => 'ピュ', 'ぴょ' => 'ピョ',
    
    # More modern extensions
    'ふぁ' => 'ファ', 'ふぃ' => 'フィ', 'ふぇ' => 'フェ', 'ふぉ' => 'フォ',
    'てぃ' => 'ティ', 'でぃ' => 'ディ', 'とぅ' => 'トゥ', 'どぅ' => 'ドゥ',
    'うぃ' => 'ウィ', 'うぇ' => 'ウェ', 'うぉ' => 'ウォ',
    'ゔぁ' => 'ヴァ', 'ゔぃ' => 'ヴィ', 'ゔぇ' => 'ヴェ', 'ゔぉ' => 'ヴォ',
    'くぁ' => 'クァ', 'くぃ' => 'クィ', 'くぇ' => 'クェ', 'くぉ' => 'クォ',
    'ぐぁ' => 'グァ', 'ぐぃ' => 'グィ', 'ぐぇ' => 'グェ', 'ぐぉ' => 'グォ',
    'つぁ' => 'ツァ', 'つぃ' => 'ツィ', 'つぇ' => 'ツェ', 'つぉ' => 'ツォ',
    'ちぇ' => 'チェ', 'じぇ' => 'ジェ', 'しぇ' => 'シェ', 'いぇ' => 'イェ'
);

my constant %katakana-to-hiragana = %hiragana-to-katakana.antipairs.Hash;

# Half-width to full-width Katakana conversion table
my constant %halfwidth-to-fullwidth-katakana = (
    # Basic Katakana vowels
    'ｱ' => 'ア', 'ｲ' => 'イ', 'ｳ' => 'ウ', 'ｴ' => 'エ', 'ｵ' => 'オ',
    # K-series
    'ｶ' => 'カ', 'ｷ' => 'キ', 'ｸ' => 'ク', 'ｹ' => 'ケ', 'ｺ' => 'コ',
    # S-series
    'ｻ' => 'サ', 'ｼ' => 'シ', 'ｽ' => 'ス', 'ｾ' => 'セ', 'ｿ' => 'ソ',
    # T-series
    'ﾀ' => 'タ', 'ﾁ' => 'チ', 'ﾂ' => 'ツ', 'ﾃ' => 'テ', 'ﾄ' => 'ト',
    # N-series
    'ﾅ' => 'ナ', 'ﾆ' => 'ニ', 'ﾇ' => 'ヌ', 'ﾈ' => 'ネ', 'ﾉ' => 'ノ',
    # H-series
    'ﾊ' => 'ハ', 'ﾋ' => 'ヒ', 'ﾌ' => 'フ', 'ﾍ' => 'ヘ', 'ﾎ' => 'ホ',
    # M-series
    'ﾏ' => 'マ', 'ﾐ' => 'ミ', 'ﾑ' => 'ム', 'ﾒ' => 'メ', 'ﾓ' => 'モ',
    # Y-series
    'ﾔ' => 'ヤ', 'ﾕ' => 'ユ', 'ﾖ' => 'ヨ',
    # R-series
    'ﾗ' => 'ラ', 'ﾘ' => 'リ', 'ﾙ' => 'ル', 'ﾚ' => 'レ', 'ﾛ' => 'ロ',
    # W-series and N
    'ﾜ' => 'ワ', 'ｦ' => 'ヲ', 'ﾝ' => 'ン',
    # Small katakana
    'ｧ' => 'ァ', 'ｨ' => 'ィ', 'ｩ' => 'ゥ', 'ｪ' => 'ェ', 'ｫ' => 'ォ',
    'ｬ' => 'ャ', 'ｭ' => 'ュ', 'ｮ' => 'ョ', 'ｯ' => 'ッ',
    
    # Voiced combinations using Unicode escapes
    "\x[FF76]\x[FF9E]" => 'ガ', "\x[FF77]\x[FF9E]" => 'ギ', "\x[FF78]\x[FF9E]" => 'グ', "\x[FF79]\x[FF9E]" => 'ゲ', "\x[FF7A]\x[FF9E]" => 'ゴ',
    "\x[FF7B]\x[FF9E]" => 'ザ', "\x[FF7C]\x[FF9E]" => 'ジ', "\x[FF7D]\x[FF9E]" => 'ズ', "\x[FF7E]\x[FF9E]" => 'ゼ', "\x[FF7F]\x[FF9E]" => 'ゾ',
    "\x[FF80]\x[FF9E]" => 'ダ', "\x[FF81]\x[FF9E]" => 'ヂ', "\x[FF82]\x[FF9E]" => 'ヅ', "\x[FF83]\x[FF9E]" => 'デ', "\x[FF84]\x[FF9E]" => 'ド',
    "\x[FF8A]\x[FF9E]" => 'バ', "\x[FF8B]\x[FF9E]" => 'ビ', "\x[FF8C]\x[FF9E]" => 'ブ', "\x[FF8D]\x[FF9E]" => 'ベ', "\x[FF8E]\x[FF9E]" => 'ボ',
    "\x[FF73]\x[FF9E]" => 'ヴ',
    
    # Semi-voiced combinations using Unicode escapes
    "\x[FF8A]\x[FF9F]" => 'パ', "\x[FF8B]\x[FF9F]" => 'ピ', "\x[FF8C]\x[FF9F]" => 'プ', "\x[FF8D]\x[FF9F]" => 'ペ', "\x[FF8E]\x[FF9F]" => 'ポ',
    
    # Sound marks using Unicode escapes
    "\x[FF9E]" => '゛', "\x[FF9F]" => '゜',
    
    # Punctuation using Unicode escapes
    "\x[FF61]" => '。', "\x[FF64]" => '、', "\x[FF62]" => '「', "\x[FF63]" => '」', "\x[FF70]" => 'ー'
);

# Full-width to half-width Katakana conversion table
my constant %fullwidth-to-halfwidth-katakana = %halfwidth-to-fullwidth-katakana.antipairs.Hash;

sub to-fullwidth-katakana(Str $text) is export {
    my $result = $text;
    
    # Sort by length (longest first) to handle multi-character combinations first
    for %halfwidth-to-fullwidth-katakana.keys.sort(*.chars).reverse -> $halfwidth {
        $result = $result.subst($halfwidth, %halfwidth-to-fullwidth-katakana{$halfwidth}, :g);
    }
    
    return $result;
}

sub to-halfwidth-katakana(Str $text) is export {
    my $result = $text;
    
    # Sort by length (longest first) to handle multi-character combinations first
    for %fullwidth-to-halfwidth-katakana.keys.sort(*.chars).reverse -> $fullwidth {
        $result = $result.subst($fullwidth, %fullwidth-to-halfwidth-katakana{$fullwidth}, :g);
    }
    
    return $result;
}

# Hentaigana to Hiragana conversion table with multiple interpretations
my constant %hentaigana-to-hiragana = (
    # Basic vowels
    '𛀁' => ['あ'],           # Hentaigana A variant (from 安)
    '𛀂' => ['い'],           # Hentaigana I variant (from 以)
    '𛀃' => ['う'],           # Hentaigana U variant (from 宇)
    '𛀄' => ['え'],           # Hentaigana E variant (from 衣)
    '𛀅' => ['お'],           # Hentaigana O variant (from 於)
    
    # K-series
    '𛀆' => ['か'],           # Hentaigana KA variant (from 加)
    '𛀇' => ['が'],           # Hentaigana GA variant
    '𛀈' => ['き'],           # Hentaigana KI variant (from 幾)
    '𛀉' => ['ぎ'],           # Hentaigana GI variant
    '𛀊' => ['く'],           # Hentaigana KU variant (from 久)
    '𛀋' => ['ぐ'],           # Hentaigana GU variant
    '𛀌' => ['け'],           # Hentaigana KE variant (from 計)
    '𛀍' => ['げ'],           # Hentaigana GE variant
    '𛀎' => ['こ'],           # Hentaigana KO variant (from 己)
    '𛀏' => ['ご'],           # Hentaigana GO variant
    
    # S-series with multiple readings
    '𛀐' => ['さ'],           # Hentaigana SA variant (from 左)
    '𛀑' => ['ざ'],           # Hentaigana ZA variant
    '𛀒' => ['し', 'せ'],     # Hentaigana SI variant (from 之) - can be read as shi or se
    '𛀓' => ['じ', 'ぜ'],     # Hentaigana ZI variant - can be read as ji or ze
    '𛀔' => ['す'],           # Hentaigana SU variant (from 寸)
    '𛀕' => ['ず'],           # Hentaigana ZU variant
    '𛀖' => ['せ', 'し'],     # Hentaigana SE variant (from 世) - can be read as se or shi
    '𛀗' => ['ぜ', 'じ'],     # Hentaigana ZE variant - can be read as ze or ji
    '𛀘' => ['そ'],           # Hentaigana SO variant (from 曽)
    '𛀙' => ['ぞ'],           # Hentaigana ZO variant
    
    # T-series
    '𛀚' => ['た'],           # Hentaigana TA variant (from 太)
    '𛀛' => ['だ'],           # Hentaigana DA variant
    '𛀜' => ['ち'],           # Hentaigana TI variant (from 知)
    '𛀝' => ['ぢ'],           # Hentaigana DI variant
    '𛀞' => ['つ'],           # Hentaigana TU variant (from 川)
    '𛀟' => ['づ'],           # Hentaigana DU variant
    '𛀠' => ['て'],           # Hentaigana TE variant (from 天)
    '𛀡' => ['で'],           # Hentaigana DE variant
    '𛀢' => ['と'],           # Hentaigana TO variant (from 止)
    '𛀣' => ['ど'],           # Hentaigana DO variant
    
    # N-series
    '𛀤' => ['な'],           # Hentaigana NA variant (from 奈)
    '𛀥' => ['に'],           # Hentaigana NI variant (from 仁)
    '𛀦' => ['ぬ'],           # Hentaigana NU variant (from 奴)
    '𛀧' => ['ね'],           # Hentaigana NE variant (from 祢)
    '𛀨' => ['の'],           # Hentaigana NO variant (from 乃)
    
    # H-series
    '𛀩' => ['は'],           # Hentaigana HA variant (from 波)
    '𛀪' => ['ば'],           # Hentaigana BA variant
    '𛀫' => ['ぱ'],           # Hentaigana PA variant
    '𛀬' => ['ひ'],           # Hentaigana HI variant (from 比)
    '𛀭' => ['び'],           # Hentaigana BI variant
    '𛀮' => ['ぴ'],           # Hentaigana PI variant
    '𛀯' => ['ふ'],           # Hentaigana HU variant (from 不)
    '𛀰' => ['ぶ'],           # Hentaigana BU variant
    '𛀱' => ['ぷ'],           # Hentaigana PU variant
    '𛀲' => ['へ'],           # Hentaigana HE variant (from 部)
    '𛀳' => ['べ'],           # Hentaigana BE variant
    '𛀴' => ['ぺ'],           # Hentaigana PE variant
    '𛀵' => ['ほ'],           # Hentaigana HO variant (from 保)
    '𛀶' => ['ぼ'],           # Hentaigana BO variant
    '𛀷' => ['ぽ'],           # Hentaigana PO variant
    
    # M-series
    '𛀸' => ['ま'],           # Hentaigana MA variant (from 万)
    '𛀹' => ['み'],           # Hentaigana MI variant (from 美)
    '𛀺' => ['む'],           # Hentaigana MU variant (from 武)
    '𛀻' => ['め'],           # Hentaigana ME variant (from 女)
    '𛀼' => ['も'],           # Hentaigana MO variant (from 毛)
    
    # Y-series
    '𛀽' => ['や'],           # Hentaigana YA variant (from 也)
    '𛀾' => ['ゆ'],           # Hentaigana YU variant (from 由)
    '𛀿' => ['よ'],           # Hentaigana YO variant (from 与)
    
    # R-series
    '𛁀' => ['ら'],           # Hentaigana RA variant (from 良)
    '𛁁' => ['り'],           # Hentaigana RI variant (from 利)
    '𛁂' => ['る'],           # Hentaigana RU variant (from 留)
    '𛁃' => ['れ'],           # Hentaigana RE variant (from 礼)
    '𛁄' => ['ろ'],           # Hentaigana RO variant (from 呂)
    
    # W-series (historical)
    '𛁅' => ['わ'],           # Hentaigana WA variant (from 和)
    '𛁆' => ['ゐ', 'い'],     # Hentaigana WI variant - can be read as wi or i
    '𛁇' => ['ゑ', 'え'],     # Hentaigana WE variant - can be read as we or e
    '𛁈' => ['を', 'お'],     # Hentaigana WO variant - can be read as wo or o
    
    # N
    '𛁉' => ['ん'],           # Hentaigana N variant (from 无)
    
    # Additional variants with multiple readings
    '𛂚' => ['こ', 'き'],     # Hentaigana variant that can be ko or ki
    '𛂛' => ['は', 'ほ'],     # Hentaigana variant that can be ha or ho
    '𛂜' => ['も', 'む'],     # Hentaigana variant that can be mo or mu
    '𛂝' => ['よ', 'ろ'],     # Hentaigana variant that can be yo or ro
    '𛂞' => ['つ', 'て'],     # Hentaigana variant that can be tsu or te
    '𛂟' => ['り', 'ら'],     # Hentaigana variant that can be ri or ra
    '𛂠' => ['ね', 'な'],     # Hentaigana variant that can be ne or na
    '𛂡' => ['し', 'す'],     # Hentaigana variant that can be shi or su
    '𛂢' => ['ゑ', 'へ'],     # Hentaigana variant that can be we or he
    '𛂣' => ['ゐ', 'ひ'],     # Hentaigana variant that can be wi or hi
    '𛂤' => ['を', 'ほ'],     # Hentaigana variant that can be wo or ho
    '𛂥' => ['か', 'が'],     # Hentaigana variant that can be ka or ga
    '𛂦' => ['き', 'ぎ'],     # Hentaigana variant that can be ki or gi
    '𛂧' => ['く', 'ぐ'],     # Hentaigana variant that can be ku or gu
    '𛂨' => ['け', 'げ'],     # Hentaigana variant that can be ke or ge
    '𛂩' => ['さ', 'ざ'],     # Hentaigana variant that can be sa or za
    '𛂪' => ['た', 'だ'],     # Hentaigana variant that can be ta or da
    '𛂫' => ['ち', 'ぢ'],     # Hentaigana variant that can be chi or di
    '𛂬' => ['ふ', 'ぶ', 'ぷ'], # Hentaigana variant that can be fu, bu, or pu
    '𛂭' => ['へ', 'べ', 'ぺ'], # Hentaigana variant that can be he, be, or pe
    '𛂮' => ['ま', 'み'],     # Hentaigana variant that can be ma or mi
    '𛂯' => ['む', 'め'],     # Hentaigana variant that can be mu or me
);

sub to-hiragana(Str $text) is export {
    my $result = $text;
    
    # First convert half-width katakana to full-width katakana
    $result = to-fullwidth-katakana($result);
    
    # Then convert katakana to hiragana
    for %katakana-to-hiragana.keys.sort(*.chars).reverse -> $katakana {
        $result = $result.subst($katakana, %katakana-to-hiragana{$katakana}, :g);
    }
    
    return $result;
}

sub to-katakana(Str $text) is export {
    my $result = $text;
    
    for %hiragana-to-katakana.keys.sort(*.chars).reverse -> $hiragana {
        $result = $result.subst($hiragana, %hiragana-to-katakana{$hiragana}, :g);
    }
    
    return $result;
}


# Sound mark splitting tables
my constant %voiced-to-base = (
    'が' => 'か', 'ぎ' => 'き', 'ぐ' => 'く', 'げ' => 'け', 'ご' => 'こ',
    'ざ' => 'さ', 'じ' => 'し', 'ず' => 'す', 'ぜ' => 'せ', 'ぞ' => 'そ',
    'だ' => 'た', 'ぢ' => 'ち', 'づ' => 'つ', 'で' => 'て', 'ど' => 'と',
    'ば' => 'は', 'び' => 'ひ', 'ぶ' => 'ふ', 'べ' => 'へ', 'ぼ' => 'ほ',
    'ゔ' => 'う'
);

my constant %semi-voiced-to-base = (
    'ぱ' => 'は', 'ぴ' => 'ひ', 'ぷ' => 'ふ', 'ぺ' => 'へ', 'ぽ' => 'ほ'
);

sub split-sound-marks(Str $char) is export {
    if %voiced-to-base{$char}:exists {
        return (%voiced-to-base{$char}, '゛');
    } elsif %semi-voiced-to-base{$char}:exists {
        return (%semi-voiced-to-base{$char}, '゜');
    } else {
        return ($char,);
    }
}

# Hiragana to Hentaigana conversion table with multiple variants
my constant %hiragana-to-hentaigana = (
    # Basic vowels
    'あ' => ['𛀁', '𛄀', '𛄁'],  # Multiple hentaigana variants for A
    'い' => ['𛀂', '𛄂'],        # Multiple hentaigana variants for I
    'う' => ['𛀃', '𛄃'],        # Multiple hentaigana variants for U
    'え' => ['𛀄', '𛄄'],        # Multiple hentaigana variants for E
    'お' => ['𛀅', '𛄅'],        # Multiple hentaigana variants for O
    
    # K-series
    'か' => ['𛀆', '𛂥'],        # Multiple variants for KA
    'き' => ['𛀈', '𛂚', '𛂦'], # Multiple variants for KI
    'く' => ['𛀊', '𛂧'],        # Multiple variants for KU
    'け' => ['𛀌', '𛂨'],        # Multiple variants for KE
    'こ' => ['𛀎', '𛂚'],        # Multiple variants for KO
    
    # S-series
    'さ' => ['𛀐', '𛂩'],        # Multiple variants for SA
    'し' => ['𛀒', '𛀖', '𛂡'], # Multiple variants for SHI
    'す' => ['𛀔', '𛂡'],        # Multiple variants for SU
    'せ' => ['𛀖', '𛀒'],        # Multiple variants for SE
    'そ' => ['𛀘'],              # Single variant for SO
    
    # T-series
    'た' => ['𛀚', '𛂪'],        # Multiple variants for TA
    'ち' => ['𛀜', '𛂫'],        # Multiple variants for CHI
    'つ' => ['𛀞', '𛂞'],        # Multiple variants for TSU
    'て' => ['𛀠', '𛂞'],        # Multiple variants for TE
    'と' => ['𛀢'],              # Single variant for TO
    
    # N-series
    'な' => ['𛀤', '𛂠'],        # Multiple variants for NA
    'に' => ['𛀥'],              # Single variant for NI
    'ぬ' => ['𛀦'],              # Single variant for NU
    'ね' => ['𛀧', '𛂠'],        # Multiple variants for NE
    'の' => ['𛀨'],              # Single variant for NO
    
    # H-series
    'は' => ['𛀩', '𛂛'],        # Multiple variants for HA
    'ひ' => ['𛀬', '𛂣'],        # Multiple variants for HI
    'ふ' => ['𛀯', '𛂬'],        # Multiple variants for FU
    'へ' => ['𛀲', '𛂢', '𛂭'], # Multiple variants for HE
    'ほ' => ['𛀵', '𛂛', '𛂤'], # Multiple variants for HO
    
    # M-series
    'ま' => ['𛀸', '𛂮'],        # Multiple variants for MA
    'み' => ['𛀹', '𛂮'],        # Multiple variants for MI
    'む' => ['𛀺', '𛂜', '𛂯'], # Multiple variants for MU
    'め' => ['𛀻', '𛂯'],        # Multiple variants for ME
    'も' => ['𛀼', '𛂜'],        # Multiple variants for MO
    
    # Y-series
    'や' => ['𛀽'],              # Single variant for YA
    'ゆ' => ['𛀾'],              # Single variant for YU
    'よ' => ['𛀿', '𛂝'],        # Multiple variants for YO
    
    # R-series
    'ら' => ['𛁀', '𛂟'],        # Multiple variants for RA
    'り' => ['𛁁', '𛂟'],        # Multiple variants for RI
    'る' => ['𛁂'],              # Single variant for RU
    'れ' => ['𛁃'],              # Single variant for RE
    'ろ' => ['𛁄', '𛂝'],        # Multiple variants for RO
    
    # W-series (historical)
    'わ' => ['𛁅'],              # Single variant for WA
    'ゐ' => ['𛁆', '𛂣'],        # Multiple variants for WI
    'ゑ' => ['𛁇', '𛂢'],        # Multiple variants for WE
    'を' => ['𛁈', '𛂤'],        # Multiple variants for WO
    
    # N
    'ん' => ['𛁉'],              # Single variant for N
);

sub hentaigana-to-hiragana(Str $text) is export {
    my $result = $text;
    
    for %hentaigana-to-hiragana.keys -> $hentaigana {
        my @readings = %hentaigana-to-hiragana{$hentaigana};
        my $replacement = @readings.elems == 1 ?? @readings[0] !! @readings.join('・');
        $result = $result.subst($hentaigana, $replacement, :g);
    }
    
    return $result;
}

sub hiragana-to-hentaigana(Str $text) is export {
    my $result = $text;
    
    # Process each character
    for $text.comb -> $char {
        # Split sound marks first
        my @parts = split-sound-marks($char);
        my $base-char = @parts[0];
        my $sound-mark = @parts.elems > 1 ?? @parts[1] !! '';
        
        # Convert base character to hentaigana if available
        if %hiragana-to-hentaigana{$base-char}:exists {
            my @variants = %hiragana-to-hentaigana{$base-char};
            my $hentaigana-variants = @variants.join('・');
            
            # Add sound mark back if present
            my $replacement = $sound-mark ?? $hentaigana-variants ~ $sound-mark !! $hentaigana-variants;
            $result = $result.subst($char, $replacement, :g);
        }
    }
    
    return $result;
}

# Circled Katakana to components conversion table
my constant %circled-katakana-to-components = (
    # Circled Katakana letters (U+32D0-U+32FE)
    '㋐' => 'ア',    # CIRCLED KATAKANA A
    '㋑' => 'イ',    # CIRCLED KATAKANA I
    '㋒' => 'ウ',    # CIRCLED KATAKANA U
    '㋓' => 'エ',    # CIRCLED KATAKANA E
    '㋔' => 'オ',    # CIRCLED KATAKANA O
    '㋕' => 'カ',    # CIRCLED KATAKANA KA
    '㋖' => 'キ',    # CIRCLED KATAKANA KI
    '㋗' => 'ク',    # CIRCLED KATAKANA KU
    '㋘' => 'ケ',    # CIRCLED KATAKANA KE
    '㋙' => 'コ',    # CIRCLED KATAKANA KO
    '㋚' => 'サ',    # CIRCLED KATAKANA SA
    '㋛' => 'シ',    # CIRCLED KATAKANA SI
    '㋜' => 'ス',    # CIRCLED KATAKANA SU
    '㋝' => 'セ',    # CIRCLED KATAKANA SE
    '㋞' => 'ソ',    # CIRCLED KATAKANA SO
    '㋟' => 'タ',    # CIRCLED KATAKANA TA
    '㋠' => 'チ',    # CIRCLED KATAKANA TI
    '㋡' => 'ツ',    # CIRCLED KATAKANA TU
    '㋢' => 'テ',    # CIRCLED KATAKANA TE
    '㋣' => 'ト',    # CIRCLED KATAKANA TO
    '㋤' => 'ナ',    # CIRCLED KATAKANA NA
    '㋥' => 'ニ',    # CIRCLED KATAKANA NI
    '㋦' => 'ヌ',    # CIRCLED KATAKANA NU
    '㋧' => 'ネ',    # CIRCLED KATAKANA NE
    '㋨' => 'ノ',    # CIRCLED KATAKANA NO
    '㋩' => 'ハ',    # CIRCLED KATAKANA HA
    '㋪' => 'ヒ',    # CIRCLED KATAKANA HI
    '㋫' => 'フ',    # CIRCLED KATAKANA HU
    '㋬' => 'ヘ',    # CIRCLED KATAKANA HE
    '㋭' => 'ホ',    # CIRCLED KATAKANA HO
    '㋮' => 'マ',    # CIRCLED KATAKANA MA
    '㋯' => 'ミ',    # CIRCLED KATAKANA MI
    '㋰' => 'ム',    # CIRCLED KATAKANA MU
    '㋱' => 'メ',    # CIRCLED KATAKANA ME
    '㋲' => 'モ',    # CIRCLED KATAKANA MO
    '㋳' => 'ヤ',    # CIRCLED KATAKANA YA
    '㋴' => 'ユ',    # CIRCLED KATAKANA YU
    '㋵' => 'ヨ',    # CIRCLED KATAKANA YO
    '㋶' => 'ラ',    # CIRCLED KATAKANA RA
    '㋷' => 'リ',    # CIRCLED KATAKANA RI
    '㋸' => 'ル',    # CIRCLED KATAKANA RU
    '㋹' => 'レ',    # CIRCLED KATAKANA RE
    '㋺' => 'ロ',    # CIRCLED KATAKANA RO
    '㋻' => 'ワ',    # CIRCLED KATAKANA WA
    '㋼' => 'ヰ',    # CIRCLED KATAKANA WI
    '㋽' => 'ヱ',    # CIRCLED KATAKANA WE
    '㋾' => 'ヲ',    # CIRCLED KATAKANA WO
);

# Square Katakana to components conversion table
my constant %square-katakana-to-components = (
    # Square Katakana (CJK Compatibility) letters (U+3300-U+3357 range)
    '㌀' => 'アパート',   # SQUARE APAATO (apartment)
    '㌁' => 'アルファ',   # SQUARE ARUHUA (alpha)
    '㌂' => 'アンペア',   # SQUARE ANPEA (ampere)
    '㌃' => 'アール',     # SQUARE AARU (are)
    '㌄' => 'イニング',   # SQUARE ININGU (inning)
    '㌅' => 'インチ',     # SQUARE INTI (inch)
    '㌆' => 'ウォン',     # SQUARE UON (won)
    '㌇' => 'エスクード', # SQUARE ESUKUUDO (escudo)
    '㌈' => 'エーカー',   # SQUARE EEKAA (acre)
    '㌉' => 'オンス',     # SQUARE ONSU (ounce)
    '㌊' => 'オーム',     # SQUARE OOMU (ohm)
    '㌋' => 'カイリ',     # SQUARE KAIRI (nautical mile)
    '㌌' => 'カラット',   # SQUARE KARATTO (carat)
    '㌍' => 'カロリー',   # SQUARE KARORII (calorie)
    '㌎' => 'ガロン',     # SQUARE GARON (gallon)
    '㌏' => 'ガンマ',     # SQUARE GANMA (gamma)
    '㌐' => 'ギガ',       # SQUARE GIGA
    '㌑' => 'ギニー',     # SQUARE GINII (guinea)
    '㌒' => 'キュリー',   # SQUARE KYURII (curie)
    '㌓' => 'ギルダー',   # SQUARE GIRUDAA (guilder)
    '㌔' => 'キロ',       # SQUARE KIRO (kilo)
    '㌕' => 'キログラム', # SQUARE KIROGURAMU (kilogram)
    '㌖' => 'キロメートル', # SQUARE KIROMEETORU (kilometer)
    '㌗' => 'キロワット', # SQUARE KIROWATTO (kilowatt)
    '㌘' => 'グラム',     # SQUARE GURAMU (gram)
    '㌙' => 'グラムトン', # SQUARE GURAMUTON (gram ton)
    '㌚' => 'クルゼイロ', # SQUARE KURUZEIRO (cruzeiro)
    '㌛' => 'クローネ',   # SQUARE KUROONE (krone)
    '㌜' => 'ケース',     # SQUARE KEESU (case)
    '㌝' => 'コルナ',     # SQUARE KORUNA (koruna)
    '㌞' => 'コーポ',     # SQUARE KOOPU (coop)
    '㌟' => 'サイクル',   # SQUARE SAIKURU (cycle)
    '㌠' => 'サンチーム', # SQUARE SANTIIMU (centime)
    '㌡' => 'シリング',   # SQUARE SIRINGU (shilling)
    '㌢' => 'センチ',     # SQUARE SENTI (centi)
    '㌣' => 'セント',     # SQUARE SENTO (cent)
    '㌤' => 'ダース',     # SQUARE DAASU (dozen)
    '㌥' => 'デシ',       # SQUARE DESI (deci)
    '㌦' => 'ドル',       # SQUARE DORU (dollar)
    '㌧' => 'トン',       # SQUARE TON
    '㌨' => 'ナノ',       # SQUARE NANO
    '㌩' => 'ノット',     # SQUARE NOTTO (knot)
    '㌪' => 'ハイツ',     # SQUARE HAITSU (heights)
    '㌫' => 'パーセント', # SQUARE PAASENTO (percent)
    '㌬' => 'パーツ',     # SQUARE PAATSU (parts)
    '㌭' => 'バーレル',   # SQUARE BAARERU (barrel)
    '㌮' => 'ピアストル', # SQUARE PIASTORU (piastre)
    '㌯' => 'ピクル',     # SQUARE PIKURU (picul)
    '㌰' => 'ピコ',       # SQUARE PIKO (pico)
    '㌱' => 'ビル',       # SQUARE BIRU (building)
    '㌲' => 'ファラッド', # SQUARE FARADDO (farad)
    '㌳' => 'フィート',   # SQUARE FIITO (feet)
    '㌴' => 'ブッシェル', # SQUARE BUSSYERU (bushel)
    '㌵' => 'フラン',     # SQUARE FURAN (franc)
    '㌶' => 'ヘクタール', # SQUARE HEKUTAARU (hectare)
    '㌷' => 'ペソ',       # SQUARE PESO
    '㌸' => 'ペニヒ',     # SQUARE PENIHI (pfennig)
    '㌹' => 'ヘルツ',     # SQUARE HERUTSU (hertz)
    '㌺' => 'ペンス',     # SQUARE PENSU (pence)
    '㌻' => 'ページ',     # SQUARE PEEJI (page)
    '㌼' => 'ベータ',     # SQUARE BEETA (beta)
    '㌽' => 'ポイント',   # SQUARE POINTO (point)
    '㌾' => 'ボルト',     # SQUARE BORUTO (volt)
    '㌿' => 'ホン',       # SQUARE HON (hon)
    '㍀' => 'ポンド',     # SQUARE PONDO (pound)
    '㍁' => 'ホール',     # SQUARE HOORU (hall)
    '㍂' => 'ホーン',     # SQUARE HOON (horn)
    '㍃' => 'マイクロ',   # SQUARE MAIKURO (micro)
    '㍄' => 'マイル',     # SQUARE MAIRU (mile)
    '㍅' => 'マッハ',     # SQUARE MAHHA (mach)
    '㍆' => 'マルク',     # SQUARE MARUKU (mark)
    '㍇' => 'マンション', # SQUARE MANSION
    '㍈' => 'ミクロン',   # SQUARE MIKURON (micron)
    '㍉' => 'ミリ',       # SQUARE MIRI (milli)
    '㍊' => 'ミリバール', # SQUARE MIRIBAARU (millibar)
    '㍋' => 'メガ',       # SQUARE MEGA
    '㍌' => 'メガトン',   # SQUARE MEGATON
    '㍍' => 'メートル',   # SQUARE MEETORU (meter)
    '㍎' => 'ヤード',     # SQUARE YAADO (yard)
    '㍏' => 'ヤール',     # SQUARE YAARU (yard)
    '㍐' => 'ユアン',     # SQUARE YUAN
    '㍑' => 'リットル',   # SQUARE RITTORU (liter)
    '㍒' => 'リラ',       # SQUARE RIRA (lira)
    '㍓' => 'ルピー',     # SQUARE RUPII (rupee)
    '㍔' => 'ルーブル',   # SQUARE RUUBURU (rouble)
    '㍕' => 'レム',       # SQUARE REMU (rem)
    '㍖' => 'レントゲン', # SQUARE RENTOGEN (roentgen)
    '㍗' => 'ワット',     # SQUARE WATTO (watt)
);

# Reverse conversion tables
my constant %components-to-circled-katakana = %circled-katakana-to-components.antipairs.Hash;
my constant %components-to-square-katakana = %square-katakana-to-components.antipairs.Hash;

sub decircle-katakana(Str $text) is export {
    my $result = $text;
    
    for %circled-katakana-to-components.keys -> $circled-char {
        my $components = %circled-katakana-to-components{$circled-char};
        $result = $result.subst($circled-char, $components, :g);
    }
    
    return $result;
}

sub desquare-katakana(Str $text) is export {
    my $result = $text;
    
    for %square-katakana-to-components.keys -> $square-char {
        my $components = %square-katakana-to-components{$square-char};
        $result = $result.subst($square-char, $components, :g);
    }
    
    return $result;
}

sub encircle-katakana(Str $text) is export {
    my $result = $text;
    
    for %components-to-circled-katakana.keys -> $component {
        my $circled = %components-to-circled-katakana{$component};
        $result = $result.subst($component, $circled, :g);
    }
    
    return $result;
}

sub ensquare-katakana(Str $text) is export {
    my $result = $text;
    
    # Sort by length (longest first) to handle longer terms before shorter ones
    for %components-to-square-katakana.keys.sort(*.chars).reverse -> $component {
        my $square = %components-to-square-katakana{$component};
        $result = $result.subst($component, $square, :g);
    }
    
    return $result;
}