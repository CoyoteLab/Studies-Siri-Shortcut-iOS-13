//
//  Configuration.swift
//  StudiesSiriShortcuts
//
//  Created by Stephan Yannick on 12/08/2019.
//  Copyright © 2019 Stephan Yannick. All rights reserved.
//

import Foundation


// MARK: - ConfigurationService

public enum ConfigurationService: String {

    private static let bundleIdentifier = "com.studies.IntentsSiriKit"

    case gsmPlacesClientAPIKey = "GMS_PLACE_CLIENT_API_KEY"
    case getCurrentLocasion = "GET_CURRENT_LOCATION"
    case isFranceLocation = "IS_FRANCE_LOCATION"
    case sharedAppGroupIdentfier =  "SHARED_APP_GROUP_IDENTIFIER"

    enum AppGroupIdentfierUserDefaultKeys: String {
        case currentPosition
    }

    public enum Error: Swift.Error {
        case missingKey, invalidValue
    }

    public static func value(for key: ConfigurationService) throws -> String {
        guard
            let bundle = Bundle(identifier: bundleIdentifier),
            let object = bundle.object(forInfoDictionaryKey:key.rawValue) else {
            throw Error.missingKey
        }

        switch object {
        case let value as String:
            return value
        default:
            throw Error.invalidValue
        }
    }

    public static func value(for key: ConfigurationService) throws -> Bool {
        guard
            let bundle = Bundle(identifier: bundleIdentifier),
            let object = bundle.object(forInfoDictionaryKey:key.rawValue) else {
            throw Error.missingKey
        }

        switch object {
        case let value as String:
            return value == "1"
        default:
            throw Error.invalidValue
        }
    }
}
