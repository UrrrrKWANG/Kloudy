//
//  CheckWeatherCellLabelView.swift
//  Kloudy
//
//  Created by Byeon jinha on 2022/10/25.
//

import UIKit

class CheckWeatherCellLabelView: UIView{
    
    private lazy var todayIndex: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.KColor.gray04
        label.text = "오늘의 생활 지수"
        label.font = UIFont.KFont.appleSDNeoSemiBoldSmall
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.setPreferredSymbolConfiguration(
            UIImage.SymbolConfiguration(pointSize: 14, weight: .light), forImageIn: .normal
        )
        // 버튼 사이즈 및 굵기 조절
        button.tintColor = UIColor.KColor.gray04
        //버튼 색상
        //        button.addTarget(self, action: #selector(넘어갈 뷰), for: .touchUpInside)
        return button
    }()
    
    private lazy var separatorView: UIView = {
        let line = UIView()
        line.backgroundColor =  UIColor.KColor.gray02
        return line
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {  //레이아웃 서브뷰 공부 더하기
        [todayIndex, addButton, separatorView].forEach {
                self.addSubview($0)
        }
        self.todayIndex.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(14)
            $0.leading.centerY.equalToSuperview()
        }
        self.addButton.snp.makeConstraints {
            $0.width.height.equalTo(14)
            $0.trailing.centerY.equalToSuperview()
        }
        self.separatorView.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width*0.9)
            $0.height.equalTo(1)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(15)
        }
    }
}
