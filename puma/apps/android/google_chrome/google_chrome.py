from time import sleep
from typing import Dict

from appium.webdriver.common.appiumby import AppiumBy

from puma.apps.android.appium_actions import AndroidAppiumActions

GOOGLE_CHROME_PACKAGE = 'com.android.chrome'

class GoogleChromeActions(AndroidAppiumActions):
    def __init__(self,
                 device_udid,
                 desired_capabilities: Dict[str, str] = None,
                 impicit_wait=1,
                 appium_server='http://localhost:4723'):
        AndroidAppiumActions.__init__(self,
                                      device_udid,
                                      GOOGLE_CHROME_PACKAGE,
                                      desired_capabilities=desired_capabilities,
                                      implicit_wait=impicit_wait,
                                      appium_server=appium_server)

    def go_to(self, url_string: str, new_tab: bool = False):
        if self.is_present('//android.widget.LinearLayout[@resource-id="com.android.chrome:id/search_box"]'):
            self.driver.find_element(by=AppiumBy.XPATH, value='//android.widget.LinearLayout[@resource-id="com.android.chrome:id/search_box"]').click()

        if new_tab:
            self.driver.find_element(by=AppiumBy.XPATH, value='//android.widget.ImageButton[@content-desc="Switch or close tabs"]').click()
            self.driver.find_element(by=AppiumBy.XPATH, value='//android.widget.TextView[@resource-id="com.android.chrome:id/new_tab_view_desc"]').click()
            self.driver.find_element(by=AppiumBy.XPATH, value='//android.widget.LinearLayout[@resource-id="com.android.chrome:id/search_box"]').click()

        element = self.driver.find_element(by=AppiumBy.XPATH, value='//android.widget.EditText[@resource-id="com.android.chrome:id/url_bar"]')
        element.click()
        element.send_keys(url_string)
        self.driver.press_keycode(66)

    def bookmark_page(self):
        self.driver.find_element(by=AppiumBy.XPATH, value='//android.widget.ImageButton[@content-desc="Customize and control Google Chrome"]').click()
        self.driver.find_element(by=AppiumBy.XPATH, value='//android.widget.ImageButton[@content-desc="Bookmark"]').click()

    def load_bookmark(self):
        self.driver.find_element(by=AppiumBy.XPATH, value='//android.widget.ImageButton[@content-desc="Customize and control Google Chrome"]').click()
        self.driver.find_element(by=AppiumBy.XPATH, value='//android.widget.TextView[@resource-id="com.android.chrome:id/menu_item_text" and @text="Bookmarks"]').click()
        if self.is_present('//android.widget.TextView[@resource-id="com.android.chrome:id/title" and @text="Mobile bookmarks"]'):
            self.driver.find_element(by=AppiumBy.XPATH, value='//android.widget.TextView[@resource-id="com.android.chrome:id/title" and @text="Mobile bookmarks"]').click()
        self.driver.find_element(by=AppiumBy.XPATH, value='//android.widget.LinearLayout[@resource-id="com.android.chrome:id/container"]').click()

    def switch_to_tab(self, num_tab: int = 1):
        self.driver.find_element(by=AppiumBy.XPATH, value='//android.widget.ImageButton[@content-desc="Switch or close tabs"]').click()
        self.driver.find_element(by=AppiumBy.XPATH, value=f'(//android.widget.FrameLayout[@resource-id="com.android.chrome:id/content_view"])[{num_tab}]').click()

    def go_to_incognito(self, url_string: str):
        self.driver.find_element(by=AppiumBy.XPATH, value='//android.widget.ImageButton[@content-desc="Customize and control Google Chrome"]').click()
        self.driver.find_element(by=AppiumBy.XPATH, value='//android.widget.TextView[@resource-id="com.android.chrome:id/title" and @text="New Incognito tab"]').click()
        self.go_to(url_string)


if __name__ == "__main__":
    chrome_actions = GoogleChromeActions("emulator-5554")
    sleep(1)
    chrome_actions.go_to("google.com")
    chrome_actions.bookmark_page()
    chrome_actions.go_to("en.wikipedia.org")
    chrome_actions.go_to("www.imdb.com", True)
    chrome_actions.load_bookmark()
    chrome_actions.switch_to_tab()
    chrome_actions.go_to_incognito("DFRWS is awesome!")
