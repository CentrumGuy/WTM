//
//  Color Scheme.swift
//  UIExperiments
//
//  Created by Shahar Ben-Dor on 8/16/18.
//  Copyright © 2018 Quantum. All rights reserved.
//

import Foundation
import UIKit

class ColorScheme {
    /*
     CREDITS:
     */
    
    static var isDark = false
    
    static let primary = #colorLiteral(red: 0.7254901961, green: 0.05098039216, blue: 0.2039215686, alpha: 1)
    static let secondary = #colorLiteral(red: 0.7254901961, green: 0.05098039216, blue: 0.2039215686, alpha: 1)
    static let gradient1 = #colorLiteral(red: 0.5889388568, green: 0.05098039216, blue: 0.2477831757, alpha: 1)
    static let gradient2 = #colorLiteral(red: 0.8235928747, green: 0.05098039216, blue: 0.08324634539, alpha: 1)
    
    static let interactive = #colorLiteral(red: 0.5137254902, green: 0.1411764706, blue: 0.9764705882, alpha: 1)
    static let interactiveD1 = #colorLiteral(red: 0.3607843137, green: 0.1294117647, blue: 0.6470588235, alpha: 1)
    static let interactiveGradient1 = #colorLiteral(red: 0.8078431373, green: 0.6156862745, blue: 0.9882352941, alpha: 1)
    static let interactiveGradient2 = #colorLiteral(red: 0.2235294118, green: 0.05490196078, blue: 0.6823529412, alpha: 1)
    
    static let l1 = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let l2 = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
    static let l3 = #colorLiteral(red: 0.7843137255, green: 0.7843137255, blue: 0.7843137255, alpha: 1)
    static let d1 = #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.2352941176, alpha: 1)
    static let d2 = #colorLiteral(red: 0.2745098039, green: 0.2745098039, blue: 0.2745098039, alpha: 1)
    static let d3 = #colorLiteral(red: 0.3137254902, green: 0.3137254902, blue: 0.3137254902, alpha: 1)
    static let d4 = #colorLiteral(red: 0.3921568627, green: 0.3921568627, blue: 0.3921568627, alpha: 1)
    
    static var lowContrast: UIColor {
        get {
            if isDark {
                return d3
            }
            
            return l2
        }
    }
    static var increasedlowContrast: UIColor {
        get {
            if isDark {
                return d4
            }
            
            return l3
        }
    }
    static var highContrast: UIColor {
        get {
            if isDark {
                return l1
            }

            return d1
        }
    }
    static var reducedHighContrast: UIColor {
        get {
            if isDark {
                return l2
            }

            return d3
        }
    }
    static let error = UIColor(red: 255/255, green: 90/255, blue: 90/255, alpha: 1)
    static let success = UIColor(red: 100/255, green: 230/255, blue: 180/255, alpha: 1)
    static var disabled: UIColor {
        get {
            if isDark {
                return d4
            }

            return l3
        }
    }
    
    static let disabledTint: UIColor = ColorScheme.darkText
    static let darkText = l1
    static let lightText = d2
    static var text: UIColor {
        get {
            if isDark {
                return darkText
            }
            
            return lightText
        }
    }
    static var bg: UIColor {
        get {
            if isDark {
                return d1
            }
            
            return l1
        }
    }
    static let darkTint = bg
    
    static let titleFont = UIFont(name: "AvenirNext-Medium", size: 35)
    
    private static func applyBackground(bg: UIImage?) -> UIImage? {
        if let bg = bg {
            if isDark {
                return applyBrightnessContrast(brightness: -0.475, contrast: 0.1, image: bg)
            } else {
                return applyBrightnessContrast(brightness: 0.25, contrast: 0.9, image: bg)
            }
        }
        
        return nil
    }
    
    private static func applyBrightnessContrast(brightness: Float?, contrast: Float?, image: UIImage) -> UIImage {
        let aCGImage = image.cgImage
        let aCIImage = CIImage(cgImage: aCGImage!)
        let context = CIContext(options: nil)
        let filter = CIFilter(name: "CIColorControls")
        filter!.setValue(aCIImage, forKey: "inputImage")
        
        if let brightness = brightness {
            filter!.setValue(brightness, forKey: "inputBrightness")
        }
        
        if let contrast = contrast {
            filter!.setValue(contrast, forKey: "inputContrast")
        }
        let outputImage = filter!.outputImage!
        let cgimg = context.createCGImage(outputImage, from: outputImage.extent)
        let newUIImage = UIImage(cgImage: cgimg!)
        return newUIImage
    }
    
