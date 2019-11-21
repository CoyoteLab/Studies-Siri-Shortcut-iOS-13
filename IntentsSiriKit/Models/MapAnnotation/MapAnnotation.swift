//
//  MapAnnotation.swift
//  StudiesSiriShortcuts
//
//  Created by Stephan Yannick on 09/08/2019.
//  Copyright © 2019 Coyote Lab. All rights reserved.
//
import MapKit

// MARK: - MapAnnotation

public class MapAnnotation: MKPointAnnotation {

    public enum MKAnnotationType {
        case pin
        case view
    }

    // MARK: Propreties

    public var type: MKAnnotationType
    public var identifier: String

    // MARK: LifeCycle

    override init() {
        self.type = .pin
        self.identifier = ""
    }
    
    public convenience init(type: MKAnnotationType, for identifier: String) {
        self.init()
        self.type = type
        self.identifier = identifier
    }
}
