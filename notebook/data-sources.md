Notes on data sources and data quality
====

GeoNames.org
---

http://www.geonames.org/

We use the asciinames field, filtered to include populated places only.

Problems with GeoNames for China and Mongolia

- inconsistent romanization
	- Mongolian-derived placenames are romanized one way in Mongolia and two other ways in China (one systematic, one not)
	- a few placenames in Mongolia are clearly romanized via Chinese (pinyin or Wade-Giles) 
	- a few placenames in China are romanized using pre-Pinyin systems such as Wade-Giles
- surprisingly small number of data points
	- only 7,000 pp's within Inner Mongolia in GeoNames
	- should be more than twice that many: "Mongolian-Chinese placename correspondence handbook" (2006) lists 14,985 village-level admin units (admin-4)
- distribution of pp's doesn't always correlate with population density
	- anomaly in western Alashan
	- anomaly in northern and eastern Hulunbuir

GeoNames.nga.mil
---

According to [GeoNames documentation](http://www.geonames.org/data-sources.html), 
the original source for most of the non-US names is the US National Geospatial-Intelligence Agency (NGA)

http://geonames.nga.mil/gns/html/index.html

2017/07/14: Using NGA's interactive map, I examined a region along the China-Mongolia border.
It's apparent that placenames in Mongolia are in a very consistent romanization of Cyrillic Mongolian, while Mongolian placenames in China are sometimes in Hanyu Pinyin (i.e. first transliterated into Chinese, then into English), sometimes in a Roman Mongolian orthography (not a transliteration). Chinese placenames in China are in Hanyu Pinyin.
Haven't checked NGA's data thoroughly to see if there are any exceptions--possibly the exceptions in GeoNames came not from NGA but from other data sources.
