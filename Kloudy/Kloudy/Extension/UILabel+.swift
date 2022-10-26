//
//  UILabel+.swift
//  Kloudy
//
//  Created by 이주화 on 2022/10/25.
//

import UIKit

extension UILabel {
    
    // UILabel을 설정해주는 extension 입니다. ex. UILabel.configureLabel(text: "테스트", font: UIFont.KFont.lexendExtraLarge, textColor: UIColor.KColor.primaryDarkGreen)
    func configureLabel(text: String, font: UIFont, textColor: UIColor) {
        self.text = text
        self.font = font
        self.textColor = textColor
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.5
    }
    
    // UILabel의 특정 글자만 색을 설정해주는 extension 입니다. ex. UILabel.configureLabel(text: "테스트", font: UIFont.KFont.lexendExtraLarge, textColor: UIColor.KColor.primaryDarkGreen, attributeString: ["°", "|"], attributeColor: [UIColor.KColor.primaryDarkGreen, UIColor.KColor.BackgrundBlack])
    func configureLabel(text: String, font: UIFont, textColor: UIColor, attributeString: [String], attributeColor: [UIColor]) {
        self.text = text
        let attributedStr = NSMutableAttributedString(string: self.text!)
        self.font = font
        self.textColor = textColor
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.5
        for index in 0..<attributeString.count {
            attributedStr.addAttribute(.foregroundColor, value: attributeColor[index], range: (self.text! as NSString).range(of: attributeString[index]))
        }
        self.attributedText = attributedStr
    }
}
