//
//  IndexIconView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/11/13.
//

import UIKit
import SnapKit
import RxSwift

class IndexIconView: UIView {
    
    let disposeBag = DisposeBag()
    let iconImageView = UIImageView()
    let iconTitleLabel = UILabel()
    let iconNumberLabel = UILabel()
    
    var value = ""
    let iconImage: BehaviorSubject<String> = BehaviorSubject(value: "caution")
    let iconTitle: BehaviorSubject<String> = BehaviorSubject(value: "")
    let iconValue: BehaviorSubject<String> = BehaviorSubject(value: "")
    let iconUnit: BehaviorSubject<String> = BehaviorSubject(value: "")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        iconImage
            .subscribe(onNext: {
                self.iconImageView.image = UIImage(named: $0)
            })
            .disposed(by: disposeBag)
        
        iconTitle
            .subscribe(onNext: {
                self.configureIconTitleLabel(iconTitleText: $0)
            })
            .disposed(by: disposeBag)
        
        iconValue
            .subscribe(onNext: {
                self.value = $0
            })
            .disposed(by: disposeBag)
        
        iconUnit
            .subscribe(onNext: {
                self.configureIconNumberLabel(iconValueText: "\(self.value)\($0)")
            })
            .disposed(by: disposeBag)
    }
    
    private func layout() {
        [iconImageView, iconTitleLabel, iconNumberLabel].forEach{ self.addSubview($0) }
        
        iconImageView.snp.makeConstraints {
            $0.size.equalTo(50)
            $0.top.leading.bottom.equalToSuperview()
        }
        
        iconTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(4)
            $0.leading.equalTo(iconImageView.snp.trailing).offset(12)
        }
        
        iconNumberLabel.snp.makeConstraints {
            $0.top.equalTo(iconTitleLabel.snp.bottom)
            $0.leading.equalTo(iconTitleLabel)
            $0.bottom.equalToSuperview().inset(4)
        }
    }
    
    private func configureIconTitleLabel(iconTitleText: String) {
        iconTitleLabel.text = iconTitleText
        iconTitleLabel.textColor = UIColor.KColor.black
        iconTitleLabel.font = UIFont.KFont.appleSDNeoMedium14
        iconTitleLabel.sizeToFit()
    }
    
    private func configureIconNumberLabel(iconValueText: String) {
        iconNumberLabel.text = iconValueText.localized
        iconNumberLabel.textColor = UIColor.KColor.black
        iconNumberLabel.font = UIFont.KFont.appleSDNeoBold20
        iconNumberLabel.sizeToFit()
    }
}
