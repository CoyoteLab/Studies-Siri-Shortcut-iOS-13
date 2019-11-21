//
//  MapAnnotation+Exts.swift
//  StudiesSiriShortcuts
//
//  Created by Stephan Yannick on 19/08/2019.
//  Copyright © 2019 Stephan Yannick. All rights reserved.
//

import Foundation
import CoreLocation

extension Array where Element == MapAnnotation {

    func first(by identifier: String) -> MapAnnotation? {
        return filter { $0.identifier == identifier }.first
    }

    func first(by coordinate: CLLocationCoordinate2D) -> MapAnnotation? {
        return filter { $0.coordinate == coordinate }.first
    }

    func filter(by identifier: String) -> [MapAnnotation] {
        return filter { $0.identifier == identifier }
    }
}
