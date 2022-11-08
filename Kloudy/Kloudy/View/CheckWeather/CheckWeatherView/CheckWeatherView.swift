//
//  CheckWeatherView.swift
//  Kloudy
//
//  Created by Hyeongjung on 2022/11/07.
//

import UIKit
import SnapKit

// https://www.linkedin.com/pulse/using-ios-pageviewcontroller-without-storyboards-paul-tangen/
// https://ios-development.tistory.com/623

class CheckWeatherView: UIViewController {
    
    let checkWeatherBasicNavigationView = CheckWeatherBasicNavigationView()
    
    let pageControl = UIPageControl()
    let initialPage = 0
    
    lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        
        return vc
    }()
    lazy var test = ["pohang", "daegu", "jeju"]
    
    var dataViewControllers = [UIViewController]()
    
    func loadWeatherView() {
        test.forEach { city in
            // 여기서 Controller를 그린다.
            // view를 그릴 때 viewModel을 가져와 사용한다.
            // viewmodel에 init을 줘서 코어데이터에 있는 도시를 가져와서 사용하면 될 듯
            lazy var num: UIViewController = {
                let vc = UIViewController()
                vc.view.backgroundColor = .brown
                let test = UITextView()
                let locationView = UIView()
                //    let weatherIndexView = WeatherIndexView()
                //    let detailWeatherView = DetailWeatherView()
                let weatherIndexView = UIView()
                let detailWeatherView = UIView()
                vc.view.addSubview(test)
                test.text = city
                test.snp.makeConstraints {
                    $0.top.trailing.equalToSuperview().inset(30)
                    $0.size.equalTo(100)
                }
                vc.view.addSubview(locationView)
                vc.view.addSubview(weatherIndexView)
                vc.view.addSubview(detailWeatherView)
                
                locationView.backgroundColor = .red
                locationView.snp.makeConstraints {
                    $0.top.equalToSuperview().inset(28)
                    $0.leading.equalToSuperview().inset(20)
                    $0.width.equalTo(203)
                    $0.height.equalTo(150)
                }
                weatherIndexView.backgroundColor = .blue
                weatherIndexView.snp.makeConstraints {
                    $0.top.equalTo(locationView.snp.bottom).offset(24)
                    $0.leading.equalToSuperview().inset(20)
                    $0.width.equalTo(350)
                    $0.height.equalTo(360)
                }
                detailWeatherView.backgroundColor = .green
                detailWeatherView.snp.makeConstraints {
                    $0.top.equalTo(weatherIndexView.snp.bottom).offset(20)
                    $0.leading.equalToSuperview().inset(20)
                    $0.width.equalTo(350)
                    $0.height.equalTo(43)
                }
                return vc
            }()
            dataViewControllers.append(num)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWeatherView()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        view.addSubview(checkWeatherBasicNavigationView)
        configureCheckWeatherNavigationView()
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        configurePageViewController()
        
        if let firstVC = dataViewControllers.first {
            pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
        //pageControl 부분
        self.pageControl.frame = CGRect()
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl.numberOfPages = self.dataViewControllers.count
        self.pageControl.currentPage = initialPage
        self.view.addSubview(self.pageControl)
        
        self.pageControl.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(6)
            $0.centerX.equalToSuperview()
        }
    }
    
    func configureCheckWeatherNavigationView() {
        checkWeatherBasicNavigationView.backgroundColor = .black
        checkWeatherBasicNavigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
            $0.trailing.equalToSuperview().inset(21)
            $0.width.equalTo(103)
            $0.height.equalTo(20)
            
            //            checkWeatherBasicNavigationView.locationButton.addTarget(self, action: #selector(tapLocationButton), for: .touchUpInside)
            //            checkWeatherCellLabelView.addButton.addTarget(self, action: #selector(tapAddIndexButton), for: .touchUpInside)
        }
    }
    
    private func configurePageViewController() {
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(checkWeatherBasicNavigationView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    // 네비게이션 버튼
    //    @objc func tapLocationButton() {
    //        let locationSelectionView = LocationSelectionView()
    //        self.navigationController?.pushViewController(locationSelectionView, animated: true)
    //    }
    
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
        
        // set the pageControl.currentPage to the index of the current viewController in pages
        if let viewControllers = pageViewController.viewControllers {
            if let viewControllerIndex = self.dataViewControllers.firstIndex(of: viewControllers[0]) {
                self.pageControl.currentPage = viewControllerIndex
            }
        }
    }
    
    
}
