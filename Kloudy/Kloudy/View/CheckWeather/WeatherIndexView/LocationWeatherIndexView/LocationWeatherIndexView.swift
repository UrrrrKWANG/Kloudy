//
//  LocationWeatherIndexView.swift
//  Kloudy
//
//  Created by Byeon jinha on 2022/11/14.
//

import UIKit
import SnapKit
import Lottie
import RxSwift
import RxCocoa

class LocationWeatherIndexView: UIView {
    var cityIndex = Int()
    
    lazy var internalIndex = 0
    let weatherIndexNameLabel = UILabel()
    let intenalIndexListView = UIView()
    var containerView = UIView()
    var textContainerView = UIView()
    var city = String()
    let weatherIndexStatusLabel = WeatherIndexStatusLabel()
    
    private var layout : UICollectionViewFlowLayout {
        let layout = CollectionViewRightAlignFlowLayout(cellItemSize: 30)
        return layout
    }
    
    let indexViewTapped: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var cityString: BehaviorSubject<String> = BehaviorSubject(value: "")
    var indexString: BehaviorSubject<IndexType> = BehaviorSubject(value: .umbrella)
    let tapGesture = UITapGestureRecognizer()
    let disposeBag = DisposeBag()
    
    var indexArray = [IndexType]()
    var weathers: Weather?
    
    let sentWeather = PublishSubject<Weather>()
    
    //    var indexName: IndexType?
    var sentIndexName: IndexType?
    var indexName = PublishSubject<IndexType>()
    var transedIndexName: String = ""
    var indexStatus = PublishSubject<Int>()
    var imageOrLottieName: String = ""
    var compareIndexText = ""
    var umbrellaIndexText = ""
    
    let temperatureGapView = TemperatureGapView()
    
    // 내부 지수 배열을 받을 변수
    let sentIndexArray = PublishSubject<[IndexType]>()
    
    //TODO: 페이지 개수 받아오는 부분 (임시)
    init() {
        super.init(frame: .zero)
        setLayout()
        bind()
        changeCollectionView(internalIndex: 0)
        containerView.addGestureRecognizer(tapGesture)
        temperatureGapView.addGestureRecognizer(tapGesture)
    }
    
    private func bind() {
        tapGesture.rx.event
            .bind(onNext: { _ in
                self.indexViewTapped.onNext(true)
            })
            .disposed(by: disposeBag)
        
        sentWeather
            .subscribe(onNext: {
                self.weathers = $0
            })
            .disposed(by: disposeBag)
        
        sentIndexArray
            .subscribe(onNext: {
                self.indexArray = $0
                self.indexName.onNext($0[0])
            })
            .disposed(by: disposeBag)
        
        indexName
            .subscribe(onNext: {
                self.transedIndexName = self.transIndexName(indexName: $0)
                self.sentIndexName = $0
                self.changeTextView(indexType: $0)
                guard let weathers = self.weathers else { return }
                let weatherIndex = weathers.localWeather[0].weatherIndex[0]
                if $0 == .temperatureGap {
                    if self.containerView.subviews.count != 0 {
                        self.containerView.subviews[0].removeFromSuperview()
                    }
                    self.temperatureGapView.sentWeather.onNext(weathers)
                    self.makeCompareIndexText(compareIndex: weathers.localWeather[0].weatherIndex[0].compareIndex[0])
                    self.configureView(indexNameLabel: self.transedIndexName, indexStatusLabel: self.compareIndexText)
                } else if $0 == .umbrella {
                    self.makeUmbrellaIndexText(umbrellaHourly: weathers.localWeather[0].weatherIndex[0].umbrellaIndex[0].umbrellaHourly)
                    self.configureView(indexNameLabel: self.transedIndexName, indexStatusLabel: self.umbrellaIndexText)
                    self.indexStatus.onNext(self.findStatus(indexName: $0))
                } else if $0 == .outer {
                    let outerTextArray: [String] = ["캐주얼 재킷, 가디건".localized, "캐주얼 재킷, 가디건".localized, "라이더 재킷, 트렌치 코트".localized, "코트, 무스탕, 항공점퍼".localized, "패딩, 두꺼운 코트".localized, "목도리나 장갑 등 방한용품 착용".localized]
                    self.configureView(indexNameLabel: self.transedIndexName, indexStatusLabel: outerTextArray[weathers.localWeather[0].weatherIndex[0].outerIndex[0].status])
                    self.indexStatus.onNext(self.findStatus(indexName: $0))
                } else if $0 == .mask {
                    let maskTextArray: [String] = ["좋음".localized, "보통".localized, "나쁨".localized, "매우나쁨".localized]
                    self.configureView(indexNameLabel: self.transedIndexName, indexStatusLabel: maskTextArray[weatherIndex.maskIndex[0].status])
                    self.indexStatus.onNext(self.findStatus(indexName: $0))
                } else {
                    self.configureView(indexNameLabel: self.transedIndexName, indexStatusLabel: "")
                    self.indexStatus.onNext(self.findStatus(indexName: $0))
                }
            })
            .disposed(by: disposeBag)
        
        indexStatus
            .subscribe(onNext: {
                self.imageOrLottieName = self.findImageOrLottieName(indexName: self.sentIndexName ?? .umbrella, status: $0)
                self.changeImageView(name: self.imageOrLottieName)
            })
            .disposed(by: disposeBag)
    }
    
