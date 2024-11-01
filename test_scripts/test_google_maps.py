import unittest
from time import sleep

from puma.apps.android.google_maps.google_maps import GoogleMapsActions, TransportType

# Fill in the udid below. Run ADB devices to see the udids.
device_udids = {
    "Alice": ""
}


class TestGoogleMaps(unittest.TestCase):
    """
    With this test, you can check whether all Appium functionality works for the current version of Google Maps.
    The test can only be run manually, as you need a setup with at least one but preferably two phones.

    Prerequisites:
    - All prerequisites mentioned in the README.
    - Phone with Google Maps installed
    """

    @classmethod
    def setUpClass(self):
        if not device_udids["Alice"]:
            print("No udid was configured for Alice. Please add at the top of the script.\nExiting....")
            exit(1)
        self.alice = GoogleMapsActions(device_udids["Alice"])

    def test_search(self):
        self.alice.search_place('Eiffel Tower')
        self.alice.search_place('Laan van ypenburg 6, The Hague')
        self.alice.search_place('52°35\'05.6"N 5°22\'53.2"E')

    def test_navigation(self):
        self.alice.start_navigation('Tower Bridge, London')
        self.alice.start_navigation('Eiffel Tower', transport_type=TransportType.BIKE)
        self.alice.start_navigation('Atomium', time_to_wait=5)

    def test_route(self):
        self.alice.start_route(from_query='Laan van ypenburg 6', to_query='Eiffel Tower', speed=100)
        sleep(10)
        self.alice.route_simulator.update_speed(50)
        sleep(10)
        self.alice.route_simulator.update_speed(0)
        sleep(5)
        self.alice.route_simulator.update_speed(100, variance_absolute=10)
        sleep(10)
        self.alice.route_simulator.stop_route()


if __name__ == '__main__':
    unittest.main()
