from playwright.sync_api import sync_playwright
from get_browser import get_browser
import config

def load_progress():
    print("Reading progress file")
    try:
        with open(config.progress_file, 'r') as progress_file:
            processed_files_info = progress_file.read()
        processed_files = [f.split()[0] for f in processed_files_info.strip().split('\n')]
        print(f'{len(processed_files)} files processed')
    except IOError:
        print('Progress file does not exist')
        processed_files = []

    return processed_files


def download_photos(page):
    page.goto('https://photos.google.com')
    if 'https://photos.google.com' not in page.url:
        print('Something went wrong. {page.url} has been opened')
        return

    processed_files = load_progress()
    current_file = None
    last_file = None

    while True:
        page.keyboard.press('ArrowRight')
        page.wait_for_timeout(100)

        page.keyboard.press('Enter')
        page.wait_for_timeout(1000)

        current_file = page.url.split('/')[-1]

        if current_file == last_file:
            print('The last file processed. Done')
            break

        if current_file in processed_files:
            print(f'Skipping file {current_file}')
            page.keyboard.press('Escape')
            page.wait_for_timeout(1000)
            continue

        with page.expect_download() as download_info:
            page.keyboard.down('Shift')
            page.keyboard.press('d')
            page.keyboard.up('Shift')
            download = download_info.value
            download.save_as(config.downloads_dir + download.suggested_filename)

        print(f'Saved file {current_file} as {download.suggested_filename}')
        with open(config.progress_file, 'a+') as progress_file:
            progress_file.write(f'{current_file} {download.suggested_filename}\n')

        processed_files.append(current_file)
        last_file = current_file

        page.wait_for_timeout(1000)

        page.keyboard.press('Escape')
        page.wait_for_timeout(1000)

if __name__ == "__main__":
    with sync_playwright() as p:
        browser = get_browser(p)
        page = browser.new_page()

        download_photos(page)

        browser.close()
