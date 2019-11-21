//
//  AssetsImage.swift
//  StudiesSiriShortcuts
//
//  Created by Stephan Yannick on 19/08/2019.
//  Copyright © 2019 Stephan Yannick. All rights reserved.
//

import UIKit

// MARK: - AssetsImage

public enum AssetImages: String {
    case sreenShorcutSpotLight
    case sreenShorcutWidget

    public var image: UIImage {
        return UIImage(named: self.rawValue)!
    }
}
