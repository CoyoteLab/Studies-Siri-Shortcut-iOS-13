//
//  GeoPoint.swift
//  IntentsSiriKit
//
//  Created by Stephan Yannick on 01/10/2019.
//  Copyright © 2019 Coyote Lab. All rights reserved.
//

import Foundation

public typealias Latitude = Double
public typealias Longitude = Double
public typealias DistanceInMeters = Double

// MARK: - GeoPoint

public struct GeoPoint: Codable {

    // MARK: Required properties

    public var identifier: UUID
    public var latitude: Latitude
    public var longitude: Longitude

    // MARK: Optional properties

    public var name: String?

    // MARK: Initializer

    public init(identifier: UUID = UUID(),
                latitude: Latitude,
                longitude: Longitude,
                name: String? = nil) {
        self.identifier = identifier
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
    }
}
