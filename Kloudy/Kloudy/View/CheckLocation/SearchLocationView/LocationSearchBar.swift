//
//  LocationSearchBar.swift
//  Kloudy
//
//  Created by 이영준 on 2022/11/08.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class LocationSearchBar: UISearchBar {
    let disposeBag = DisposeBag()
    let searchFieldText: BehaviorSubject<String> = BehaviorSubject(value: "")
    let searchFieldTapped: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func checkEmailValid(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }
    
    private func bind() {
        
   }
    
    private func attribute() {
        self.placeholder = "지역을 검색해 보세요"
        self.setImage(UIImage(), for: .search, state: .normal)
        self.searchBarStyle = .prominent
        self.backgroundImage = UIImage()

        if let textField = self.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor.KColor.gray02
            textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.KColor.gray06, NSAttributedString.Key.font : UIFont.KFont.appleSDNeoRegularLarge])
            textField.textColor = UIColor.KColor.white
        }
    }
}
