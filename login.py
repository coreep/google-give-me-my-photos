from playwright.sync_api import sync_playwright
from get_browser import get_browser;

def login(page):
    page.goto('https://photos.google.com/login')

    if 'https://photos.google.com' in page.url:
        print('We are on photos page. No need to login')
        return

    while 'https://photos.google.com' not in page.url:
        print('Complete login')
        page.pause()

if __name__ == "__main__":
    with sync_playwright() as p:
        browser = get_browser(p)
        page = browser.new_page()

        login(page)

        browser.close()
