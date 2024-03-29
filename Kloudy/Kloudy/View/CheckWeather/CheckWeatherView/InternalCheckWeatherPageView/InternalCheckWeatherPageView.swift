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
            
            let currentWeatherImage: UIImageView = {
                let currentWeatherImage = UIImageView()
                currentWeatherImage.contentMode = .scaleAspectFit
                currentWeatherImage.image = UIImage(named: "detailWeather-\(weather.localWeather[0].main[0].currentWeather)")
                return currentWeatherImage
            }()
            
            vc.view.backgroundColor = UIColor.KColor.clear
            [currentWeatherView, currentWeatherImage, weatherIndexView].forEach { vc.view.addSubview($0) }
            
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
//                $0.bottom.equalToSuperview().inset(94)
                $0.height.equalTo(UIScreen.main.bounds.height * 456 / 844)
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
