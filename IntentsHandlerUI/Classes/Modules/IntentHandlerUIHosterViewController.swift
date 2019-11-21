//
//  IntentHandlerUIHosterViewController.swift
//  IntentHandlerUIHosterViewController
//
//  Created by Stephan Yannick on 16/08/2019.
//  Copyright © 2019 Stephan Yannick. All rights reserved.
//

import IntentsUI
import IntentsSiriKit
import os.log

// MARK: - IntentHandlerUIHosterViewController

// Class for presenting custom content in the Siri and Maps interfaces.
final class IntentHandlerUIHosterViewController: UIViewController, INUIHostedViewControlling {
    
    // MARK: Propreties
        
    private var desiredSize: CGSize {
        let width = self.extensionContext?.hostedViewMaximumAllowedSize.width ?? 320
        return CGSize(width: width, height: 400)
    }

    func configure(with interaction: INInteraction, context: INUIHostedViewContext, completion: @escaping (CGSize) -> Void) {
        
    }
    // Prepare your view controller for the interaction to handle.
    func configureView(for parameters: Set<INParameter>, of interaction: INInteraction, interactiveBehavior: INUIInteractiveBehavior, context: INUIHostedViewContext, completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {
        
        switch (interaction.intentResponse, interaction.intentResponse?.userActivity) {
        case (let response as GoToFavoriteIntentResponse, .some(let userActivity)) where response.code == .success:
            let viewController = NavigationMapBoxViewController.instantiate(on: .mainInterface)
            attachChild(viewController)
            viewController.restoreUserActivityState(userActivity)
            completion(true, parameters, desiredSize)
            
        default:
            completion(false, parameters, desiredSize)
        }
    }
    
    
    // MARK: Private methods
    
    private func attachChild(_ viewController: UIViewController) {
        guard let subview = viewController.view else {
            return
        }
        addChild(viewController)
        view.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        subview.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        subview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subview.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        viewController.didMove(toParent: self)
    }
}
