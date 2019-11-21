//
//  CLLocationCoordinate2D+Exts.swift
//  IntentsSiriKit
//
//  Created by Stephan Yannick on 19/08/2019.
//  Copyright © 2019 Stephan Yannick. All rights reserved.
//

import CoreLocation

extension CLLocationCoordinate2D {

    /// To Geo point
    public var toGeoPoint: GeoPoint {
        return GeoPoint(latitude: self.latitude, longitude: self.longitude)
    }

}


extension CLLocationCoordinate2D: Equatable {}

public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return (lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude)
}

public func == (lhs: MapAnnotation, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.coordinate == rhs
}
