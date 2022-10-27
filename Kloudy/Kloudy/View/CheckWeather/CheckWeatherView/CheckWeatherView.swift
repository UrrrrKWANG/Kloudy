//
//  CheckWeatherView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/10/17.
//

import UIKit
import SwiftUI
import Combine

protocol SendFirstSequenceLocationDelegate: AnyObject {
    func sendFirstSequenceLocation(_ location : Location)
}

class CheckWeatherView: UIViewController {
    let checkWeatherBasicNavigationView = CheckWeatherBasicNavigationView()
    let checkWeatherCellLabelView = CheckWeatherCellLabelView()  //생활지수 라벨
    let addLivingIndexCellView = AddLivingIndexCellView()
    let CheckWeatherPageView = TmpCheckWeatherPageView()
    
    let cityInformationModel = FetchWeatherInformation()
    let viewModel = LocationSelectionViewModel()
    var locations = [Location]()
    var firstSequenceLocation = Location()
    
    // csv 파일 데이터
    var cityInformation = [CityInformation]()
    var firstSequenceProvince = ""
    var firstSequenceCity = ""
    
    @ObservedObject var fetchedWeatherInfo = FetchWeatherInformation()
    var cancelBag = Set<AnyCancellable>()
    var weatherData: Weather = Weather(today: "", main: [], weatherIndex: [])
    let checkLocationWeatherView = CheckLocationWeatherView()
    weak var delegate: SendFirstSequenceLocationDelegate?
    
    //MARK: View LifeCycle Function
    override func viewDidLoad() {
        if UserDefaults.standard.bool(forKey: "launchedBefore") == false {
            viewModel.saveLocation(city: "1111000000", latitude: 37, longtitude: 126, sequence: 0)
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        self.cityInformation = cityInformationModel.loadCityListFromCSV()
        
        self.delegate = self.addLivingIndexCellView
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = UIColor.KColor.backgroundBlack

        self.view.addSubview(checkWeatherBasicNavigationView)
        self.configureCheckWeatherBasicNavigationView()
        // 코드 구현을 위해 BasicNavigationView 의 경우 isHidden 처리
        self.checkWeatherBasicNavigationView.isHidden = false
        
        self.view.addSubview(checkLocationWeatherView)
        checkLocationWeatherView.snp.makeConstraints {
            $0.top.equalTo(checkWeatherBasicNavigationView.snp.bottom).offset(16)
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.height.equalTo(181)
        }
        
        self.view.addSubview(checkWeatherCellLabelView)
        checkWeatherCellLabelView.snp.makeConstraints {
            $0.top.equalTo(checkLocationWeatherView.snp.bottom).offset(25)
            $0.leading.trailing.equalToSuperview().inset(21)
            $0.height.equalTo(180)
        }
        checkWeatherCellLabelView.addSubview(CheckWeatherPageView)
        CheckWeatherPageView.snp.makeConstraints {
            $0.height.width.equalToSuperview()
//            $0.height.equalTo(UIScreen.main.bounds.height/5)
//            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.top.equalToSuperview().offset(10)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // sequence 가 가장 낮은 Location 을 반환
        self.locations = viewModel.fetchLocations()
        self.firstSequenceLocation = self.locations[0]
        
        self.cityInformation.forEach { info in
            if info.code == firstSequenceLocation.city {
                self.firstSequenceProvince = info.province
                self.firstSequenceCity = info.city
            }
        }
        
        // 기상 데이터 요청
        self.fetchedWeatherInfo.$result
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                // add action
                self!.weatherData = (self?.fetchedWeatherInfo.result)!
                self!.setLocationWeatherView()
            })
            .store(in: &self.cancelBag)
        fetchedWeatherInfo.startLoad(province: self.firstSequenceProvince, city: self.firstSequenceCity)
    }
    
    //MARK: Style Function
    private func configureCheckWeatherBasicNavigationView() {
        checkWeatherBasicNavigationView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(63)
            $0.trailing.equalToSuperview().inset(21)
            $0.width.equalTo(103)
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
        self.delegate?.sendFirstSequenceLocation(self.firstSequenceLocation)
        self.present(self.addLivingIndexCellView, animated: true)
    }
}

extension CheckWeatherView {
    func setLocationWeatherView() {
        checkLocationWeatherView.locationLabel.configureLabel(text: "\(self.firstSequenceCity)", font: UIFont.KFont.appleSDNeoSemiBoldLarge, textColor: UIColor.KColor.white)
        checkLocationWeatherView.temperatureLabel.configureLabel(text: "\(Int(weatherData.main[0].currentTemperature))°", font: UIFont.KFont.lexendExtraLarge, textColor: UIColor.KColor.white)
        
        checkLocationWeatherView.maxTemperatureLabel.configureLabel(text: "최고  \(Int(weatherData.main[0].dayMaxTemperature))°",font:  UIFont.KFont.appleSDNeoMediumSmall, textColor: UIColor.KColor.gray07)
        checkLocationWeatherView.minTemperatureLabel.configureLabel(text: "최저  \(Int(weatherData.main[0].dayMinTemperature))°", font: UIFont.KFont.appleSDNeoMediumSmall, textColor: UIColor.KColor.gray07)
        let currentWeatherNum = "currentWeather_\(weatherData.main[0].currentWeather)"
        checkLocationWeatherView.weatherImage.image = UIImage(named: currentWeatherNum)
    }
}
