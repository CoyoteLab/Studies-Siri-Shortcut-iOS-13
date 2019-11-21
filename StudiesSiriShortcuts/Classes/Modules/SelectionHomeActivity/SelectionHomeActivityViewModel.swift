//
//  SelectionHomeActivityViewModel.swift
//  StudiesSiriShortcuts
//
//  Created by Stephan Yannick on 09/08/2019.
//  Copyright © 2019 Coyote Lab. All rights reserved.
//

import Foundation
import CoreLocation

import IntentsSiriKit

// MARK: - SelectionHomeActivityViewModelable

protocol SelectionHomeActivityViewModelable {

    var didChangeActivity: ((_ activity: NSUserActivity?) -> ())? { get set }
    var didChangeAdress: ((_ name: String?) -> ())? { get set }
    var homeAdress: GeoPoint? { get set }
    var activity: NSUserActivity? { get }

    func changeAdress(name: String, location: CLLocationCoordinate2D)
    func loadData()
    func cleanBackup()
}

// MARK: - SelectionHomeActivityViewModel

final class SelectionHomeActivityViewModel: SelectionHomeActivityViewModelable {

    private enum UserDefaultsKey : String {
        case homeAdressKey = "SelectionHomeActivityViewModel.homeAdress"
    }

    // MARK: Public properties

    var didChangeActivity: ((NSUserActivity?) -> ())?
    var didChangeAdress: ((_ name: String?) -> ())?

    var activity: NSUserActivity? {
        guard let homeAdress = homeAdress else {
            return nil
        }
        return  ShorcutLaunchMap.goToHome.getActivity(geoPoint: homeAdress)
    }

    var homeAdress: GeoPoint? {
        didSet {
            didChangeActivity?(activity)
            didChangeAdress?(homeAdress?.name)

            if let homeAdress = homeAdress, let encoded = try? JSONEncoder().encode(homeAdress) {
                UserDefaults.standard.set(encoded, forKey: UserDefaultsKey.homeAdressKey.rawValue)
            } else {
                UserDefaults.standard.removeObject(forKey: UserDefaultsKey.homeAdressKey.rawValue)
                ShorcutLaunchMap.goToHome.delete()
            }
        }
    }

    // MARK: Public methods

    func loadData() {
        guard
            let savedPerson = UserDefaults.standard.object(forKey: UserDefaultsKey.homeAdressKey.rawValue) as? Data,
            let mapAdress = try? JSONDecoder().decode(GeoPoint.self, from: savedPerson) else {
                return
            }
        homeAdress = mapAdress
    }

    func changeAdress(name: String, location: CLLocationCoordinate2D) {
        homeAdress = GeoPoint(latitude: location.latitude,
                              longitude: location.longitude,
                              name: name)
    }

    func cleanBackup() {
        homeAdress = nil
    }
}
