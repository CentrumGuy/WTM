//
//  UILabelX.swift
//  DesignableXTesting
//
//  Created by Mark Moeykens on 1/28/17.
//  Copyright © 2017 Moeykens. All rights reserved.
//

import UIKit

@IBDesignable
class UILabelX: UILabel {
    // MARK: - Corner Radius
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
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
    
    // MARK: - Border
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var rotationAngle: CGFloat = 0 {
        didSet {
            self.transform = CGAffineTransform(rotationAngle: rotationAngle * .pi / 180)
        }
    }
    
    // MARK: - Shadow Text Properties
    
    @IBInspectable public var shadowOpacity: Float = 0 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable public var shadowColorLayer: UIColor = UIColor.black {
        didSet {
            layer.shadowColor = shadowColorLayer.cgColor
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat = 5 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable public var shadowOffsetLayer: CGPoint = CGPoint(x: 0, y: 0) {
        didSet {
            layer.shadowOffset = CGSize(width: shadowOffsetLayer.x, height: shadowOffsetLayer.y)
        }
    }
    
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
    
    override public class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    @IBInspectable private var labelLookFromInt: Int = 0 {
        didSet {
            look = LabelLook(rawValue: labelLookFromInt) ?? .custom
        }
    }
    
    var look: LabelLook = .custom {
        didSet {
            updateLook()
        }
    }
    
    enum LabelLook: Int {
        case custom = 0
        case highContrast = 1
        case reducedHighContrast = 2
        case increasedLowContrast = 3
        case lowContrast = 4
        case primary = 5
    }
    
    func updateLook() {
        switch look {
        case .custom:
            break
        case .highContrast:
            textColor = ColorScheme.highContrast
        case .reducedHighContrast:
            textColor = ColorScheme.reducedHighContrast
        case .increasedLowContrast:
            textColor = ColorScheme.increasedlowContrast
        case .lowContrast:
            textColor = ColorScheme.lowContrast
        case .primary:
            textColor = ColorScheme.primary
        }
    }
    
    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [gradientFirstColor.cgColor, gradientSecondColor.cgColor]
        
        layer.startPoint = gradientStart
        layer.endPoint = gradientEnd
    }
}
