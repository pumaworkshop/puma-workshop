import random
import threading
import time
from time import sleep
from typing import Optional, Callable

import geopy.distance
import gpxpy
import requests
from appium.webdriver.webdriver import WebDriver
from geopy import Point
from gpxpy.gpx import GPXTrackPoint


class GpsUtils:

    def __init__(self, driver: WebDriver,
                 target_speed: int,
                 absolute_speed_variance: int = None,
                 relative_speed_variance: float = None):
        # static settings
        self.location_update_interval = 1
        # dynamic fields
        self.driver = driver
        # initial speed is 0
        self.update_speed(target_speed,
                          variance_absolute=absolute_speed_variance,
                          variance_relative=relative_speed_variance)
        # fields relating to current and future locations
        self._next_point = None
        self._current_location: Optional[Point] = None
        self._next_locations: [Point] = []
        self._last_location_update: Optional[float] = None

    def _load_gpx(self, gpx_file: str):
        points: [GPXTrackPoint] = []
        with open(gpx_file, 'r') as opened_file:
            gpx = gpxpy.parse(opened_file)
            for track in gpx.tracks:
                for segment in track.segments:
                    points.extend(segment.points)
        # transform GPXTrackPoint to Point objects. Do not include p.elevation because calculating distances between
        # points with an elevation is not supported by geopy
        self._next_locations = [Point(p.latitude, p.longitude, 0) for p in points]
        self._current_location = None

    def _travel_distance(self, distance_to_travel):
        # only travel if there's a waypoint as next location, and if distance is > 0
        if not self._next_locations or distance_to_travel <= 0:
            return
        distance_to_next_point = geopy.distance.geodesic(self._current_location, self._next_locations[0]).m

        if distance_to_next_point < distance_to_travel:
            self._current_location = self._next_locations.pop(0)
            self._travel_distance(distance_to_travel - distance_to_next_point)
        else:
            percent_to_go = distance_to_travel / distance_to_next_point
            pos1 = self._current_location
            pos2 = self._next_locations[0]
            next_pos = Point(
                pos1.latitude + (pos2.latitude - pos1.latitude) * percent_to_go,
                pos1.longitude + (pos2.longitude - pos1.longitude) * percent_to_go,
                pos1.altitude + (pos2.altitude - pos1.altitude) * percent_to_go
            )
            self._current_location = next_pos

    def _update_location(self):
        if not self._next_locations:
            return
        now = time.time()
        if not self._current_location:
            self._current_location = self._next_locations.pop(0)
        else:
            time_elapsed = now - self._last_location_update
            # calculate current speed with variance
            self._current_speed = random.uniform(self._target_speed_lower_bound, self._target_speed_upper_bound)
            distance_to_travel = time_elapsed * ((self._current_speed * 1000) / 3600)  # km/h to m/s
            self._travel_distance(distance_to_travel)
        self._last_location_update = now

    def _update_appium_location(self):
        self.driver.set_location(self._current_location.latitude,
                                 self._current_location.longitude,
                                 self._current_location.altitude,
                                 self._current_speed, 5)

    def _route_loop(self):
        while self._next_locations:
            start = time.time()
            self._update_location()
            stop = time.time()
            delay = stop - start
            sleep(max(self.location_update_interval - delay, 0.1))

    def _appium_loop(self):
        while self._current_location:
            start = time.time()
            self._update_appium_location()
            stop = time.time()
            delay = stop - start
            sleep(max(self.location_update_interval - delay, 0.1))

    def execute_route_with_gpx(self, gpx_file: str):
        self._load_gpx(gpx_file)
        self._start_route()

    def execute_route_with_points(self, point_list: [Point]):
        """
        This method executes a route by updating the GPS location of the device.
        The points it will follow are defined in the list provided by the user.
        :param point_list: the list with points of the route
        """
        self._next_locations = point_list
        self._current_location = None
        self._start_route()

    def execute_route_with_queries(self, start_loc: str, destination: str, transport_mode: str, start_visual_function: Callable[[str, str], None] = None):
        """
        This method executes a route by updating the GPS location of the device.
        The points this route will follow are calculated based upon the two locations provided by the user.
        The locations will be queried with nominatim, the route is calculated with OSM, and the nodes
        are translated by Overpass.
        :param start_loc: the location to start from as string value
        :param destination: the destination location as string value
        :param transport_mode: the mode of transportation that is used, this can only be: 'car', 'foot', or 'bike'
        :param start_visual_function: an optional method that will be called after the route is calculated, but before the route points are being updated,
        this can be used to start the directions in a navigation based application after the start location has been set.
        """
        config = dict(user_agent="Maps")
        cls = geopy.get_geocoder_for_service("nominatim")
        geocoder = cls(**config)
        start_location = geocoder.geocode(start_loc)
        destination_location = geocoder.geocode(destination)
        start_lat = start_location.latitude
        start_lon = start_location.longitude
        end_lat = destination_location.latitude
        end_lon = destination_location.longitude
        self.driver.set_location(start_lat, start_lon)

        URL = f"http://router.project-osrm.org/route/v1/{transport_mode}/{start_lon},{start_lat};{end_lon},{end_lat}?alternatives=false&annotations=nodes"  # car / bike / foot
        r = requests.get(url=URL)
        data = r.json()
        nodes = data["routes"][0]["legs"][0]["annotation"]["nodes"]
        overpass_query = f"[out:json];({''.join('node(' + str(x) + ');' for x in nodes)});(._;>;);out;"
        r2 = requests.post(url='https://overpass-api.de/api/interpreter', verify=False, data=overpass_query)
        data2 = r2.json()

        point_dict = {}
        point_list = []
        for element in data2['elements']:
            point_dict.update({element['id']: Point(element['lat'], element['lon'])})
        for x in nodes:
            point_list.append(point_dict.get(x))

        if start_visual_function is not None:
            start_visual_function(destination, transport_mode)
        self.execute_route_with_points(point_list)

    def _start_route(self):
        consumer_thread = threading.Thread(target=self._route_loop)
        consumer_thread.daemon = True
        consumer_thread.start()
        consumer_thread = threading.Thread(target=self._appium_loop)
        consumer_thread.daemon = True
        consumer_thread.start()

    def stop_route(self):
        self._next_locations = None
        self._current_location = None

    def update_speed(self, speed: float, variance_absolute: int = 0, variance_relative: float = 0.0):
        """
        Updates the speed at which the route is being traveled. Optionally, the speed can be variable by giving
        either an absolute or relative variance.
        This method can be called to update the speed as a route is being traveled.
        :param speed: The (average) speed the route will be traversed.
        :param variance_absolute: The absolute variance in speed. A value of 5 means the speed will vary between -5kmph
        and +5kmph of the given speed.
        :param variance_relative: The relative variance in speed. A value of 0.05 means the speed will vary between 95%
        and 105% of the given speed.
        """
        self._current_speed = speed
        if variance_absolute:
            self._target_speed_lower_bound = max(0.0, speed - variance_absolute)
            self._target_speed_upper_bound = max(0.0, speed + variance_absolute)
            return
        if variance_relative:
            self._target_speed_lower_bound = speed * max(0.0, 1 - variance_relative)
            self._target_speed_upper_bound = speed * max(0.0, 1 + variance_relative)
            return
        # no variance: constant speed
        self._target_speed_lower_bound = speed
        self._target_speed_upper_bound = speed
