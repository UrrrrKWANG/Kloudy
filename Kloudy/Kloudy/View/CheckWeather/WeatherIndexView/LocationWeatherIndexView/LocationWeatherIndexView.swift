//
//  LocationWeatherIndexView.swift
//  Kloudy
//
//  Created by Byeon jinha on 2022/11/14.
//

import Lottie
import SnapKit
import UIKit

class LocationWeatherIndexView: UIView {
    
    var cityIndex = Int()
    var internalIndex = 0
    lazy var locationWeatherIndexView = LocationWeatherIndexView(city: city)
    var viewModel = WeatherIndexViewModel()
    let weatherIndexNameLabel = UILabel()
    let intenalIndexListView = UIView()
    private var layout : UICollectionViewFlowLayout {
        let layout = CollectionViewRightAlignFlowLayout(cellItemSize: 30)
        return layout
    }
    lazy var internalIndexCollectionView: UICollectionView = {
        var uiCollectionView =  UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        uiCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        uiCollectionView.delegate = self
        uiCollectionView.dataSource = self
        return uiCollectionView
    }()
    
    var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    var city = String()
    let weatherIndexStatusLabel = UILabel()
    
    //TODO: 페이지 개수 받아오는 부분 (임시)
    init(city: String) {
        super.init(frame: .zero)
        self.city = city
        addLayout()
        setLayout()
        let cityIndex = findCityIndex(city: city)
        let indexName = viewModel.indexArray[cityIndex].IndexArray[0]
        let transedIndexName = transIndexName(indexName: indexName)
        let indexStatus = findStatus(city: city, indexName: indexName)
        let imageOrLottieName = findImageOrLottieName(indexName: indexName, status: indexStatus)
        
        configureView(indexNameLabel:  transedIndexName, indexStatusLabel: "하루종일 내림")
        changeImageView(name: imageOrLottieName)
        changeCollectionView(index: 0)
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
        var view:AnyObject = makeLottieView(name: name)
        if view.frame.width == 0 {
            view = makeImageView(name: name)
        }
        containerView.addSubview(view as! UIView)
        (view as! UIView).snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    func changeCollectionView(index: Int) {
        self.internalIndex = index
        
        // 이미 추가된 subview가 있으면 지우고 새로 올림
        if intenalIndexListView.subviews.count != 0 {
            intenalIndexListView.subviews[0].removeFromSuperview()
        }
        
        intenalIndexListView.addSubview(internalIndexCollectionView)
        internalIndexCollectionView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    private func addLayout() {
        [weatherIndexNameLabel, containerView, weatherIndexStatusLabel, intenalIndexListView].forEach() {
            self.addSubview($0)
        }
    }
    
    private func setLayout() {
        weatherIndexNameLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(20)
            $0.width.equalTo(106)
            $0.height.equalTo(24)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(weatherIndexNameLabel.snp.bottom)
            $0.bottom.equalToSuperview().inset(74)
            $0.leading.equalToSuperview().inset(15)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        weatherIndexStatusLabel.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.bottom).offset(16)
            $0.bottom.leading.equalToSuperview().inset(18)
            $0.trailing.equalToSuperview().inset(140)
        }
        
        intenalIndexListView.snp.makeConstraints{
            $0.top.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(300)
            $0.trailing.equalToSuperview()
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
    
    func findImageOrLottieName(indexName: String, status: Int) -> String {
        let findedElement =  (indexName, status)
        switch findedElement {
        case let(indexName, status) where indexName == "maskIndex" && status == 0 :
            return "마스크_1단계"
        case let(indexName, status) where indexName == "maskIndex" && status == 1 :
            return "마스크_2단계"
        case let(indexName, status) where indexName == "maskIndex" && status == 2 :
            return "마스크_3단계"
        case let(indexName, status) where indexName == "maskIndex" && status == 3 :
            return "mask_4grade"
        case let(indexName, status) where indexName == "maskIndex" && status == 4 :
            return "mask_4grade"
        case let(indexName, status) where indexName == "umbrellaIndex" && status == 0 :
            return "rain_step1"
        case let(indexName, status) where indexName == "umbrellaIndex" && status == 1 :
            return "rain_step2"
        case let(indexName, status) where indexName == "umbrellaIndex" &&  status == 2 :
            return "rain_step3"
        case let(indexName, status) where indexName == "umbrellaIndex" && status == 3 :
            return "rain_step4"
        case let(indexName, status) where indexName == "umbrellaIndex" && status == 4 :
            return "rain_step4"
        default:
            return ""
        }
        
    }
    func transIndexName(indexName: String) -> String {
        switch indexName {
        case "maskIndex" :
            return "마스크 지수"
        case "umbrellaIndex" :
            return "우산 지수"
        case "outerIndex" :
            return "겉옷 지수"
        case "laundryIndex" :
            return "빨래 지수"
        case "carwashIndex" :
            return "세차 지수"
        case "campareIndex" :
            return "일교차 지수"
        default :
            break
        }
        return ""
    }
    
    func findStatus(city: String, indexName: String) -> Int {
        for cityIndex in 0..<viewModel.indexDummyData.count {
            if city == viewModel.indexDummyData[cityIndex].localName && indexName == "umbrellaIndex" {
                return viewModel.indexDummyData[cityIndex].cityIndexData[0].umbrella_index.status
            } else if city == viewModel.indexDummyData[cityIndex].localName && indexName == "maskIndex" {
                return viewModel.indexDummyData[cityIndex].cityIndexData[0].mask_index.status
            } else if city == viewModel.indexDummyData[cityIndex].localName && indexName == "outerIndex" {
                return viewModel.indexDummyData[cityIndex].cityIndexData[0].outer_index.status
            } else if city == viewModel.indexDummyData[cityIndex].localName && indexName == "laundryIndex" {
                return viewModel.indexDummyData[cityIndex].cityIndexData[0].laundry_index.status
            } else if city == viewModel.indexDummyData[cityIndex].localName && indexName == "carwashIndex" {
                return viewModel.indexDummyData[cityIndex].cityIndexData[0].carwash_index.status
            } else if city == viewModel.indexDummyData[cityIndex].localName && indexName == "campareIndex" {
                return Int(viewModel.indexDummyData[cityIndex].cityIndexData[0].campare_index.today_max_temperature)
            }
        }
        return 0
    }
    func findInternalIndexColorAndImage(indexName: String, pathIndex: Int) -> UIView {
        let findedElement = (indexName, pathIndex)
        var uiColor = UIColor()
        switch findedElement {
        case let(indexName, pathIndex) where indexName == "maskIndex" && pathIndex == 0 :
            uiColor = UIColor.yellow
        case let(indexName, pathIndex) where indexName == "maskIndex" && pathIndex == 1 :
            uiColor = UIColor.red
        case let(indexName, pathIndex) where indexName == "umbrellaIndex" && pathIndex == 0 :
            uiColor = UIColor.gray
        case let(indexName, pathIndex) where indexName == "umbrellaIndex" && pathIndex == 1 :
            uiColor = UIColor.green
        case let(indexName, pathIndex) where indexName == "outerIndex" && pathIndex == 0 :
            uiColor = UIColor.blue
        case let(indexName, pathIndex) where indexName == "laundryIndex" && pathIndex == 0 :
            uiColor = UIColor.cyan
        case let(indexName, pathIndex) where indexName == "carwashIndex" && pathIndex == 0 :
            uiColor = UIColor.cyan
        case let(indexName, pathIndex) where indexName == "carwashIndex" && pathIndex == 1 :
            uiColor = UIColor.yellow
        case let(indexName, pathIndex) where indexName == "carwashIndex" && pathIndex == 2 :
            uiColor = UIColor.red
            
            
        default:
            uiColor = UIColor.KColor.black
        }
        let cellFrame: UIView = UIView()
        cellFrame.layer.cornerRadius = 8
        cellFrame.layer.backgroundColor = uiColor.cgColor
        return cellFrame
    }
}


extension LocationWeatherIndexView:  UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout {
    
    //TODO: 받아오는 내용 마다 셀 개수를 새로 갱신할 로직 필요.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let cityIndex = findCityIndex(city: city)
        let indexName = viewModel.indexArray[cityIndex].IndexArray[self.internalIndex]
        var cellCount = 0
        switch indexName {
        case "umbrellaIndex":
            cellCount = 2
        case "maskIndex":
            cellCount = 2
        case "outerIndex":
            cellCount = 1
        case "laundryIndex":
            cellCount = 1
        case "carwashIndex":
            cellCount = 3
        default:
            break
        }
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let cityIndex = findCityIndex(city: city)
        let indexName = viewModel.indexArray[cityIndex].IndexArray[self.internalIndex]
        let internalIndexView = findInternalIndexColorAndImage(indexName: indexName, pathIndex: indexPath.row)
        
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
}
// 참조 collectionView 정렬 - https://fomaios.tistory.com/entry/iOSUI-%EC%BB%AC%EB%A0%89%EC%85%98%EB%B7%B0%EC%85%80-%EC%9E%90%EB%8F%99%EC%9C%BC%EB%A1%9C-%ED%81%AC%EA%B8%B0-%EC%A1%B0%EC%A0%95%ED%95%98%EA%B3%A0-%EC%99%BC%EC%AA%BD-%EC%A0%95%EB%A0%AC%ED%95%98%EA%B8%B0-CollectionViewCell-Automaticsize-LeftAlign

class CollectionViewRightAlignFlowLayout: UICollectionViewFlowLayout {
    let cellSpacing: CGFloat = 4
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
        self.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom:0, right: 16)
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var rightMargin = sectionInset.right
        var maxY: CGFloat = 300
        attributes?.forEach { layoutAttribute in
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
