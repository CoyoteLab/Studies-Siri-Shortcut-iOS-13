//
//  UIViewController+StoryboardInstantiatable.swift
//  StarWars
//
//  Created by Yannick Stephan on 2019-06-16.
//  Copyright © 2019 Yannick Stephan. All rights reserved.
//

import UIKit

// MARK: - StoryboardInstantiatable

public enum StoryboardType: String {
    case main = "Main", mainInterface = "MainInterface"
}

/// see: [StackOverFlow](https://dev.to/tattn/my-favorite--swift-extensions-8g7)
public protocol StoryboardInstantiatable {
    static var identifier: String { get }


}

// MARK: - StoryboardInstantiatable

extension StoryboardInstantiatable {


    public static var identifier: String { return String(describing: self) }
    
    public static func instantiate(on storyboardType: StoryboardType) -> Self {
        return instantiateWithName(name: identifier, on: storyboardType)
    }
    
    public static func instantiateWithName(name: String, on storyboardType: StoryboardType) -> Self {
        let storyboard = UIStoryboard(name: storyboardType.rawValue, bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: identifier) as? Self else{
            fatalError("failed to load \(name) storyboard file.")
        }
        return vc
    }
}
