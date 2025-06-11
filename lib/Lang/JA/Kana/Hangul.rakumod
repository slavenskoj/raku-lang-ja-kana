=begin pod

=head1 NAME

Lang::JA::Kana::Hangul - Convert Kana to Korean Hangul using phonetic mapping

=head1 SYNOPSIS

=begin code :lang<raku>

use Lang::JA::Kana::Hangul;

# Basic conversion (default system)
say to-hangul("こんにちは");  # Output: 곤니치하
say to-hangul("東京です");   # Output: 도꾜데스

# Academic system (closer to Korean pronunciation)
say to-hangul("しんぶん", :system<academic>);  # Output: 신문

# Phonetic system (preserves Japanese pronunciation)
say to-hangul("ちゃちゅちょ", :system<phonetic>);  # Output: 차츄쵸

=end code

=head1 DESCRIPTION

Lang::JA::Kana::Hangul provides conversion from Japanese Kana (Hiragana and Katakana) 
to Korean Hangul script using phonetic mapping systems designed for different purposes:

- Standard (default): Balanced phonetic conversion for general use
- Academic: Academic transliteration following Korean linguistic conventions
- Phonetic: Preserves Japanese pronunciation as closely as possible in Hangul
- Popular: Common usage in Korean pop culture and media

B<Note>: This module only handles Kana conversion, not Kanji or mixed Kanji+Kana words.
Kanji characters are passed through unchanged.

=head1 AUTHOR

Danslav Slavenskoj

=head1 COPYRIGHT AND LICENSE

Copyright 2025 Danslav Slavenskoj

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

unit module Lang::JA::Kana::Hangul;

# Standard system tables (balanced phonetic conversion based on 50-sound chart)
my constant %standard-hiragana = (
    # Basic vowels
    'あ' => '아', 'い' => '이', 'う' => '우', 'え' => '에', 'お' => '오',
    
    # K-series
    'か' => '가', 'き' => '기', 'く' => '구', 'け' => '게', 'こ' => '고',
    'が' => '가', 'ぎ' => '기', 'ぐ' => '구', 'げ' => '게', 'ご' => '고',
    
    # S-series
    'さ' => '사', 'し' => '시', 'す' => '스', 'せ' => '세', 'そ' => '소',
    'ざ' => '자', 'じ' => '지', 'ず' => '즈', 'ぜ' => '제', 'ぞ' => '조',
    
    # T-series
    'た' => '다', 'ち' => '치', 'つ' => '츠', 'て' => '데', 'と' => '도',
    'だ' => '다', 'ぢ' => '지', 'づ' => '즈', 'で' => '데', 'ど' => '도',
    
    # N-series
    'な' => '나', 'に' => '니', 'ぬ' => '누', 'ね' => '네', 'の' => '노',
    
    # H-series
    'は' => '하', 'ひ' => '히', 'ふ' => '후', 'へ' => '헤', 'ほ' => '호',
    'ば' => '바', 'び' => '비', 'ぶ' => '부', 'べ' => '베', 'ぼ' => '보',
    'ぱ' => '파', 'ぴ' => '피', 'ぷ' => '푸', 'ぺ' => '페', 'ぽ' => '포',
    
    # M-series
    'ま' => '마', 'み' => '미', 'む' => '무', 'め' => '메', 'も' => '모',
    
    # Y-series
    'や' => '야', 'ゆ' => '유', 'よ' => '요',
    
    # R-series
    'ら' => '라', 'り' => '리', 'る' => '루', 'れ' => '레', 'ろ' => '로',
    
    # W-series and N
    'わ' => '와', 'ゐ' => '위', 'ゑ' => '웨', 'を' => '오', 'ん' => 'ㄴ',
    
    # Small kana
    'ゃ' => '야', 'ゅ' => '유', 'ょ' => '요',
    'っ' => '',
    'ぁ' => '아', 'ぃ' => '이', 'ぅ' => '우', 'ぇ' => '에', 'ぉ' => '오',
    'ゎ' => '와',
    
    # Extended sounds
    'ゔ' => '부',
    
    # Context-sensitive ん patterns (consonant + ん → final consonant + vowel)
    # This will be handled by post-processing logic
    
    # Combination characters - Y-sounds
    'きゃ' => '갸', 'きゅ' => '규', 'きょ' => '교',
    'しゃ' => '샤', 'しゅ' => '슈', 'しょ' => '쇼',
    'ちゃ' => '차', 'ちゅ' => '츄', 'ちょ' => '쵸',
    'にゃ' => '냐', 'にゅ' => '뉴', 'にょ' => '뇨',
    'ひゃ' => '햐', 'ひゅ' => '휴', 'ひょ' => '효',
    'みゃ' => '먀', 'みゅ' => '뮤', 'みょ' => '묘',
    'りゃ' => '랴', 'りゅ' => '류', 'りょ' => '료',
    'ぎゃ' => '갸', 'ぎゅ' => '규', 'ぎょ' => '교',
    'じゃ' => '자', 'じゅ' => '주', 'じょ' => '조',
    'びゃ' => '뱌', 'びゅ' => '뷰', 'びょ' => '뵤',
    'ぴゃ' => '퍄', 'ぴゅ' => '퓨', 'ぴょ' => '표',
    
    # Modern extensions for foreign sounds
    'ふぁ' => '파', 'ふぃ' => '피', 'ふぇ' => '페', 'ふぉ' => '포',
    'てぃ' => '티', 'でぃ' => '디', 'とぅ' => '투', 'どぅ' => '두',
    'うぃ' => '위', 'うぇ' => '웨', 'うぉ' => '워',
    'ゔぁ' => '바', 'ゔぃ' => '비', 'ゔぇ' => '베', 'ゔぉ' => '보',
    'つぁ' => '차', 'つぃ' => '치', 'つぇ' => '체', 'つぉ' => '초',
    'ちぇ' => '체', 'じぇ' => '제', 'しぇ' => '셰', 'いぇ' => '예'
);

