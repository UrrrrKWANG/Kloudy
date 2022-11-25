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
    let locationIndex = Int()
    let localWeather =  [LocalWeather]?.self
    var dataViewControllers = [UIViewController]()
    let pageControl = UIPageControl()
    var weathers: Weather?
    lazy var sentWeather = PublishSubject<Weather>()
    let disposeBag = DisposeBag()
    let initialPage = 0
    lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical)
        return vc
    }()
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
   
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
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()

        
        addChild(pageViewController)
        loadWeatherView()
        
        [pageViewController.view].forEach { view.addSubview($0) }
        pageViewController.dataSource = self
        pageViewController.delegate = self
        configurePageViewController()
        
        if let firstVC = dataViewControllers.first {
            pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        // 스와이프로 pop되어서 런치스크린으로 가는 것을 막아줍니다.
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        view.backgroundColor = UIColor.KColor.white
        
        
        sentWeather.debug().subscribe().disposed(by: disposeBag)
        
    }
    func loadWeatherView() {
        let location = self.weathers
        lazy var localWeather = [LocalWeather](location!.localWeather)
        let main = [Main](localWeather[0].main)
        lazy var num: UIViewController = {
            let vc = UIViewController()
            let currentWeatherView = CurrentWeatherView(localWeather: localWeather)
            let weatherIndexView = WeatherIndexView()
            
            let currentWeatherImage: UIImageView = {
                let currentWeatherImage = UIImageView()
                currentWeatherImage.contentMode = .scaleAspectFit
                currentWeatherImage.image = UIImage(named: "detailWeather-\(main[0].currentWeather)")
                return currentWeatherImage
            }()
//            let detailWeatherViewLabel: UILabel = {
//                let detailWeatherViewLabel = UILabel()
//                detailWeatherViewLabel.configureLabel(text: "상세 날씨".localized, font: UIFont.KFont.appleSDNeoSemiBold17, textColor: UIColor.KColor.primaryBlue01)
//                return detailWeatherViewLabel
//            }()
//            let rightIcon: UIImageView = {
//                let rightIcon = UIImageView()
//                rightIcon.image = UIImage(named: "right")
//                rightIcon.contentMode = .scaleAspectFit
//                return rightIcon
//            }()
            
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
//
//
//            [detailWeatherViewLabel, rightIcon].forEach { detailWeatherView.addSubview($0) }
//
//            detailWeatherViewLabel.snp.makeConstraints {
//                $0.centerY.equalToSuperview()
//                $0.leading.equalToSuperview().inset(16)
//            }
//            rightIcon.snp.makeConstraints {
//                $0.centerY.equalToSuperview()
//                $0.trailing.equalToSuperview().inset(16)
//                $0.width.equalTo(8)
//                $0.height.equalTo(14)
//            }
            return vc
        }()
        dataViewControllers.append(num)
        let detailWeatherView = DetailWeatherView(weatherDatas: location!)
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
        if let viewControllers = pageViewController.viewControllers {
            if let viewControllerIndex = self.dataViewControllers.firstIndex(of: viewControllers[0]) {
                self.pageControl.currentPage = viewControllerIndex
            }
        }
    }
}
