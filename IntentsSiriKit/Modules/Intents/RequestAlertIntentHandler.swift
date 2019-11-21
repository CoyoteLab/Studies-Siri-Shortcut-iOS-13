//
//  RequestAlert.swift
//  IntentsSiriKit
//
//  Created by Stephan Yannick on 20/08/2019.
//  Copyright © 2019 Coyote Lab. All rights reserved.
//

import Foundation
import UIKit
import os.log


// MARK: - RequestAlertHandler

public class RequestAlertIntentHandler: NSObject, RequestAlertIntentHandling {

    /// Called for resolve `AlertDeclaration`,  if in intent propreties not contains `alertDeclaration`  an `Alert` that call `API` and display on Siri
    /// Determine if this intent is ready for the next step (confirmation)
    /// Called to make sure the app extension is capable of handling this intent in its current form. This method is for validating if the intent needs any further fleshing out.
    ///
    /// - Parameter intent: intent The input intent
    /// - Parameter completion: The response block contains an `INIntentResolutionResult` this `AlertResolutionResult` for the parameter being resolved
    public func resolveAlertDeclaration(for intent: RequestAlertIntent, with completion: @escaping (AlertResolutionResult) -> Void) {
        guard let alertDeclaration = intent.alertDeclaration else {
            Mockup.mokeAPIAlerts { alerts in
                completion(.disambiguation(with: alerts))
            }
            return
        }
        completion(.success(with: alertDeclaration))
    }

    /// Called for resolve `directionWayType`, get value if is `unknown` type and display on Siri
    /// Determine if this intent is ready for the next step (confirmation)
    /// Called to make sure the app extension is capable of handling this intent in its current form. This method is for validating if the intent needs any further fleshing out.
    ///
    /// - Parameter intent: intent The input intent 
    /// - Parameter completion: The response block contains an `INEnumResolutionResult` this `DirectionTypeResolutionResult` for the parameter being resolved
    public func resolveDirectionWayType(for intent: RequestAlertIntent, with completion: @escaping (DirectionTypeResolutionResult) -> Void) {
        guard  intent.directionWayType != .unknown else {
            completion(.needsValue())
            return
        }
        completion(.success(with: intent.directionWayType))
    }

    // MARK: - Confirm and handling

    /// Validate that this intent is ready for the next step (i.e. handling)
    /// Called prior to asking the app to handle the intent. The app should return a response object that contains additional information about the intent, which may be relevant for the system to show the user prior to handling. If unimplemented, the system will assume the intent is valid, and will assume there is no additional information relevant to this intent.
    ///
    /// - Note: We get the current position of user by Shared App group 
    ///
    /// - Parameter intent: The input intent
    /// - Parameter completion: The response block contains an `INIntentResponse` this `RequestAlertIntentResponse` for the parameter being resolved
    public func confirm(intent: RequestAlertIntent, completion: @escaping (RequestAlertIntentResponse) -> Swift.Void) {
        guard let alertDeclaration = intent.alertDeclaration else {
            completion(.failure(failureMessageDisplay: "Nous n'avons pas pu confirmer votre résolution d'alerte"))
            return
        }
        guard let userPosition = UserDefaults.currentUserPosition else {
            completion(RequestAlertIntentResponse(code: .failureCantGetUserPositionOrApi, userActivity: nil))
            return
        }
        guard  intent.directionWayType != .unknown else {
            completion(.failure(failureMessageDisplay: "Votre direction ne peut être inconnu"))
            return
        }

        let displayDirectionWay: String
        switch intent.directionWayType {
        case .same:
            displayDirectionWay = "votre sens"

        default:
            displayDirectionWay =  "le sens opposé"
        }

        let response: RequestAlertIntentResponse = .readyConfirm(displayReadyValidationAlertDeclaration: alertDeclaration,
                                                                 displayReadyValidationDirectionWay: displayDirectionWay,
                                                                 displayReadyValidationPosition: "latitude \(userPosition.latitude)" + " et longitude" + "\(userPosition.longitude)")
        completion(response)
    }

    /// Handling method - Execute the task represented by the `RequestAlertIntent ` that's passed in
    /// - Parameter intent: The input intent
    /// - Parameter completion: The response block contains an `INIntentResponse` this `RequestAlertIntentResponse` containing the details of the result of having executed the intent
    public func handle(intent: RequestAlertIntent, completion: @escaping (RequestAlertIntentResponse) -> Void) {
        guard let alertDeclaration = intent.alertDeclaration else {
            completion(.failure(failureMessageDisplay: "Nous n'avons pas pu finaliser votre déclaration"))
            return
        }
        guard let positionUser = UserDefaults.currentUserPosition else {
            completion(RequestAlertIntentResponse(code: .failureCantGetUserPositionOrApi, userActivity: nil))
            return
        }
        Mockup.mokeSendAlertAPI(alert: alertDeclaration, direction: intent.directionWayType, positionUser: positionUser) { (finish) in
            guard finish else { return }
            completion(RequestAlertIntentResponse(code: .success, userActivity: nil))
        }
    }
}
