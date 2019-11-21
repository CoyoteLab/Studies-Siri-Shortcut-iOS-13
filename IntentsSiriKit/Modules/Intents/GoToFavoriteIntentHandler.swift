//
//  GotToFavoritesIntentHandler.swift
//  IntentsSiriKit
//
//  Created by Stephan Yannick on 12/08/2019.
//  Copyright © 2019 Stephan Yannick. All rights reserved.
//

import Foundation
import Intents
import os.log


// MARK: - GoToFavoriteHandler

// Class to declare support for handling a GoToFavoriteIntent. By implementing the protocol GoToFavoriteIntentHandling, this class provide logic for resolving, confirming and handling the intent.
public class GoToFavoriteIntentHandler: NSObject, GoToFavoriteIntentHandling {

    // MARK: - ChoiceActionType handling

    /// Called for resolve `goFavorite`, if in intent propreties not contains `goFavorite`  an `Favorite` that call `API` and display on Siri
    /// Determine if this intent is ready for the next step (confirmation)
    /// Called to make sure the app extension is capable of handling this intent in its current form. This method is for validating if the intent needs any further fleshing out.
    ///
    /// - Parameter intent: intent The input intent
    /// - Parameter completion: The response block contains an `INObjectResolutionResult` this `FavoriteResolutionResult` for the parameter being resolved
    public func resolveFavorite(for intent: GoToFavoriteIntent, with completion: @escaping (FavoriteResolutionResult) -> Void) {
        guard let favoris = intent.favorite else {
            Mockup.mokeAPIFavoritesDirection { favorites in
                completion(.disambiguation(with: favorites))
            }
            return
        }
        completion(.success(with: favoris))
    }

    // MARK: - ChoiceActionEditionType handling

    // MARK: - Confirm and handling

    /// Validate that this intent is ready for the next step (i.e. handling)
    /// Called prior to asking the app to handle the intent. The app should return a response object that contains additional information about the intent, which may be relevant for the system to show the user prior to handling. If unimplemented, the system will assume the intent is valid, and will assume there is no additional information relevant to this intent.
    ///
    /// - Parameter intent: The input intent
    /// - Parameter completion: The response block contains an `INIntentResponse` this `GoToFavoriteIntentResponse` for the parameter being resolved
    public func confirm(intent: GoToFavoriteIntent, completion: @escaping (GoToFavoriteIntentResponse) -> Swift.Void) {
        guard let favorite = intent.favorite else {
            completion(.failure(failureMessageDisplay: "Nous ne pouvons lancer la confirmation vers votre lieu"))
            return
        }
        guard
            let geoPoint = favorite.toGeoPoint,
            let shorcutLaunchMap = ShorcutLaunchMap(displayString: favorite.displayString) else {
            completion(GoToFavoriteIntentResponse(code: .failureMapUserActivity, userActivity: nil))
            return
        }
        let response = GoToFavoriteIntentResponse(code: .ready, userActivity: shorcutLaunchMap.getActivity(geoPoint: geoPoint))
        completion(response)
    }

    /// Handling method - Execute the task represented by the `GoToFavoriteIntent ` that's passed in
    /// - Parameter intent: The input intent
    /// - Parameter completion: The response block contains an `INIntentResponse` this `GoToFavoriteIntentResponse` containing the details of the result of having executed the intent
    public func handle(intent: GoToFavoriteIntent, completion: @escaping (GoToFavoriteIntentResponse) -> Void) {
        guard let favorite = intent.favorite else {
            completion(.failure(failureMessageDisplay: "Nous ne pouvons finaliser votre itinéraire vers votre lieu"))
            return
        }
        guard
            let geoPoint = favorite.toGeoPoint,
            let shorcutLaunchMap = ShorcutLaunchMap(displayString: favorite.displayString) else {
            completion(.init(code: .failureMapUserActivity, userActivity: nil))
            return
        }
        let response = GoToFavoriteIntentResponse(code: .continueInApp, userActivity: shorcutLaunchMap.getActivity(geoPoint: geoPoint))
        completion(response)
    }
}
