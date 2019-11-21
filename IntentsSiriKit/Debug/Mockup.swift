//
//  Mockup.swift
//  IntentsSiriKit
//
//  Created by Stephan Yannick on 19/08/2019.
//  Copyright © 2019 Stephan Yannick. All rights reserved.
//

import Foundation

import CoreLocation
import Contacts

fileprivate enum AlertType: String, CaseIterable {
    case temporaryDanger = "Danger temporaire"
    case stoppedVehicle = "Véhicule arrêté"
    case slowDown = "Ralentissement"
    case objectOnWay = "Objet sur la voie"
    case accident = "Accident"
}


enum Mockup {

    static func mokeAPIFavoritesDirection(completion: @escaping (([Favorite])->())) {

        var favoritesDirection = [Favorite] ()

        let homeFavoritesDirection = Favorite.instance(displayString: .goToHome)
        let workFavoritesDirection = Favorite.instance(displayString: .goToWork)

        do {
            let isLocationFrance: Bool = try ConfigurationService.value(for: .isFranceLocation)
            if isLocationFrance {
                homeFavoritesDirection.location = CLPlacemark(location: CLLocation(latitude: 47.418794, longitude: 0.233304),
                                                              name: "Honfleur",
                                                              postalAddress: nil)
                workFavoritesDirection.location = CLPlacemark(location: CLLocation(latitude: 47.182148, longitude: -0.369686),
                                                              name: "Caen",
                                                              postalAddress: nil)

            } else {
                homeFavoritesDirection.location = CLPlacemark(location: CLLocation(latitude: 40.658183, longitude: -73.941406),
                                                              name: "New York",
                                                              postalAddress: nil)

                workFavoritesDirection.location = CLPlacemark(location: CLLocation(latitude: 49.333084, longitude:-122.767553),
                                                              name: "Vancouver",
                                                              postalAddress: nil)


            }
        } catch {
            print("[Mockup][mokeAPIFavoritesDirection] Can't get config ConfigurationService")
        }

        favoritesDirection.append(homeFavoritesDirection)
        favoritesDirection.append(workFavoritesDirection)


        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            completion(favoritesDirection)
        })
    }

    // MARK: - Private methods

    static func mokeAPIAlerts(completion: @escaping (([Alert])->())) {

        var alertArray = [Alert] ()

        for alert in AlertType.allCases {
            let objectAlert = Alert(identifier: UUID().uuidString, display: alert.rawValue)
            alertArray.append(objectAlert)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            completion(alertArray)
        })
    }

    static func mokeSendAlertAPI(alert: Alert, direction: DirectionType, positionUser: GeoPoint, completion: @escaping ((Bool)->())) {

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            completion(true)
        })
    }
}