    func makeUmbrellaIndexText(umbrellaHourly: [UmbrellaHourly]) {
        var rainArray:[Int] = [0,0,0,0]
        var now = (Int(Date().getTimeOfDay()) ?? 0)
        
        switch now {
        case 0...5:
            now = 0
        case 6...11:
            now = 1
        case 12...17:
            now = 2
        case 18...23:
            now = 3
        default:
            break
        }
        
        umbrellaHourly.forEach {
            if $0.time <= 5 && $0.precipitation != 0.0 {
                rainArray[0] += 1
            } else if $0.time >= 6 && $0.time < 12 && $0.precipitation != 0.0 {
                rainArray[1] += 1
            } else if $0.time >= 12 && $0.time < 18 && $0.precipitation != 0.0 {
                rainArray[2] += 1
            } else if $0.time >= 18 && $0.time < 24 && $0.precipitation != 0.0 {
                rainArray[3] += 1
            }
        }
        var capricious: [Int] = []
        var raining: [Int] = []
        var once: [Int] = []
        for (index, rain) in rainArray.enumerated() {
            if index >= now && rain > 0 && rain < 4 {
                capricious.append(index)
                once.append(index)
            }
            if index >= now && rain >= 4{
                raining.append(index)
            }
        }
        var rainText = ""
        if now == 0 {
            if rainArray.reduce(0, +) >= 16 {
                rainText = "하루종일 내림".localized
            } else if raining.count >= 3 {
                rainText = "하루종일 내림".localized
            } else if rainArray.reduce(0, +) == 0 {
                rainText = "비 안옴".localized
            } else {
                if capricious.count >= 3 {
                    rainText = "변덕스럽게 내림".localized
                } else if !raining.isEmpty {
                    rainText = fetchRainText(rainType: "raining", indexArray: raining)
                } else {
                    rainText = fetchRainText(rainType: "once", indexArray: once)
                }
            }
        } else if now == 1 {
            if rainArray[1] + rainArray[2] + rainArray[3] >= 12 {
                rainText = "하루종일 내림".localized
            } else if raining.count == 3 {
                rainText = "하루종일 내림".localized
            } else if rainArray[1] + rainArray[2] + rainArray[3] == 0 {
                rainText = "비 안옴".localized
            } else if capricious.count == 3 {
                rainText = "변덕스럽게 내림".localized
            } else if !raining.isEmpty {
                rainText = fetchRainText(rainType: "raining", indexArray: raining)
            } else {
                rainText = fetchRainText(rainType: "once", indexArray: once)
            }
        } else if now == 2 {
            if rainArray[1] + rainArray[2] + rainArray[3] >= 9 {
                rainText = "하루종일 내림".localized
            } else if raining.count == 2 {
                rainText = "하루종일 내림".localized
            } else if rainArray[1] + rainArray[2] == 0 {
                rainText = "비 안옴".localized
            } else if !raining.isEmpty {
                rainText = fetchRainText(rainType: "raining", indexArray: raining)
            } else {
                rainText = fetchRainText(rainType: "once", indexArray: once)
            }
        } else if now == 3 {
            switch rainArray[0] {
            case 4...6:
                rainText = "남은 하루 계속 비".localized
            case 2...3:
                rainText = "밤 한때 비".localized
            default:
                rainText = "비 안옴".localized
            }
        }
        umbrellaIndexText = rainText
    }
    private func fetchRainText(rainType: String, indexArray: [Int]) -> String {
        var dayArray: [String] = []
        var rainText = ""
        
        indexArray.forEach {
            switch $0 {
            case 0:
                dayArray.append("새벽")
            case 1:
                dayArray.append("아침")
            case 2:
                dayArray.append("점심")
            case 3:
                dayArray.append("저녁")
            default:
                break
            }
        }
        
        for (index, rain) in dayArray.enumerated() {
            if index == dayArray.endIndex-1 {
                rainText += "\(rain)"
                if rainType == "raining" {
                    rainText += "에 비"
                } else {
                    rainText += "한때 비"
                }
            } else {
                rainText += "\(rain) "
            }
        }
        return rainText.localized
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func makeCompareIndexText(compareIndex: CompareIndex) {
        let compareMaxTemperature = Int(compareIndex.todayMaxtemperature) - Int(compareIndex.yesterdayMaxTemperature)
        let compareMinTemperature = Int(compareIndex.todayMinTemperature) - Int(compareIndex.yesterdayMinTemperature)
        if compareMaxTemperature > 2 {
            compareIndexText = "어제보다 최고 기온이 ".localized + "\(compareMaxTemperature)" + "°C 높고 \n ".localized
        } else if compareMaxTemperature < -2 {
            compareIndexText = "어제보다 최고 기온이 ".localized + "\(compareMaxTemperature)" + "°C 낮고 \n ".localized
        } else {
            compareIndexText = "최고 기온은 어제와 비슷하며 \n ".localized
        }
        if compareMinTemperature > 2 {
            compareIndexText += "최저 기온은 ".localized + "\(compareMinTemperature)" + "°C 높습니다.".localized
        } else if compareMinTemperature < -2 {
            compareIndexText += "최저 기온은 ".localized + "\(compareMinTemperature)" + "°C 낮습니다.".localized
        } else {
            compareIndexText += "최저 기온은 비슷합니다.".localized
        }
        if compareIndexText == "최고 기온은 어제와 비슷하며 \n 최저 기온은 비슷합니다.".localized {
            compareIndexText = "어제와 기온이 비슷합니다".localized
        }
    }
    
    func makeLottieView(name: String) -> LottieAnimationView {
        let lottieView = LottieAnimationView(name: name)
        lottieView.contentMode = .scaleAspectFit
        lottieView.play()
        lottieView.loopMode = .loop
        lottieView.backgroundBehavior = .pauseAndRestore
        return lottieView
    }
    
    func makeImageView(name: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: name)
        return imageView
    }
    
