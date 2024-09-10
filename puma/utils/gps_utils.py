import threading

import geopy.distance
import gpxpy
from time import sleep
from appium.webdriver.webdriver import WebDriver
from gpxpy.gpx import GPXTrackPoint


class GpsUtils:

    def __init__(self, driver: WebDriver):
        self._seconds_per_hour = 3600
        self._updates_per_second = 1
        self._current_speed = 80
        self._next_point = None
        self._point_updated = False
        self.driver = driver

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
                    distance_to_next_travel_point = geopy.distance.geodesic((current_position.latitude, current_position.longitude), (next_travel_point.latitude, next_travel_point.longitude)).m
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
                        distance_to_travel = (self._updates_per_second * ((self._current_speed * 1000) / self._seconds_per_hour))

    def _calculate_next_point(self, file):
        for point in self._extrapolate_over_points(file):
            while self._point_updated:
               sleep(.1)
            self._next_point = point
            self._point_updated = True

    def _update_location(self):
        while True:
            if self._point_updated:
                point = self._next_point
                threading.Timer(1, function=self.set_location, args=(point[0], point[1], point[2], self._current_speed, 6)).start()
                self._point_updated = False
                sleep(1)

    def execute_route(self, file: str):
        producer_thread = threading.Thread(target=self._calculate_next_point, args=(file,))
        producer_thread.daemon = True
        producer_thread.start()
        consumer_thread = threading.Thread(target=self._update_location)
        consumer_thread.daemon = True
        consumer_thread.start()

    def update_speed(self, speed: float):
        self._current_speed = speed

    def set_location(self, lat: float, lon: float, alt: float=0, speed: float=0, num_sat: float=0):
        self.driver.set_location(lat, lon, alt, speed, num_sat)

