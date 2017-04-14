//
//  UIView+Inspectable.swift
//  ResourceManager
//
//  Created by 李智慧 on 2017/4/8.
//  Copyright © 2017年 北京海睿兴业. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

extension UIView {
    
    @IBInspectable
    public var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable
    public var borderColor: UIColor {
        set {
            layer.borderColor = newValue.cgColor
        }
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
    }
    
    @IBInspectable
    public var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
}

extension UIView {
    
    /**
     Rounds the given set of corners to the specified radius
     
     - parameter corners: Corners to round
     - parameter radius:  Radius to round to
     */
    func round(corners: UIRectCorner, radius: CGFloat) {
        _round(corners: corners, radius: radius)
    }
    
    /**
     Rounds the given set of corners to the specified radius with a border
     
     - parameter corners:     Corners to round
     - parameter radius:      Radius to round to
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func round(corners: UIRectCorner, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        let mask = _round(corners: corners, radius: radius)
        addBorder(mask: mask, borderColor: borderColor, borderWidth: borderWidth)
    }
    
    /**
     Fully rounds an autolayout view (e.g. one with no known frame) with the given diameter and border
     
     - parameter diameter:    The view's diameter
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func fullyRound(diameter: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = diameter / 2
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor;
    }
    
}

private extension UIView {
    
    @discardableResult func _round(corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        return mask
    }
    
    func addBorder(mask: CAShapeLayer, borderColor: UIColor, borderWidth: CGFloat) {
        let borderLayer = CAShapeLayer()
        borderLayer.path = mask.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame = bounds
        layer.addSublayer(borderLayer)
    }
}

//class RMCornerView: UIView {
//
//    @IBInspectable
//    public var cornerRadius: CGFloat = 0.0
//
//    @IBInspectable
//    public var corners: UIRectCorner = [.topLeft,. topRight]
//
//    @IBInspectable
//    public var borderColor: UIColor = .clear
//
//    @IBInspectable
//    public var borderWidth: CGFloat = 0.0
//
//    override func layoutSubviews() {
//        round(corners: self.corners, radius: self.cornerRadius, borderColor: UIColor("#DCDCDC") , borderWidth: self.borderWidth)
//    }
//}
