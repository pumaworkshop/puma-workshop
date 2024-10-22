"""
In this exercise we will create support for a new app, defining one user action.
To keep things simple, let's start with the cmaera, and write at least one function
for one user action: taking a picture.
"""
from appium.webdriver.common.appiumby import AppiumBy

from puma.apps.android.appium_actions import AndroidAppiumActions


class CameraActions(AndroidAppiumActions):

    def __init__(self, device_udid, appium_server='http://localhost:4723'):
        AndroidAppiumActions.__init__(self,
                                      device_udid,
                                      "CAMERA PACKAGE NAME")

    def take_picture(self):
        """
        Use the self.driver object to execute Appium commands
        """
        self.driver.find_element(by=AppiumBy.XPATH, value='XPATH to camera button')


if __name__ == '__main__':
    camera = CameraActions('your device udid')
    camera.take_picture()
