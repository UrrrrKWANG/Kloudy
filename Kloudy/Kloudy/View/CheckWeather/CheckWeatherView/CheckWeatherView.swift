//
//  CheckWeatherView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/10/17.
//

import UIKit
import SwiftUI
import Combine

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
        
    @ObservedObject var fetchedWeatherInfo = FetchWeatherInformation()
    var cancelBag = Set<AnyCancellable>()
    var weatherData: Weather = Weather(today: "", main: [], weatherIndex: [])
    let checkLocationWeatherView = CheckLocationWeatherView()
    weak var delegate: LocationDataProtocol?
    
    //MARK: View LifeCycle Function
    override func viewDidLoad() {
        self.delegate = self.addLivingIndexCellView
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = UIColor.KColor.backgroundBlack
        
        self.view.addSubview(checkWeatherBasicNavigationView)
        self.configureCheckWeatherBasicNavigationView()
        // 코드 구현을 위해 BasicNavigationView 의 경우 isHidden 처리
        self.checkWeatherBasicNavigationView.isHidden = false
        
        self.fetchedWeatherInfo.$result
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                // add action
                self!.weatherData = (self?.fetchedWeatherInfo.result)!
                self!.setLocationWeatherView()
            })
            .store(in: &self.cancelBag)
        fetchedWeatherInfo.startLoad(province: "경상북도", city: "포항시")
        
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
        self.delegate?.locationData("asdf")
        self.present(self.addLivingIndexCellView, animated: true)
    }
}

extension CheckWeatherView: LocationDataProtocol {
    func locationData(_ location : String) {
    }
    
    func setLocationWeatherView() {
        checkLocationWeatherView.locationLabel.configureLabel(text: "포항시", font: UIFont.KFont.appleSDNeoSemiBoldLarge, textColor: UIColor.KColor.white)
        checkLocationWeatherView.temperatureLabel.configureLabel(text: "\(Int(weatherData.main[0].currentTemperature))°", font: UIFont.KFont.lexendExtraLarge, textColor: UIColor.KColor.white)
        
        checkLocationWeatherView.maxTemperatureLabel.configureLabel(text: "최고  \(Int(weatherData.main[0].dayMaxTemperature))°",font:  UIFont.KFont.appleSDNeoMediumSmall, textColor: UIColor.KColor.gray07)
        checkLocationWeatherView.minTemperatureLabel.configureLabel(text: "최저  \(Int(weatherData.main[0].dayMinTemperature))°", font: UIFont.KFont.appleSDNeoMediumSmall, textColor: UIColor.KColor.gray07)
        switch weatherData.main[0].currentWeather {
        case 0:
            checkLocationWeatherView.weatherImage.image = UIImage(named: "sunny")
        case 1:
            checkLocationWeatherView.weatherImage.image = UIImage(named: "rainy")
        case 2:
            checkLocationWeatherView.weatherImage.image = UIImage(named: "snowRain")
        case 3:
            checkLocationWeatherView.weatherImage.image = UIImage(named: "cloudy")
        case 4:
            checkLocationWeatherView.weatherImage.image = UIImage(named: "cloudySun")
        case 5:
            checkLocationWeatherView.weatherImage.image = UIImage(named: "snowy")
        default:
            checkLocationWeatherView.weatherImage.image = UIImage(named: "sunny")
        }
    }
}
