//
//  FavorisDirectrions+Exts.swift
//  IntentsSiriKit
//
//  Created by Stephan Yannick on 19/08/2019.
//  Copyright © 2019 Stephan Yannick. All rights reserved.
//


import Intents

// MARK: Favorite + Exts

extension Favorite {
    public var toGeoPoint: GeoPoint? {
        guard
            let location = self.location?.location,
            let name = self.location?.name else {
            return nil
        }
        return GeoPoint(latitude: location.coordinate.latitude,
                        longitude: location.coordinate.longitude,
                        name: name)
    }

    public static func instance(displayString: ShorcutLaunchMap) -> Favorite {
        return Favorite(identifier: UUID().uuidString,
                                    display: displayString.displayString,
                                    pronunciationHint: displayString.displayString)
    }
}
