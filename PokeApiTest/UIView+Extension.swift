//
//  UIView+Extension.swift
//  PokeApiTest
//
//  Created by Valdo Parlinggoman on 13/07/23.
//
import UIKit

extension UIView{
    @IBInspectable var cornerRadius: CGFloat{
        get{ return cornerRadius }
        set{
            self.layer.cornerRadius = newValue
        }
    }
}



extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
