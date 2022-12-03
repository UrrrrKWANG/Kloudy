//
//  InternalCheckWeatherPageView.swift
//  Kloudy
//
//  Created by Byeon jinha on 2022/11/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import CoreLocation

class InternalCheckWeatherPageView: UIViewController {
    var locationIndex = Int()
    let localWeather =  [LocalWeather]?.self
    var dataViewControllers = [UIViewController]()
    var pageIndex = 0
    var currentPageIndex =  PublishSubject<Int>()
    
    let pageControl = UIPageControl()
    var weathers: Weather?
    lazy var sentWeather = PublishSubject<Weather>()
    let disposeBag = DisposeBag()
    let initialPage = 0
    lazy var pageViewController = UIPageViewController()
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        bind()
        self.currentPageIndex
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(
                onNext: {
                    self.pageIndex = $0
                }
            )
            .disposed(by: disposeBag)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let firstVC = dataViewControllers[self.pageIndex]
        pageViewController.setViewControllers([firstVC], direction: .forward, animated: true)
    }
    override func viewDidLoad() {
//        super.viewDidLoad() // 왜 필요한지 공부
        for i in 0..<dataViewControllers.count {
            dataViewControllers[i].viewDidDisappear(false)
        }
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical)
        dataViewControllers = [UIViewController]()
//        addChild(pageViewController)
        loadWeatherView()
        [pageViewController.view].forEach { view.addSubview($0) }
        pageViewController.dataSource = self
        pageViewController.delegate = self
        configurePageViewController()
    
        // 스와이프로 pop되어서 런치스크린으로 가는 것을 막아줍니다.
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        view.backgroundColor = UIColor.KColor.white
    }
    
    func bind() {
        sentWeather
            .subscribe(
                onNext: {
                    self.weathers = $0
                })
            .disposed(by: disposeBag)
    }
    
    func loadWeatherView() {
        let location = self.weathers
        
        lazy var localWeather = [LocalWeather](location!.localWeather)
        
        let main = [Main](localWeather[0].main)
        lazy var num: UIViewController = {
            let vc = UIViewController()
            let currentWeatherView = CurrentWeatherView(localWeather: localWeather)
            let weatherIndexView = WeatherIndexView()
            weatherIndexView.sentWeather.onNext(weathers!)
            let currentWeatherImage: UIImageView = {
                let currentWeatherImage = UIImageView()
                currentWeatherImage.contentMode = .scaleAspectFit
                currentWeatherImage.image = UIImage(named: "detailWeather-\(main[0].currentWeather)")
                return currentWeatherImage
            }()
            
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
                $0.height.equalTo(385)
            }
            // CheckWeatherView 의 Lottie 선택 시 WeatherDetailIndexView 로 city 와 indexType 전달
            weatherIndexView.indexNameString
                .subscribe(
                onNext: {
                    weatherIndexView.locationWeatherIndexView.indexName.onNext($0)
                })
                .disposed(by: disposeBag)
            
            sentWeather
                .subscribe(onNext: {
                    weatherIndexView.weathers = $0
                })
                .disposed(by: disposeBag)
                    
            weatherIndexView.locationWeatherIndexView.indexViewTapped
                .subscribe(onNext: {
                    if $0 {
                        let weatherIndexDetailView = WeatherIndexDetailView()
                        weatherIndexView.indexNameString
                            .subscribe(onNext: {
                                weatherIndexDetailView.indexType = $0
                            })
                            .disposed(by: self.disposeBag)
                        weatherIndexDetailView.weatherData = location
                        weatherIndexDetailView.city = localWeather[0].localName
                        weatherIndexDetailView.modalPresentationStyle = .overCurrentContext
                        weatherIndexDetailView.modalTransitionStyle = .crossDissolve
                        self.present(weatherIndexDetailView, animated: true)
                    }
                })
                .disposed(by: disposeBag)
            return vc
        }()
        dataViewControllers.append(num)
        let detailWeatherView = DetailWeatherView(weatherDatas: location!)
        detailWeatherView.scrollView.clipsToBounds = false
        dataViewControllers.append(detailWeatherView)
    }
    private func configurePageViewController() {
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
        self.locationIndex = self.dataViewControllers.firstIndex(of: pageViewController.viewControllers![0])!
        if let viewControllers = pageViewController.viewControllers {
            if let viewControllerIndex = self.dataViewControllers.firstIndex(of: viewControllers[0]) {
                self.pageControl.currentPage = viewControllerIndex
                currentPageIndex.onNext(locationIndex)
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let viewControllers = pageViewController.viewControllers {
            if let viewControllerIndex = self.dataViewControllers.firstIndex(of: viewControllers[0]) {
            
                self.pageControl.currentPage = viewControllerIndex
                currentPageIndex.onNext(viewControllerIndex)
            }
        }
    }
}
