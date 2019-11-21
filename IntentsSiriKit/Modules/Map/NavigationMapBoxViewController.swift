//
//  SelectHomeMapBoxViewController.swift
//  StudiesSiriShortcuts
//
//  Created by Stephan Yannick on 08/08/2019.
//  Copyright © 2019 Stephan Yannick. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import os.log

// MARK: - NavigationMapBoxViewController

public final class NavigationMapBoxViewController: MapViewController, StoryboardInstantiatable {

    // MARK: Private @IBOutlet

    @IBOutlet private weak var currentLocationLabel: UILabel!

    // MARK: Private propreties

    fileprivate enum MapIdentifier: String {
        case carView, beginPin, endPin
    }


    private var direction: Direction?
    private var startTrip = false
    private let locationManager = CLLocationManager()
    private var locationUser: CLLocationCoordinate2D? {
        didSet {
            guard
                var direction = direction,
                let locationUser = locationUser else {
                    return
            }
                direction.origin = locationUser.toGeoPoint
                self.currentLocationLabel.text = "Localisation:\nlatitude: \(locationUser.toGeoPoint.latitude)\nlongitude: \(locationUser.toGeoPoint.longitude)"
            self.setupTrip(with: direction)

        }
    }

    // MARK: LifeCycle

    override public func restoreUserActivityState(_ activity: NSUserActivity) {
        super.restoreUserActivityState(activity)
        guard
            ShorcutLaunchMap.launchMapFavoritesAddressActivityType == activity.activityType,
            let distinationGeoPoint = ShorcutLaunchMap.getGeoPoint(with: activity) else {
                return
        }
        direction = Direction(from: nil, to: distinationGeoPoint)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        registrer(type: .pin, for: MapIdentifier.beginPin.rawValue)
        registrer(type: .pin, for: MapIdentifier.endPin.rawValue)

    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    // MARK: Private method

    private func setupTrip(with direction: Direction) {
        guard let originDestination = direction.origin else {
            return
        }
        let mid = originDestination.midPoint(to: direction.destination)
        let distance = originDestination.distance(from: direction.destination)

        let offsetMap =  distance / 4
        kDefaultRadius = distance  + offsetMap

        self.currentCenter = originDestination.toCLLocationCoordinate2D
        self.setRegion(with: mid)

        self.addAnnotation(for:  MapIdentifier.beginPin.rawValue,
                           type: .pin,
                           with: originDestination.toCLLocationCoordinate2D)

        self.addAnnotation(for:  MapIdentifier.endPin.rawValue,
                           type: .pin,
                           with: direction.destination.toCLLocationCoordinate2D)
    }
}

// MARK: - CLLocationManagerDelegate implementation

extension NavigationMapBoxViewController: CLLocationManagerDelegate {

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location?.coordinate, startTrip == false else { return }
        DispatchQueue.main.async {
            self.startTrip = true
            self.locationUser = location
        }
    }
}
