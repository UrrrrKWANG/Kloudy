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
        static var black: UIColor { UIColor(named: "Black")! }
        static var primaryBlue01: UIColor { UIColor(named: "PrimaryBlue01")! }
        static var primaryBlue02: UIColor { UIColor(named: "PrimaryBlue02")! }
        static var primaryBlue03: UIColor { UIColor(named: "PrimaryBlue03")! }
        static var primaryBlue04: UIColor { UIColor(named: "PrimaryBlue04")! }
        static var primaryBlue05: UIColor { UIColor(named: "PrimaryBlue05")! }
        static var primaryBlue06: UIColor { UIColor(named: "PrimaryBlue06")! }
        static var gray01: UIColor { UIColor(named: "Gray01")! }
        static var gray02: UIColor { UIColor(named: "Gray02")! }
        static var gray03: UIColor { UIColor(named: "Gray03")! }
        static var white: UIColor { UIColor(named: "White")! }
        static var clear: UIColor { UIColor.clear }
    }
}
