//
//  WeatherIndexView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/11/07.
//

import UIKit
import SnapKit
import Lottie

class WeatherIndexView: UIView {
    let weatherIndexNameLabel = UILabel()
    let weatherIndexListCollectionView = UICollectionView()
    let weatherIndexPointImageList = [UIImageView(), UIImageView()]
    let weatherIndexLottiView = LottieAnimationView()
    let weatehrIndexStatusLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setLayout() {
        [weatherIndexNameLabel, weatherIndexListCollectionView, weatherIndexPointImageList[0], weatherIndexPointImageList[1], weatherIndexLottiView, weatehrIndexStatusLabel].forEach() {
            self.addSubview($0)
        }
        
        weatherIndexNameLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(20)
            $0.width.equalTo(106)
            $0.height.equalTo(24)
        }
        
        weatherIndexListCollectionView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(283)
            $0.trailing.equalToSuperview().inset(12)
        }
        
        weatherIndexLottiView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(69)
            $0.bottom.equalToSuperview().inset(74)
            $0.leading.equalToSuperview().inset(15)
            $0.trailing.equalToSuperview().inset(93)
        }
        
        weatherIndexPointImageList[0].snp.makeConstraints {
            $0.top.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(337)
            $0.leading.equalToSuperview().inset(199)
            $0.trailing.equalToSuperview().inset(121)
        }
        
        weatherIndexPointImageList[1].snp.makeConstraints {
            $0.top.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(337)
            $0.leading.equalTo(weatherIndexPointImageList[0].snp.trailing).inset(199)
            $0.trailing.equalToSuperview().inset(121)
        }
        
        weatehrIndexStatusLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(337)
            $0.bottom.equalToSuperview().inset(13)
            $0.leading.equalToSuperview().inset(18)
            $0.trailing.equalToSuperview().inset(220)
        }
    }
    
    private func configureView() {
        weatherIndexNameLabel.configureLabel(text: "우산 지수", font: UIFont.KFont.appleSDNeoBoldSmallLarge, textColor: UIColor.KColor.black)
        weatehrIndexStatusLabel.configureLabel(text: "하루종일 내림", font: UIFont.KFont.appleSDNeoSemiBoldMedium, textColor: UIColor(red: 30, green: 45, blue: 96, alpha: 100)) // 색상, 폰트 추가 필요
        weatehrIndexStatusLabel.layer.cornerRadius = 10
        weatehrIndexStatusLabel.layer.backgroundColor = CGColor(red: 96, green: 97, blue: 100, alpha: 100)
    }
}
