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
    var indexString: BehaviorSubject<IndexType> = BehaviorSubject(value: .unbrella)
    let tapGesture = UITapGestureRecognizer()
    let disposeBag = DisposeBag()
    
    var indexArray = [IndexType]()
    var weathers: Weather?
    
    let sentIndexArray = PublishSubject<[IndexType]>()
    let sentWeather = PublishSubject<Weather>()
    
    //    var indexName: IndexType?
    var sentIndexName: IndexType?
    var indexName = PublishSubject<IndexType>()
    var transedIndexName: String = ""
    var indexStatus = PublishSubject<Int>()
    var imageOrLottieName: String = ""
    var compareIndexText = ""
    var umbrellaIndexText = ""
    
    //TODO: 페이지 개수 받아오는 부분 (임시)
    init() {
        super.init(frame: .zero)
        setLayout()
        bind()
        changeCollectionView()
        containerView.addGestureRecognizer(tapGesture)
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
                self.indexStatus.onNext(self.findStatus(indexName: $0))
                self.changeTextView(indexType: $0)
                guard let weathers = self.weathers else { return }
                if $0 == .unbrella {
                    self.makeUmbrellaIndexText(umbrellaHourly: weathers.localWeather[0].weatherIndex[0].umbrellaIndex[0].umbrellaHourly)
                    self.configureView(indexNameLabel: self.transedIndexName, indexStatusLabel: self.umbrellaIndexText)
                } else if $0 == .temperatureGap {
                    self.makeCompareIndexText(compareIndex: weathers.localWeather[0].weatherIndex[0].compareIndex[0])
                    self.configureView(indexNameLabel: self.transedIndexName, indexStatusLabel: self.compareIndexText)
                } else {
                    self.configureView(indexNameLabel: self.transedIndexName, indexStatusLabel: "")
                }
            })
            .disposed(by: disposeBag)
        
        indexStatus
            .subscribe(onNext: {
                self.imageOrLottieName = self.findImageOrLottieName(indexName: self.sentIndexName ?? .unbrella, status: $0)
                self.changeImageView(name: self.imageOrLottieName)
            })
            .disposed(by: disposeBag)
    }
    
    func makeUmbrellaIndexText(umbrellaHourly: [UmbrellaHourly]) {
        var index:[Int] = [0,0,0,0]
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
        default :
            now = 4
        }
        
        umbrellaHourly.forEach {
            if $0.time <= 5 && $0.precipitation != 0.0 {
                index[0] += 1
            } else if $0.time >= 6 && $0.time < 12 && $0.precipitation != 0.0 {
                index[1] += 1
            } else if $0.time >= 12 && $0.time < 18 && $0.precipitation != 0.0 {
                index[2] += 1
            } else if $0.time >= 18 && $0.time < 24 && $0.precipitation != 0.0 {
                index[3] += 1
            }
        }
        var newArray:[Int] = []
        (now...3).forEach {
            newArray.append(index[$0])
        }
        var rainText = ""
        if now == 0 {
            if newArray.reduce(0, +) >= 16 {
                rainText = "하루종일 내림"
            } else if newArray.count == 0 {
                rainText = "비 안옴"
            } else {
                for (index, rain) in newArray.enumerated() {
                    if index == 0 && rain > 0{
                        rainText += "새벽 "
                    }
                    if index == 1 && rain > 0{
                        rainText += "오전 "
                    }
                    if index == 2 && rain > 0{
                        rainText += "오후 "
                    }
                    if index == 3 && rain > 0{
                        rainText += "밤"
                    }
                }
                rainText += "에 비"
            }
            
        } else if now == 1 {
            if newArray.reduce(0, +) >= 12 {
                rainText = "하루종일 내림"
            } else if newArray.count == 0 {
                rainText = "비 안옴"
            } else {
                for (index, rain) in newArray.enumerated() {
                    if index == 0 && rain > 0{
                        rainText += "오전 "
                    }
                    if index == 1 && rain > 0{
                        rainText += "오후 "
                    }
                    if index == 2 && rain > 0{
                        rainText += "밤"
                    }
                }
                rainText += "에 비"
            }
        } else if now == 2 {
            if newArray.reduce(0, +) >= 9 {
                rainText = "하루종일 내림"
            } else {
                let rain = newArray.filter{ $0 >= 4 }
                if rain.count == 2 {
                    rainText = "하루종일 내림"
                } else if rain.count == 1 {
                    if newArray[0] >= 4 {
                        rainText = "오후에 비"
                    } else {
                        rainText = "밤에 비"
                    }
                } else {
                    let sometime = newArray.filter{ $0 >= 1 }
                    if sometime.count == 2 {
                        rainText = "오후 밤 한때 비"
                    } else if sometime.count == 1 {
                        if newArray[0] >= 1 {
                            rainText = "오후 한때 비"
                        } else {
                            rainText = "밤 한때 비"
                        }
                    } else {
                        rainText = "비 안옴"
                    }
                }
            }
        } else if now == 3 {
            switch newArray[0] {
            case 4...6:
                rainText = "남은 하루 계속 비"
            case 2...3:
                rainText = "밤 한때 비"
            default:
                rainText = "비 안옴"
            }
        }
        umbrellaIndexText = rainText
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func makeCompareIndexText(compareIndex: CompareIndex) {
        let compareMaxTemperature = Int(compareIndex.todayMaxtemperature) - Int(compareIndex.yesterdayMaxTemperature)
        let compareMinTemperature = Int(compareIndex.todayMinTemperature) - Int(compareIndex.yesterdayMinTemperature)
        
        if compareMaxTemperature > 2 {
            compareIndexText = "어제보다 최고 기온이".localized + "\(compareMaxTemperature)" + "°C 높고 \n ".localized
        } else if compareMaxTemperature < -2 {
            compareIndexText = "어제보다 최고 기온이".localized + "\(compareMaxTemperature)" + "°C 낮고 \n ".localized
        } else {
            compareIndexText = "최고 기온은 어제와 비슷하며 \n ".localized
        }
        if compareMinTemperature > 2 {
            compareIndexText += "최저 기온은".localized + "\(compareMinTemperature)" + "°C 높습니다.".localized
        } else if compareMinTemperature < -2 {
            compareIndexText += "최저 기온은".localized + "\(compareMinTemperature)" + "°C 낮습니다.".localized
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
        if indexType == .unbrella || indexType == .temperatureGap {
            textContainerView.addSubview(weatherIndexStatusLabel)
            weatherIndexStatusLabel.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
    
    func changeCollectionView() {
        intenalIndexListView.backgroundColor = UIColor.KColor.black
        lazy var internalIndexCollectionView: UICollectionView = {
            let uiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
            uiCollectionView.register(InternalIndexCollectionViewCell.self, forCellWithReuseIdentifier: InternalIndexCollectionViewCell.identifier)
            return uiCollectionView
        }()
//        internalIndexCollectionView.delegate = self
//        internalIndexCollectionView.dataSource = self
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
        [weatherIndexNameLabel, containerView, textContainerView, intenalIndexListView].forEach() {
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

        if indexNameLabel == "우산 지수".localized {
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
        case let(indexName, status) where indexName == .mask && status == 0 :
            return "mask_step1"
        case let(indexName, status) where indexName == .mask && status == 1 :
            return "mask_step2"
        case let(indexName, status) where indexName == .mask && status == 2 :
            return "mask_step3"
        case let(indexName, status) where indexName == .mask && status == 3 :
            return "mask_step4"
        case let(indexName, status) where indexName == .mask && status == 4 :
            return "mask_step4"
        case let(indexName, status) where indexName == .unbrella && status == 0 :
            return "rain_step1"
        case let(indexName, status) where indexName == .unbrella && status == 1 :
            return "rain_step2"
        case let(indexName, status) where indexName == .unbrella &&  status == 2 :
            return "rain_step3"
        case let(indexName, status) where indexName == .unbrella && status == 3 :
            return "rain_step4"
        case let(indexName, status) where indexName == .unbrella && status == 4 :
            return "rain_step4"
        case let(indexName, status) where indexName == .laundry && status == 0 :
            return "laundry_1"
        case let(indexName, status) where indexName == .laundry && status == 1 :
            return "laundry_1"
        case let(indexName, status) where indexName == .laundry &&  status == 2 :
            return "laundry_2"
        case let(indexName, status) where indexName == .laundry && status == 3 :
            return "laundry_3"
        case let(indexName, status) where indexName == .laundry && status == 4 :
            return "laundry_4"
        case let(indexName, status) where indexName == .car && status == 0 :
            return "carwash_step4"
        case let(indexName, status) where indexName == .car && status == 1 :
            return "carwash_step3"
        case let(indexName, status) where indexName == .car &&  status == 2 :
            return "carwash_step2"
        case let(indexName, status) where indexName == .car && status == 3 :
            return "carwash_step1"
        case let(indexName, status) where indexName == .car && status == 4 :
            return "carwash_step1"
        case let(indexName, status) where indexName == .outer && status == 0 :
            return "outer_step1"
        case let(indexName, status) where indexName == .outer && status == 1 :
            return "outer_step2"
        case let(indexName, status) where indexName == .outer &&  status == 2 :
            return "outer_step3"
        case let(indexName, status) where indexName == .outer && status == 3 :
            return "outer_step4"
        case let(indexName, status) where indexName == .outer && status == 4 :
            return "outer_step5"
        default:
            return ""
        }
        
    }
    func transIndexName(indexName: IndexType) -> String {
        switch indexName {
        case .mask :
            return "마스크 지수".localized
        case .unbrella :
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
        case let(indexName, pathIndex) where indexName == .unbrella && isIndexOn[pathIndex] == .typhoon:
            uiImageView.image = UIImage(named: "typhoon")
        case let(indexName, pathIndex) where indexName == .unbrella && isIndexOn[pathIndex] == .strongWind:
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
        case .unbrella :
            if weathers?.localWeather[0].weatherIndex[0].umbrellaIndex[0].wind ?? 0 >= 4 {
                isIndexOn.append(.strongWind)
            }
        case .mask :
            if weathers?.localWeather[0].weatherIndex[0].maskIndex[0].pm10value ?? 0 >= 400 {
                isIndexOn.append(.yellowDust)
                break
            }
            if weathers?.localWeather[0].weatherIndex[0].maskIndex[0].pollenIndex ?? 0 >= 2 {
                isIndexOn.append(.pollen)
            }
        case .car :
            if weathers?.localWeather[0].weatherIndex[0].carwashIndex[0].dayMaxTemperature ?? 0 <= 2 {
                isIndexOn.append(.freezeAndBurst)
            }
            if weathers?.localWeather[0].weatherIndex[0].carwashIndex[0].pollenIndex ?? 0 >= 2 {
                isIndexOn.append(.pollen)
            }
            if weathers?.localWeather[0].weatherIndex[0].maskIndex[0].pm10value ?? 0 >= 400 {
                isIndexOn.append(.yellowDust)
                break
            }
        case .outer :
            if weathers?.localWeather[0].weatherIndex[0].outerIndex[0].dayMinTemperature ?? 0 <= -12 {
                isIndexOn.append(.coldWave)
            }
        case .laundry :
            if weathers?.localWeather[0].weatherIndex[0].laundryIndex[0].dayMaxTemperature ?? 0 <= 2{
                isIndexOn.append(.freezeAndBurst)
            }
        default :
            break
        }
        return isIndexOn
    }
    func findStatus(indexName: IndexType) -> Int {
        if indexName == .unbrella {
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
}

//extension LocationWeatherIndexView:  UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let indexName = self.indexArray[self.internalIndex]
//        let cellCount = calculateInternalIndexCount(indexName: indexName).count
//        return cellCount
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InternalIndexCollectionViewCell.identifier, for: indexPath)
//        let indexName = self.indexArray[self.internalIndex]
//        let isIndexOn = calculateInternalIndexCount(indexName: indexName)
//        let internalIndexView = findInternalIndexColorAndImage(indexName: indexName,isIndexOn: isIndexOn ,pathIndex: indexPath.row)
//        cell.addSubview(internalIndexView)
//        internalIndexView.snp.makeConstraints{
//            $0.top.equalToSuperview()
//            $0.width.height.equalTo(30)
//        }
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return  CGSize(width: 30 , height: 30)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        //TODO: 셀에 이미지 클릭하고 호출할 이벤트 넣을 메서드
//    }
//}

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
