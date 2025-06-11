#!/usr/bin/env raku

use Test;
use lib 'lib';
use Lang::JA::Kana;

plan 12;

# Test module loading
ok True, 'Module loads successfully';

# Test basic functionality described in README examples
subtest 'README Basic Examples', {
    plan 8;
    
    # Basic conversions from README
    is to-katakana("こんにちは"), "コンニチハ", "Basic README example: こんにちは → コンニチハ";
    is to-hiragana("コンニチハ"), "こんにちは", "Basic README example: コンニチハ → こんにちは";
    
    # Modern extensions from README
    is to-katakana("ふぁみりー"), "ファミリー", "README example: ふぁみりー → ファミリー";
    is to-hiragana("ファミリー"), "ふぁみりー", "README example: ファミリー → ふぁみりー";
    
    # Combination sounds from README
    is to-katakana("きゃりーぱみゅぱみゅ"), "キャリーパミュパミュ", "README example: complex combination";
    
    # Mixed text from README
    is to-katakana("Hello こんにちは World"), "Hello コンニチハ World", "README example: mixed text hiragana";
    is to-hiragana("Hello コンニチハ World"), "Hello こんにちは World", "README example: mixed text katakana";
    
    # Numbers and letters passthrough
    is to-katakana("123 ABC"), "123 ABC", "README example: non-kana unchanged";
};

subtest 'Half-width Katakana Examples', {
    plan 6;
    
    # Half-width examples from README
    is to-fullwidth-katakana("ｱｲｳｴｵ"), "アイウエオ", "README example: basic half-width";
    is to-fullwidth-katakana("ｶﾞｷﾞｸﾞ"), "ガギグ", "README example: voiced combinations";
    is to-fullwidth-katakana("ﾊﾟﾋﾟﾌﾟ"), "パピプ", "README example: semi-voiced combinations";
    
    is to-halfwidth-katakana("アイウエオ"), "ｱｲｳｴｵ", "README example: full to half basic";
    is to-halfwidth-katakana("ガギグ"), "ｶﾞｷﾞｸﾞ", "README example: full to half voiced";
    is to-halfwidth-katakana("パピプ"), "ﾊﾟﾋﾟﾌﾟ", "README example: full to half semi-voiced";
};

subtest 'Cross-script Integration Examples', {
    plan 9;
    
    # Romaji conversion examples
    is kana-to-romaji("こんにちは"), "konnichiha", "README example: basic romaji";
    is kana-to-romaji("ひらがな"), "hiragana", "README example: hiragana romaji";
    is kana-to-romaji("しんぶん", :system<kunrei>), "sinbun", "README example: kunrei system";
    
    # Cyrillic conversion examples
    is kana-to-kuriru-moji("こんにちは"), "конничиха", "README example: basic cyrillic";
    is kana-to-kuriru-moji("ひらがな"), "хирагана", "README example: hiragana cyrillic";
    is kana-to-kuriru-moji("しんぶん", :system<phonetic>), "шинбун", "README example: phonetic cyrillic";
    
    # Hangul conversion examples
    is kana-to-hangul("こんにちは"), "곤니치하", "README example: basic hangul";
    is kana-to-hangul("ひらがな"), "히라가나", "README example: hiragana hangul";
    is kana-to-hangul("がっこう", :system<academic>), "깍코우", "README example: academic hangul";
};

subtest 'Character Support Examples', {
    plan 8;
    
    # Standard kana examples
    is to-katakana("あいうえお"), "アイウエオ", "Character support: basic vowels";
    is to-katakana("かきくけこ"), "カキクケコ", "Character support: K-series";
    is to-katakana("がぎぐげご"), "ガギグゲゴ", "Character support: voiced K-series";
    
    # Small kana examples
    is to-katakana("ぁぃぅぇぉ"), "ァィゥェォ", "Character support: small vowels";
    is to-katakana("ゃゅょ"), "ャュョ", "Character support: small Y-sounds";
    is to-katakana("っ"), "ッ", "Character support: small tsu";
    
    # Combination sounds
    is to-katakana("きゃきゅきょ"), "キャキュキョ", "Character support: Y-combinations";
    is to-katakana("しゃしゅしょ"), "シャシュショ", "Character support: SHA combinations";
};

