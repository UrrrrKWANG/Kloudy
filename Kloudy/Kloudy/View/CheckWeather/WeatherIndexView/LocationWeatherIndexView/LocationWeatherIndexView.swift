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
    var internalIndex = 0
    lazy var locationWeatherIndexView = LocationWeatherIndexView(city: city)
    var viewModel = WeatherIndexViewModel()
    let weatherIndexNameLabel = UILabel()
    let intenalIndexListView = UIView()
    var containerView = UIView()
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
    
    //TODO: 페이지 개수 받아오는 부분 (임시)
    init(city: String) {
        super.init(frame: .zero)
        self.city = city
        setLayout()
        bind()
        
        let cityIndex = findCityIndex(city: city)
        let indexName = viewModel.indexArray[cityIndex].IndexArray[0]
        let transedIndexName = transIndexName(indexName: indexName)
        
        let indexStatus = findStatus(city: city, indexName: indexName)
        let imageOrLottieName = findImageOrLottieName(indexName: indexName, status: indexStatus)
        configureView(indexNameLabel:  transedIndexName, indexStatusLabel: "하루종일 내림")
        changeImageView(name: imageOrLottieName)
        changeCollectionView(index: 0)
        containerView.addGestureRecognizer(tapGesture)
    }
    
    private func bind() {
        tapGesture.rx.event
            .bind(onNext: { _ in
                self.indexViewTapped.onNext(true)
                print(self.city)
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
    
    func changeCollectionView(index: Int) {
        self.internalIndex = index
        intenalIndexListView.backgroundColor = UIColor.KColor.black
        lazy var internalIndexCollectionView: UICollectionView = {
            let uiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
            uiCollectionView.register(InternalIndexCollectionViewCell.self, forCellWithReuseIdentifier: InternalIndexCollectionViewCell.identifier)
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
        [weatherIndexNameLabel, containerView, weatherIndexStatusLabel, intenalIndexListView].forEach() {
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
        weatherIndexStatusLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(14)
            $0.height.equalTo(36)
        }
        intenalIndexListView.snp.makeConstraints{
            $0.top.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(30)
            $0.leading.equalTo(weatherIndexStatusLabel.snp.trailing)
        }
    }
    
    func configureView(indexNameLabel: String, indexStatusLabel: String) {
        weatherIndexNameLabel.configureLabel(text: indexNameLabel, font: UIFont.KFont.appleSDNeoBoldSmallLarge, textColor: UIColor.KColor.black)
        weatherIndexStatusLabel.configureLabel(text: indexStatusLabel, font: UIFont.KFont.appleSDNeoSemiBoldMedium, textColor: UIColor.KColor.primaryBlue01) // 색상, 폰트 추가 필요
        weatherIndexStatusLabel.textAlignment = .center
        weatherIndexStatusLabel.layer.cornerRadius = 10
        weatherIndexStatusLabel.layer.backgroundColor = UIColor.KColor.primaryBlue06.cgColor
    }
    
    func findCityIndex(city: String) -> Int {
        for cityIndex in 0..<viewModel.indexArray.count {
            if viewModel.indexDummyData[cityIndex].localName == city {
                return cityIndex
            }
        }
        return 0
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
            return "laundry_2"
        case let(indexName, status) where indexName == .laundry &&  status == 2 :
            return "laundry_3"
        case let(indexName, status) where indexName == .laundry && status == 3 :
            return "laundry_4"
        case let(indexName, status) where indexName == .laundry && status == 4 :
            return "laundry_4"
        case let(indexName, status) where indexName == .car && status == 0 :
            return "carwash_step1"
        case let(indexName, status) where indexName == .car && status == 1 :
            return "carwash_step2"
        case let(indexName, status) where indexName == .car &&  status == 2 :
            return "carwash_step3"
        case let(indexName, status) where indexName == .car && status == 3 :
            return "carwash_step4"
        case let(indexName, status) where indexName == .car && status == 4 :
            return "carwash_step4"
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
            return "마스크 지수"
        case .unbrella :
            return "우산 지수"
        case .outer :
            return "겉옷 지수"
        case .laundry :
            return "빨래 지수"
        case .car :
            return "세차 지수"
        case .temperatureGap :
            return "일교차 지수"
        }
    }
    func findStatus(city: String, indexName: IndexType) -> Int {
        for cityIndex in 0..<viewModel.indexDummyData.count {
            if city == viewModel.indexDummyData[cityIndex].localName && indexName == .unbrella {
                return viewModel.indexDummyData[cityIndex].cityIndexData[0].umbrella_index.status
            } else if city == viewModel.indexDummyData[cityIndex].localName && indexName == .mask {
                return viewModel.indexDummyData[cityIndex].cityIndexData[0].mask_index.status
            } else if city == viewModel.indexDummyData[cityIndex].localName && indexName == .outer {
                return viewModel.indexDummyData[cityIndex].cityIndexData[0].outer_index.status
            } else if city == viewModel.indexDummyData[cityIndex].localName && indexName == .laundry {
                return viewModel.indexDummyData[cityIndex].cityIndexData[0].laundry_index.status
            } else if city == viewModel.indexDummyData[cityIndex].localName && indexName == .car {
                return viewModel.indexDummyData[cityIndex].cityIndexData[0].carwash_index.status
            } else if city == viewModel.indexDummyData[cityIndex].localName && indexName == .temperatureGap {
                return Int(viewModel.indexDummyData[cityIndex].cityIndexData[0].campare_index.today_max_temperature)
            }
        }
        return 0
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
        let cityIndex = findCityIndex(city: city)
        switch indexName {
        case .unbrella :
            if viewModel.indexDummyData[cityIndex].cityIndexData[0].umbrella_index.wind >= 4 {
                isIndexOn.append(.strongWind)
            }
        case .mask :
            for hour in 0..<viewModel.indexDummyData[cityIndex].cityIndexData.count {
                if viewModel.indexDummyData[cityIndex].cityIndexData[hour].mask_index.pm10value >= 400 {
                    isIndexOn.append(.yellowDust)
                    break
                }
            }
            if viewModel.indexDummyData[cityIndex].cityIndexData[0].mask_index.pollen_index >= 2 {
                isIndexOn.append(.pollen)
            }
        case .car :
            if viewModel.indexDummyData[cityIndex].cityIndexData[0].carwash_index.day_max_temperature <= 2 {
                isIndexOn.append(.freezeAndBurst)
            }
            if viewModel.indexDummyData[cityIndex].cityIndexData[0].mask_index.pollen_index >= 2 {
                isIndexOn.append(.pollen)
            }
            for hour in 0..<viewModel.indexDummyData[cityIndex].cityIndexData.count {
                if viewModel.indexDummyData[cityIndex].cityIndexData[hour].mask_index.pm10value >= 400 {
                    isIndexOn.append(.yellowDust)
                    break
                }
            }
        case .outer :
            if viewModel.indexDummyData[cityIndex].cityIndexData[0].outer_index.day_min_temperature <= -12 {
                isIndexOn.append(.coldWave)
            }
        case .laundry :
            if viewModel.indexDummyData[cityIndex].cityIndexData[0].laundry_index.day_max_temperature <= 2{
                isIndexOn.append(.freezeAndBurst)
            }
        default :
            break
        }
        return isIndexOn
    }

}

extension LocationWeatherIndexView:  UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let cityIndex = findCityIndex(city: city)
        let indexName = viewModel.indexArray[cityIndex].IndexArray[self.internalIndex]
        let cellCount = calculateInternalIndexCount(indexName: indexName).count
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InternalIndexCollectionViewCell.identifier, for: indexPath)
        let cityIndex = findCityIndex(city: city)
        let indexName = viewModel.indexArray[cityIndex].IndexArray[self.internalIndex]
        let isIndexOn = calculateInternalIndexCount(indexName: indexName)
        let internalIndexView = findInternalIndexColorAndImage(indexName: indexName,isIndexOn: isIndexOn ,pathIndex: indexPath.row)
        cell.addSubview(internalIndexView)
        internalIndexView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize(width: 30 , height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      //TODO: 셀에 이미지 클릭하고 호출할 이벤트 넣을 메서드
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