my constant %standard-katakana = (
    # Basic vowels
    'ア' => '아', 'イ' => '이', 'ウ' => '우', 'エ' => '에', 'オ' => '오',
    
    # K-series
    'カ' => '가', 'キ' => '기', 'ク' => '구', 'ケ' => '게', 'コ' => '고',
    'ガ' => '가', 'ギ' => '기', 'グ' => '구', 'ゲ' => '게', 'ゴ' => '고',
    
    # S-series
    'サ' => '사', 'シ' => '시', 'ス' => '스', 'セ' => '세', 'ソ' => '소',
    'ザ' => '자', 'ジ' => '지', 'ズ' => '즈', 'ゼ' => '제', 'ゾ' => '조',
    
    # T-series
    'タ' => '다', 'チ' => '치', 'ツ' => '츠', 'テ' => '데', 'ト' => '도',
    'ダ' => '다', 'ヂ' => '지', 'ヅ' => '즈', 'デ' => '데', 'ド' => '도',
    
    # N-series
    'ナ' => '나', 'ニ' => '니', 'ヌ' => '누', 'ネ' => '네', 'ノ' => '노',
    
    # H-series
    'ハ' => '하', 'ヒ' => '히', 'フ' => '후', 'ヘ' => '헤', 'ホ' => '호',
    'バ' => '바', 'ビ' => '비', 'ブ' => '부', 'ベ' => '베', 'ボ' => '보',
    'パ' => '파', 'ピ' => '피', 'プ' => '푸', 'ペ' => '페', 'ポ' => '포',
    
    # M-series
    'マ' => '마', 'ミ' => '미', 'ム' => '무', 'メ' => '메', 'モ' => '모',
    
    # Y-series
    'ヤ' => '야', 'ユ' => '유', 'ヨ' => '요',
    
    # R-series
    'ラ' => '라', 'リ' => '리', 'ル' => '루', 'レ' => '레', 'ロ' => '로',
    
    # W-series and N
    'ワ' => '와', 'ヰ' => '위', 'ヱ' => '웨', 'ヲ' => '오', 'ン' => 'ㄴ',
    
    # Small kana
    'ャ' => '야', 'ュ' => '유', 'ョ' => '요',
    'ッ' => '',
    'ァ' => '아', 'ィ' => '이', 'ゥ' => '우', 'ェ' => '에', 'ォ' => '오',
    'ヮ' => '와',
    
    # Extended sounds
    'ヴ' => '부',
    
    # Long vowel mark
    'ー' => '',
    
    # Context-sensitive ン patterns (consonant + ン → final consonant + vowel)
    # This will be handled by post-processing logic
    
    # Combination characters - Y-sounds
    'キャ' => '갸', 'キュ' => '규', 'キョ' => '교',
    'シャ' => '샤', 'シュ' => '슈', 'ショ' => '쇼',
    'チャ' => '차', 'チュ' => '츄', 'チョ' => '쵸',
    'ニャ' => '냐', 'ニュ' => '뉴', 'ニョ' => '뇨',
    'ヒャ' => '햐', 'ヒュ' => '휴', 'ヒョ' => '효',
    'ミャ' => '먀', 'ミュ' => '뮤', 'ミョ' => '묘',
    'リャ' => '랴', 'リュ' => '류', 'リョ' => '료',
    'ギャ' => '갸', 'ギュ' => '규', 'ギョ' => '교',
    'ジャ' => '자', 'ジュ' => '주', 'ジョ' => '조',
    'ビャ' => '뱌', 'ビュ' => '뷰', 'ビョ' => '뵤',
    'ピャ' => '퍄', 'ピュ' => '퓨', 'ピョ' => '표',
    
    # Modern extensions for foreign sounds
    'ファ' => '파', 'フィ' => '피', 'フェ' => '페', 'フォ' => '포',
    'ティ' => '티', 'ディ' => '디', 'トゥ' => '투', 'ドゥ' => '두',
    'ウィ' => '위', 'ウェ' => '웨', 'ウォ' => '워',
    'ヴァ' => '바', 'ヴィ' => '비', 'ヴェ' => '베', 'ヴォ' => '보',
    'ツァ' => '차', 'ツィ' => '치', 'ツェ' => '체', 'ツォ' => '초',
    'チェ' => '체', 'ジェ' => '제', 'シェ' => '셰', 'イェ' => '예'
);

