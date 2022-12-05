//
//  InternalCheckWeatherPageView.swift
//  Kloudy
//
//  Created by Byeon jinha on 2022/12/06.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import CoreLocation

class InternalCheckWeatherPageView: UIViewController {
    
    let disposeBag = DisposeBag()
    let sentIndexStrArray = PublishSubject<[String]>()
    
    var weather: Weather?
    var locationWeatherIndex = Int()
    let localWeather = [LocalWeather]?.self
    
    lazy var pageViewController = UIPageViewController()
    var dataViewControllers = [UIViewController]()
    
    var indexArray = [IndexType]()
    var indexStrArray = [String]()
    let pageControl = UIPageControl()
    
    let initialPage = 0
    var pageIndex = 0
    
    override func viewWillAppear(_ animated: Bool) {
        let firstVC = dataViewControllers[0]
        pageViewController.setViewControllers([firstVC], direction: .forward, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.KColor.white
        for dataViewController in dataViewControllers {
            dataViewController.viewDidDisappear(false)
        }
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical)
        dataViewControllers = [UIViewController]()
        
        bind()
        loadWeatherView()
        configurePageViewController()
    }
    
    private func bind() {
        sentIndexStrArray
            .subscribe(onNext: {
                self.indexStrArray = $0
                self.indexArray = CoreDataManager.shared.convertStringToIndexTypeArray(indexStrArray: $0)
            })
            .disposed(by: disposeBag)
    }
    
    private func loadWeatherView() {
        guard let weather = self.weather else { return }
        lazy var locationVC: UIViewController = {
            let vc = UIViewController()
            let currentWeatherView = CurrentWeatherView(localWeather: weather.localWeather)
            let weatherIndexView = WeatherIndexView()
            weatherIndexView.weatherIndex = self.locationWeatherIndex
            weatherIndexView.sentWeatherIndex.onNext(locationWeatherIndex)
            weatherIndexView.sentWeather.onNext(weather)
            
//            if (self.currentStatus == .authorized || self.currentStatus == .authorizedWhenInUse) && locationIndex == 0 {
//                self.indexStrArray = Storage.fetchCurrentLocationIndexArray()
//            } else {
//                self.indexStrArray = locations[locationIndex].indexArray ?? Storage.defaultIndexArray
//            }
            
//            weatherIndexView.sentIndexStrArray.onNext(self.indexStrArray)
            
            let detailWeatherView: UIButton = {
                let detailWeatherView = UIButton()
                detailWeatherView.backgroundColor = UIColor.KColor.white
                detailWeatherView.layer.cornerRadius = 10
                detailWeatherView.layer.applySketchShadow(color: UIColor.KColor.primaryBlue01, alpha: 0.1, x: 0, y: 0, blur: 40, spread: 0)
                return detailWeatherView
            }()
            
            let currentWeatherImage: UIImageView = {
                let currentWeatherImage = UIImageView()
                currentWeatherImage.contentMode = .scaleAspectFit
                currentWeatherImage.image = UIImage(named: "detailWeather-\(weather.localWeather[0].main[0].currentWeather)")
                return currentWeatherImage
            }()
            let detailWeatherViewLabel: UILabel = {
                let detailWeatherViewLabel = UILabel()
                detailWeatherViewLabel.configureLabel(text: "상세 날씨".localized, font: UIFont.KFont.appleSDNeoSemiBold17, textColor: UIColor.KColor.primaryBlue01)
                return detailWeatherViewLabel
            }()
            let rightIcon: UIImageView = {
                let rightIcon = UIImageView()
                rightIcon.image = UIImage(named: "right")
                rightIcon.contentMode = .scaleAspectFit
                return rightIcon
            }()
            
            vc.view.backgroundColor = UIColor.KColor.clear
            [currentWeatherView, currentWeatherImage, weatherIndexView, detailWeatherView].forEach { vc.view.addSubview($0) }
            
            currentWeatherView.snp.makeConstraints {
                $0.top.equalToSuperview().inset(24)
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.height.equalTo(108)
            }
            currentWeatherImage.snp.makeConstraints {
                $0.top.equalToSuperview().inset(-6)
                $0.leading.equalToSuperview().inset(36)
                $0.width.equalTo(150)
                $0.height.equalTo(130)
            }
            weatherIndexView.snp.makeConstraints {
                $0.top.equalTo(currentWeatherView.snp.bottom).offset(32)
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.height.equalTo(385)
            }
            
            // CheckWeatherView 의 Lottie 선택 시 WeatherDetailIndexView 로 city 와 indexType 전달
            weatherIndexView.locationWeatherIndexView.indexViewTapped
                .subscribe(onNext: {
                    if $0 {
                        let weatherIndexDetailView = WeatherIndexDetailView()
                        weatherIndexView.indexNameString
                            .subscribe(onNext: {
                                weatherIndexDetailView.indexType = $0
                            })
                            .disposed(by: self.disposeBag)
                        
                        weatherIndexDetailView.weatherData = weather
                        weatherIndexDetailView.city = weather.localWeather[0].localName
                        weatherIndexDetailView.modalPresentationStyle = .overCurrentContext
                        weatherIndexDetailView.modalTransitionStyle = .crossDissolve
                        self.present(weatherIndexDetailView, animated: true)
                    }
                })
                .disposed(by: disposeBag)
            
            detailWeatherView.rx.tap
                .bind {
                    let detailWeatherView = DetailWeatherView(weatherDatas: weather)
                    detailWeatherView.modalPresentationStyle = .pageSheet
                    detailWeatherView.modalTransitionStyle = .coverVertical
                    self.present(detailWeatherView, animated: true)
                }
                .disposed(by: disposeBag)
            
            detailWeatherView.snp.makeConstraints {
                $0.top.equalTo(weatherIndexView.snp.bottom).offset(32)
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.height.equalTo(58)
            }
            
            [detailWeatherViewLabel, rightIcon].forEach { detailWeatherView.addSubview($0) }
            
            detailWeatherViewLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().inset(16)
            }
            rightIcon.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview().inset(16)
                $0.width.equalTo(8)
                $0.height.equalTo(14)
            }
            return vc
        }()
        dataViewControllers.append(locationVC)
        let detailWeatherView = DetailWeatherView(weatherDatas: weather)
        detailWeatherView.scrollView.clipsToBounds = false
        dataViewControllers.append(detailWeatherView)
    }
    
    private func configurePageViewController() {
        view.addSubview(pageViewController.view)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
extension InternalCheckWeatherPageView: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 {
            return nil
        }
        return dataViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        if nextIndex == dataViewControllers.count {
            return nil
        }
        return dataViewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let viewControllers = pageViewController.viewControllers {
            if let viewControllerIndex = self.dataViewControllers.firstIndex(of: viewControllers[0]) {
                self.pageControl.currentPage = viewControllerIndex
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let viewControllers = pageViewController.viewControllers {
            if let viewControllerIndex = self.dataViewControllers.firstIndex(of: viewControllers[0]) {
                self.pageControl.currentPage = viewControllerIndex
            }
        }
    }
}
