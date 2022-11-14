//
//  WeatherIndexDetailView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/11/07.
//

import UIKit
import SnapKit
import Charts
import RxSwift

enum IndexType {
    case unbrella
    case mask
    case laundry
    case outer
    case car
    case temperatureGap
    
    var detailIndexString: [String] {
        switch self {
        case .unbrella: return ["우산", "precipitation_png", "하루 강수량", "mm", "wind_png", "최대 풍속", "m/s", "강수량", "mm"]
        case .mask: return ["마스크", "precipitation_png", "미세먼지", "mm", "wind_png", "초미세먼지", "m/s", "미세먼지", "mm"]
        case .laundry: return ["빨래"]
        case .outer: return ["겉옷"]
        case .car: return ["세차"]
        case .temperatureGap: return ["일교차"]
        }
    }
}

class WeatherIndexDetailView: UIViewController {
    
    let baseBackgroundView = UIView()
    let baseIndexView = UIView()
    let titleLabel = UILabel()
    let firstIconView = IndexIconView(frame: CGRect(origin: .zero, size: CGSize(width: 159, height: 50)))
    let secondIconView = IndexIconView(frame: CGRect(origin: .zero, size: CGSize(width: 159, height: 50)))
    let chartLabel = UILabel()
    let chartUnit = UILabel()
    let chartView = IndexChartView()
    let presentButtonView = IndexButtonView()
    let indexStepView = IndexStepView()
    
    var indexType: IndexType = .unbrella
    
    // API 데이터 받을 시 전달 (_24h)
    var chartValue: Double = 0
    
    var presentButtonTapped: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        layout()
        attribute()
    }
    
    private func bind() {
        firstIconView.iconImage.onNext(indexType.detailIndexString[1])
        firstIconView.iconTitle.onNext(indexType.detailIndexString[2])
        firstIconView.iconUnit.onNext(indexType.detailIndexString[3])
        // API 데이터 받을 시 전달
//        firstIconView.iconValue.onNext(data.precipitaion_24h)
        
        secondIconView.iconImage.onNext(indexType.detailIndexString[4])
        secondIconView.iconTitle.onNext(indexType.detailIndexString[5])
        secondIconView.iconUnit.onNext(indexType.detailIndexString[6])
        // API 데이터 받을 시 전달
//        secondIconView.iconValue.onNext(data.wind)
        
        // API 데이터 받을 시 전달
//        indexIconView.indexStatus.onNext(data.status)
    }
    
    private func layout() {
        [baseBackgroundView, baseIndexView].forEach { view.addSubview($0) }
        
        baseBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        baseIndexView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(350)
            $0.height.equalTo(490)
        }
        
        [titleLabel, firstIconView, secondIconView, chartLabel, chartUnit, chartView, presentButtonView, indexStepView].forEach { baseIndexView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18)
            $0.leading.equalToSuperview().inset(16)
        }
        
        firstIconView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(31)
            $0.leading.equalTo(titleLabel)
        }
        
        secondIconView.snp.makeConstraints {
            $0.top.equalTo(firstIconView)
            $0.leading.equalTo(firstIconView.snp.trailing).offset(159)
        }
        
        chartLabel.snp.makeConstraints {
            $0.top.equalTo(firstIconView.snp.bottom).offset(42)
            $0.leading.equalTo(titleLabel)
        }
        
        chartUnit.snp.makeConstraints {
            $0.leading.equalTo(chartLabel.snp.trailing).offset(4)
            $0.top.equalTo(firstIconView.snp.bottom).offset(38)
        }
        
        chartView.snp.makeConstraints {
            $0.top.equalTo(chartLabel.snp.top).offset(11)
            $0.height.equalTo(190)
            $0.leading.equalTo(6)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        presentButtonView.snp.makeConstraints {
            $0.top.equalTo(chartView.snp.bottom).offset(46)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(20)
//            $0.height.equalTo(57)
            $0.centerX.equalToSuperview()
        }
        
        indexStepView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(presentButtonView.snp.bottom).offset(7)
            $0.bottom.equalToSuperview().inset(13)
        }
    }
    
    private func attribute() {
        self.view.backgroundColor = UIColor.KColor.clear
        configureBaseBackgroundView()
        configurebBaseIndexView()
        configureTitleLabel()
        configureChartLabel()
        presentButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapPresentButton)))
    }
    
    private func configureBaseBackgroundView() {
        baseBackgroundView.backgroundColor = UIColor.KColor.clear.withAlphaComponent(0.5)
        baseBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapBackgroundView)))
    }
    
    private func configurebBaseIndexView() {
        baseIndexView.backgroundColor = UIColor.KColor.white
        baseIndexView.layer.cornerRadius = 10
    }
    
    private func configureTitleLabel() {
        titleLabel.configureLabel(text: "\(indexType.detailIndexString[0]) 지수", font: UIFont.KFont.appleSDNeoBoldMedium, textColor: UIColor.KColor.black)
        titleLabel.sizeToFit()
    }
    
    private func configureChartLabel() {
        chartLabel.configureLabel(text: indexType.detailIndexString[7], font: UIFont.KFont.appleSDNeoMediumSmall, textColor: UIColor.KColor.black)
        chartLabel.sizeToFit()
        
        chartUnit.configureLabel(text: "\(chartValue)\(indexType.detailIndexString[8])", font: UIFont.KFont.appleSDNeoSemiBoldExtraLarge, textColor: UIColor.KColor.black)
        chartUnit.sizeToFit()
    }
    
    @objc private func tapBackgroundView() {
        self.dismiss(animated: true)
    }
    
    @objc private func tapPresentButton() {
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.presentButtonView.snp.remakeConstraints {
                $0.top.equalToSuperview().inset(50)
                $0.leading.trailing.equalToSuperview().inset(16)
                $0.height.equalTo(57)
                $0.centerX.equalToSuperview()
            }
            
            self.indexStepView.snp.remakeConstraints {
                $0.top.equalTo(self.presentButtonView.snp.bottom)
                $0.leading.trailing.equalToSuperview().inset(16)
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().inset(16)
            }
            
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.indexStepView.presentButtonTapped.onNext(true)
        }
            
        
//        UIView.animate(withDuration: 0.7, delay: 0) {
//
//
//        } completion: { _ in
//            print("💙")
//            self.presentButtonView.presentButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
//        }
    }
}
