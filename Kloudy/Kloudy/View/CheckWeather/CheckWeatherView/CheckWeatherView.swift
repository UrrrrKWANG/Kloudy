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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(self.weathers)
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
        checkWeatherViewModel.cityWeather.forEach { city in
            // 여기서 Controller를 그린다.
            // view를 그릴 때 viewModel을 가져와 사용한다.
            // viewmodel에 init을 줘서 코어데이터에 있는 도시를 가져와서 사용하면 될 듯
            lazy var num: UIViewController = {
                let vc = UIViewController()
                let locationView = UIView()
                let weatherIndexView = WeatherIndexView(city: city.localName)
                let detailWeatherView = UIButton()
                let currentWeatherImage = UIImageView()
                let detailWeatherViewLabel = UILabel()
                let rightIcon = UIImageView()
                
                vc.view.backgroundColor = .clear
                [locationView, currentWeatherImage, weatherIndexView, detailWeatherView].forEach { vc.view.addSubview($0) }
                
                temp_locationView(view: locationView, city: city)
                locationView.backgroundColor = UIColor.KColor.primaryBlue01
                locationView.layer.cornerRadius = 15
                locationView.snp.makeConstraints {
                    $0.top.equalToSuperview().inset(24)
                    $0.leading.trailing.equalToSuperview().inset(20)
                    $0.height.equalTo(108)
                }
                
                currentWeatherImage.image = UIImage(named: "detailWeather-\(city.currentWeather)")
                currentWeatherImage.snp.makeConstraints {
                    $0.top.equalToSuperview().inset(-6)
                    $0.leading.equalToSuperview().inset(36)
                    $0.width.equalTo(150)
                    $0.height.equalTo(130)
                }
                weatherIndexView.backgroundColor = UIColor.KColor.white
                weatherIndexView.layer.cornerRadius = 12
                weatherIndexView.layer.applySketchShadow(color: UIColor.KColor.primaryBlue01, alpha: 0.1, x: 0, y: 0, blur: 40, spread: 0)
                weatherIndexView.snp.makeConstraints {
                    $0.top.equalTo(locationView.snp.bottom).offset(32)
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
                            
                            weatherIndexDetailView.city = city.localName
                            weatherIndexDetailView.modalPresentationStyle = .overCurrentContext
                            weatherIndexDetailView.modalTransitionStyle = .crossDissolve
                            self.present(weatherIndexDetailView, animated: true)
                        }
                    })
                    .disposed(by: disposeBag)
                
                detailWeatherView.rx.tap
                    .bind {
                        let detailWeatherView = DetailWeatherView()
                        detailWeatherView.modalPresentationStyle = .pageSheet
                        detailWeatherView.modalTransitionStyle = .coverVertical
                        self.present(detailWeatherView, animated: true)
                    }
                    .disposed(by: disposeBag)
                
                detailWeatherView.backgroundColor = UIColor.KColor.white
                detailWeatherView.layer.cornerRadius = 10
                detailWeatherView.layer.applySketchShadow(color: UIColor.KColor.primaryBlue01, alpha: 0.1, x: 0, y: 0, blur: 40, spread: 0)
                detailWeatherView.snp.makeConstraints {
                    $0.top.equalTo(weatherIndexView.snp.bottom).offset(32)
                    $0.leading.trailing.equalToSuperview().inset(20)
                    $0.height.equalTo(58)
                }
                
                rightIcon.image = UIImage(named: "right")
                rightIcon.contentMode = .scaleToFill
                
                [detailWeatherViewLabel, rightIcon].forEach { detailWeatherView.addSubview($0) }

                detailWeatherViewLabel.configureLabel(text: "상세 날씨", font: UIFont.KFont.appleSDNeoSemiBoldMedium, textColor: UIColor.KColor.primaryBlue01)
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
    
    func temp_locationView(view: UIView, city: CityWeather) {
        let locationLabel = UILabel()
        let locationIcon = UIImageView()
        let temperature = UILabel()
        
        [locationLabel, locationIcon, temperature].forEach { view.addSubview($0) }
        locationIcon.image = UIImage(named: "location_mark")
        locationLabel.configureLabel(text: "\(city.localName)", font: UIFont.KFont.appleSDNeoBoldSmallest, textColor: UIColor.KColor.white)
        temperature.configureLabel(text: "\(Int(city.currentTemperature))°", font: UIFont.KFont.lexendXLarge, textColor: UIColor.KColor.white)

        locationLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13)
            $0.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(20)
        }
        locationIcon.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.trailing.equalTo(locationLabel.snp.leading).offset(-5)
            $0.width.equalTo(11)
            $0.height.equalTo(14)
        }
        
        temperature.snp.makeConstraints {
            $0.top.equalTo(locationLabel.snp.bottom).offset(2)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(63)
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
    
    
    //    @objc func tapAddIndexButton() {
    //        self.delegate?.sendFirstSequenceLocation(self.firstSequenceLocation)
    //        self.present(self.addLivingIndexCellView, animated: true)
    //    }
    
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
