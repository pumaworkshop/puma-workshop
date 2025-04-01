from typing import Dict

from appium.webdriver.common.appiumby import AppiumBy

from puma.apps.android.appium_actions import AndroidAppiumActions

OPEN_CAMERA_PACKAGE = 'net.sourceforge.opencamera'


class OpenCameraActions(AndroidAppiumActions):
    def __init__(self,
                 device_udid,
                 desired_capabilities: Dict[str, str] = None,
                 implicit_wait=1,
                 appium_server='http://localhost:4723'):
        AndroidAppiumActions.__init__(self,
                                      device_udid,
                                      OPEN_CAMERA_PACKAGE,
                                      desired_capabilities=desired_capabilities,
                                      implicit_wait=implicit_wait,
                                      appium_server=appium_server)

    def take_picture(self):
        xpath = '//android.widget.ImageButton[@resource-id="net.sourceforge.opencamera:id/take_photo"]'
        shutter = self.driver.find_element(by=AppiumBy.XPATH, value=xpath)
        shutter.click()

    # def switch_camera(self):
    #     # raise NotImplementedError
    #     xpath = ('//android.widget.ImageButton['
    #              '@content-desc="Switch to front camera" or '
    #              '@content-desc="Switch to back camera"]')
    #     switch_camera_button = self.driver.find_element(by=AppiumBy.XPATH, value=xpath)
    #     switch_camera_button.click()

    # def take_video(self, duration):
    #     xpath = '//android.widget.ImageButton[@content-desc="Switch to video mode"]'
    #     if self.is_present(xpath):
    #         video_mode_button = self.driver.find_element(by=AppiumBy.XPATH, value = xpath)
    #         video_mode_button.click()
    #     else:
    #         print("already in video mode")
    #     self.take_picture()
    #     sleep(duration)
    #     self.take_picture()

    # def zoom(self, zoom_amount):
    #     xpath = '//android.widget.SeekBar[@content-desc="Zoom"]'
    #     zoom_slider = self.driver.find_element(by=AppiumBy.XPATH, value=xpath)
    #     x = zoom_slider.location.get('x')
    #     y = zoom_slider.location.get('y')
    #     width = zoom_slider.size.get('width')
    #     height = zoom_slider.size.get('height')
    #     x_to_tap = x + (width//2)
    #     y_to_tap = y + (height * (1-zoom_amount))
    #     self.driver.tap([(x_to_tap, y_to_tap)])