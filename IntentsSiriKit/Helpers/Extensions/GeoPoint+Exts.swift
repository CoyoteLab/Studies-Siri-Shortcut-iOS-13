//
//  GeoPoint+Exts.swift
//  IntentsSiriKit
//
//  Created by Stephan Yannick on 01/10/2019.
//  Copyright © 2019 Coyote Lab. All rights reserved.
//

import Foundation
import CoreLocation

// MARK: - GeoPoint extensions

extension GeoPoint {

    /// Distance from GeoPoint location
    /// - Parameter geoPoint: From GeoPoint
    /// - Returns: Returns the lateral distance between two GeoPoint in meters
    public func distance(from geoPoint: GeoPoint) -> DistanceInMeters {
        return self.toCLLocation.distance(from: geoPoint.toCLLocation)
    }

    /// GeoPoint to CLLocationCoordinate2D
    public var toCLLocationCoordinate2D: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    /// This is the half-way point along a great circle path between the two points
    /// http://www.movable-type.co.uk/scripts/latlong.html
    /// - Parameter point: to GeoPoint
    public func midPoint(to point: GeoPoint) -> GeoPoint {
        let lat1 = self.latitude.degreesToRadians
        let lat2 = point.latitude.degreesToRadians
        let lng1 = self.longitude.degreesToRadians
        let lng2 = point.longitude.degreesToRadians

        let bx = cos(lat2) * cos(lng2 - lng1)
        let by = cos(lat2) * sin(lng2 - lng1)
        let λi = atan2(sin(lat1) + sin(lat2),sqrt( (cos(lat1) + bx) * (cos(lat1) + bx) + by * by))
        let φi = lng1 + atan2(by, cos(lat1) + bx)

        return GeoPoint(latitude: λi.radiansToDegrees, longitude: φi.radiansToDegrees)
    }

    /// GeoPoint to CLLocation
    public var toCLLocation: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}
