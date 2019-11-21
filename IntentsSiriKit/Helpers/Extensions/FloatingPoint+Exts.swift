//
//  FloatingPoint.swift
//  IntentsSiriKit
//
//  Created by Stephan Yannick on 01/10/2019.
//  Copyright © 2019 Coyote Lab. All rights reserved.
//

import Foundation

// MARK: - FloatingPoint Extensions

extension FloatingPoint {

  /// Degrees to Radians
  public var degreesToRadians: Self {
      return self * .pi / 180
  }

  /// Radians to Degrees
  public var radiansToDegrees: Self {
      return self * 180 / .pi
  }
}
