//
//  CheckWeatherView.swift
//  Kloudy
//
//  Created by Hyeongjung on 2022/11/07.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import CoreLocation

// https://www.linkedin.com/pulse/using-ios-pageviewcontroller-without-storyboards-paul-tangen/
// https://ios-development.tistory.com/623

class CheckWeatherView: UIViewController {
    let disposeBag = DisposeBag()
    let checkWeatherBasicNavigationView = CheckWeatherBasicNavigationView()
    let locationSelectionView = LocationSelectionView()
    let settingView = SettingView()
    
    var currentPageIndex = PublishSubject<Int>()
    var pageIndex = 0
    
    let pageControl = UIPageControl()
    let initialPage = 0
    
    let cityInformationModel = FetchWeatherInformation()
    lazy var cityData = self.cityInformationModel.loadCityListFromCSV()
    var locationList = CoreDataManager.shared.fetchLocations()

    lazy var pageViewController = UIPageViewController()
    let checkWeatherViewModel = CheckWeatherViewModel()
    var dataViewControllers = [UIViewController]()
    
    var weathers = [Weather]()
    var initialWeathers = [Weather]()
    
    var locations = [Location]()
    weak var delegate: LocationSelectionDelegate?
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for i in 0..<dataViewControllers.count {
            dataViewControllers[i].viewDidDisappear(false)
        }
        dataViewControllers = [UIViewController]()
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        
        [checkWeatherBasicNavigationView, pageViewController.view, pageControl].forEach { $0.removeFromSuperview() }
        loadWeatherView()

        addChild(pageViewController)
        [checkWeatherBasicNavigationView, pageViewController.view, pageControl].forEach { view.addSubview($0) }
        configureCheckWeatherNavigationView()

        pageViewController.dataSource = self
        pageViewController.delegate = self
        configurePageViewController()

        if let firstVC = dataViewControllers.first {
            pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }

        pageControl.frame = CGRect()
        pageControl.currentPageIndicatorTintColor = UIColor.KColor.primaryBlue01
        pageControl.pageIndicatorTintColor = UIColor.KColor.primaryBlue03
        pageControl.numberOfPages = self.dataViewControllers.count
        pageControl.currentPage = initialPage

        pageControl.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(6)
            $0.centerX.equalToSuperview()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageViewController.view.setNeedsLayout()
        locations = CoreDataManager.shared.fetchLocations()
        self.weathers = serializeLocationSequence(locations: locations, initialWeathers: initialWeathers)
        self.delegate = self.locationSelectionView
        // 스와이프로 pop되어서 런치스크린으로 가는 것을 막아줍니다.
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        view.backgroundColor = UIColor.KColor.white
    }
    
    private func bind() {
        locationSelectionView.additionalLocation
            .subscribe(onNext: {
                print($0)
                self.weathers.append($0)
            })
            .disposed(by: disposeBag)
        
        locationSelectionView.deleteLocationCode
            .subscribe(onNext: { [self] in
                for index in 0..<self.weathers.count {
                    if $0 == self.weathers[index].localWeather[pageIndex].localCode {
                        self.weathers.remove(at: index)
                        return
                    }
                }
            })
            .disposed(by: disposeBag)
        locationSelectionView.exchangeLocationIndex
            .subscribe(onNext: {
                let itemMove = self.weathers[$0[0]]
                self.weathers.remove(at: $0[0])
                self.weathers.insert(itemMove, at: $0[1])
            })
            .disposed(by: disposeBag)
        
        locationSelectionView.authorizeButtonTapped
            .subscribe(onNext: {
                self.locationSelectionView.navigationController?.popViewController(animated: true)
                self.navigationController?.pushViewController(self.settingView, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func serializeLocationSequence(locations: [Location], initialWeathers: [Weather]) -> [Weather] {
        var weatherData = [Weather](repeating: FetchWeatherInformation().dummyData, count: locations.count + 1)
        weatherData[0] = initialWeathers[0]
        for weatherIndex in 1..<initialWeathers.count {
            for locationIndex in 0..<locations.count {
                if initialWeathers[weatherIndex].localWeather[0].localCode == locations[locationIndex].code {
                    weatherData[locationIndex + 1] = initialWeathers[weatherIndex]
                    continue
                }
            }
        }
        return weatherData
    }
    
    func loadWeatherView() {
        let currentStatus = CLLocationManager().authorizationStatus
        self.weathers.indices.forEach { locationIndex in
            if locationIndex == 0 && (currentStatus == .restricted || currentStatus == .notDetermined || currentStatus == .denied) { return }
            let location = weathers[locationIndex]
            let internalCheckWeatherPageView = InternalCheckWeatherPageView()
            let weatherIndexView = WeatherIndexView()
            internalCheckWeatherPageView.weathers = self.weathers[locationIndex]
            internalCheckWeatherPageView.sentWeather.onNext(location)
            internalCheckWeatherPageView.currentPageIndex.onNext(self.pageIndex)
            internalCheckWeatherPageView.currentPageIndex
                .observe(on: MainScheduler.asyncInstance)
                .subscribe(
                onNext: {
                    self.pageIndex = $0
//                    print(self.pageIndex)
//                    internalCheckWeatherPageView.currentPageIndex.onNext($0)
                })
            .disposed(by: disposeBag)
            weatherIndexView.sentWeather.onNext(location)
            dataViewControllers.append(internalCheckWeatherPageView)
        }
    }
    
    func configureCheckWeatherNavigationView() {
        checkWeatherBasicNavigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(9)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(111)
            $0.height.equalTo(40)
        }
            
        checkWeatherBasicNavigationView.locationButton.addTarget(self, action: #selector(tapLocationButton), for: .touchUpInside)
        checkWeatherBasicNavigationView.settingButton.addTarget(self, action: #selector(tapSettingButton), for: .touchUpInside)
    }
    
    private func configurePageViewController() {
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(checkWeatherBasicNavigationView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    @objc func tapLocationButton() {
        self.navigationController?.pushViewController(locationSelectionView, animated: true)
        self.delegate?.sendWeatherData(weatherData: weathers)
    }
    @objc func tapSettingButton() {
        self.navigationController?.pushViewController(settingView, animated: true)
    }
    
    @objc func tapDetailWeatherViewButton() {
        let detailWeatherView = LocationSelectionView()
        self.present(detailWeatherView, animated: true)
    }
}

extension CheckWeatherView: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        print("checkWeather 이전페이지")
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
}
