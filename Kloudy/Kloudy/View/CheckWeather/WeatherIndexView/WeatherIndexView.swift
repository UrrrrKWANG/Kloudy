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

class WeatherIndexView: UIView {
    
    var disposeBag = DisposeBag()
    var viewModel = WeatherIndexViewModel()
    var city = String()
    lazy var locationWeatherIndexView = LocationWeatherIndexView(city: city)
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
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
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
    
    // checkWeatherView에서 받아온 지역 이름과 데이터의 city를 비교 후 지역의 index를 받아올 함수
    func findCityIndex(city: String) -> Int {
        for cityIndex in 0..<viewModel.indexArray.count {
            if viewModel.indexDummyData[cityIndex].localName == city {
                return cityIndex
            }
        }
        return 0
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
    
    //TODO: 페이지 개수 받아오는 부분 (임시)
    lazy var pageControlNum = viewModel.indexArray.count
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.frame)
        scrollView.showsHorizontalScrollIndicator = false // 가로스크롤인디케이터 숨김
        scrollView.showsVerticalScrollIndicator = false // 세로스크롤인디케이터 숨김
        scrollView.isPagingEnabled = true // 페이지가 구역에 맞게 넘어가게 만들어줌
        scrollView.delegate = self // scrollView의 델리게이트, 하단 extention에 따로 만듬
        scrollView.contentSize = CGSize(width: CGFloat(pageControlNum) * UIScreen.main.bounds.width, height: UIScreen.main.bounds.height) // 컨텐츠사이즈
        scrollView.backgroundColor = UIColor.KColor.black
        return scrollView
    }()
    
    init(city: String) {
        super.init(frame: .zero)
        self.city = city
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
       
//        indexCollectionView.snp.makeConstraints {
//            $0.top.equalToSuperview() // 나중에 checkWeatherCellLabelView안에 넣게 된다면 수정 할 것
//            $0.width.height.equalToSuperview()
//        }
    }
}

extension WeatherIndexView:  UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cityIndex = locationWeatherIndexView.findCityIndex(city: city)
        let indexName = viewModel.indexArray[cityIndex].IndexArray[indexPath.row]
        let indexStatus = locationWeatherIndexView.findStatus(city: city, indexName: indexName)
        let imageOrLottieName = locationWeatherIndexView.findImageOrLottieName(indexName: indexName, status: indexStatus)
        locationWeatherIndexView.changeImageView(name: imageOrLottieName)
        locationWeatherIndexView.changeCollectionView(index: indexPath.row)
        let transedIndexName = locationWeatherIndexView.transIndexName(indexName: indexName)
        locationWeatherIndexView.configureView(indexNameLabel: transedIndexName, indexStatusLabel: "지수별 text 받아올 부분")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let cityIndex = findCityIndex(city: city)
        return viewModel.indexArray[cityIndex].IndexArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let cityIndex = findCityIndex(city: city)
        let indexName = viewModel.indexArray[cityIndex].IndexArray[indexPath.row]
        let indexStatus = locationWeatherIndexView.findStatus(city: city, indexName: indexName)
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
        let cityIndex = findCityIndex(city: city)
        let item = viewModel.indexArray[cityIndex].IndexArray.remove(at: sourceIndexPath.row)
        viewModel.indexArray[cityIndex].IndexArray.insert(item, at: destinationIndexPath.row)
        locationWeatherIndexView.viewModel = self.viewModel
    }
}