    func changeImageView(name: String) {
        if containerView.subviews.count != 0 {
            containerView.subviews[0].removeFromSuperview()
        }
        if temperatureGapView.subviews.count != 0 {
            temperatureGapView.subviews.forEach { $0.removeFromSuperview() }
        }
        let view = makeLottieView(name: name)
        if view.frame.width == 0 {
            let view = makeImageView(name: name)
            containerView.addSubview(view)
            view.snp.makeConstraints { $0.edges.equalToSuperview() }
        } else {
            containerView.addSubview(view)
            view.snp.makeConstraints { $0.edges.equalToSuperview() }
        }
    }
    
    func changeTextView(indexType: IndexType) {
        if textContainerView.subviews.count != 0 {
            textContainerView.subviews[0].removeFromSuperview()
        }
        if indexType == .umbrella || indexType == .temperatureGap || indexType == .outer || indexType == .mask {
            textContainerView.addSubview(weatherIndexStatusLabel)
            weatherIndexStatusLabel.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
    
    func changeCollectionView(internalIndex: Int) {
        self.internalIndex = internalIndex
        lazy var internalIndexCollectionView: UICollectionView = {
            let uiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
            uiCollectionView.register(InternalIndexCollectionViewCell.self, forCellWithReuseIdentifier: InternalIndexCollectionViewCell.identifier)
            uiCollectionView.clipsToBounds = false
            return uiCollectionView
        }()
        internalIndexCollectionView.delegate = self
        internalIndexCollectionView.dataSource = self
        if intenalIndexListView.subviews.count != 0 {
            intenalIndexListView.subviews[0].removeFromSuperview()
        }
        intenalIndexListView.addSubview(internalIndexCollectionView)
        internalIndexCollectionView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
    }
    
    private func setLayout() {
        [weatherIndexNameLabel, containerView, temperatureGapView, textContainerView, intenalIndexListView].forEach() {
            self.addSubview($0)
        }
        
        weatherIndexNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(19)
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(24)
        }
        containerView.snp.makeConstraints {
            $0.top.equalTo(weatherIndexNameLabel.snp.bottom).offset(26)
            $0.leading.equalToSuperview().inset(15)
            $0.trailing.equalToSuperview().inset(26)
            $0.bottom.equalToSuperview().inset(74)
        }
        temperatureGapView.snp.makeConstraints {
            $0.top.equalTo(weatherIndexNameLabel.snp.bottom).offset(35)
            $0.leading.equalToSuperview().inset(40)
            $0.trailing.equalToSuperview().inset(37)
            $0.bottom.equalTo(textContainerView.snp.top).offset(-30.5)
        }
        intenalIndexListView.snp.makeConstraints{
            $0.top.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(30)
            $0.leading.equalTo(weatherIndexNameLabel.snp.trailing)
        }
        
        textContainerView.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(14)
            $0.height.equalTo(36)
        }
    }
    
