//
//  CALayer+.swift
//  Kloudy
//
//  Created by Hyeongjung on 2022/11/14.
//

import UIKit

// CALayer을 설정해주는 extenstion입니다. ex) detailWeatherView.layer.applySketchShadow(color: UIColor.KColor.primaryBlue01, alpha: 0.1, x: 0, y: 0, blur: 40, spread: 0)
public extension CALayer {
    func applySketchShadow(
        color: UIColor,
        alpha: Float,
        x: CGFloat,
        y: CGFloat,
        blur: CGFloat,
        spread: CGFloat
    ) {
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / UIScreen.main.scale
        if spread == 0 {
            shadowPath = nil
        } else {
            let rect = bounds.insetBy(dx: -spread, dy: -spread)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
