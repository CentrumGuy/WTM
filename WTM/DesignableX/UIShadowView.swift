//
//  UIViewX.swift
//  DesignableX
//
//  Created by Mark Moeykens on 12/31/16.
//  Copyright © 2016 Mark Moeykens. All rights reserved.
//

import UIKit

@IBDesignable
class UIShadowView: UIView {
    // MARK: - Shadow
    
    @IBInspectable public var shadowOpacity: Float = 0 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable public var shadowColor: UIColor = UIColor.black {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat = 5 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable public var shadowOffset: CGPoint = CGPoint(x: 0, y: 0) {
        didSet {
            layer.shadowOffset = CGSize(width: shadowOffset.x, height: shadowOffset.y)
        }
    }
}
