#!/usr/bin/env raku

use Test;
use lib 'lib';
use Lang::JA::Kana;

plan 153;

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

# Test Kana to Romaji conversion - Hepburn (default)
is kana-to-romaji("こんにちは"), "konnichiha", "Basic Hepburn romaji conversion";
is kana-to-romaji("ひらがな"), "hiragana", "Hepburn hiragana conversion";
is kana-to-romaji("カタカナ"), "katakana", "Hepburn katakana conversion";
is kana-to-romaji("しんぶん"), "shinbun", "Hepburn shi/fu sounds";
is kana-to-romaji("ちゃちゅちょ"), "chachucho", "Hepburn cha/chu/cho sounds";
is kana-to-romaji("じゃじゅじょ"), "jajujo", "Hepburn ja/ju/jo sounds";

# Test Kunrei-shiki romanization
is kana-to-romaji("しんぶん", :system<kunrei>), "sinbun", "Kunrei-shiki si/hu sounds";
is kana-to-romaji("ちゃちゅちょ", :system<kunrei>), "tyatyutyo", "Kunrei-shiki tya/tyu/tyo sounds";
is kana-to-romaji("じゃじゅじょ", :system<kunrei>), "zyazyuzyo", "Kunrei-shiki zya/zyu/zyo sounds";
is kana-to-romaji("ふじさん", :system<kunrei>), "huzisan", "Kunrei-shiki hu/zi sounds";

# Test Nihon-shiki romanization
is kana-to-romaji("ちちち", :system<nihon>), "tititi", "Nihon-shiki ti sound";
is kana-to-romaji("づつき", :system<nihon>), "dutuki", "Nihon-shiki du/tu distinction";
is kana-to-romaji("ぢぢぢ", :system<nihon>), "dididi", "Nihon-shiki di sound";

# Test mixed text (non-kana passthrough)
is kana-to-romaji("Hello こんにちは World"), "Hello konnichiha World", "Mixed text romaji conversion";
is kana-to-romaji("123 あいう ABC"), "123 aiu ABC", "Numbers and letters passthrough";

# Test small tsu (sokuon) doubling
is kana-to-romaji("がっこう"), "gakkou", "Small tsu doubling (Hepburn)";
is kana-to-romaji("がっこう", :system<kunrei>), "gakkou", "Small tsu doubling (Kunrei)";
is kana-to-romaji("ちょっと"), "chotto", "Small tsu with cho sound";

# Test traditional Hepburn (default - no macrons)
is kana-to-romaji("がっこう"), "gakkou", "Traditional Hepburn: gakkou (no macron)";
is kana-to-romaji("とうきょう"), "toukyou", "Traditional Hepburn: toukyou (no macron)";
is kana-to-romaji("おおきい"), "ookii", "Traditional Hepburn: ookii (no macron)";

# Test Modified Hepburn (with macrons)
is kana-to-romaji("がっこう", :system<hepburn-mod>), "gakkō", "Modified Hepburn: gakkō (with macron)";
is kana-to-romaji("とうきょう", :system<hepburn-mod>), "tōkyō", "Modified Hepburn: tōkyō (with macron)";
is kana-to-romaji("おおきい", :system<hepburn-mod>), "ookī", "Modified Hepburn: ookī (with macron)";

# Test historical kana
is kana-to-romaji("ゐゑを"), "wiwewo", "Historical wi/we/wo sounds"; 
is kana-to-romaji("ゔぁゔぃゔぇゔぉ"), "vavivevo", "VU sound variations";

# Test modern extensions
is kana-to-romaji("ふぁふぃふぇふぉ"), "fafifefo", "FA-FO sounds (Hepburn)";
is kana-to-romaji("てぃでぃ"), "tidi", "TI/DI sounds";

# Test Kana to Cyrillic (Kuriru-moji) conversion - Polivanov (default)
is kana-to-kuriru-moji("こんにちは"), "конничиха", "Basic Polivanov Cyrillic conversion";
is kana-to-kuriru-moji("ひらがな"), "хирагана", "Polivanov hiragana conversion";
is kana-to-kuriru-moji("カタカナ"), "катакана", "Polivanov katakana conversion";
is kana-to-kuriru-moji("しんぶん"), "синбун", "Polivanov si/fu sounds";