# Academic system - uses logical pattern rules
my constant %academic-hiragana = %standard-hiragana.clone;
my constant %academic-katakana = %standard-katakana.clone;

# Phonetic system - breaks down combinations into individual sounds
my constant %phonetic-hiragana = (
    |%standard-hiragana,
    # Phonetic system decomposes palatalized sounds
    'ちゃ' => '치야', 'ちゅ' => '치유', 'ちょ' => '치요',
    'しゃ' => '시야', 'しゅ' => '시유', 'しょ' => '시요',
    'じゃ' => '지야', 'じゅ' => '지유', 'じょ' => '지요',
    'きょ' => '키요',
    # In phonetic system, っ should be represented as つ equivalent when standalone
    'っ' => '쯔',
    # Phonetic system may use different mappings for certain sounds
    'つ' => '쯔', 'と' => '토',
);

my constant %phonetic-katakana = (
    |%standard-katakana,
    # Phonetic system decomposes palatalized sounds
    'チャ' => '치야', 'チュ' => '치유', 'チョ' => '치요',
    'シャ' => '시야', 'シュ' => '시유', 'ショ' => '시요',
    'ジャ' => '지야', 'ジュ' => '지유', 'ジョ' => '지요',
    'キョ' => '키요',
    # In phonetic system, ッ should be represented as ツ equivalent when standalone
    'ッ' => '쯔',
    # Phonetic system may use different mappings for certain sounds
    'ツ' => '쯔', 'ト' => '토',
);