    func configureView(indexNameLabel: String, indexStatusLabel: String) {
        weatherIndexStatusLabel.textAlignment = .center
        weatherIndexStatusLabel.layer.cornerRadius = 10
        weatherIndexStatusLabel.numberOfLines = 2
        weatherIndexNameLabel.configureLabel(text: indexNameLabel, font: UIFont.KFont.appleSDNeoBoldSmallLarge, textColor: UIColor.KColor.black)
        
        if indexNameLabel == "우산 지수".localized || indexNameLabel == "겉옷 지수".localized || indexNameLabel == "마스크 지수".localized {
            weatherIndexStatusLabel.layer.backgroundColor = UIColor.KColor.primaryBlue07.cgColor
            weatherIndexStatusLabel.configureLabel(text: indexStatusLabel.localized, font: UIFont.KFont.appleSDNeoSemiBoldMedium, textColor: UIColor.KColor.primaryBlue01)
            
            textContainerView.snp.remakeConstraints {
                $0.leading.equalToSuperview().inset(16)
                $0.bottom.equalToSuperview().inset(14)
                $0.height.equalTo(36)
            }
        }
        if indexNameLabel == "일교차 지수".localized {
            weatherIndexStatusLabel.layer.backgroundColor = UIColor.KColor.gray05.cgColor
            weatherIndexStatusLabel.configureLabel(text: indexStatusLabel, font: UIFont.KFont.appleSDNeoSemiBold15, textColor: UIColor.KColor.black)
            textContainerView.snp.remakeConstraints {
                $0.leading.equalToSuperview().inset(16)
                $0.bottom.equalToSuperview().inset(14)
                if indexStatusLabel.count == 13 {
                    $0.height.equalTo(36)
                } else {
                    $0.width.equalTo(251)
                    $0.height.equalTo(60)
                }
            }
        }
    }
    
