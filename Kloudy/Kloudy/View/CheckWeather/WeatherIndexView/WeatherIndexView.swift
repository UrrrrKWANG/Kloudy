//
//  WeatherIndexView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/11/07.
//

import Lottie
import SnapKit
import UIKit

class WeatherIndexView: UIView {
    // 뷰모델
    var viewModel = WeatherIndexViewModel()
    
    // 지역별
    var city = String()
    lazy var locationWeatherIndexView = LocationWeatherIndexView(city: city)
    let weatherIndexListView = UIView()
    var indexCollectionView: UICollectionView?
    
    //롱텝 핸들링
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        guard let collectionView = indexCollectionView else {
            return
        }
        switch gesture.state {
        case .began:
            guard let targetIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                return
            }
            collectionView.beginInteractiveMovementForItem(at: targetIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    func findCityIndex(city: String) -> Int {
        for cityIndex in 0..<viewModel.indexArray.count {
            if viewModel.indexDummyData[cityIndex].localName == city {
                return cityIndex
            }
        }
        return 0
    }
    
    private func makeLottieViewOrImage(indexName: String) -> AnyObject{
        let lottieView = LottieAnimationView(name: indexName)
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
    
    //TODO: 더미데이터, 아키텍쳐 확인 후 수정
    private var layout : UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        return layout
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
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setLayout() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 12
        
        weatherIndexListView.backgroundColor = UIColor.KColor.primaryBlue06
        weatherIndexListView.layer.cornerRadius = 10
        indexCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        indexCollectionView?.backgroundColor = UIColor.KColor.clear
        indexCollectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        indexCollectionView?.showsVerticalScrollIndicator = false
        indexCollectionView?.delegate = self
        indexCollectionView?.dataSource = self
        
        
        
        
        weatherIndexListView.addSubview(indexCollectionView!)
        indexCollectionView!.snp.makeConstraints {
            $0.top.equalToSuperview() // 나중에 checkWeatherCellLabelView안에 넣게 된다면 수정 할 것
            $0.width.height.equalToSuperview()
        }
        
        
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_ :)))
        indexCollectionView?.addGestureRecognizer(gesture)
        
        [locationWeatherIndexView, weatherIndexListView].forEach() {
            self.addSubview($0)
        }
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
    }
}

extension WeatherIndexView:  UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cityIndex = locationWeatherIndexView.findCityIndex(city: city)
        
        let indexName = viewModel.indexArray[cityIndex].IndexArray[indexPath.row]
        let indexStatus = locationWeatherIndexView.findStatus(city: city, indexName: indexName)
        let imageOrLottieName = locationWeatherIndexView.findImageOrLottieName(indexName: indexName, status: indexStatus)
        locationWeatherIndexView.changeImageView(name: imageOrLottieName)
        locationWeatherIndexView.changeCollectionView(index: indexPath.row)
        let transedIndexName = locationWeatherIndexView.transIndexName(indexName: indexName)
        print(indexName, "?")
        locationWeatherIndexView.configureView(indexNameLabel: transedIndexName, indexStatusLabel: "?")
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
        
        print(item, "itemm")
        print(viewModel.indexArray[cityIndex].IndexArray)
    }
}
