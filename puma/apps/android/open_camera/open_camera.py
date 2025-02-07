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
    #     xpath = '//android.widget.ImageButton[@resource-id="net.sourceforge.opencamera:id/switch_camera"]'
    #     button = self.driver.find_element(by=AppiumBy.XPATH, value=xpath)
    #     button.click()

