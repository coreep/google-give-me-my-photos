import sys
sys.path.append('src/')

from login import login
from download import download_photos
from get_browser import get_browser

from playwright.sync_api import sync_playwright
with sync_playwright() as p:
    browser = get_browser(p)
    page = browser.new_page()

    login(page)
    download_photos(page)

    browser.close()
