//
//  HomeViewModel.swift
//  StudiesSiriShortcut
//
//  Created by Stephan Yannick on 05/08/2019.
//  Copyright © 2019 Coyote Lab. All rights reserved.
//

import Foundation

import IntentsSiriKit

// MARK: - HomeViewModelable

protocol HomeViewModelable {

    /// Store in Shared app group the current position of user
    var storePosition: GeoPoint? { get set }
}

// MARK: - HomeViewModel

final class HomeViewModel: HomeViewModelable {

    var storePosition: GeoPoint? {
        didSet {
            UserDefaults.currentUserPosition = storePosition
        }
    }
}
