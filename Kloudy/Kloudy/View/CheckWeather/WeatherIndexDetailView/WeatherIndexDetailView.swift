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
        case .mask: return ["마스크", "dust_png", "미세먼지", "㎍/㎥", "fineDust_png", "초미세먼지", "㎍/㎥", "", ""]
        case .laundry: return ["빨래", "todayWeather_png", "오늘의 날씨", "", "humidity_png", "습도", "%", "", ""]
        case .outer: return ["겉옷", "lowestTemperature_png", "일 최저 기온", "℃", "goWorkingTemperature_png", "출근시간대 온도", "℃", "", ""]
        case .car: return ["세차", "todayWeather_png", "오늘의 날씨", "", "precipitation_png", "강수 예정", "일 후", "", ""]
        case .temperatureGap: return ["일교차", "lowestTemperature_png", "최저 기온", "℃", "highestTemperature_png", "최고 온도", "℃", "", ""]
        }
    }
    
    var totalIndexStep: Int {
        switch self {
        case .unbrella: return 5
        case .mask: return 4
        case .laundry: return 4
        case .outer: return 5
        case .car: return 4
        case .temperatureGap: return 5
        }
    }
    
    var stepImageString: [String] {
        switch self {
        case .unbrella: return ["rain_step1", "rain_step2", "rain_step3", "rain_step4", ""]
        case .mask: return ["마스크_1단계", "마스크_2단계", "마스크_3단계", "mask_4grade"]
        case .laundry: return ["", "", "", ""]
        case .outer: return ["", "", "", "", ""]
        case .car: return ["", "", "", ""]
        case .temperatureGap: return ["", "", "", "", ""]
        }
    }
    
    var stepExplainString: [String] {
        switch self {
        case .unbrella: return ["비가 오지 않습니다.", "우산 없이 후드티를 입고도 가까운 거리를 이동할 수 있습니다.", "우산을 쓰고 이동해야하며, 신발이나 옷이 젖습니다.", "우비를 뚫고 옷이 젖기도 하며, 장화를 신어야할만큼 비가 옵니다.", "위험합니다."]
        case .mask: return ["바깥 활동하기 좋은 공기입니다.", "장시간 노출 시, 건강상 경미한 영향을 줍니다.", "환자군 및 민감군에게 유해한 영향, 일반인에게도 건강상 불쾌감을 줍니다.", "환자군 및 민감군에게 급성 노출시 심각한 영향을 주며 일반인에게도 영향을 끼칩니다."]
        case .laundry: return ["빨래하기 좋은 날입니다.", "빨래하셔도 괜찮습니다.", "실내 건조하세요.", "빨래를 다음으로 미루는 것을 추천드려요."]
        case .outer: return ["캐주얼 재킷, 가디건", "라이더 재킷, 트렌치 코트", "코트, 무스탕, 항공점퍼", "패딩, 두꺼운 코트", "목도리나 장갑 등 방한용품 착용"]
        case .car: return ["세차하기 좋은 날입니다.", "빨래하셔도 괜찮습니다.", "꼭 필요한 게 아니라면 세차를 미루는 것을 추천드려요.", "빨래를 다음으로 미루는 것을 추천드려요."]
        case .temperatureGap: return ["", "", "", "", ""]
        }
    }
    
    var isChartViewIncluded: Bool {
        switch self {
        case .unbrella: return true
        case .mask: return false
        case .laundry: return false
        case .outer: return false
        case .car: return false
        case .temperatureGap: return true
        }
    }
}

class WeatherIndexDetailView: UIViewController {
    
    let disposeBag = DisposeBag()
    let baseBackgroundView = UIView()
    let baseIndexView = UIView()
    let titleLabel = UILabel()
    let firstIconView = IndexIconView(frame: CGRect(origin: .zero, size: CGSize(width: 159, height: 50)))
    let secondIconView = IndexIconView(frame: CGRect(origin: .zero, size: CGSize(width: 159, height: 50)))
    lazy var chartView = IndexChartView()
    let presentButtonView = IndexButtonView()
    let indexStepView = IndexStepView()
    
    var city = String()
    var indexType: IndexType = .unbrella
    
    // API 데이터 받을 시 전달 (_24h)
    var chartValue: Double = 0
    
    var dismissStepView: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    var sendButtonIndex: BehaviorSubject<Int> = BehaviorSubject(value: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        attribute()
        layout()
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
        
        
        chartView.chartLabelText.onNext(indexType.detailIndexString[7])
        chartView.chartUnitText.onNext(indexType.detailIndexString[8])
        
        presentButtonView.totalIndexStep.onNext(indexType.totalIndexStep)
        
        // API 데이터 받을 시 전달
        //        indexIconView.indexStatus.onNext(data.step)
        
        presentButtonView.isDismissButtonTapped
            .subscribe(onNext: {
                if $0 {
                    self.tapDismissButton()
                } else {
                    self.tapPresentButton()
                }
            })
            .disposed(by: disposeBag)
        
        presentButtonView.presentButtonIndex
            .distinctUntilChanged()
            .subscribe(onNext: {
                self.indexStepView.imageString
                    .onNext(self.indexType.stepImageString[$0])
                self.indexStepView.valueString.onNext($0+1)
                self.indexStepView.explainString
                    .onNext(self.indexType.stepExplainString[$0])
            }).disposed(by: disposeBag)
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
        
        [titleLabel, firstIconView, secondIconView, presentButtonView].forEach { baseIndexView.addSubview($0) }
        
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
        
        presentButtonView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(413)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
        }
        
        if indexType.isChartViewIncluded { layoutChartView() }
        
        baseIndexView.addSubview(indexStepView)
        
        indexStepView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(presentButtonView.snp.bottom).offset(7)
            $0.bottom.equalToSuperview().inset(13)
        }
    }
    
    private func layoutChartView() {
        baseIndexView.addSubview(chartView)
        
        chartView.snp.makeConstraints {
            $0.top.equalTo(firstIconView.snp.bottom).offset(42)
            $0.leading.equalTo(6)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(207)
        }
    }
    
    private func attribute() {
        self.view.backgroundColor = UIColor.KColor.clear
        configureBaseBackgroundView()
        configurebBaseIndexView()
        configureTitleLabel()
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
    
    @objc private func tapBackgroundView() {
        self.dismiss(animated: true)
    }
    
    private func tapPresentButton() {
        UIView.animate(withDuration: 0.5) {
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
            self.indexStepView.isPresentStepView.onNext(true)
            self.presentButtonView.presentButton.isHidden = true
            self.presentButtonView.dismissButton.isHidden = false
            self.presentButtonView.collectionView.allowsSelection = true
        }
    }
    
    private func tapDismissButton() {
        self.indexStepView.isPresentStepView.onNext(false)
        UIView.animate(withDuration: 0.5) {
            self.presentButtonView.snp.remakeConstraints {
                $0.top.equalToSuperview().inset(413)
                $0.leading.trailing.equalToSuperview().inset(16)
                $0.bottom.equalToSuperview().inset(20)
                $0.centerX.equalToSuperview()
            }
            self.indexStepView.snp.remakeConstraints {
                $0.leading.trailing.equalToSuperview().inset(16)
                $0.top.equalTo(self.presentButtonView.snp.bottom).offset(7)
                $0.bottom.equalToSuperview().inset(13)
            }
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.presentButtonView.presentButton.isHidden = false
            self.presentButtonView.dismissButton.isHidden = true
            self.presentButtonView.collectionView.allowsSelection = false
            self.presentButtonView.firstTap = false
        }
    }
}