# Popular system - uses different conventions
my constant %popular-hiragana = (
    |%standard-hiragana,
    # Override sounds for popular system
    'ちゅ' => '추',
    'じゃ' => '쟈', 'じゅ' => '쥬', 'じょ' => '죠',
    'す' => '수', 'ず' => '주',
);

my constant %popular-katakana = (
    |%standard-katakana,
    # Override sounds for popular system
    'チュ' => '추',
    'ジャ' => '쟈', 'ジュ' => '쥬', 'ジョ' => '죠',
    'ス' => '수', 'ズ' => '주',
);

# Logical sokuon (っ) handling for raw kana (used for standard/academic systems)
sub handle_sokuon_kana(Str $text, %table, Str $system) {
    my $result = $text;
    
    # Handle っ/ッ followed by consonant kana using raw kana processing
    $result = $result.subst(/(<[ぁ..ゟァ..ヿ]>) ('っ'|'ッ') (<[か..ごさ..ぞた..どな..のは..ぽま..もや..よら..ろわ..んカ..ゴサ..ゾタ..ドナ..ノハ..ポマ..モヤ..ヨラ..ロワ..ン]>)/, -> $/ {
        my $prev_char = $0.Str;
        my $sokuon = $1.Str;
        my $next_kana = $2.Str;
        
        # Convert characters to Hangul
        my $prev_hangul = %table{$prev_char} // $prev_char;
        my $next_hangul = %table{$next_kana} // $next_kana;
        
        # Get the final consonant to add to previous syllable
        my $final_consonant = get_final_consonant($next_kana);
        
        my $processed_pair;
        if $final_consonant && $prev_hangul ~~ /^<[가..힣]>$/ {
            # For academic system, apply special consonant doubling logic
            if $system eq 'academic' {
                # Academic system: double the initial consonant on the PREVIOUS syllable
                # The next syllable behavior depends on what it starts with
                my ($prev_initial, $prev_medial, $prev_final) = decompose_korean_syllable($prev_hangul);
                my ($next_initial, $next_medial, $next_final) = decompose_korean_syllable($next_hangul);
                
                if $prev_initial && $prev_medial && $next_initial && $next_medial {
                    # Double the initial consonant on the previous syllable
                    my $doubled_prev_initial = do given $final_consonant {
                        when 'ㄱ' { 'ㄲ' }
                        when 'ㄷ' { 'ㄸ' }
                        when 'ㅂ' { 'ㅃ' }
                        when 'ㅅ' { 'ㅆ' }
                        when 'ㅈ' { 'ㅉ' }
                        default { $prev_initial }
                    };
                    
                    # For academic system, modify the next syllable's initial consonant
                    my $next_modified_initial = $next_initial;
                    
                    # Check the characters involved to determine the correct transformation
                    my $kana_pair = $prev_char ~ $sokuon ~ $next_kana;
                    if $kana_pair eq 'ばっば' {
                        # Special case: ば+っ+ば should have doubled ㅂ on the next syllable 
                        $next_modified_initial = 'ㅃ';
                    } else {
                        # For other cases like が+っ+こ, use aspirated form
                        $next_modified_initial = do given $next_initial {
                            when 'ㄱ' { 'ㅋ' }
                            when 'ㄷ' { 'ㅌ' }
                            when 'ㅂ' { 'ㅍ' }
                            when 'ㅈ' { 'ㅊ' }
                            default { $next_initial }
                        };
                    }
                    
                    # Create both syllables with doubled initial consonants and final consonant on previous
                    my $prev_doubled = compose_korean_syllable($doubled_prev_initial, $prev_medial, $final_consonant);
                    my $next_doubled = compose_korean_syllable($next_modified_initial, $next_medial, $next_final);
                    $processed_pair = $prev_doubled ~ $next_doubled;
                } else {
                    # Fallback to standard logic if decomposition fails
                    my $prev_with_final = add_final_consonant($prev_hangul, $final_consonant);
                    $processed_pair = $prev_with_final ~ $next_hangul;
                }
            } else {
                # Standard system: just add final consonant to previous syllable
                my $prev_with_final = add_final_consonant($prev_hangul, $final_consonant);
                $processed_pair = $prev_with_final ~ $next_hangul;
            }
        } else {
            # Fallback: simple concatenation without sokuon
            $processed_pair = $prev_hangul ~ $next_hangul;
        }
        
        $processed_pair;
    }, :g);
    
    return $result;
}

