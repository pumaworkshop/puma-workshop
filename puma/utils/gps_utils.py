import threading
import time
from time import sleep
from typing import Optional

import geopy.distance
import gpxpy
from appium.webdriver.webdriver import WebDriver
from geopy import Point
from gpxpy.gpx import GPXTrackPoint


class GpsUtils:

    def __init__(self, driver: WebDriver):
        self._current_speed = 80
        self._next_point = None
        self._point_updated = False
        self.driver = driver
        self._current_location: Optional[Point] = None
        self._next_locations: [Point] = []
        self._last_location_update = None

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
            distance_to_travel = time_elapsed * ((self._current_speed * 1000) / 3600)  # km/h to m/s
            self._travel_distance(distance_to_travel)
        self._last_location_update = now
        self.set_appium_location(self._current_location.latitude,
                                 self._current_location.longitude,
                                 self._current_location.altitude,
                                 self._current_speed)

    def _route_loop(self):
        while self._next_locations:
            self._update_location()
            sleep(1)

    def execute_route(self, gpx_file: str):
        self._load_gpx(gpx_file)
        consumer_thread = threading.Thread(target=self._route_loop)
        consumer_thread.daemon = True
        consumer_thread.start()

    def update_speed(self, speed: float):
        self._current_speed = speed

    def set_appium_location(self, lat: float, lon: float, alt: float = 0, speed: float = 0, num_sat: float = 0):
        self.driver.set_location(lat, lon, alt, speed, num_sat)
