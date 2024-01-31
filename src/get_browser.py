import config

def get_browser(p):
    return p.chromium.launch_persistent_context(
        config.session_dir,
        args=[
            '--no-sandbox',
            '--disable-setuid-sandbox',
            '--disable-blink-features=AutomationControlled'
        ],
        headless=False,
        chromium_sandbox=False
    )