    func findImageOrLottieName(indexName: IndexType, status: Int) -> String {
        let foundElement =  (indexName, status)
        switch foundElement {
        case let(indexName, status) where indexName == .mask && status == 0:
            return "mask_step1"
        case let(indexName, status) where indexName == .mask && status == 1:
            return "mask_step2"
        case let(indexName, status) where indexName == .mask && status == 2:
            return "mask_step3"
        case let(indexName, status) where indexName == .mask && status == 3:
            return "mask_step4"
        case let(indexName, status) where indexName == .mask && status == 4:
            return "mask_step4"
        case let(indexName, status) where indexName == .umbrella && status == 0:
            return "rain_step1"
        case let(indexName, status) where indexName == .umbrella && status == 1:
            return "rain_step2"
        case let(indexName, status) where indexName == .umbrella &&  status == 2:
            return "rain_step3"
        case let(indexName, status) where indexName == .umbrella && status == 3:
            return "rain_step4"
        case let(indexName, status) where indexName == .umbrella && status == 4:
            return "rain_step4"
        case let(indexName, status) where indexName == .laundry && status == 0:
            return "laundry_4"
        case let(indexName, status) where indexName == .laundry && status == 1:
            return "laundry_4"
        case let(indexName, status) where indexName == .laundry && status == 2:
            return "laundry_3"
        case let(indexName, status) where indexName == .laundry && status == 3:
            return "laundry_2"
        case let(indexName, status) where indexName == .laundry && status == 4:
            return "laundry_1"
        case let(indexName, status) where indexName == .car && status == 0:
            return "carwash_step4"
        case let(indexName, status) where indexName == .car && status == 1:
            return "carwash_step3"
        case let(indexName, status) where indexName == .car && status == 2:
            return "carwash_step2"
        case let(indexName, status) where indexName == .car && status == 3:
            return "carwash_step1"
        case let(indexName, status) where indexName == .car && status == 4:
            return "carwash_step1"
        case let(indexName, status) where indexName == .outer && status == 0:
            return "outer_step1"
        case let(indexName, status) where indexName == .outer && status == 1:
            return "outer_step1"
        case let(indexName, status) where indexName == .outer && status == 2:
            return "outer_step2"
        case let(indexName, status) where indexName == .outer && status == 3:
            return "outer_step3"
        case let(indexName, status) where indexName == .outer && status == 4:
            return "outer_step4"
        case let(indexName, status) where indexName == .outer && status == 5:
            return "outer_step5"
        default:
            return ""
        }
        
    }
    func transIndexName(indexName: IndexType) -> String {
        switch indexName {
        case .mask :
            return "마스크 지수".localized
        case .umbrella :
            return "우산 지수".localized
        case .outer :
            return "겉옷 지수".localized
        case .laundry :
            return "빨래 지수".localized
        case .car :
            return "세차 지수".localized
        case .temperatureGap :
            return "일교차 지수".localized
        }
    }
    
