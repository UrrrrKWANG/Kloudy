//
//  OnboardingView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/12/02.
//

import UIKit
import SnapKit
import CoreLocation

class OnboardingView: UIViewController {
    
    let startButton = UIButton()
    
    lazy var pageViewController = UIPageViewController()
    var insideViewControllers = [UIViewController]()
    let pageControl = UIPageControl()
    let initialPage = 0
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        attribute()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkIsAlertDismissed), userInfo: nil, repeats: true)
    }
    
    private func layout() {
        view.backgroundColor = UIColor.KColor.white
        [OnboardingPageView(imageName: "onboarding1", mainLabelText: "순서를 변경하세요".localized, subLabelText: "아이콘을 길게 눌러 변경하고자 하는 지수의 순서를 바꿔보세요".localized),
         OnboardingPageView(imageName: "onboarding2", mainLabelText: "세부 날씨를 확인하세요".localized, subLabelText: "아래로 화면을 밀어 세부 날씨를 확인할 수 있어요".localized)].forEach { insideViewControllers.append($0) }
        
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        addChild(pageViewController)
        
        [pageViewController.view, pageControl, startButton].forEach { view.addSubview($0) }
        
        pageViewController.view.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(154)
            $0.height.equalTo(435)
            $0.leading.trailing.equalToSuperview()
        }
        
        if let firstVC = insideViewControllers.first {
            pageViewController.setViewControllers([firstVC], direction: .forward, animated: true)
        }
        
        pageControl.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(200)
            $0.centerX.equalToSuperview()
        }
        
        startButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(55)
            $0.leading.trailing.equalToSuperview().inset(44)
            $0.bottom.equalToSuperview().inset(100)
        }
    }
    
    private func attribute() {
        configurePageViewController()
        configurePageControl()
        configureStartButton()
    }
    
    private func configurePageViewController() {
        pageViewController.dataSource = self
        pageViewController.delegate = self
    }
    
    private func configurePageControl() {
        pageControl.frame = CGRect()
        pageControl.currentPageIndicatorTintColor = UIColor.KColor.primaryBlue01
        pageControl.pageIndicatorTintColor = UIColor.KColor.primaryBlue03
        pageControl.numberOfPages = 2
        pageControl.currentPage = initialPage
    }
    
    private func configureStartButton() {
        startButton.setTitle("시작하기".localized, for: .normal)
        startButton.setTitleColor(UIColor.KColor.white, for: .normal)
        startButton.titleLabel?.font = UIFont.KFont.appleSDNeoBold18
        startButton.backgroundColor = UIColor.KColor.primaryBlue01
        startButton.layer.cornerRadius = 28
        startButton.addTarget(self, action: #selector(tapNextButton), for: .touchUpInside)
    }
    
    @objc private func tapNextButton() {
        CLLocationManager().requestAlwaysAuthorization()
    }
    
    @objc private func checkIsAlertDismissed() {
        switch CLLocationManager().authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse, .restricted, .denied:
            self.navigationController?.pushViewController(ViewController(), animated: true)
            timer?.invalidate()
        case .notDetermined:
            return
        @unknown default:
            fatalError()
        }
    }
}

extension OnboardingView: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = insideViewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 {
            return nil
        }
        return insideViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = insideViewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1

        if nextIndex == insideViewControllers.count {
            return nil
        }
        return insideViewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let viewControllers = pageViewController.viewControllers {
            if let viewControllerIndex = self.insideViewControllers.firstIndex(of: viewControllers[0]) {
                self.pageControl.currentPage = viewControllerIndex
            }
        }
    }
}
