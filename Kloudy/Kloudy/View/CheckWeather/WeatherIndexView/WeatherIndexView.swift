//
//  WeatherIndexView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/11/07.
//

import Lottie
import SnapKit
import UIKit
import RxCocoa
import RxSwift
import CoreData
import CoreLocation

enum InternalIndexType {
    case coldWave
    case freezeAndBurst
    case pollen
    case strongWind
    case typhoon
    case yellowDust
}

class WeatherIndexView: UIView {
    let cityInformationModel = FetchWeatherInformation()
    lazy var cityData = self.cityInformationModel.loadCityListFromCSV()
    var disposeBag = DisposeBag()
    lazy var locationWeatherIndexView = LocationWeatherIndexView()
    let weatherIndexListView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.KColor.primaryBlue07
        uiView.layer.cornerRadius = 10
        return uiView
    }()
    //TODO: 더미데이터, 아키텍쳐 확인 후 수정
    private var layout : UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        return layout
    }
    //지수 컬렉션뷰
    lazy var indexCollectionView: UICollectionView = {
        var uiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        uiCollectionView.backgroundColor = UIColor.KColor.clear
        uiCollectionView.register(indexCollectionViewCell.self, forCellWithReuseIdentifier: indexCollectionViewCell.identifier)
        uiCollectionView.showsVerticalScrollIndicator = false
        uiCollectionView.delegate = self
        uiCollectionView.dataSource = self
        return uiCollectionView
    }()
    
    let indexNameString: BehaviorSubject<IndexType> = BehaviorSubject(value: .umbrella)
    //
    var weathers: Weather?
    var weatherIndex: Int?
    let sentWeather = PublishSubject<Weather>()
    let sentWeatherIndex = PublishSubject<Int>()

    var locationList = [Location]()
    var indexArray = [IndexType]()
    var indexStrArray = [String]()
    let currentStatus = CLLocationManager().authorizationStatus
    
    // 내부지수 배열을 받을 변수
    let isConvertedIndexStrArray: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    //롱텝 핸들링
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let targetIndexPath = indexCollectionView.indexPathForItem(at: gesture.location(in: indexCollectionView)) else {
                return
            }
            indexCollectionView.beginInteractiveMovementForItem(at: targetIndexPath)
        case .changed:
            indexCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: indexCollectionView))
        case .ended:
            indexCollectionView.endInteractiveMovement()
        default:
            indexCollectionView.cancelInteractiveMovement()
        }
    }
    
    // Lottie 나 이미지뷰를 반환할 함수 떄문에 AnyObject로 반환
    private func makeLottieViewOrImage(indexName: String) -> AnyObject{
        let lottieView = LottieAnimationView(name: indexName)
        
        // Lottie 뷰의 frame이 0 이면 이미지 뷰를 반환
        if lottieView.frame.width == 0 {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: indexName)
            imageView.translatesAutoresizingMaskIntoConstraints = true
            imageView.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
            return imageView
        }
        lottieView.contentMode = .scaleAspectFit
        lottieView.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        lottieView.loopMode = .loop
        lottieView.backgroundBehavior = .pauseAndRestore
        lottieView.isUserInteractionEnabled = false
        return lottieView
    }
    
    init() {
        super.init(frame: .zero)
        bind()
        addLayout()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func bind() {
        sentWeatherIndex
            .subscribe(onNext: {
                self.weatherIndex = $0
            })
            .disposed(by: disposeBag)
        
        sentWeather
            .subscribe(onNext: {
                self.weathers = $0
                self.locationWeatherIndexView.sentWeather.onNext($0)
                self.fetchLocationIndexArray(sentWeather: $0)
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchLocationIndexArray(sentWeather: Weather) {
        self.locationList = CoreDataManager.shared.fetchLocations()
        
        // 현재 위치 정보 권한 동의 및 현재 위치 지역의 지수 순서
        if !(currentStatus == .restricted || currentStatus == .notDetermined || currentStatus == .denied) && self.weatherIndex == 0 {
            self.indexStrArray = Storage.fetchCurrentLocationIndexArray()
            self.indexArray = Storage.convertStringToIndexType(indexStrArray: self.indexStrArray)
            self.locationWeatherIndexView.sentIndexArray.onNext(self.indexArray)
        }
        
        // 이외 지역
        self.locationList.forEach { location in
            if location.code == sentWeather.localWeather[0].localCode {
                self.indexStrArray = location.indexArray ?? []
                self.indexStrArray.forEach { index in
                    switch index {
                    case "rain":
                        self.indexArray.append(.umbrella)
                    case "mask":
                        self.indexArray.append(.mask)
                    case "laundry":
                        self.indexArray.append(.laundry)
                    case "car":
                        self.indexArray.append(.car)
                    case "outer":
                        self.indexArray.append(.outer)
                    case "temperatureGap":
                        self.indexArray.append(.temperatureGap)
                    default:
                        break
                    }
                }
                self.locationWeatherIndexView.sentIndexArray.onNext(self.indexArray)
                return
            }
        }
    }
    
    private func addLayout() {
        [locationWeatherIndexView, weatherIndexListView].forEach() {
            self.addSubview($0)
        }
        weatherIndexListView.addSubview(indexCollectionView)
    }
    private func setLayout() {
        self.backgroundColor = UIColor.KColor.white
        self.layer.cornerRadius = 12
        self.layer.applySketchShadow(color: UIColor.KColor.primaryBlue01, alpha: 0.1, x: 0, y: 0, blur: 40, spread: 0)
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_ :)))
        
        indexCollectionView.addGestureRecognizer(gesture)
        
        weatherIndexListView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(283)
            $0.trailing.equalToSuperview().inset(12)
        }
        
        locationWeatherIndexView.snp.makeConstraints{
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(weatherIndexListView.snp.leading)
        }
        
        indexCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview() // 나중에 checkWeatherCellLabelView안에 넣게 된다면 수정 할 것
            $0.width.height.equalToSuperview()
        }
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
    
    func findIndexImage(indexName: IndexType) -> UIImageView {
        let uiImageView = UIImageView()
        switch indexName {
        case .car:
            uiImageView.image = UIImage(named: "carwash")
        case .laundry:
            uiImageView.image = UIImage(named: "laundry")
        case .mask:
            uiImageView.image = UIImage(named: "mask")
        case .outer:
            uiImageView.image = UIImage(named: "outer")
        case .temperatureGap:
            uiImageView.image = UIImage(named: "updown")
        case .umbrella:
            uiImageView.image = UIImage(named: "umbrella")
        }
        return uiImageView
    }
}

