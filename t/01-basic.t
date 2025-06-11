#!/usr/bin/env raku

use Test;
use lib 'lib';
use Lang::JA::Kana;

plan 52;

# Test module loading
ok True, 'Module loads successfully';

# Test basic Hiragana to Katakana conversion
is to-katakana("こんにちは"), "コンニチハ", "Basic Hiragana to Katakana conversion";
is to-katakana("ひらがな"), "ヒラガナ", "Function-based Hiragana to Katakana conversion";

# Test basic Katakana to Hiragana conversion  
is to-hiragana("コンニチハ"), "こんにちは", "Basic Katakana to Hiragana conversion";
is to-hiragana("カタカナ"), "かたかな", "Function-based Katakana to Hiragana conversion";

# Test mixed text handling
is to-katakana("Hello こんにちは World"), "Hello コンニチハ World", "Mixed text Hiragana conversion";
is to-hiragana("Hello コンニチハ World"), "Hello こんにちは World", "Mixed text Katakana conversion";

# Test text with no kana (should remain unchanged)
is to-katakana("Hello World"), "Hello World", "Non-kana text unchanged (Katakana)";
is to-hiragana("123 ABC"), "123 ABC", "Non-kana text unchanged (Hiragana)";

# Test small kana variants
is to-katakana("ぁぃぅぇぉ"), "ァィゥェォ", "Small vowel conversion";
is to-hiragana("ァィゥェォ"), "ぁぃぅぇぉ", "Small vowel reverse conversion";
is to-katakana("ゎ"), "ヮ", "Small WA conversion";
is to-hiragana("ヮ"), "ゎ", "Small WA reverse conversion";

# Test historical kana
is to-katakana("ゐゑ"), "ヰヱ", "Historical WI/WE conversion";
is to-hiragana("ヰヱ"), "ゐゑ", "Historical WI/WE reverse conversion";
is to-katakana("ゔ"), "ヴ", "VU sound conversion";
is to-hiragana("ヴ"), "ゔ", "VU sound reverse conversion";
is to-katakana("ゟ"), "ヿ", "Digraph Yori conversion";
is to-hiragana("ヿ"), "ゟ", "Digraph Yori reverse conversion";

# Test modern extensions
is to-katakana("ふぁふぃふぇふぉ"), "ファフィフェフォ", "FA-FO sounds conversion";
is to-hiragana("ファフィフェフォ"), "ふぁふぃふぇふぉ", "FA-FO sounds reverse conversion";
is to-katakana("てぃでぃ"), "ティディ", "TI/DI sounds conversion";
is to-hiragana("ティディ"), "てぃでぃ", "TI/DI sounds reverse conversion";

# Test combination characters
is to-katakana("きゃりーぱみゅぱみゅ"), "キャリーパミュパミュ", "Complex combination conversion";
is to-hiragana("キャリーパミュパミュ"), "きゃりーぱみゅぱみゅ", "Complex combination reverse conversion";

# Test half-width katakana conversion
is to-fullwidth-katakana("ｱｲｳｴｵ"), "アイウエオ", "Basic half-width to full-width";
is to-halfwidth-katakana("アイウエオ"), "ｱｲｳｴｵ", "Basic full-width to half-width";

# Test half-width voiced combinations
is to-fullwidth-katakana("ｶﾞｷﾞｸﾞ"), "ガギグ", "Half-width voiced combinations";
is to-halfwidth-katakana("ガギグ"), "ｶﾞｷﾞｸﾞ", "Full-width to half-width voiced";

# Test half-width semi-voiced combinations
is to-fullwidth-katakana("ﾊﾟﾋﾟﾌﾟ"), "パピプ", "Half-width semi-voiced combinations";
is to-halfwidth-katakana("パピプ"), "ﾊﾟﾋﾟﾌﾟ", "Full-width to half-width semi-voiced";

# Test half-width small katakana
is to-fullwidth-katakana("ｧｨｩｪｫ"), "ァィゥェォ", "Half-width small katakana";
is to-halfwidth-katakana("ァィゥェォ"), "ｧｨｩｪｫ", "Full-width to half-width small";

# Test half-width VU sound
is to-fullwidth-katakana("ｳﾞ"), "ヴ", "Half-width VU sound";
is to-halfwidth-katakana("ヴ"), "ｳﾞ", "Full-width to half-width VU";

# Test half-width integration with existing functions
is to-hiragana("ｶﾀｶﾅ"), "かたかな", "Half-width to Hiragana integration";
is to-hiragana("ｱｲｳｴｵ"), "あいうえお", "Half-width function integration";

# Test Hentaigana basic conversion
is hentaigana-to-hiragana("𛀁𛀂𛀃"), "あいう", "Basic Hentaigana conversion";
like hentaigana-to-hiragana("𛀒"), /し|せ/, "Hentaigana multiple reading";

# Test Hiragana to Hentaigana conversion
like hiragana-to-hentaigana("る"), /𛁂/, "Hiragana to Hentaigana single";
like hiragana-to-hentaigana("あ"), /𛀁/, "Hiragana to Hentaigana multiple";

# Test sound mark splitting
my @parts = split-sound-marks("が");
is @parts[0], "か", "Sound mark splitting base";
is @parts[1], "゛", "Sound mark splitting mark";

# Test circled katakana
is decircle-katakana("㋐㋑㋒"), "アイウ", "Circled katakana to components";
is encircle-katakana("アイウ"), "㋐㋑㋒", "Components to circled katakana";

# Test square katakana
like desquare-katakana("㌔"), /キロ/, "Square katakana to components";
like ensquare-katakana("キロ"), /\㌔/, "Components to square katakana";

# Test edge cases
is to-katakana(""), "", "Empty string handling";
is to-hiragana(""), "", "Empty string reverse handling";
is to-fullwidth-katakana(""), "", "Empty string half-width handling";
is to-halfwidth-katakana(""), "", "Empty string full-width handling";

# Test mixed scenarios
is to-hiragana("ｶﾞｷﾞｸﾞｹﾞｺﾞ"), "がぎぐげご", "Complex half-width voiced to Hiragana";

done-testing;