//
//  UIScrollViewX.swift
//  Q-Me Remade
//
//  Created by Shahar Ben-Dor on 9/11/18.
//  Copyright © 2018 Quantum. All rights reserved.
//

import UIKit

class UIScrollViewX: UIScrollView {
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIControl
            && !(view is UITextInput)
            && !(view is UISlider)
            && !(view is UISwitch) {
            return true
        }
        
        return super.touchesShouldCancel(in: view)
    }
}