    func findInternalIndexColorAndImage(indexName: IndexType, isIndexOn: [InternalIndexType], pathIndex: Int) -> UIImageView {
        let uiImageView = UIImageView()
        let foundElement = (indexName, pathIndex)
        switch foundElement {
        case let(indexName, pathIndex) where indexName == .mask && isIndexOn[pathIndex] == .pollen:
            uiImageView.image = UIImage(named: "pollen")
        case let(indexName, pathIndex) where indexName == .mask && isIndexOn[pathIndex] == .yellowDust:
            uiImageView.image = UIImage(named: "yellowDust")
        case let(indexName, pathIndex) where indexName == .umbrella && isIndexOn[pathIndex] == .typhoon:
            uiImageView.image = UIImage(named: "typhoon")
        case let(indexName, pathIndex) where indexName == .umbrella && isIndexOn[pathIndex] == .strongWind:
            uiImageView.image = UIImage(named: "strongWind")
        case let(indexName, pathIndex) where indexName == .outer && isIndexOn[pathIndex] == .coldWave:
            uiImageView.image = UIImage(named: "coldWave")
        case let(indexName, pathIndex) where indexName == .laundry && isIndexOn[pathIndex] == .freezeAndBurst:
            uiImageView.image = UIImage(named: "freezeAndBurst")
        case let(indexName, pathIndex) where indexName == .car && isIndexOn[pathIndex] == .pollen:
            uiImageView.image = UIImage(named: "pollen")
        case let(indexName, pathIndex) where indexName == .car && isIndexOn[pathIndex] == .yellowDust:
            uiImageView.image = UIImage(named: "yellowDust")
        case let(indexName, pathIndex) where indexName == .car && isIndexOn[pathIndex] == .freezeAndBurst:
            uiImageView.image = UIImage(named: "freezeAndBurst")
            
        default:
            uiImageView.image = UIImage(named: "")
        }
        return uiImageView
    }
    func calculateInternalIndexCount(indexName: IndexType) -> [InternalIndexType] {
        var isIndexOn = [InternalIndexType]()
        switch indexName {
            // 강풍 기준치 4
        case .umbrella :
            if weathers?.localWeather[0].weatherIndex[0].umbrellaIndex[0].wind ?? 0 >= 4 {
                isIndexOn.append(.strongWind)
            }
            //황사 기준치 400
        case .mask :
            if weathers?.localWeather[0].weatherIndex[0].maskIndex[0].todayPM10value ?? 0 >= 400 {
                isIndexOn.append(.yellowDust)
                break
            }
            //꽃가루 기준치 2
            if weathers?.localWeather[0].weatherIndex[0].maskIndex[0].pollenIndex ?? 0 >= 2 {
                isIndexOn.append(.pollen)
            }
        case .car :
            // 동파 기준치 2
            if weathers?.localWeather[0].weatherIndex[0].carwashIndex[0].dayMaxTemperature ?? 0 <= 2 {
                isIndexOn.append(.freezeAndBurst)
            }
            // 꽃가루 기준치 2
            if weathers?.localWeather[0].weatherIndex[0].carwashIndex[0].pollenIndex ?? 0 >= 2 {
                isIndexOn.append(.pollen)
            }
            // 황사 기준치 400
            if weathers?.localWeather[0].weatherIndex[0].maskIndex[0].todayPM10value ?? 0 >= 400 {
                isIndexOn.append(.yellowDust)
                break
            }
        case .outer :
            // 한파 기준치 -12
            if weathers?.localWeather[0].weatherIndex[0].outerIndex[0].dayMinTemperature ?? 0 <= -12 {
                isIndexOn.append(.coldWave)
            }
        case .laundry :
            // 동파 기준치 2
            if weathers?.localWeather[0].weatherIndex[0].laundryIndex[0].dayMaxTemperature ?? 0 <= 2 {
                isIndexOn.append(.freezeAndBurst)
            }
        default :
            break
        }
        return isIndexOn
    }
    func findStatus(indexName: IndexType) -> Int {
        if indexName == .umbrella {
            return weathers?.localWeather[0].weatherIndex[0].umbrellaIndex[0].status ?? 0
        } else if indexName == .mask {
            return weathers?.localWeather[0].weatherIndex[0].maskIndex[0].status ?? 0
        } else if indexName == .outer {
            return weathers?.localWeather[0].weatherIndex[0].outerIndex[0].status ?? 0
        } else if indexName == .laundry {
            return weathers?.localWeather[0].weatherIndex[0].laundryIndex[0].status ?? 0
        } else if indexName == .car {
            return weathers?.localWeather[0].weatherIndex[0].carwashIndex[0].status ?? 0
        }
        return 0
    }
    