subtest 'Modern Extensions', {
    plan 6;
    
    # F-sounds
    is to-katakana("ふぁふぃふぇふぉ"), "ファフィフェフォ", "Modern extension: FA-FO sounds";
    
    # T/D-sounds
    is to-katakana("てぃでぃ"), "ティディ", "Modern extension: TI/DI sounds";
    is to-katakana("とぅどぅ"), "トゥドゥ", "Modern extension: TU/DU sounds";
    
    # W-sounds
    is to-katakana("うぃうぇうぉ"), "ウィウェウォ", "Modern extension: WI/WE/WO sounds";
    
    # V-sounds
    is to-katakana("ゔぁゔぃゔぇゔぉ"), "ヴァヴィヴェヴォ", "Modern extension: VA-VO sounds";
    
    # Other combinations
    is to-katakana("ちぇじぇしぇいぇ"), "チェジェシェイェ", "Modern extension: CHE sounds";
};

subtest 'Historical Kana Examples', {
    plan 4;
    
    # Historical characters
    is to-katakana("ゐゑを"), "ヰヱヲ", "Historical: WI/WE/WO";
    is to-hiragana("ヰヱヲ"), "ゐゑを", "Historical: reverse WI/WE/WO";
    
    # VU sound
    is to-katakana("ゔ"), "ヴ", "Historical: VU sound";
    is to-hiragana("ヴ"), "ゔ", "Historical: reverse VU sound";
};

subtest 'Hentaigana Basic Support', {
    plan 3;
    
    # Basic hentaigana conversion
    is hentaigana-to-hiragana("𛀁𛀂𛀃"), "あいう", "Hentaigana: basic conversion";
    
    # Multiple reading example (should contain either し or せ)
    my $result = hentaigana-to-hiragana("𛀒");
    ok $result ~~ /し|せ/, "Hentaigana: multiple reading contains expected characters";
    
    # Hiragana to hentaigana (should contain expected character)
    my $henta-result = hiragana-to-hentaigana("あ");
    ok $henta-result ~~ /𛀁/, "Hentaigana: hiragana to hentaigana contains expected character";
};

subtest 'Sound Mark Processing', {
    plan 4;
    
    # Sound mark splitting
    my @parts = split-sound-marks("が");
    is @parts[0], "か", "Sound marks: base character extraction";
    is @parts[1], "゛", "Sound marks: voiced mark extraction";
    
    @parts = split-sound-marks("ぱ");
    is @parts[0], "は", "Sound marks: semi-voiced base";
    is @parts[1], "゜", "Sound marks: semi-voiced mark";
};

subtest 'Specialized Unicode Symbols', {
    plan 4;
    
    # Circled katakana
    is decircle-katakana("㋐㋑㋒"), "アイウ", "Unicode symbols: decircle katakana";
    is encircle-katakana("アイウ"), "㋐㋑㋒", "Unicode symbols: encircle katakana";
    
    # Square katakana (basic test)
    like desquare-katakana("㌔"), /キロ/, "Unicode symbols: desquare basic";
    like ensquare-katakana("キロ"), /'㌔'/, "Unicode symbols: ensquare basic";
};

subtest 'Edge Cases and Error Handling', {
    plan 4;
    
    # Empty strings
    is to-katakana(""), "", "Edge case: empty string katakana";
    is to-hiragana(""), "", "Edge case: empty string hiragana";
    is to-fullwidth-katakana(""), "", "Edge case: empty string fullwidth";
    is hentaigana-to-hiragana(""), "", "Edge case: empty string hentaigana";
};

subtest 'Integration with Half-width Processing', {
    plan 3;
    
    # Half-width integration
    is to-hiragana("ｶﾀｶﾅ"), "かたかな", "Integration: half-width to hiragana";
    is kana-to-romaji("ｺﾝﾆﾁﾊ"), "konnichiha", "Integration: half-width romaji";
    is kana-to-kuriru-moji("ｺﾝﾆﾁﾊ"), "конничиха", "Integration: half-width cyrillic";
};

done-testing;