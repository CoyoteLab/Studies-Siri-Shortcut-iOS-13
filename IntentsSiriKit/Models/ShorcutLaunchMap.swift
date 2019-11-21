//
//  NSUserActivity+Exts.swift
//  IntentsSiriKit
//
//  Created by Stephan Yannick on 27/08/2019.
//  Copyright © 2019 Coyote Lab. All rights reserved.
//

import Foundation
import CoreSpotlight
import MobileCoreServices

// MARK: - ShorcutLaunchMap

public enum ShorcutLaunchMap: String, CaseIterable {

    init?(displayString: String) {
        switch displayString {
        case ShorcutLaunchMap.goToWork.displayString:
            self = ShorcutLaunchMap.goToWork
        case ShorcutLaunchMap.goToHome.displayString:
            self = ShorcutLaunchMap.goToHome
        default:
            return nil
        }
    }

    // MARK: Activity types
    public static let launchMapFavoritesAddressActivityType = "com.studies.launchMapFavoritesAddress"

    case goToHome = "GoToHome"
    case goToWork = "GoToWork"

    public var displayString: String {
        switch self {
        case .goToHome:
            return "Maison"
        case .goToWork:
            return "Travail"
        }
    }

    public var title: String {
        switch self {
        case .goToHome:
            return "Aller à la maison"
        case .goToWork:
            return "Aller su travail"
        }
    }

    public var keywords: [String] {
        switch self {
        case .goToHome:
            return ["aller", "direction", "maison", "Coyote"]
        case .goToWork:
            return ["aller", "direction", "travail", "Coyote"]
        }
    }

    public var contentDescription: String {
        switch self {
        case .goToHome:
            return "Ouvrir l'application Coyote pour aller à la maison"
        case .goToWork:
            return "Ouvrir l'application Coyote pour aller au travail"
        }
    }

    public var suggestedInvocationPhrase: String {
        switch self {
        case .goToHome:
            return "Direction maison avec Coyote"
        case .goToWork:
            return "Direction travail avec Coyote"
        }
    }

    public static func getGeoPoint(with activity: NSUserActivity) -> GeoPoint? {
        guard
            let userInfo = activity.userInfo,
            let uuidString = userInfo[NSUserActivity.regionDirectionIdentifierKeyString] as? String,
            let uuid = UUID(uuidString: uuidString),
            let longitudeString = userInfo[NSUserActivity.regionDirectionLatitudeKeyString] as? String,
            let longitude = Longitude(longitudeString),
            let latitudeString = userInfo[NSUserActivity.regionDirectionLongitudeKeyString] as? String,
            let latitude = Latitude(latitudeString),
            let name = userInfo[NSUserActivity.regionDirectionNameKeyString] as? String else {
                return nil
        }
        return GeoPoint(identifier: uuid, latitude: longitude, longitude: latitude, name: name)
    }

    // TODO: YS/ Add to finish
    public func delete() {
        NSUserActivity.deleteSavedUserActivities(withPersistentIdentifiers: [ShorcutLaunchMap.launchMapFavoritesAddressActivityType]) {

        }
    }

    public func getActivity(geoPoint: GeoPoint) -> NSUserActivity {
        let activity = NSUserActivity(activityType: ShorcutLaunchMap.launchMapFavoritesAddressActivityType)
        activity.title = title

        activity.needsSave = true
        activity.requiredUserInfoKeys = NSUserActivity.viewingActivityRequiredKeys
        activity.updateViewingRegion(geoPoint)
        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true
        activity.isEligibleForPublicIndexing = true
        activity.persistentIdentifier = rawValue
        activity.suggestedInvocationPhrase = suggestedInvocationPhrase

        let attributes = CSSearchableItemAttributeSet(itemContentType: kUTTypeItem as String)
        attributes.contentDescription = contentDescription
        attributes.keywords = keywords
//        attributes.thumbnailData = UIImage(named: "iconHome")!.pngData()
        attributes.displayName = title
        activity.contentAttributeSet = attributes
        return activity
    }
}

// MARK: - NSUserActivity extensions

fileprivate extension NSUserActivity {

    // MARK: Activity Keys
    static let regionDirectionIdentifierKeyString =  "com.studies.launchMapFavoritesAddress.regionIdentifier"
    static let regionDirectionLatitudeKeyString =  "com.studies.launchMapFavoritesAddress.regionLatitude"
    static let regionDirectionLongitudeKeyString =  "com.studies.launchMapFavoritesAddress.regionLongitude"
    static let regionDirectionNameKeyString =  "com.studies.launchMapFavoritesAddress.regionName"

    static let viewingActivityRequiredKeys: Set<String> = [
        NSUserActivity.regionDirectionIdentifierKeyString, NSUserActivity.regionDirectionIdentifierKeyString,
        NSUserActivity.regionDirectionLatitudeKeyString, NSUserActivity.regionDirectionLatitudeKeyString,
        NSUserActivity.regionDirectionLongitudeKeyString, NSUserActivity.regionDirectionLongitudeKeyString,
        NSUserActivity.regionDirectionNameKeyString, NSUserActivity.regionDirectionNameKeyString,
    ]

    func updateViewingRegion(_ geoPoint: GeoPoint) {
        var updateDict: [String : Any] = [
            NSUserActivity.regionDirectionIdentifierKeyString: geoPoint.identifier.uuidString,
            NSUserActivity.regionDirectionLatitudeKeyString: String(geoPoint.latitude),
            NSUserActivity.regionDirectionLongitudeKeyString: String(geoPoint.longitude),

        ]

        if let name = geoPoint.name {
            updateDict[NSUserActivity.regionDirectionNameKeyString] = name
        }
        addUserInfoEntries(from: updateDict)
    }
}