    func searchInternalIndexStrAndColor(indexName: IndexType, isIndexOn: [InternalIndexType], pathIndex: Int) -> [Any] {
        let foundElement = (indexName, pathIndex)
        switch foundElement {
        case let(indexName, pathIndex) where indexName == .mask && isIndexOn[pathIndex] == .pollen:
            return ["꽃가루" ,UIColor.KColor.internalIndexRed01, UIColor.KColor.internalIndexRed02]
        case let(indexName, pathIndex) where indexName == .mask && isIndexOn[pathIndex] == .yellowDust:
            return ["황사" ,UIColor.KColor.internalIndexYellow01, UIColor.KColor.internalIndexYellow02]
        case let(indexName, pathIndex) where indexName == .umbrella && isIndexOn[pathIndex] == .typhoon:
            return ["태풍주의" ,UIColor.KColor.internalIndexGray01, UIColor.KColor.internalIndexGray02]
        case let(indexName, pathIndex) where indexName == .umbrella && isIndexOn[pathIndex] == .strongWind:
            return ["강풍주의" ,UIColor.KColor.internalIndexGreen01, UIColor.KColor.internalIndexGreen02]
        case let(indexName, pathIndex) where indexName == .outer && isIndexOn[pathIndex] == .coldWave:
            return ["한파주의" ,UIColor.KColor.internalIndexBlue01, UIColor.KColor.internalIndexBlue02]
        case let(indexName, pathIndex) where indexName == .laundry && isIndexOn[pathIndex] == .freezeAndBurst:
            return ["동파주의" ,UIColor.KColor.internalIndexCyan01, UIColor.KColor.internalIndexCyan02]
        case let(indexName, pathIndex) where indexName == .car && isIndexOn[pathIndex] == .pollen:
            return ["꽃가루" ,UIColor.KColor.internalIndexRed01, UIColor.KColor.internalIndexRed02]
        case let(indexName, pathIndex) where indexName == .car && isIndexOn[pathIndex] == .yellowDust:
            return ["황사" ,UIColor.KColor.internalIndexYellow01, UIColor.KColor.internalIndexYellow02]
        case let(indexName, pathIndex) where indexName == .car && isIndexOn[pathIndex] == .freezeAndBurst:
            return ["동파주의" ,UIColor.KColor.internalIndexCyan01, UIColor.KColor.internalIndexCyan02]
        default:
            return ["황사" ,UIColor.KColor.internalIndexRed01, UIColor.KColor.internalIndexRed02]
        }
    }
}

extension LocationWeatherIndexView:  UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let indexName = self.indexArray[self.internalIndex]
        let cellCount = calculateInternalIndexCount(indexName: indexName).count
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InternalIndexCollectionViewCell.identifier, for: indexPath) as! InternalIndexCollectionViewCell
        let indexName = self.indexArray[self.internalIndex]
        let isIndexOn = calculateInternalIndexCount(indexName: indexName)
        let internalIndexView = findInternalIndexColorAndImage(indexName: indexName, isIndexOn: isIndexOn, pathIndex: indexPath.row)
        cell.addSubview(internalIndexView)
        internalIndexView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        let toastContents = searchInternalIndexStrAndColor(indexName: indexName, isIndexOn: isIndexOn, pathIndex: indexPath.row)
        let gesture = UITapGestureRecognizer()
        cell.addGestureRecognizer(gesture)
        gesture.rx.event.bind {_ in
            cell.showToast(message: toastContents[0] as! String, fontColor: toastContents[1] as! UIColor, bgColor: toastContents[2] as! UIColor)
            collectionView.bringSubviewToFront(collectionView.cellForItem(at: indexPath)!)
        }.disposed(by: disposeBag)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

class CollectionViewRightAlignFlowLayout: UICollectionViewFlowLayout {
    let cellSpacing: CGFloat = 8
    let cellItemSize: Double
    init(cellItemSize: Double){
        self.cellItemSize = cellItemSize
        super.init()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        self.minimumLineSpacing = 4.0
        guard let superArray = super.layoutAttributesForElements(in: rect) else { return nil }
        guard let attributes = NSArray(array: superArray, copyItems: true) as? [UICollectionViewLayoutAttributes] else { return nil }
        var rightMargin = sectionInset.right
        var maxY: CGFloat = 300
        attributes.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                rightMargin = sectionInset.right
            }
            layoutAttribute.frame.origin.x =  collectionViewContentSize.width - rightMargin - cellItemSize
            rightMargin += layoutAttribute.frame.width + cellSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        return attributes
    }
}

class WeatherIndexStatusLabel: UILabel {
    private var padding = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        
        return contentSize
    }
}