# Test Phonetic system
is kana-to-kuriru-moji("しんぶん", :system<phonetic>), "шинбун", "Phonetic shi/fu sounds";
is kana-to-kuriru-moji("ちゃちゅちょ", :system<phonetic>), "чачучо", "Phonetic cha/chu/cho sounds";
is kana-to-kuriru-moji("じゃじゅじょ", :system<phonetic>), "джяджюджё", "Phonetic ja/ju/jo sounds";

# Test Static system
is kana-to-kuriru-moji("こんにちは", :system<static>), "коннитиха", "Static system basic";
is kana-to-kuriru-moji("ざじずぜぞ", :system<static>), "зазизузезо", "Static z-sounds";

# Test mixed text (non-kana passthrough)
is kana-to-kuriru-moji("Hello こんにちは World"), "Hello конничиха World", "Mixed text Cyrillic conversion";
is kana-to-kuriru-moji("123 あいう ABC"), "123 аиу ABC", "Numbers and letters passthrough (Cyrillic)";

# Test small tsu (sokuon) doubling in Cyrillic
is kana-to-kuriru-moji("がっこう"), "гакко:", "Small tsu doubling (Polivanov)";
is kana-to-kuriru-moji("ちょっと", :system<phonetic>), "чотто", "Small tsu with cho sound (Phonetic)";

# Test long vowels in Polivanov
is kana-to-kuriru-moji("とうきょう"), "то:кё:", "Polivanov long vowels with colons";
is kana-to-kuriru-moji("おおきい"), "о:ки:", "Polivanov doubled vowels";

# Test historical kana in Cyrillic
is kana-to-kuriru-moji("ゐゑを"), "вивэо", "Historical wi/we/wo sounds (Cyrillic)";
is kana-to-kuriru-moji("ゔぁゔぃゔぇゔぉ"), "вавивэво", "VU sound variations (Cyrillic)";

# Test modern extensions in Cyrillic
is kana-to-kuriru-moji("ふぁふぃふぇふぉ"), "фафифэфо", "FA-FO sounds (Cyrillic)";
is kana-to-kuriru-moji("てぃでぃ"), "тиди", "TI/DI sounds (Cyrillic)";

# Test various Slavic language systems
is kana-to-kuriru-moji("さくら", :system<ukrainian>), "сакура", "Ukrainian system";
is kana-to-kuriru-moji("さくら", :system<serbian>), "сакура", "Serbian system";
is kana-to-kuriru-moji("さくら", :system<bulgarian>), "сакура", "Bulgarian system";

# Test Gaming and Anime-Manga systems
is kana-to-kuriru-moji("ナルト", :system<anime-manga>), "наруто", "Anime-Manga system";
is kana-to-kuriru-moji("ゲーム", :system<gaming>), "гему", "Gaming system";

# Test new aliases
is kana-to-kuriru-moji("ナルト", :system<anime>), "наруто", "Anime alias";
is kana-to-kuriru-moji("ゲーム", :system<game>), "гему", "Game alias";
is kana-to-kuriru-moji("さくら", :system<ukraine>), "сакура", "Ukraine alias";
is kana-to-kuriru-moji("さくら", :system<ukr>), "сакура", "UKR country code";
is kana-to-kuriru-moji("さくら", :system<serbia>), "сакура", "Serbia alias";
is kana-to-kuriru-moji("さくら", :system<srb>), "сакура", "SRB country code";
is kana-to-kuriru-moji("さくら", :system<srbija>), "сакура", "Srbija native alias";
is kana-to-kuriru-moji("さくら", :system<srbski>), "сакура", "Srbski native alias";
is kana-to-kuriru-moji("さくら", :system<uk>), "сакура", "UK language code";
is kana-to-kuriru-moji("さくら", :system<ukraina>), "сакура", "Ukraina native alias";
is kana-to-kuriru-moji("さくら", :system<ukuraina>), "сакура", "Ukuraina Japanese-in-romaji alias";
is kana-to-kuriru-moji("さくら", :system<serubija>), "сакура", "Serubija Japanese-in-romaji alias";
is kana-to-kuriru-moji("さくら", :system<balgarija>), "сакура", "Balgarija native alias";
is kana-to-kuriru-moji("さくら", :system<burugarija>), "сакура", "Burugarija Japanese-in-romaji alias";
is kana-to-kuriru-moji("さくら", :system<makedonija>), "сакура", "Makedonija native alias";
is kana-to-kuriru-moji("さくら", :system<berarushi>), "сакура", "Berarushi Japanese-in-romaji alias";
is kana-to-kuriru-moji("さくら", :system<mongoru>), "сакура", "Mongoru Japanese-in-romaji alias";
is kana-to-kuriru-moji("さくら", :system<qazaqstan>), "сакура", "Qazaqstan native alias";
is kana-to-kuriru-moji("さくら", :system<kazafusutan>), "сакура", "Kazafusutan Japanese-in-romaji alias";
is kana-to-kuriru-moji("さくら", :system<kirugisutan>), "сакура", "Kirugisutan Japanese-in-romaji alias";
is kana-to-kuriru-moji("はな", :system<ru-petr1708>), "хана", "Pre-revolutionary alias";

