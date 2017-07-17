Transcription and transliteration of Mongolian names in GIS datasets
===

Romanization of Mongolian names for places in Mongolia
---

The official native names are in Cyrillic Mongolian. The GeoNames dataset does not have Cyrillic, but uses a consistent transliteration of Cyrillic Mongolian for both the "name" and "asciiname" fields. The only difference is that umlaut diacritics are removed in "asciiname".

Romanization of Mongolian names for places in China
---

The official native names exist in Chinese characters and Traditional Mongolian.

The main system used for writing Mongolian placenames in GeoNames and NGA datasets appears to be the official one promulgated by the PRC for placenames. [Wikipedia](https://en.wikipedia.org/wiki/SASM/GNC_romanization) calls it the SASM-GNC romanization.
However, *only about half the Mongolian placenames in GeoNames use the GNC romanization* (my impressionistic estimate from scrolling through and classifying).
The others use pure Hanyu Pinyin, which we can call "character-to-pinyin" romanization.

### Official SASM-GNC Romanization (GNC for short)

The GNC romanization is not actually a transliteration of Mongolian orthography. 
Instead, it is a broad phonetic transcription of the standard Chakhar (Qahar) dialect. 
The phonetic values of the roman alphabet symbols are derived from their usage in Hanyu Pinyin (Pinyin for Chinese), which means some consonant symbols like Q and X refer to very different sounds than they would in other systems like English, Russian or IPA. (Not a problem in itself, just something to note.)

- Chinese government agencies/committees involved in this romanization: (name changes in chronological order)
    - 国家测绘总局、国家测绘局、国家测绘地理信息局
    - 中国地名委员会
    - 中国文字改革委员会、国家语言文字工作委员会

### "Character-to-Pinyin" romanization of Mongolian names via Chinese characters

Sometimes, the romanization of a Mongolian name is created by transcribing into Chinese characters and then transliterating the Chinese characters according to a Chinese transliteration scheme such as Hanyu Pinyin.

Why it happens:

- China's official placename records and geographic information databases are primarily kept in Chinese character form.
- Generating a proper GNC transcription requires Mongolian language expertise as well as GNC expertise. If the GNC transcription is missing for a particular placename, mapmakers and record keepers may have to fall back on the Chinese character form (which will never be missing).
- In the GIS datasets, spacing and capitalization often correspond to the proper word breaks in Mongolian, suggesting that some record keepers knew Mongolian but not GNC.

How it "works":

- The Chinese character transcription is typically based on the Mongolian pronunciation, not spelling.
	- There is no consistent or agreed-upon system for this transcription that I know of, although there are some informal conventions.
	- It follows that dialect variation in both Mongolian and Chinese can affect the transcription.
- There tends to be a one-to-many correspondence from Mongolian to Chinese. If you ask a Mongolian speaker to write down the name of their hometown in Chinese characters, they might choose different characters than are on the official map (I have performed this experiment many times).
- The number of possible alternatives is reduced once the characters are transliterated to Pinyin and the tone marks removed (as in our ASCII data), though there are still multiple forms for practically any Mongolian word.
- There tends to be a many-to-one correspondence from Chinese to Mongolian. A person familiar with the conventions can usually guess the Mongolian word from the Chinese characters. Guessing does require familiarity with the Mongolian lexicon (phonology is not enough).

Sources of distortion (loss of phonological information):

- The main source of distortion in transcription is that Chinese has a rigid (C)(G)V(N) syllable structure while Mongolian has a more flexible structure that allows C codas and C clusters.
- A secondary source of distortion is the mismatches between segment inventories (lack of direct mapping between phonemes).
- A third source of distortion is the loss or corruption of word boundary information, since Chinese characters are written without spaces

### Examples of some common geographical feature words and their transliteration space
- "spring": Mongolian *bulaɣ*, GNC *bulag*, Cyrillic *булаг bulag*, toneless Pinyin *bulage*, *baoligao*, *baolege*, etc.
- "rich in, a lot of": Mongolian *bayan*, GNC *bayan*, Cyrillic *баян bayan*, toneless Pinyin *bayan*, *baiyin*, *baiyan*, etc.
- "mountain": Mongolian *aɣula*, GNC *ul*, Cyrillic *уул uul*, toneless Pinyin *wula*
- "cairn": Mongolian *oboɣ-a*, GNC *obo*, Cyrillic *овоо ovoo*, toneless Pinyin *aobao*

Combining Mongolian and Chinese words in placenames
---

- Redundant form
	- Ul Shan: Mongolian *ul* "mountain" plus Chinese *shan* "mountain"
- Mongolian name plus Chinese admin unit label
	- Ar Horqin Qi: Mongolian *ar horqin* "rear Horchin" plus Chinese *qi* "banner" (Mongolian name in GNC: Ar Horqin Huxu)

Comparing Romanization of Mongolian names in China vs. Mongolia
---

1. Phonological differences between Khalkha and Chakhar Mongolian

- Affricate depalatalization: 
	- Khalkha /ts tʃ/ → Chakhar /tʃ/ 
	- Khalkha /tsʰ tʃʰ/ → Chakhar /tʃʰ/
	- Affects the letters <ts, ch, dz, z, j> in Romanized Cyrillic Mongolian, <q j> in GNC, and <c ch z zh j q> in Character-to-Pinyin.
	- For our analysis, tranforming <ts>,<ch> to <q> and <dz>,<j> to <j> is adequate to make the Cyrillic source match the GNC. 
	- <z> and <dz> are two alternative Romanizations of the same letter <з>. The GIS datasets primarily use <dz> although there are a few cases of <z> like Zamiin-Uud.

2. Transcriptional differences

- Diphthongs ending in [i]: Romanized Cyrillic uses <y>, e.g. <ay> <oy>. GNC uses [i], e.g. <ai>, <oi>. Character-to-Pinyin usually uses [i], as in <ai>, but often the first vowel is modified, e.g. the <oi> sequence does not exist in the Chinese inventory so <ai> may be used instead, e.g. GNC <tohoi> usually becomes Character-to-Pinyin <tuhai>.
	- For our analysis, I don't know if it's safe to transform all <ay> into <ai>, etc., or if we would need to take account of syllable boundaries. For example, the word <bayan> would be incorrectly transformed in to <baian> if we used that rule.
- Long vowels: Romanized Cyrillic uses double vowel symbols to indicate phonologically long vowels in Mongolian. GNC uses single vowel symbols for both long and short vowels. There is a more detailed variant of GNC that uses double vowel symbols for long vowels, however the vast majority of Inner Mongolian placenames in GeoNames appear to use the single-vowel approach. Character-to-Pinyin does not take account of vowel length.
	- For our analysis, transforming all double vowels in Mongolia to single vowels is adequate.
- Bilabial stop vs. fricative: Mongolian phonology reduces bilabial stops to fricatives or approximants in intervocalic or coda position. Cyrillic orthography represents the different forms differently. The romanizations used in China represent them all the same.
	- For our analysis, transforming <v> to <b> is adequate to make Romanized Cyrillic match GNC.
