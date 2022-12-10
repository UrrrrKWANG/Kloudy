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
    case umbrella
    case mask
    case laundry
    case outer
    case car
    case temperatureGap
    
    var detailIndexString: [String] {
        switch self {
        case .umbrella: return ["우산".localized, "precipitation_png", "하루 강수량".localized, "mm", "wind_png", "최대 풍속".localized, "m/s", "강수량".localized, "mm"]
        case .mask: return ["마스크".localized, "dust_png", "미세먼지".localized, "㎍/㎥", "fineDust_png", "초미세먼지".localized, "㎍/㎥", "", ""]
        case .laundry: return ["빨래".localized, "todayWeather_png", "오늘의 날씨".localized, "", "humidity_png", "습도".localized, "%", "", ""]
        case .outer: return ["겉옷".localized, "lowestTemperature_png", "일 최저 기온".localized, "℃", "goWorkingTemperature_png", "출근시간대 온도".localized, "℃", "현재 온도".localized, ""]
        case .car: return ["세차".localized, "todayWeather_png", "오늘의 날씨".localized, "", "precipitation_png", "강수 예정".localized, "", "", ""]
        case .temperatureGap: return ["일교차".localized, "lowestTemperature_png", "최저 기온".localized, "℃", "highestTemperature_png", "최고 온도".localized, "℃", "현재 온도".localized, ""]
        }
    }
    
    var totalIndexStep: Int {
        switch self {
        case .umbrella: return 5
        case .mask: return 4
        case .laundry: return 4
        case .outer: return 5
        case .car: return 4
        case .temperatureGap: return 5
        }
    }
    
    var stepImageString: [String] {
        switch self {
        case .umbrella: return ["rain_step1", "rain_step2", "rain_step3", "rain_step4", "rain_step4"]
        case .mask: return ["mask_step1", "mask_step2", "mask_step3", "mask_step4"]
        case .laundry: return ["laundry_4", "laundry_3", "laundry_2", "laundry_1"]
        case .outer: return ["outer_step1", "outer_step2", "outer_step3", "outer_step4", "outer_step5"]
        case .car: return ["carwash_step4", "carwash_step3", "carwash_step2", "carwash_step1"]
        case .temperatureGap: return ["", "", "", "", ""]
        }
    }
    
    var stepExplainString: [String] {
        switch self {
        case .umbrella: return ["비가 오지 않습니다.".localized, "우산 없이 후드티를 입고도 가까운 거리를 이동할 수 있습니다.".localized, "우산을 쓰고 이동해야하며, 신발이나 옷이 젖습니다.".localized, "우비를 뚫고 옷이 젖기도 하며, 장화를 신어야할만큼 비가 옵니다.".localized, "위험합니다.".localized]
        case .mask: return ["바깥 활동하기 좋은 공기입니다.".localized, "장시간 노출 시, 건강상 경미한 영향을 줍니다.".localized, "환자와 민감군에게 유해, 일반인에게 건강상 불쾌감을 줍니다.".localized, "환자와 민감군에게 심각한 영향, 일반인에게 영향을 끼칩니다.".localized]
        case .laundry: return ["빨래하기 좋은 날입니다.".localized, "빨래하셔도 괜찮습니다.".localized, "실내 건조하세요.".localized, "빨래를 다음으로 미루는 것을 추천드려요.".localized]
        case .outer: return ["캐주얼 재킷, 가디건".localized, "라이더 재킷, 트렌치 코트".localized, "코트, 무스탕, 항공점퍼".localized, "패딩, 두꺼운 코트".localized, "목도리나 장갑 등 방한용품 착용".localized]
        case .car: return ["세차하기 좋은 날입니다.".localized, "세차하셔도 괜찮습니다.".localized, "꼭 필요한 게 아니라면 세차를 미루는 것을 추천드려요.".localized, "세차를 다음으로 미루는 것을 추천드려요.".localized]
        case .temperatureGap: return ["", "", "", "", ""]
        }
    }
    
    var isChartViewIncluded: Bool {
        switch self {
        case .umbrella: return true
        case .mask: return false
        case .laundry: return false
        case .outer: return true
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
    
    var city = ""
    var indexType: IndexType = .umbrella
    var weatherData: Weather?
    
    let firstIndexType: BehaviorSubject<IndexType> = BehaviorSubject(value: .umbrella)
    
    init() {
        super.init(nibName: nil, bundle: nil)
        firstIndexType
            .subscribe(onNext: {
                self.indexType = $0
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        attribute()
        layout()
    }
    
    private func bind() {
        // API 데이터 받을 시 전달
        if indexType == .umbrella {
            firstIconView.iconValue.onNext(String(
                round(weatherData?.localWeather[0].weatherIndex[0].umbrellaIndex[0].precipitation24H ?? 0 * 10)/10
            ))
            
            secondIconView.iconValue.onNext(String(
                round(weatherData?.localWeather[0].weatherIndex[0].umbrellaIndex[0].wind ?? 0 * 100)/100
            ))
            
            presentButtonView.indexStatus.onNext(weatherData?.localWeather[0].weatherIndex[0].umbrellaIndex[0].status ?? 1)
            
            chartView.chartType.onNext(.precipitation)
            chartView.chartLabelText.onNext(indexType.detailIndexString[7])
            chartView.chartData.onNext(weatherData?.localWeather[0].hourlyWeather ?? [])
            chartView.chartUnitText.onNext(String(round((weatherData?.localWeather[0].weatherIndex[0].umbrellaIndex[0].precipitation24H ?? 0) * 100)/100) + "mm")
            
        } else if indexType == .mask {
            firstIconView.iconValue.onNext(String(
                round(weatherData?.localWeather[0].weatherIndex[0].maskIndex[0].todayPM10value ?? 0)
            ))
            
            secondIconView.iconValue.onNext(String(
                round(weatherData?.localWeather[0].weatherIndex[0].maskIndex[0].todayPM25value ?? 0)
            ))
            
            presentButtonView.indexStatus.onNext(weatherData?.localWeather[0].weatherIndex[0].maskIndex[0].status ?? 1)

        } else if indexType == .car {
            firstIconView.iconValue.onNext(self.changeCarWashToString(step: weatherData?.localWeather[0].weatherIndex[0].carwashIndex[0].dailyWeather ?? 0))
            
            secondIconView.iconValue.onNext(weatherData?.localWeather[0].weatherIndex[0].carwashIndex[0].weather3Am7pm.localized ?? "")
            
            presentButtonView.indexStatus.onNext(weatherData?.localWeather[0].weatherIndex[0].carwashIndex[0].status ?? 1)
            
        } else if indexType == .laundry {
            firstIconView.iconValue.onNext(self.changeLaundryToString(step: weatherData?.localWeather[0].weatherIndex[0].laundryIndex[0].dailyWeather ?? 0))
            
            secondIconView.iconValue.onNext(String(
                Int(weatherData?.localWeather[0].weatherIndex[0].laundryIndex[0].humidity ?? 0)
            ))
            
            presentButtonView.indexStatus.onNext(weatherData?.localWeather[0].weatherIndex[0].laundryIndex[0].status ?? 1)
            
        } else if indexType == .outer {
            firstIconView.iconValue.onNext(String(Int(weatherData?.localWeather[0].weatherIndex[0].outerIndex[0].dayMinTemperature ?? 0)))
            secondIconView.iconValue.onNext(String(Int(weatherData?.localWeather[0].weatherIndex[0].outerIndex[0].morningTemperature ?? 0)))
            
            if weatherData?.localWeather[0].weatherIndex[0].outerIndex[0].status ?? 1 > 4 {
                presentButtonView.indexStatus.onNext(4)
            } else {
                presentButtonView.indexStatus.onNext(weatherData?.localWeather[0].weatherIndex[0].outerIndex[0].status ?? 1)
            }
            
            chartView.chartType.onNext(.temperature)
            chartView.chartLabelText.onNext(indexType.detailIndexString[7])
            chartView.chartData.onNext(weatherData?.localWeather[0].hourlyWeather ?? [])
            chartView.chartUnitText.onNext(String((weatherData?.localWeather[0].minMaxTemperature()[0] ?? 0)) + "℃")
            
        } else if indexType == .temperatureGap {
            firstIconView.iconValue.onNext(String(Int(weatherData?.localWeather[0].weatherIndex[0].compareIndex[0].todayMinTemperature ?? 0)))
            secondIconView.iconValue.onNext(String(Int(weatherData?.localWeather[0].weatherIndex[0].compareIndex[0].todayMaxtemperature ?? 0)))
            
            if weatherData?.localWeather[0].weatherIndex[0].outerIndex[0].status ?? 1 > 4 {
                presentButtonView.indexStatus.onNext(4)
            } else {
                presentButtonView.indexStatus.onNext(weatherData?.localWeather[0].weatherIndex[0].outerIndex[0].status ?? 1)
            }
            
            chartView.chartType.onNext(.temperature)
            chartView.chartLabelText.onNext(indexType.detailIndexString[7])
            chartView.chartData.onNext(weatherData?.localWeather[0].hourlyWeather ?? [])
            chartView.chartUnitText.onNext(String((weatherData?.localWeather[0].minMaxTemperature()[0] ?? 0)) + "℃")
        }
        
        firstIconView.iconImage.onNext(indexType.detailIndexString[1])
        firstIconView.iconTitle.onNext(indexType.detailIndexString[2])
        firstIconView.iconUnit.onNext(indexType.detailIndexString[3])
        
        secondIconView.iconImage.onNext(indexType.detailIndexString[4])
        secondIconView.iconTitle.onNext(indexType.detailIndexString[5])
        secondIconView.iconUnit.onNext(indexType.detailIndexString[6])
        
        presentButtonView.totalIndexStep.onNext(indexType.totalIndexStep)
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
    
    private func changeCarWashToString(step: Int) -> String {
        switch step {
        case 0: return "맑음".localized
        case 1: return "비".localized
        case 2: return "비/눈".localized
        case 3: return "구름 많음".localized
        case 4: return "흐림".localized
        case 5: return "눈".localized
        default: return "적당함".localized
        }
    }
    
    private func changeLaundryToString(step: Int) -> String {
        switch step {
        case -15: return "비".localized
        case -10: return "비".localized
        case 0: return "흐림".localized
        case 10: return "맑음".localized
        default: return "적당함".localized
        }
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
        
        if indexType == .temperatureGap {
            [presentButtonView, indexStepView].forEach {
                $0.removeFromSuperview()
            }
            baseIndexView.layoutIfNeeded()
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
        titleLabel.configureLabel(text: "\(indexType.detailIndexString[0])" + "지수".localized, font: UIFont.KFont.appleSDNeoBold20, textColor: UIColor.KColor.black)
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
            self.presentButtonView.clearButton.isHidden = true
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
            self.presentButtonView.clearButton.isHidden = false
            self.presentButtonView.collectionView.allowsSelection = false
            self.presentButtonView.firstTap = false
        }
    }
}