# Test Kana to Hangul conversion - Standard (default)
is kana-to-hangul("こんにちは"), "곤니치하", "Basic Standard Hangul conversion";
is kana-to-hangul("ひらがな"), "히라가나", "Standard hiragana conversion";
is kana-to-hangul("カタカナ"), "가다가나", "Standard katakana conversion";
is kana-to-hangul("しんぶん"), "신분", "Standard si/fu sounds";

# Test Academic system
is kana-to-hangul("しんぶん", :system<academic>), "신분", "Academic shi/fu sounds";
is kana-to-hangul("がっこう", :system<academic>), "깍코우", "Academic doubled consonants";
is kana-to-hangul("ばっば", :system<academic>), "빱빠", "Academic ba/pa distinction";

# Test Phonetic system
is kana-to-hangul("しんぶん", :system<phonetic>), "신분", "Phonetic shi/fu sounds";
is kana-to-hangul("ちゃちゅちょ", :system<phonetic>), "치야치유치요", "Phonetic cha/chu/cho sounds";
is kana-to-hangul("きょう", :system<phonetic>), "키요우", "Phonetic combination sounds";

# Test Popular system
is kana-to-hangul("ちゅう", :system<popular>), "추우", "Popular chu sound";
is kana-to-hangul("じゃじゅじょ", :system<popular>), "쟈쥬죠", "Popular ja/ju/jo sounds";
is kana-to-hangul("すず", :system<popular>), "수주", "Popular su/zu sounds";

# Test mixed text (non-kana passthrough)
is kana-to-hangul("Hello こんにちは World"), "Hello 곤니치하 World", "Mixed text Hangul conversion";
is kana-to-hangul("123 あいう ABC"), "123 아이우 ABC", "Numbers and letters passthrough (Hangul)";

# Test small tsu (sokuon) doubling in Hangul
is kana-to-hangul("がっこう"), "각고우", "Small tsu doubling (Standard)";
is kana-to-hangul("ちょっと", :system<phonetic>), "치요쯔토", "Small tsu with cho sound (Phonetic)";

# Test long vowels in Hangul
is kana-to-hangul("とうきょう"), "도우교우", "Standard long vowels";
is kana-to-hangul("おおきい"), "오오기이", "Standard doubled vowels";

# Test historical kana in Hangul
is kana-to-hangul("ゐゑを"), "위웨오", "Historical wi/we/wo sounds (Hangul)";
is kana-to-hangul("ゔぁゔぃゔぇゔぉ"), "바비베보", "VU sound variations (Hangul)";

# Test modern extensions in Hangul
is kana-to-hangul("ふぁふぃふぇふぉ"), "파피페포", "FA-FO sounds (Hangul)";
is kana-to-hangul("てぃでぃ"), "티디", "TI/DI sounds (Hangul)";

# Test various system aliases
is kana-to-hangul("さくら", :system<default>), "사구라", "Default system alias";
is kana-to-hangul("さくら", :system<scholarly>), "사구라", "Scholarly system alias";
is kana-to-hangul("さくら", :system<literal>), "사구라", "Literal system alias";
is kana-to-hangul("さくら", :system<media>), "사구라", "Media system alias";
is kana-to-hangul("さくら", :system<kpop>), "사구라", "K-pop system alias";

done-testing;