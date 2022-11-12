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
        static var black: UIColor { UIColor(named: "black")! }
        static var primaryBlue01: UIColor { UIColor(named: "primaryBlue01")! }
        static var primaryBlue02: UIColor { UIColor(named: "primaryBlue02")! }
        static var primaryBlue03: UIColor { UIColor(named: "primaryBlue03")! }
        static var primaryBlue04: UIColor { UIColor(named: "primaryBlue04")! }
        static var primaryBlue05: UIColor { UIColor(named: "primaryBlue05")! }
        static var primaryBlue06: UIColor { UIColor(named: "primaryBlue06")! }
        static var gray01: UIColor { UIColor(named: "gray01")! }
        static var gray02: UIColor { UIColor(named: "gray02")! }
        static var gray03: UIColor { UIColor(named: "gray03")! }
        static var white: UIColor { UIColor(named: "white")! }
        static var clear: UIColor { UIColor.clear }
    }
}
