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

// https://www.linkedin.com/pulse/using-ios-pageviewcontroller-without-storyboards-paul-tangen/
// https://ios-development.tistory.com/623

class CheckWeatherView: UIViewController {
    let disposeBag = DisposeBag()
    let checkWeatherBasicNavigationView = CheckWeatherBasicNavigationView()
    
    let pageControl = UIPageControl()
    let initialPage = 0
    
    var weathers = [Weather]()
    
    lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        
        return vc
    }()
    let checkWeatherViewModel = CheckWeatherViewModel()
    
    var dataViewControllers = [UIViewController]()
    
    var locations = [Location]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        지역이 변경될 시 사용할 코드
//        dataViewControllers = [UIViewController]()
//        loadWeatherView()
//
//        addChild(pageViewController)
//        [checkWeatherBasicNavigationView, pageViewController.view, pageControl].forEach { view.addSubview($0) }
//        configureCheckWeatherNavigationView()
//
//        pageViewController.dataSource = self
//        pageViewController.delegate = self
//        configurePageViewController()
//
//        if let firstVC = dataViewControllers.first {
//            pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
//        }
//
//        pageControl.frame = CGRect()
//        pageControl.currentPageIndicatorTintColor = UIColor.KColor.primaryBlue01
//        pageControl.pageIndicatorTintColor = UIColor.KColor.primaryBlue03
//        pageControl.numberOfPages = self.dataViewControllers.count
//        pageControl.currentPage = initialPage
//
//        pageControl.snp.makeConstraints {
//            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(6)
//            $0.centerX.equalToSuperview()
//        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let weathers = appDelegate?.weathers {
            self.weathers = weathers
        }
        
        view.backgroundColor = UIColor.KColor.white
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
    
    private func bind() {
        
    }
    
    func loadWeatherView() {
        weathers.forEach { location in
            let localWeather = [LocalWeather](location.localWeather)
            let main = [Main](localWeather[0].main)
            let hourlyWeather = [HourlyWeather](localWeather[0].hourlyWeather)
            
            lazy var num: UIViewController = {
                let vc = UIViewController()
                let currentWeatherView = CurrentWeatherView(localWeather: localWeather)
                let weatherIndexView = WeatherIndexView(city: localWeather[0].localName)
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
                    currentWeatherImage.image = UIImage(named: "detailWeather-\(main[0].currentWeather)")
                    return currentWeatherImage
                }()
                let detailWeatherViewLabel: UILabel = {
                    let detailWeatherViewLabel = UILabel()
                    detailWeatherViewLabel.configureLabel(text: "상세 날씨", font: UIFont.KFont.appleSDNeoSemiBold17, textColor: UIColor.KColor.primaryBlue01)
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
                            
                            weatherIndexDetailView.city = localWeather[0].localName
                            weatherIndexDetailView.modalPresentationStyle = .overCurrentContext
                            weatherIndexDetailView.modalTransitionStyle = .crossDissolve
                            self.present(weatherIndexDetailView, animated: true)
                        }
                    })
                    .disposed(by: disposeBag)
                
                detailWeatherView.rx.tap
                    .bind {
                        let detailWeatherView = DetailWeatherView(weatherDatas: location)
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
            dataViewControllers.append(num)
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    @objc func tapLocationButton() {
        let locationSelectionView = LocationSelectionView()
        self.navigationController?.pushViewController(locationSelectionView, animated: true)
    }
    @objc func tapSettingButton() {
        let settingView = SettingView()
        self.navigationController?.pushViewController(settingView, animated: true)
    }
    
    @objc func tapDetailWeatherViewButton() {
        let detailWeatherView = LocationSelectionView()
        self.present(detailWeatherView, animated: true)
    }
    
}

extension CheckWeatherView: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
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
