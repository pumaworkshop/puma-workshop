import threading
import time
from time import sleep

import geopy.distance
import gpxpy
from appium.webdriver.webdriver import WebDriver
from geopy import Point
from gpxpy.gpx import GPXTrackPoint


class GpsUtils:

    def __init__(self, driver: WebDriver):
        self._seconds_per_hour = 3600
        self._updates_per_second = 1
        self._current_speed = 80
        self._next_point = None
        self._point_updated = False
        self.driver = driver
        self._current_location: Point = None
        self._next_locations: [Point] = None
        self._last_location_update = None

    def _load_gpx(self, gpx_file: str):
        points: [GPXTrackPoint] = []
        with open(gpx_file, 'r') as opened_file:
            gpx = gpxpy.parse(opened_file)
            for track in gpx.tracks:
                for segment in track.segments:
                    points.extend(segment.points)
        self._next_locations = [Point(p.latitude, p.longitude, p.elevation) for p in points]
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
            self._last_location_update = now
            self.set_location(self._current_location.latitude,
                              self._current_location.longitude,
                              self._current_location.altitude,
                              self._current_speed)
            return
        time_elapsed = now - self._last_location_update
        print(f'time elapsed {time_elapsed}')
        distance_to_travel = time_elapsed * ((self._current_speed * 1000) / 3600)
        self._travel_distance(distance_to_travel)
        print(f"setting location to {self._current_location}")
        self._last_location_update = now
        self.set_location(self._current_location.latitude,
                          self._current_location.longitude,
                          self._current_location.altitude,
                          self._current_speed)

    def _extrapolate_over_points(self, file: str):
        distance_to_travel = (self._updates_per_second * ((self._current_speed * 1000) / self._seconds_per_hour))
        distance_travelled = 0
        gpx = gpxpy.parse(open(file, 'r'))
        for track in gpx.tracks:
            for segment in track.segments:
                point_index = 0
                points = segment.points
                current_position = points[point_index]
                yield current_position.latitude, current_position.longitude, current_position.elevation
                while point_index + 1 < len(points):
                    next_travel_point = points[point_index + 1]
                    distance_to_next_travel_point = geopy.distance.geodesic(
                        (current_position.latitude, current_position.longitude),
                        (next_travel_point.latitude, next_travel_point.longitude)).m
                    if distance_to_next_travel_point < distance_to_travel - distance_travelled:
                        distance_travelled += distance_to_next_travel_point
                        current_position = next_travel_point
                        point_index += 1
                    else:
                        percent_to_go = (distance_to_travel - distance_travelled) / distance_to_next_travel_point
                        x_dist = abs(float(current_position.latitude) - float(next_travel_point.latitude))
                        y_dist = abs(float(current_position.longitude) - float(next_travel_point.longitude))
                        if current_position.latitude > next_travel_point.latitude:
                            next_x = current_position.latitude - x_dist * percent_to_go
                        else:
                            next_x = current_position.latitude + x_dist * percent_to_go
                        if current_position.longitude > next_travel_point.longitude:
                            next_y = current_position.longitude - y_dist * percent_to_go
                        else:
                            next_y = current_position.longitude + y_dist * percent_to_go
                        distance_travelled = 0
                        current_position = GPXTrackPoint(next_x, next_y, current_position.elevation)
                        yield current_position.latitude, current_position.longitude, current_position.elevation
                        distance_to_travel = (
                                self._updates_per_second * ((self._current_speed * 1000) / self._seconds_per_hour))

    def _calculate_next_point(self, file):
        for point in self._extrapolate_over_points(file):
            while self._point_updated:
                sleep(.1)
            self._next_point = point
            self._point_updated = True

    # def _update_location(self):
    #     while True:
    #         if self._point_updated:
    #             point = self._next_point
    #             threading.Timer(1, function=self.set_location,
    #                             args=(point[0], point[1], point[2], self._current_speed, 6)).start()
    #             self._point_updated = False
    #             sleep(1)

    def execute_route(self, file: str):
        producer_thread = threading.Thread(target=self._calculate_next_point, args=(file,))
        producer_thread.daemon = True
        producer_thread.start()
        consumer_thread = threading.Thread(target=self._update_location)
        consumer_thread.daemon = True
        consumer_thread.start()

    def _do_entire_route(self):
        while self._next_locations:
            self._update_location()
            sleep(1)

    def execute_route2(self, gpx_file: str):
        self._load_gpx(gpx_file)
        consumer_thread = threading.Thread(target=self._do_entire_route)
        consumer_thread.daemon = True
        consumer_thread.start()

    def update_speed(self, speed: float):
        self._current_speed = speed

    def set_location(self, lat: float, lon: float, alt: float = 0, speed: float = 0, num_sat: float = 0):
        self.driver.set_location(lat, lon, alt, speed, num_sat)
