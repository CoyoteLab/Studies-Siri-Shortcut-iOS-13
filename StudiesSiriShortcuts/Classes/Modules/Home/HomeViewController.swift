//
//
//  HomeViewController.swift
//  SiriShortcutsStudies
//
//  Created by Stephan Yannick on 31/07/2019.
//  Copyright © 2019 Coyote Lab. All rights reserved.
//

import UIKit
import IntentsSiriKit
import CoreLocation

// MARK: - HomeViewController

final class HomeViewController: UIViewController {

    // MARK: Public properties

    private let locationManager = CLLocationManager()

    private var viewModel: HomeViewModelable = HomeViewModel()

    // MARK: LifeCycle

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.locationManager.requestAlwaysAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
}

// MARK: - CLLocationManagerDelegate implementation

extension HomeViewController: CLLocationManagerDelegate {

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location?.coordinate else { return }
        DispatchQueue.main.async {
            self.viewModel.storePosition = location.toGeoPoint
        }
    }
}