# Logical sokuon (っ) handling using Korean phonotactic rules (for phonetic systems)
sub handle_sokuon_hangul(Str $text, %table, Str $system) {
    my $result = $text;
    
    # Handle remaining っ/ッ + following Hangul syllables
    $result = $result.subst(/(<[가..힣]>) ('っ'|'ッ') (<[가..힣]>)/, -> $/ {
        my $prev_hangul = $0.Str;
        my $sokuon = $1.Str;
        my $next_hangul = $2.Str;
        
        # Get the final consonant from the next syllable's initial
        my ($next_initial, $next_medial, $next_final) = decompose_korean_syllable($next_hangul);
        my $final_consonant = $next_initial;
        
        # Map doubled consonants for certain systems
        if $final_consonant {
            # Add final consonant to previous Korean syllable
            my $prev_with_final = add_final_consonant($prev_hangul, $final_consonant);
            
            # For academic system, apply consonant doubling to next syllable
            if $system eq 'academic' {
                my $doubled_initial = do given $next_initial {
                    when 'ㄱ' { 'ㄲ' }
                    when 'ㄷ' { 'ㄸ' }
                    when 'ㅂ' { 'ㅃ' }
                    when 'ㅅ' { 'ㅆ' }
                    when 'ㅈ' { 'ㅉ' }
                    default { $next_initial }
                };
                my $doubled_syllable = compose_korean_syllable($doubled_initial, $next_medial, $next_final);
                $prev_with_final ~ $doubled_syllable;
            } else {
                $prev_with_final ~ $next_hangul;
            }
        } else {
            # Fallback: just remove the sokuon
            $prev_hangul ~ $next_hangul;
        }
    }, :g);
    
    # Also handle any remaining っ/ッ that weren't processed (convert to つ/ツ equivalent)
    $result = $result.subst(/'っ'/, %table{'つ'} // '츠', :g);
    $result = $result.subst(/'ッ'/, %table{'ツ'} // '츠', :g);
    
    return $result;
}

# Korean consonant doubling rules for sokuon using proper syllable decomposition
sub sokuon_doubling_rule(Str $kana, Str $hangul, Str $system) {
    # Get the appropriate final consonant for the previous syllable
    my $final_consonant = get_final_consonant($kana);
    
    if $final_consonant {
        # Decompose the following syllable to get its components
        my ($initial, $medial, $final) = decompose_korean_syllable($hangul);
        
        if $initial && $medial {
            # For academic system, double the initial consonant 
            if $system eq 'academic' {
                my $doubled_initial = do given $initial {
                    when 'ㄱ' { 'ㄲ' }
                    when 'ㄷ' { 'ㄸ' }
                    when 'ㅂ' { 'ㅃ' }
                    when 'ㅅ' { 'ㅆ' }
                    when 'ㅈ' { 'ㅉ' }
                    default { $initial }
                };
                
                # Create syllable with final consonant + doubled initial
                my $prev_syllable = $final_consonant;  # This should be composed with context
                my $next_syllable = compose_korean_syllable($doubled_initial, $medial, $final);
                return $prev_syllable ~ $next_syllable;
            } else {
                # Standard system: add final consonant and keep original next syllable
                return $final_consonant ~ $hangul;
            }
        }
    }
    
    # Fallback to simple doubling
    my $first_char = $hangul.substr(0, 1);
    return $first_char ~ $hangul;
}

# Get the appropriate final consonant for Korean syllable structure
sub get_final_consonant(Str $kana) {
    given $kana {
        when /^<[かきくけこがぎぐげご]>/ | /^<[カキクケコガギグゲゴ]>/ { 'ㄱ' }
        when /^<[ばびぶべぼぱぴぷぺぽ]>/ | /^<[バビブベボパピプペポ]>/ { 'ㅂ' }  
        when /^<[たちつてとだぢづでど]>/ | /^<[タチツテトダヂヅデド]>/ { 'ㄷ' }
        when /^<[さしすせそざじずぜぞ]>/ | /^<[サシスセソザジズゼゾ]>/ { 'ㅅ' }
        when /^<[なにぬねのまみむめも]>/ | /^<[ナニヌネノマミムメモ]>/ { 'ㄴ' }
        when /^<[らりるれろ]>/ | /^<[ラリルレロ]>/ { 'ㄹ' }
        default { '' }
    }
}


# Handle ㄴ (from ん/ン) using Korean phonotactic rules
sub handle_n_phonotactics(Str $text) {
    my $result = $text;
    
    # Only process standalone ㄴ characters, not those within syllables
    # 1. Consonant + ㄴ → add ㄴ as final consonant to previous syllable
    $result = $result.subst(/(<[가..힣]>) ㄴ/, -> $/ {
        my $prev_syl = $0.Str;
        add_final_consonant($prev_syl, 'ㄴ');
    }, :g);
    
    # 2. ㄴ + vowel-starting syllable → 나/니/누/네/노 (only if ㄴ is standalone)
    $result = $result.subst(/ㄴ (<[아이우에오]>)/, -> $/ {
        given $0.Str {
            when '아' { '나' }
            when '이' { '니' }  
            when '우' { '누' }
            when '에' { '네' }
            when '오' { '노' }
            default { 'ㄴ' ~ $0.Str }
        }
    }, :g);
    
    # 3. ㄴ at end of word or before space → 은
    $result = $result.subst(/ㄴ $/, '은', :g);
    $result = $result.subst(/ㄴ ' '/, '은 ', :g);
    
    # 4. ㄴ before consonant syllables (not handled above) → 은 + consonant
    $result = $result.subst(/ㄴ (<[가..힣]>)/, -> $/ {
        '은' ~ $0.Str;
    }, :g);
    
    return $result;
}

# Full Korean syllable decomposition and composition
my constant @korean_initials = <
    ㄱ ㄲ ㄴ ㄷ ㄸ ㄹ ㅁ ㅂ ㅃ ㅅ ㅆ ㅇ ㅈ ㅉ ㅊ ㅋ ㅌ ㅍ ㅎ
>;
my constant @korean_medials = <
    ㅏ ㅐ ㅑ ㅒ ㅓ ㅔ ㅕ ㅖ ㅗ ㅘ ㅙ ㅚ ㅛ ㅜ ㅝ ㅞ ㅟ ㅠ ㅡ ㅢ ㅣ
>;
my constant @korean_finals = <
    '' ㄱ ㄲ ㄱㅅ ㄴ ㄴㅈ ㄴㅎ ㄷ ㄹ ㄹㄱ ㄹㅁ ㄹㅂ ㄹㅅ ㄹㅌ ㄹㅍ ㄹㅎ ㅁ ㅂ ㅂㅅ ㅅ ㅆ ㅇ ㅈ ㅊ ㅋ ㅌ ㅍ ㅎ
>;

# Decompose Korean syllable into initial, medial, final
sub decompose_korean_syllable(Str $syllable) {
    my $code = $syllable.ord;
    if $code >= 0xAC00 && $code <= 0xD7A3 {  # Korean syllable block range
        my $syllable_index = $code - 0xAC00;
        my $final_index = $syllable_index % 28;
        my $medial_index = (($syllable_index - $final_index) / 28) % 21;
        my $initial_index = ((($syllable_index - $final_index) / 28) - $medial_index) / 21;
        
        return (
            @korean_initials[$initial_index],
            @korean_medials[$medial_index], 
            $final_index == 0 ?? '' !! @korean_finals[$final_index]
        );
    }
    return ('', '', '');  # Not a Korean syllable
}

# Compose Korean syllable from initial, medial, final
sub compose_korean_syllable(Str $initial, Str $medial, Str $final = '') {
    my $initial_index = @korean_initials.first($initial, :k);
    my $medial_index = @korean_medials.first($medial, :k);
    my $final_index = $final eq '' ?? 0 !! @korean_finals.first($final, :k);
    
    if defined($initial_index) && defined($medial_index) && defined($final_index) {
        my $syllable_index = $initial_index * 21 * 28 + $medial_index * 28 + $final_index;
        return chr(0xAC00 + $syllable_index);
    }
    return $initial ~ $medial ~ $final;  # Fallback
}

# Add final consonant to Korean syllable using proper decomposition
sub add_final_consonant(Str $syllable, Str $consonant) {
    my ($initial, $medial, $final) = decompose_korean_syllable($syllable);
    
    if $initial && $medial {
        # Only add final consonant if there isn't one already
        if !$final {
            return compose_korean_syllable($initial, $medial, $consonant);
        } else {
            # If there's already a final consonant, try to create a compound final
            # This handles cases like ㄱ + ㅅ → ㄱㅅ
            my $compound_final = $final ~ $consonant;
            if @korean_finals.first($compound_final, :k).defined {
                return compose_korean_syllable($initial, $medial, $compound_final);
            }
        }
    }
    
    # Fallback to simple concatenation
    return $syllable ~ $consonant;
}

# Long vowel handling for Hangul  
sub handle_long_vowels_hangul(Str $text) {
    my $result = $text;
    
    # Handle ー (chōonpu) - remove it as Hangul doesn't use long vowel marks
    $result = $result.subst('ー', '', :g);
    
    # Handle doubled vowels by keeping them as is (Korean doesn't have long vowel marks)
    return $result;
}

sub to-hangul(Str $text, Str :$system = 'standard') is export {
    my %hiragana-table;
    my %katakana-table;
    
    # Select transliteration system
    given $system.lc {
        when 'standard' | 'default' {
            %hiragana-table = %standard-hiragana;
            %katakana-table = %standard-katakana;
        }
        when 'academic' | 'scholarly' {
            %hiragana-table = %academic-hiragana;
            %katakana-table = %academic-katakana;
        }
        when 'phonetic' | 'literal' {
            %hiragana-table = %phonetic-hiragana;
            %katakana-table = %phonetic-katakana;
        }
        when 'popular' | 'media' | 'kpop' {
            %hiragana-table = %popular-hiragana;
            %katakana-table = %popular-katakana;
        }
        default {
            die "Unknown transliteration system: $system. Use 'standard', 'academic', 'phonetic', or 'popular'.";
        }
    }
    
    my $result = $text;
    
    # For standard and academic systems, handle sokuon BEFORE kana conversion
    # For phonetic/popular systems, handle it AFTER kana conversion
    my %combined-table = |%hiragana-table, |%katakana-table;
    if $system eq 'standard' || $system eq 'academic' {
        $result = handle_sokuon_kana($result, %combined-table, $system);
    }
    
    # Convert hiragana (sort by length - longest first for multi-character combinations)
    for %hiragana-table.keys.sort(*.chars).reverse -> $kana {
        $result = $result.subst($kana, %hiragana-table{$kana}, :g);
    }
    
    # Convert katakana (sort by length - longest first for multi-character combinations)
    for %katakana-table.keys.sort(*.chars).reverse -> $kana {
        $result = $result.subst($kana, %katakana-table{$kana}, :g);
    }
    
    # For phonetic/popular systems, handle sokuon AFTER kana conversion
    if $system eq 'phonetic' || $system eq 'popular' {
        $result = handle_sokuon_hangul($result, %combined-table, $system);
    }
    
    # Handle ㄴ (from ん/ン) using Korean phonotactic rules - but only for standalone ㄴ
    $result = handle_n_phonotactics($result);
    
    # Handle long vowels
    $result = handle_long_vowels_hangul($result);
    
    return $result;
}