    public static func apply(superView: UIView, bgImage: UIImageView? = nil, hardIgnore: [UIView]? = nil, softIgnore: [UIView]? = nil, applySections: Bool, isMain: Bool) {
        if isMain {
            superView.backgroundColor = self.bg
        }
        
        var newSoft = softIgnore
        if let bg = bgImage {
            bg.image = applyBackground(bg: bg.image)
            
            if newSoft == nil {
                newSoft = [UIView]()
            }
            
            if !newSoft!.contains(bg) {
                newSoft!.append(bg)
            }
        }
        
        for view in superView.subviews {
            if view.tag == -2 || hardIgnore != nil && hardIgnore!.contains(view) {
                continue
            }
            
            if view.tag == -1 || softIgnore != nil && softIgnore!.contains(view) {
                ColorScheme.apply(superView: view, bgImage: nil, hardIgnore: hardIgnore, softIgnore: softIgnore, applySections: applySections, isMain: false)
                continue
            }
            
            if let field = view as? UITextField {
                field.minimumFontSize = (field.font?.pointSize ?? 7) - 3
                if field.layer.borderWidth > 0 {
                    updateOutline(textField: field, state: .regular)
                }
                
                field.attributedPlaceholder = NSAttributedString(string: field.placeholder ?? "", attributes:[NSAttributedString.Key.foregroundColor: text.withAlphaComponent(0.6)])
                
                if let fieldX = field as? UITextFieldX {
                    switch fieldX.look {
                    case .custom:
                        break
                    case .filledRectangle:
                        fieldX.backgroundColor = lowContrast
                        break
                    case .underline:
                        fieldX.lineColor = primary
                        fieldX.applyLine(lineType: .extendingRight)
                        break
                    case .withDescriptor:
                        if fieldX.descriptor == nil || fieldX.descriptor!.isEmpty {
                            fieldX.descriptor = fieldX.placeholder
                        }
                        fieldX.placeholder = nil
                        break
                    }
                    
                    if !fieldX.colored {
                        fieldX.tintColor = primary
                        fieldX.textColor = reducedHighContrast
                        fieldX.imageColor = reducedHighContrast
                        fieldX.descriptorTextColor = increasedlowContrast
                        fieldX.updateDescriptorView()
                        fieldX.updateView()
                        continue
                    }
                }
                
                field.tintColor = secondary
                field.textColor = text
                
                continue
            }
            
            if let button = view as? UIButton {
                if let buttonX = button as? UIButtonX {
                    if buttonX.look != .custom {
                        buttonX.adjustsImageWhenHighlighted = false
                    }
                    
                    switch buttonX.look {
                    case .custom:
                        ColorScheme.apply(superView: view, bgImage: nil, hardIgnore: hardIgnore, softIgnore: softIgnore, applySections: applySections, isMain: false)
                        break
                    case .filled:
                        buttonX.backgroundColor = interactive
                        buttonX.selectedColor = interactiveD1
                        buttonX.tintColor = darkText
                        
                        buttonX.defaultBorder = UIColor.clear
                        buttonX.defaultBackground = interactive
                        break
                    case .outline:
                        buttonX.backgroundColor = nil
                        buttonX.tintColor = interactive
                        buttonX.setTitleColor(interactive, for: .normal)
                        buttonX.borderColor = interactive
                        buttonX.borderWidth = 2
                        
                        buttonX.setTitleColor(interactiveD1, for: .selected)
                        buttonX.selectedColor = interactiveD1
                        
                        buttonX.setTitleColor(disabled, for: .disabled)
                        
                        buttonX.defaultBorder = interactive
                        buttonX.defaultTint = interactive
                        buttonX.defaultBackground = nil
                        break
                    case .gradient:
                        buttonX.gradientFirstColor = interactiveGradient1
                        buttonX.gradientSecondColor = interactiveGradient2
                        buttonX.gradientStart = CGPoint(x: 0, y: 0)
                        buttonX.gradientEnd = CGPoint(x: 1, y: 1)
                        break
                    case .coloredText:
                        buttonX.setTitleColor(interactive, for: .normal)
                        buttonX.tintColor = interactive
                    case .contrastedText:
                        buttonX.setTitleColor(reducedHighContrast, for: .normal)
                        buttonX.tintColor = reducedHighContrast
                    case .reduceContrastText:
                        buttonX.setTitleColor(reducedHighContrast, for: .selected)
                        buttonX.setTitleColor(increasedlowContrast, for: .normal)
                        buttonX.tintColor = increasedlowContrast
                    }
                } else {
                    if button.backgroundColor != nil {
                        button.backgroundColor = interactive
                    } else {
                        button.tintColor = primary
                        button.setTitleColor(primary, for: .normal)
                    }
                }
                
                continue
            }
            
            if let gradientLabel = view as? UIGradientLabel {
                gradientLabel.backgroundColor = UIColor.clear
                gradientLabel.labelFontSize = (UIScreen.main.bounds.width / 320) * 35
                gradientLabel.labelFontName = "AvenirNext-Bold"
                gradientLabel.gradientFirstColor = gradient1
                gradientLabel.gradientSecondColor = gradient2
                gradientLabel.gradientStart = CGPoint(x: 0, y: 0)
                gradientLabel.gradientEnd = CGPoint(x: 1, y: 1)
                
                gradientLabel.label.setLineSpacing(lineSpacing: 1, lineHeightMultiple: 0.85)
                
                if !superView.isKind(of: UIShadowView.self) && gradientLabel.shadowOpacity > 0 {
                    let shadowView = UIShadowView(frame: gradientLabel.frame)
                    let constraints = gradientLabel.constraints
                    gradientLabel.removeConstraints(constraints)
                    gradientLabel.frame = shadowView.bounds
                    superView.addSubview(shadowView)
                    shadowView.addSubview(gradientLabel)
                    shadowView.addConstraints(constraints)
                    shadowView.updateConstraints()
                    
                    shadowView.shadowColor = gradientLabel.shadowColor
                    shadowView.shadowRadius = gradientLabel.shadowRadius
                    shadowView.shadowOffset = gradientLabel.shadowOffset
                    shadowView.shadowOpacity = isDark ? gradientLabel.shadowOpacity + 0.25 : gradientLabel.shadowOpacity
                }
                
                continue
            }
            
            if let gradientImage = view as? UIGradientImage {
                gradientImage.backgroundColor = UIColor.clear
                gradientImage.contentMode = .scaleAspectFit
                gradientImage.gradientFirstColor = gradient1
                gradientImage.gradientSecondColor = gradient2
                
                if !superView.isKind(of: UIShadowView.self) && gradientImage.shadowOpacity > 0 {
                    let shadowView = UIShadowView(frame: gradientImage.frame)
                    let constraints = gradientImage.constraints
                    gradientImage.removeConstraints(constraints)
                    gradientImage.frame = shadowView.bounds
                    superView.addSubview(shadowView)
                    shadowView.addSubview(gradientImage)
                    shadowView.addConstraints(constraints)
                    shadowView.updateConstraints()
                    shadowView.layoutIfNeeded()
                    
                    shadowView.shadowColor = gradientImage.shadowColor
                    shadowView.shadowRadius = gradientImage.shadowRadius
                    shadowView.shadowOffset = gradientImage.shadowOffset
                    shadowView.shadowOpacity = isDark ? gradientImage.shadowOpacity + 0.25 : gradientImage.shadowOpacity
                }
                
                continue
            }
            
            if let label = view as? UILabel {
                if let labelX = label as? UILabelX {
                    labelX.updateLook()
                    continue
                }
                
                label.textColor = reducedHighContrast
                continue
            }

            view.tintColor = primary
            
            if let view = view as? UIViewX, !view.ignoresColorScheme {
                if view.gradientFirstColor != UIColor.clear && view.gradientSecondColor != UIColor.clear {
                    view.gradientFirstColor = gradient1
                    view.gradientSecondColor = gradient2
                }
                
                if view.look == .defaultLook {
                    if view.shadowOpacity > 0, view.backgroundColor != nil && view.backgroundColor != UIColor.clear {
                        view.backgroundColor = bg
                    } else if applySections && view.subviews.count >= 1 {
                        view.backgroundColor = lowContrast
                    }
                }
            } else if view.backgroundColor != nil && view.backgroundColor != UIColor.clear {
                if view.subviews.count == 0 {
                    view.backgroundColor = highContrast
                    continue
                } else if applySections {
                    view.backgroundColor = lowContrast
                }
            }
            
            ColorScheme.apply(superView: view, bgImage: nil, hardIgnore: hardIgnore, softIgnore: softIgnore, applySections: applySections, isMain: false)
        }
    }
    
    enum TextFieldState {
        case regular
        case success
        case error
    }
    
    public static func updateOutline(textField: UITextField, state: TextFieldState) {
        if state == .regular {
            textField.layer.borderColor = reducedHighContrast.withAlphaComponent(0.7).cgColor
        } else if state == .success {
            textField.layer.borderColor = success.cgColor
        } else {
            textField.layer.borderColor = error.cgColor
        }
    }
}
