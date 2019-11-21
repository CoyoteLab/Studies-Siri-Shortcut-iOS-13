//
//  IntentHandlerProvider.swift
//  IntentsHandler
//
//  Created by Stephan Yannick on 16/08/2019.
//  Copyright © 2019 Stephan Yannick. All rights reserved.
//

import Intents
import IntentsSiriKit
import os.log

// MARK: - IntentHandler

// The class for dispatching intents to the custom objects that handle those intents.
final class IntentHandlerProvider: INExtension {

    override func handler(for intent: INIntent) -> Any {
        switch intent {
        case is GoToFavoriteIntent:
            return GoToFavoriteIntentHandler()

        case is RequestAlertIntent:
            return RequestAlertIntentHandler()
            
        default:
            return intent
        }
    }
}
