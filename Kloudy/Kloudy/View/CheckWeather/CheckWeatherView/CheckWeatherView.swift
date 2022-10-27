//
//  CheckWeatherView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/10/17.
//

import UIKit

class CheckWeatherView: UIViewController {
    let checkWeatherBasicNavigationView = CheckWeatherBasicNavigationView()
    let checkWeatherCellLabelView = CheckWeatherCellLabelView()  //생활지수 라벨
    let addLivingIndexCellView = AddLivingIndexCellView()
    let viewModel = LocationSelectionViewModel()
    var locations = [Location]()
    
    //MARK: View LifeCycle Function
    override func viewDidLoad() {
        if UserDefaults.standard.bool(forKey: "launchedBefore") == false {
            viewModel.saveLocation(city: "4711100000", latitude: 36, longtitude: 129, sequence: 0)
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = UIColor.KColor.backgroundBlack
        
        self.view.addSubview(checkWeatherBasicNavigationView)
        self.configureCheckWeatherBasicNavigationView()
        // 코드 구현을 위해 BasicNavigationView 의 경우 isHidden 처리
        self.checkWeatherBasicNavigationView.isHidden = false
        
      
        let checkLocationWeatherView = CheckLocationWeatherView()
        self.view.addSubview(checkLocationWeatherView)
        checkLocationWeatherView.snp.makeConstraints {
            $0.top.equalTo(checkWeatherBasicNavigationView.snp.bottom)
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.height.equalTo(181)
        }
        
        self.view.addSubview(checkWeatherCellLabelView)
        checkWeatherCellLabelView.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.height.equalTo(180)
            $0.top.equalTo(checkLocationWeatherView.snp.bottom)
        }
        let CheckWeatherPageView = TmpCheckWeatherPageView()
        checkWeatherCellLabelView.addSubview(CheckWeatherPageView)
        CheckWeatherPageView.snp.makeConstraints {
            $0.height.equalTo(UIScreen.main.bounds.height/5)
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.top.equalToSuperview().offset(10)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.locations = viewModel.fetchLocations()
        print(locations[0].city)
    }
    
    //MARK: Style Function
    private func configureCheckWeatherBasicNavigationView() {
        checkWeatherBasicNavigationView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(47)
            $0.trailing.equalToSuperview().inset(21)
            $0.width.equalTo(106)
            $0.height.equalTo(20)
        }
        checkWeatherBasicNavigationView.locationButton.addTarget(self, action: #selector(tapLocationButton), for: .touchUpInside)
        checkWeatherCellLabelView.addButton.addTarget(self, action: #selector(tapAddIndexButton), for: .touchUpInside)
    }
    
    @objc func tapLocationButton() {
        let locationSelectionView = LocationSelectionView()
        self.navigationController?.pushViewController(locationSelectionView, animated: true)
    }
    
    @objc func tapAddIndexButton() {
        let addLivingIndexCellView = AddLivingIndexCellView()
        self.present(addLivingIndexCellView, animated: true)
    }
}
