//
//  Kloudy+Font.swift
//  Kloudy
//
//  Created by 이영준 on 2022/10/16.
//

import UIKit

enum KFont {
    case lexendExtraLarge
    case lexendLarge
    case lexendMedium
    case lexendSmall
    case lexendMini
    
    case appleSDNeoBoldLarge
    case appleSDNeoBoldMedium
    case appleSDNeoBoldSmall
    
    case appleSDNeoSemiBoldLarge
    case appleSDNeoSemiBoldMedium
    case appleSDNeoSemiBoldSmall
    case appleSDNeoSemiBoldMini
    
    case appleSDNeoMediumLarge
    case appleSDNeoMediumMedium
    case appleSDNeoMediumSmall
    
    case appleSDNeoRegularLarge
    case appleSDNeoRegularMedium
    case appleSDNeoRegularSmall
}

extension UIFont {
    static func customFont(_ name: KFont) -> UIFont {
        switch name {
        case .lexendExtraLarge:
            return UIFont(name: "lexendExtraLarge", size: 100) ?? UIFont()
        case .lexendLarge:
            return UIFont(name: "Lexend-Regular", size: 34) ?? UIFont()
        case .lexendMedium:
            return UIFont(name: "Lexend-Regular", size: 20) ?? UIFont()
        case .lexendSmall:
            return UIFont(name: "Lexend-Regular", size: 15) ?? UIFont()
        case .lexendMini:
            return UIFont(name: "Lexend-Regular", size: 14) ?? UIFont()
            
        case .appleSDNeoBoldLarge:
            return UIFont(name: "AppleSDGothicNeo-Bold", size: 24) ?? UIFont()
        case .appleSDNeoBoldMedium:
            return UIFont(name: "AppleSDGothicNeo-Bold", size: 20) ?? UIFont()
        case .appleSDNeoBoldSmall:
            return UIFont(name: "AppleSDGothicNeo-Bold", size: 18) ?? UIFont()
            
            
        case .appleSDNeoSemiBoldLarge:
            return UIFont(name: "AppleSDGothicNeo-SemiBold", size: 18) ?? UIFont()
        case .appleSDNeoSemiBoldMedium:
            return UIFont(name: "AppleSDGothicNeo-SemiBold", size: 17) ?? UIFont()
        case .appleSDNeoSemiBoldSmall:
            return UIFont(name: "AppleSDGothicNeo-SemiBold", size: 14) ?? UIFont()
        case .appleSDNeoSemiBoldMini:
            return UIFont(name: "AppleSDGothicNeo-SemiBold", size: 12) ?? UIFont()
            
            
        case .appleSDNeoMediumLarge:
            return   UIFont(name: "AppleSDGothicNeo-Medium", size: 20) ?? UIFont()
        case .appleSDNeoMediumMedium:
            return   UIFont(name: "AppleSDGothicNeo-Medium", size: 15) ?? UIFont()
        case .appleSDNeoMediumSmall:
            return   UIFont(name: "AppleSDGothicNeo-Medium", size: 14) ?? UIFont()
            
        case .appleSDNeoRegularLarge:
            return   UIFont(name: "AppleSDGothicNeo-Regular", size: 18) ?? UIFont()
        case .appleSDNeoRegularMedium:
            return   UIFont(name: "AppleSDGothicNeo-Regular", size: 17) ?? UIFont()
        case .appleSDNeoRegularSmall:
            return   UIFont(name: "AppleSDGothicNeo-Regular", size: 15) ?? UIFont()
        }
    }
}
