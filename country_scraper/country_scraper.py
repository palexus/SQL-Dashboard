
import scrapy
import re
from itertools import count
from dataclasses import dataclass
from scrapy.exporters import CsvItemExporter


SOVEREIGN_STATES = 'https://en.wikipedia.org/wiki/List_of_sovereign_states'

TABOO_KEYWORDS = {
    'Edit links', 'Terms of Use', 'Privacy Policy','Disclaimers', 'Developers',
    'Cookie statement', 'All articles needing additional references',
}

gen_country_id = count(1)
gen_keyword_id = count(1)


@dataclass
class Country:
    """Container for country data"""
    id: int
    title: str
    country_name: str
    capital: str
    population: int
    iso_3166: str


@dataclass
class Keyword:
    """Container for keyword data"""
    id: int
    country_id: int
    keyword: str


class CSVPipeline:
    """
    Helper class for exporting to multiple CSV files
    """
    def __init__(self, filename):
        self.file = open(filename, 'wb')
        self.exporter = CsvItemExporter(self.file)
        self.exporter.start_exporting()

    def process_item(self, item):
        """Writes an item to the CSV file"""
        self.exporter.export_item(item)
    
    def close(self):
        """
        Closes the CSV file
        (the CSV file objects are memory-buffered, Scrapy does not save all data by itself)
        """
        self.exporter.finish_exporting()
        self.file.close()


class WikiCountrySpider(scrapy.Spider):
    """
    Extracts data on all countries and writes them to CSV files.
    """
    
    name = 'wikipedia_country_spider'
    start_urls = [SOVEREIGN_STATES]
    download_delay = 0.5

    country_pipe = CSVPipeline('countries.csv')
    keyword_pipe = CSVPipeline('keywords.csv')

    def closed(self, reason):
        """called when the """
        self.country_pipe.close()
        self.keyword_pipe.close()

    def get_title(self, response):
        return response.xpath('//h1/text()').get()

    def get_country_name(self, box):
        return box.css('.country-name').xpath("./text()").get()

    def get_capital(self, box):
        return box.xpath('//tr[contains(., "Capital")]/td/a/text()').get()

    def get_population(self, box):
        prevpop = False
        for poptr in box.xpath('//tr').getall():
            if prevpop:
                pop = re.findall('[0-9,]{5,}', poptr)
                return int(''.join(pop[:1]).replace(',', ''))
            elif 'Population' in poptr:
                prevpop = True

    def get_iso3166(self, box):
        return box.xpath('//tr[contains(., "ISO 3166")]/td/a/text()').get()

    def get_keywords(self, response):
        return response.xpath('//a[contains(@href, "/wiki/")]/text()').getall()

    def extract_country(self, response):
        """Country info mainly from the box on the right side of the page"""
        box = response.selector.css('.infobox')
        country = Country(
            id = next(gen_country_id),
            title = self.get_title(box),
            country_name = self.get_country_name(box),
            capital = self.get_capital(box),
            population = self.get_population(box),
            iso_3166 = self.get_iso3166(box),
        )
        self.country_pipe.process_item(country)
        return country

    def skip_keyword(self, kw):
        """Remove some dumb words"""
        if (
            len(kw) < 5 or
            re.match(r'^\d+th$', kw) or
            kw.startswith('Article') or
            kw.startswith('Creative Commons') or
            kw.startswith('All articles') or
            kw.startswith('Pages ') or
            kw.startswith('Use ') or
            'Wikipedia' in kw or
            kw in TABOO_KEYWORDS
        ):
            return True

    def extract_keywords(self, response, country):
        """All words that link to other Wikipedia articles"""
        for kw in self.get_keywords(response):
            if self.skip_keyword(kw):
                continue
            keyword = Keyword(
                    id = next(gen_keyword_id),
                    country_id = country.id,
                    keyword = kw.lower()
                )
            self.keyword_pipe.process_item(keyword)

    def parse_country(self, response):
        """process a country page"""
        country = self.extract_country(response)
        self.extract_keywords(response, country)
    
    def parse(self, response):
        """Extract and follow all links from the Wikipedia table of states"""
        country_links = response.xpath('//b/a[contains(@href, "/wiki/")]/@href')
        for url in country_links.getall():
            if url.startswith('/wiki/'):
                yield response.follow(url, self.parse_country)
