//
//  CheckWeatherEditNavigationView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/10/17.
//

import UIKit
import SnapKit

class CheckWeatherEditNavigationView: UIView {
    let addCellButton = UIButton()
    let completeButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addSubview(addCellButton)
        self.addSubview(completeButton)
        
//        configureAddCellButton()
//        configureCompleteButton()
    }
    
    private func configureAddCellButton() {
        addCellButton.layer.cornerRadius = 13
        addCellButton.layer.borderWidth = 1.0
        
        //TODO: Asset/Resource 파일 생성 시 수정
        addCellButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addCellButton.tintColor = .black
        addCellButton.layer.borderColor = UIColor.systemGray4.cgColor
        addCellButton.backgroundColor = .systemGray4
        
        addCellButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.width.equalTo(68)
            $0.height.equalTo(26)
        }
    }
    
//    private func configureCompleteButton() {
//        completeButton.layer.cornerRadius = 13
//        completeButton.layer.borderWidth = 1.0
//
//        //TODO: Asset/Resource 파일 생성 시 수정
//        completeButton.layer.borderColor = UIColor.systemGray4.cgColor
//        completeButton.backgroundColor = .systemGray4
//        completeButton.setTitle("완료", for: .normal)
//        completeButton.setTitleColor(UIColor.black, for: .normal)
//
//        completeButton.snp.makeConstraints {
//            $0.trailing.equalToSuperview()
//            $0.width.equalTo(68)
//            $0.height.equalTo(26)
//        }
//    }
}
