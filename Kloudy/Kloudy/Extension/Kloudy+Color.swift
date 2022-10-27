//
//  Kloudy+Color.swift
//  Kloudy
//
//  Created by 이영준 on 2022/10/16.
//

import UIKit

extension UIColor {
    // 사용 방법 : UIColor.KColor.primaryDarkGreen
    enum KColor {
        static var primaryDarkGreen: UIColor { UIColor(named: "PrimaryDarkGreen")! }
        static var primaryGreen: UIColor { UIColor(named: "PrimaryGreen")! }
        static var backgroundBlack: UIColor { UIColor(named: "BackgrundBlack")! }
        static var black: UIColor { UIColor(named: "Black")! }
        static var cellGray: UIColor { UIColor(named: "CellGray")! }
        static var gray01: UIColor { UIColor(named: "Gray01")! }
        static var gray02: UIColor { UIColor(named: "Gray02")! }
        static var gray03: UIColor { UIColor(named: "Gray03")! }
        static var gray04: UIColor { UIColor(named: "Gray04")! }
        static var gray05: UIColor { UIColor(named: "Gray05")! }
        static var gray06: UIColor { UIColor(named: "Gray06")! }
        static var gray07: UIColor { UIColor(named: "Gray07")! }
        static var white: UIColor { UIColor(named: "White")! }
        static var red: UIColor { UIColor(named: "Red")! }
        static var opacityOverlayBlack: UIColor { UIColor(named: "OpacityOverlayBlack")! }
        static var clear: UIColor { UIColor.clear }
    }
}