extension WeatherIndexView:  UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let indexName = self.indexArray[indexPath.row]
        locationWeatherIndexView.indexName.onNext(indexName)
        // WeatherDetailIndexView 에 어떤 Index 가 Tap 되었는지 전달
        indexNameString.onNext(indexName)
        locationWeatherIndexView.changeCollectionView(internalIndex: indexPath.row)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.indexArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: indexCollectionViewCell.identifier, for: indexPath) as! indexCollectionViewCell
        let indexName = self.indexArray[indexPath.row]
        if(indexPath.row == 0){
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
            indexNameString.onNext(indexName)
        }
        
        cell.isSelected = indexPath.row == 0
        
        let indexImage = findIndexImage(indexName: indexName)
        cell.addSubview(indexImage)
        indexImage.snp.makeConstraints{
            $0.width.equalTo(28)
            $0.height.equalTo(29)
            $0.centerX.centerY.equalToSuperview()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize(width: 42 , height: 42)
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = self.indexArray.remove(at: sourceIndexPath.row)
        let strItem =  self.indexStrArray.remove(at: sourceIndexPath.row)
        self.indexArray.insert(item, at: destinationIndexPath.row)
        self.indexStrArray.insert(strItem, at: destinationIndexPath.row)
        
        // Long Tab 시 UserDefaults / CoreData 에 저장
        if !(currentStatus == .restricted || currentStatus == .notDetermined || currentStatus == .denied) && self.weatherIndex == 0 {
            Storage.saveCurrentLocationIndexArray(arrayString: self.indexStrArray)
            locationWeatherIndexView.indexArray = self.indexArray
        } else {
            CoreDataManager.shared.changeLocationIndexData(code: self.weathers!.localWeather[0].localCode, indexArray: self.indexStrArray)
            locationWeatherIndexView.indexArray = self.indexArray
        }
    }
}
