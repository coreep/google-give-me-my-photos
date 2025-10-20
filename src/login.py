from get_browser import get_browser;

def login(page):
    page.goto('https://photos.google.com/login')

    if 'https://photos.google.com' in page.url:
        print('We are on photos page. No need to login')
        return

    print('Complete login manually in browser')
    page.wait_for_url('https://photos.google.com/?pli=1')
    print('Login successuly completed')

if __name__ == "__main__":
    from playwright.sync_api import sync_playwright

    with sync_playwright() as p:
        browser = get_browser(p)
        page = browser.new_page()

        login(page)

        browser.close()
