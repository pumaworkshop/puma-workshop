import time

from puma.apps.android.google_maps.google_maps import GoogleMapsActions

if __name__ == '__main__':
    """
    This is a very short but fun demo, showing the location spoofing possibilities in Puma.
    I added it this morning :) 
    """
    device_udid = 'This is the id of tour device, execute "avd devices"'
    start_location = 'enter some specific address'
    destination = 'enter some other address'

    maps = GoogleMapsActions(device_udid)
    maps.start_route(start_location, destination, speed=50)
    # we need to let the program sleep to be able to see something happening
    time.sleep(20)
    # drive faster?
    maps.route_simulator.update_speed(100)
    time.sleep(60)
