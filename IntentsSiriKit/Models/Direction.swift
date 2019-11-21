//
//  Direction.swift
//  StudiesSiriShortcut
//
//  Created by Stephan Yannick on 05/08/2019.
//  Copyright © 2019 Stephan Yannick. All rights reserved.
//

import Foundation


public struct Direction: Codable {

    let identifier: UUID
    var origin: GeoPoint?
    let destination: GeoPoint


    public init(identifier: UUID = UUID(),
                from origin: GeoPoint?,
                to destination: GeoPoint) {
        self.identifier = identifier
        self.origin = origin
        self.destination = destination
    }
}
