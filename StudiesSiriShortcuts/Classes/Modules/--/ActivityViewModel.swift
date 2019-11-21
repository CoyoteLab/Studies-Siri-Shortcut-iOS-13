//
//  HomeViewModel.swift
//  StudiesSiriShortcut
//
//  Created by Stephan Yannick on 05/08/2019.
//  Copyright © 2019 Stephan Yannick. All rights reserved.
//

import Foundation

// MARK: - HomeViewModelable

protocol ActivityViewModelable {

    var didRestoreActivityValue: ((_ type: [ActivityViewModel.EditionCity])->())? { get set }
    var didChangeActivity: ((_ activity: NSUserActivity?) -> ())? { get set }

    func viewDidLoad()
    func didEndEdting(type: ActivityViewModel.EditionCity)
}

// MARK: - HomeViewModel

final class ActivityViewModel: ActivityViewModelable {

    enum EditionCity {
        case start(_ text: String?), end(_ text: String?)
    }

    fileprivate enum UserInfoKey: String {

        case viewActivityKeyRoot

        enum ViewActivityKey: String, CaseIterable {
            case startDirection
            case endDirection
        }
    }

    var didChangeActivity: ((NSUserActivity?) -> ())?
    var didRestoreActivityValue: ((_ type: [ActivityViewModel.EditionCity])->())?
    var currentActivity: NSUserActivity? {
        didSet {
            self.didChangeActivity?(currentActivity)
        }
    }

    private var currentText: (start: String?, end: String?)

    init(with activity: NSUserActivity?) {
        self.currentActivity = activity
    }

    func viewDidLoad() {
        restoreUserActivityState()
    }

    func didEndEdting(type: EditionCity) {
        switch type {
        case .start(let text):
            currentText.start = text
        case .end(let text):
            currentText.end = text
        }
        let params = [
            UserInfoKey.viewActivityKeyRoot.rawValue:
                [
                    UserInfoKey.ViewActivityKey.startDirection.rawValue: currentText.start,
                    UserInfoKey.ViewActivityKey.endDirection.rawValue: currentText.end,
                ],
        ]
//        currentActivity = Shortcuts.launchMapFavoritesAddress.getActivity(params: params)
    }

    func restoreUserActivityState() {

        guard let array = currentActivity?.userInfo?[UserInfoKey.viewActivityKeyRoot.rawValue] as? [AnyHashable : Any] else {
            return
        }
        var response: [EditionCity] = []
        for key in UserInfoKey.ViewActivityKey.allCases {
            guard let value = array[key.rawValue] as? String else {
                return
            }
            switch key {
            case .startDirection:
                response.append(EditionCity.start(value))
            case .endDirection:
                response.append(EditionCity.end(value))
            }
            didRestoreActivityValue?(response)
        }
    }
}
