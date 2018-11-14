//
//  SMSector.swift
//  RotatingWheelController
//
//  Created by tom on 12/11/18.
//  Copyright © 2018 tom. All rights reserved.
//

import UIKit

class SMSector<T> {
    var lower: CGFloat
    var upper: CGFloat
    var value: T
    var middle: CGFloat {
        get {
            if lower < upper {
              return (lower + upper) / 2.0
            } else {
                return CGFloat.pi
            }
        }
    }
    
    init(lower: CGFloat, upper: CGFloat, value: T) {
        self.lower = lower
        self.upper = upper
        self.value = value
    }
    
    func contains(_ element: CGFloat) -> Bool {
        return lower < upper ? lower <= element && element < upper : lower <= element || element < upper
    }
}
