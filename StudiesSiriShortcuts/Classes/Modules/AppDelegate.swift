//
//  AppDelegate.swift
//  StudiesSiriShortcuts
//
//  Created by Stephan Yannick on 06/08/2019.
//  Copyright © 2019 Coyote Lab. All rights reserved.
//

import UIKit
import GooglePlaces
import IntentsSiriKit
import os.log

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        do {
            let gsmPlacesClientAPIKey: String = try ConfigurationService.value(for: .gsmPlacesClientAPIKey)
            GMSPlacesClient.provideAPIKey(gsmPlacesClientAPIKey)
            
        } catch {
            fatalError("Impossible to load key with error \(error)")
        }
        return true
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard
            ShorcutLaunchMap.launchMapFavoritesAddressActivityType == userActivity.activityType,
            let window = window,
            let rootViewController = window.rootViewController as? UINavigationController else {
                return false
        }
        rootViewController.popToRootViewController(animated: false)
        let viewController = NavigationMapBoxViewController.instantiate(on: .main)
        restorationHandler([viewController])
        rootViewController.pushViewController(viewController, animated: true)
        return true
    }
}

