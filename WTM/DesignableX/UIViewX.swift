//
//  UIViewX.swift
//  DesignableX
//
//  Created by Mark Moeykens on 12/31/16.
//  Copyright © 2016 Mark Moeykens. All rights reserved.
//

import UIKit

@IBDesignable
class UIViewX: UIView {
    
    // MARK: - Gradient
    
    @IBInspectable var gradientFirstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var gradientSecondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var gradientStart: CGPoint = CGPoint(x: 0, y: 0) {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var gradientEnd: CGPoint = CGPoint(x: 1, y: 1) {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var gradientTypeFromInt: Int = 0 {
        didSet {
            switch gradientTypeFromInt {
            case 1:
                gradientType = .radial
                break
            case 2:
                if #available(iOS 12.0, *) {
                    gradientType = .conic
                } else {
                    gradientType = .radial
                }
                break
            default:
                gradientType = .axial
                break
            }
        }
    }
    
    @IBInspectable var ignoresColorScheme: Bool = false
    
    var gradientType: CAGradientLayerType = .axial {
        didSet {
            let layer = self.layer as! CAGradientLayer
            layer.type = gradientType
        }
    }
    
    override public class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [gradientFirstColor.cgColor, gradientSecondColor.cgColor]
        
        layer.startPoint = gradientStart
        layer.endPoint = gradientEnd
    }
    
    // MARK: - Border
    
    @IBInspectable public var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    // MARK: - Corner Radius
    
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable public var cornerRadiusForCorners: String = "0,1,2,3" {
        didSet {
            let cornersString = cornerRadiusForCorners.split(separator: ",")
            var masks = CACornerMask()
            for string in cornersString {
                if let num = Int(string) {
                    switch (num) {
                    case 0:
                        masks = masks.union(.layerMinXMinYCorner)
                        break
                    case 1:
                        masks = masks.union(.layerMaxXMinYCorner)
                        break
                    case 2:
                        masks = masks.union(.layerMaxXMaxYCorner)
                        break
                    case 3:
                        masks = masks.union(.layerMinXMaxYCorner)
                        break
                    default:
                        break
                    }
                }
            }
            
            layer.maskedCorners = masks
        }
    }
    
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
    
    @IBInspectable private var viewLookFromInt: Int = 0 {
        didSet {
            look = ViewLook(rawValue: viewLookFromInt) ?? .defaultLook
        }
    }
    
    var look: ViewLook = .defaultLook {
        didSet {
            updateLook()
        }
    }
    
    enum ViewLook: Int {
        case defaultLook = 0
        case highContrast = 1
        case reducedHighContrast = 2
        case increasedLowContrast = 3
        case lowContrast = 4
        case primary = 5
    }
    
    func updateLook() {
        switch look {
        case .defaultLook:
            break
        case .highContrast:
            backgroundColor = ColorScheme.highContrast
        case .reducedHighContrast:
            backgroundColor = ColorScheme.reducedHighContrast
        case .increasedLowContrast:
            backgroundColor = ColorScheme.increasedlowContrast
        case .lowContrast:
            backgroundColor = ColorScheme.lowContrast
        case .primary:
            backgroundColor = ColorScheme.primary
        }
    }
}
