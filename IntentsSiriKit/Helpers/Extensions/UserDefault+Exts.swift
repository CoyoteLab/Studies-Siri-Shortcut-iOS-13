//
//  UserDefault+Exts.swift
//  IntentsSiriKit
//
//  Created by Stephan Yannick on 29/08/2019.
//  Copyright © 2019 Coyote Lab. All rights reserved.
//

import Foundation

// MARK: - UserDefaults
extension UserDefaults {

    // UserDefaults shared in group of App "group.studies.sirishortcutsstudies"
    public static var sharedAppGroup: UserDefaults? {
        guard
            let appGroupIdentifier: String = try? ConfigurationService.value(for: .sharedAppGroupIdentfier),
            let appGroupUserDefault = UserDefaults(suiteName: appGroupIdentifier) else {
            return nil
        }
        return appGroupUserDefault
    }

    // UserDefaults shared in group of App "group.studies.sirishortcutsstudies" current position
    public static var currentUserPosition: GeoPoint? {
        get {
            guard
                let userDefaultsAppGroup =  UserDefaults.sharedAppGroup,
                let lastPosition = userDefaultsAppGroup.data(forKey: ConfigurationService.AppGroupIdentfierUserDefaultKeys.currentPosition.rawValue),
                let geoPoint = try? JSONDecoder().decode(GeoPoint.self, from: lastPosition) else {
                    return nil
            }
            return geoPoint
        }
        set {
            guard
                let userDefaultsAppGroup =  UserDefaults.sharedAppGroup,
                let encode = try? JSONEncoder().encode(newValue) else {
                return
            }
             userDefaultsAppGroup.set(encode, forKey: ConfigurationService.AppGroupIdentfierUserDefaultKeys.currentPosition.rawValue)
        }
    }
}
