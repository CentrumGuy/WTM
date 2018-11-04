//
//  DesignableUITextField.swift
//  SkyApp
//
//  Created by Mark Moeykens on 12/16/16.
//  Copyright © 2016 Mark Moeykens. All rights reserved.
//

import UIKit

@IBDesignable
class UITextFieldX: UITextField {
    var shouldTrimTrailingSpaces = false
    
    override func awakeFromNib() {
        removeTarget(self, action: #selector(trimTrailingSpaces), for: .editingDidEnd)
        removeTarget(self, action: #selector(editingBegan), for: .editingDidBegin)
        removeTarget(self, action: #selector(editingEnded), for: .editingDidEnd)
        
        if shouldTrimTrailingSpaces {
            addTarget(self, action: #selector(trimTrailingSpaces), for: .editingDidEnd)
        }
        
        addTarget(self, action: #selector(editingBegan), for: .editingDidBegin)
        addTarget(self, action: #selector(editingEnded), for: .editingDidEnd)
    }
    
    var xDelegate: UITextFieldXDelegate? {
        didSet {
            delegate = xDelegate
        }
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0 {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftInnerPadding: CGFloat = 0 {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var rightImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var rightPadding: CGFloat = 0 {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var rightInnerPadding: CGFloat = 0 {
        didSet {
            updateView()
        }
    }
    
    var isRightViewVisible: Bool = true {
        didSet {
            updateView()
        }
    }
    
    var imageColor: UIColor? {
        didSet {
            updateView()
        }
    }
    
    override var tintColor: UIColor! {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        setLeftImage()
        setRightImage()
    }
    
    func setLeftImage() {
        leftViewMode = UITextField.ViewMode.always
        var view: UIView
        
        if let image = leftImage {
            let imageView = UIImageView(frame: CGRect(x: leftPadding, y: 0, width: 20, height: 20))
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = imageColor ?? tintColor
            imageView.tag = 1
            
            var width = imageView.frame.width + leftPadding
            
            if borderStyle == UITextField.BorderStyle.none || borderStyle == UITextField.BorderStyle.line {
                width += 10
            }
            
            width += leftInnerPadding
            
            view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20))
            view.addSubview(imageView)
        } else {
            view = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding, height: 20))
        }
        
        leftView = view
    }
    
    func setRightImage() {
        rightViewMode = UITextField.ViewMode.always
        
        var view: UIView
        
        if let image = rightImage, isRightViewVisible {
            let imageView = UIImageView(frame: CGRect(x: rightInnerPadding, y: 0, width: 20, height: 20))
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = imageColor ?? tintColor
            imageView.tag = 1
            
            var width = rightInnerPadding + imageView.frame.width + rightPadding
            
            if borderStyle == UITextField.BorderStyle.none || borderStyle == UITextField.BorderStyle.line {
                width += 10
            }
            
            view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20))
            view.addSubview(imageView)
        } else {
            view = UIView(frame: CGRect(x: 0, y: 0, width: rightPadding, height: 20))
        }
        
        rightView = view
    }
    
    // MARK: - Corner Radius
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    // MARK: - Borders
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    // MARK - Description
    var descriptorView: UILabel?
    @IBInspectable var descriptor: String? {
        didSet {
            updateDescriptorView()
        }
    }
    
    @IBInspectable var descriptorTextColor: UIColor? {
        didSet {
            updateDescriptorView()
        }
    }
    
    @IBInspectable var descriptorScale: CGFloat = 0.75
    
    func updateDescriptorView() {
        if let descriptor = descriptor {
            if descriptorView == nil {
                let editingFrame = editingRect(forBounds: bounds)
                let viewFrame = CGRect(x: editingFrame.origin.x, y: editingFrame.origin.y, width: editingFrame.width, height: editingFrame.height)
                let label = UILabel(frame: viewFrame)
                descriptorView = label
                descriptorView?.font = font
                descriptorView?.textAlignment = textAlignment
                addSubview(label)
            }
            
            descriptorView!.text = descriptor
            descriptorView!.textColor = descriptorTextColor ?? tintColor
        } else if descriptorView != nil {
            descriptorView!.removeFromSuperview()
            descriptorView = nil
        }
    }

    @objc func editingBegan() {
        guard text == nil || text!.isEmpty else {
            return
        }
        
        if let descriptorView = descriptorView {
            let scale = descriptorScale
            var transform: CGAffineTransform
            switch (textAlignment) {
            case .center:
                transform = CGAffineTransform(translationX: 0, y: -1 * (4/5) * frame.height)
                break
            case .right:
                transform = CGAffineTransform(translationX: (descriptorView.frame.width - (descriptorView.frame.width * scale)) * 1/2, y: -1 * (4/5) * frame.height)
                break
            default:
                transform = CGAffineTransform(translationX: (descriptorView.frame.width - (descriptorView.frame.width * scale)) * -1/2, y: -1 * (4/5) * frame.height)
                break
            }
            
            UIView.animate(withDuration: 0.2) {
                descriptorView.transform = transform.scaledBy(x: scale, y: scale)
            }
        }
    }
    
    @objc func editingEnded() {
        if let descriptorView = descriptorView, text == nil || text!.isEmpty {
            UIView.animate(withDuration: 0.2) {
                descriptorView.transform = .identity
            }
        }
    }
    
    func setRightImgColor(color: UIColor) {
        rightView?.viewWithTag(1)?.tintColor = color
    }
    
    func setLeftImgColor(color: UIColor) {
        leftView?.viewWithTag(1)?.tintColor = color
    }
    
    var lineView: UIView?
    var lineThickness: CGFloat = 1
    var lineColor: UIColor?
    enum LineType {
        case full
        case extendingRight
        case extendingLeft
        case none
    }
    
    func applyLine(lineType: LineType) {
        if lineType == .none {
            lineView?.removeFromSuperview()
            lineView = nil
            return
        }
        
        if lineView == nil {
            lineView = UIView()
            addSubview(lineView!)
        }
        
        var frame = CGRect(x: 0, y: bounds.height - lineThickness, width: bounds.width, height: lineThickness)
        if lineType == .full {
            lineView?.frame = frame
        } else if lineType == .extendingRight {
            frame = CGRect(x: 0, y: bounds.height - lineThickness, width: 9999999, height: lineThickness)
            lineView?.frame = frame
        } else if lineType == .extendingLeft {
            frame = CGRect(x: -9999999 + bounds.width, y: bounds.height - lineThickness, width: 9999999, height: lineThickness)
            lineView?.frame = frame
        }
        
        lineView?.backgroundColor = lineColor
    }
    
    @IBInspectable var colored: Bool = false
    
    @IBInspectable private var fieldLookFromInt: Int = 0 {
        didSet {
            look = FieldLook(rawValue: fieldLookFromInt) ?? FieldLook.custom
        }
    }
    
    var look: FieldLook = .custom
    enum FieldLook: Int {
        case custom = 0
        case underline = 1
        case filledRectangle = 2
        case withDescriptor = 3
    }
    
    @objc func trimTrailingSpaces() {
        text?.trimmedTrailingSpaces()
    }
    
    override func deleteBackward() {
        super.deleteBackward()
        xDelegate?.textFieldDidDeleteBackwards?(self)
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if let toReturn = xDelegate?.canPerformAction?(self, action, withSender: sender) {
            return toReturn
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
}

@objc protocol UITextFieldXDelegate: UITextFieldDelegate {
    @objc optional func textFieldDidDeleteBackwards(_ textField: UITextFieldX)
    @objc optional func canPerformAction(_ textField: UITextFieldX, _ action: Selector, withSender sender: Any?) -> Bool
}
