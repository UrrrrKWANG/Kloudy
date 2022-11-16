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
    
    private func bind() {
        // SearchBar 를 눌렀을 때 생기는 이벤트
        self.searchTextField.rx.controlEvent([.editingDidBegin])
            .asObservable()
            .subscribe(onNext: {
                self.searchFieldTapped.onNext(true)
            })
            .disposed(by: disposeBag)
        
        // 취소 를 눌렀을 때 생기는 이벤트
        self.searchTextField.rx.controlEvent([.editingDidEnd])
            .asObservable()
            .subscribe(onNext: {
                self.searchFieldTapped.onNext(false)
            })
            .disposed(by: disposeBag)
        
        // SearchBar 의 text 방출
        self.searchTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .bind(to: searchFieldText)
            .disposed(by: disposeBag)
   }
    
    private func attribute() {
        self.placeholder = "지역을 검색해 보세요"
        self.setImage(UIImage(), for: .search, state: .normal)
        self.setImage(UIImage(), for: .clear, state: .normal)
        self.searchBarStyle = .prominent
        self.backgroundImage = UIImage()

        if let textField = self.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor.KColor.gray03 //gray04로 변경예정
            textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.KColor.gray02, NSAttributedString.Key.font : UIFont.KFont.appleSDNeoRegularLarge])
            textField.textColor = UIColor.KColor.gray02
        }
    }
}
