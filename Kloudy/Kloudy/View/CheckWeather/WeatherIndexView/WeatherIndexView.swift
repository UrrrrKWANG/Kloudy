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
    var locationList = CoreDataManager.shared.fetchLocations()
    var indexArray = [IndexType]()
    var indexStrArray = [String]()
    var disposeBag = DisposeBag()
    var weathers: Weather?
    lazy var locationWeatherIndexView = LocationWeatherIndexView(weathers: self.weathers!, indexArray: self.indexArray)
    let weatherIndexListView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.KColor.primaryBlue06
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
        uiCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        uiCollectionView.showsVerticalScrollIndicator = false
        uiCollectionView.delegate = self
        uiCollectionView.dataSource = self
        return uiCollectionView
    }()

    let indexNameString: BehaviorSubject<IndexType> = BehaviorSubject(value: .unbrella)
    
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
            CoreDataManager.shared.changeLocationIndexData(code: self.weathers!.localWeather[0].localCode, indexArray: self.indexStrArray)
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
            imageView.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            return imageView
        }
        lottieView.contentMode = .scaleAspectFit
        lottieView.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        lottieView.loopMode = .loop
        lottieView.backgroundBehavior = .pauseAndRestore
        lottieView.isUserInteractionEnabled = false
        return lottieView
    }
    
    init(weathers: Weather) {
        super.init(frame: .zero)
        self.weathers = weathers
        for location in locationList {
            if location.code == weathers.localWeather[0].localCode {
                self.indexStrArray = location.indexArray!
                for index in location.indexArray! {
                    switch index {
                    case "rain":
                        self.indexArray.append(.unbrella)
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
            }
        }
        addLayout()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
//            else if indexName == .temperatureGap {
//                return Int(viewModel.indexDummyData[cityIndex].cityIndexData[0].campare_index.today_max_temperature)
//            }
        
        return 0
    }
}

extension WeatherIndexView:  UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let indexName = self.indexArray[indexPath.row]
        let indexStatus = findStatus(indexName: indexName)
        let imageOrLottieName = locationWeatherIndexView.findImageOrLottieName(indexName: indexName, status: indexStatus)
        locationWeatherIndexView.changeImageView(name: imageOrLottieName)
        locationWeatherIndexView.changeCollectionView(index: indexPath.row)
        locationWeatherIndexView.changeTextView(indexType: indexName)
        let transedIndexName = locationWeatherIndexView.transIndexName(indexName: indexName)
        locationWeatherIndexView.configureView(indexNameLabel: transedIndexName, indexStatusLabel: "지수별 text 받아올 부분")

        // WeatherDetailIndexView 에 어떤 Index 가 Tap 되었는지 전달
        indexNameString.onNext(indexName)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.indexArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let indexName = self.indexArray[indexPath.row]
        let indexStatus = findStatus(indexName: indexName)
        let imageOrLottieName = locationWeatherIndexView.findImageOrLottieName(indexName: indexName, status: indexStatus)
        let circle: UIView = UIView()
        circle.layer.cornerRadius = 17.5
        circle.layer.backgroundColor = UIColor.KColor.white.cgColor
        cell.addSubview(circle)
        circle.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.width.height.equalTo(35)
        }
        // lottieView 나 ImageView를 anyObject로 반환 받아 UIView로 다운 캐스팅 후 cell에 addSubView
        cell.addSubview(makeLottieViewOrImage(indexName: imageOrLottieName) as! UIView)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize(width: 35 , height: 35)
    }

    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = self.indexArray.remove(at: sourceIndexPath.row)
        let strItem =  self.indexStrArray.remove(at: sourceIndexPath.row)
        self.indexArray.insert(item, at: destinationIndexPath.row)
        self.indexStrArray.insert(strItem, at: destinationIndexPath.row)
        locationWeatherIndexView.indexArray = self.indexArray
    }
}
