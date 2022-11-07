//
//  CheckWeatherView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/10/17.
//

import UIKit
import SwiftUI
import Combine
import SnapKit

protocol SendFirstSequenceLocationDelegate: AnyObject {
    func sendFirstSequenceLocation(_ location : Location)
}

class CheckWeatherView: UIViewController {
    let checkWeatherBasicNavigationView = CheckWeatherBasicNavigationView()
    let locationView = UIView()
    let weatherIndexView = UIView()
    let detailWeatherView = UIView()
    
    
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
    weak var delegate: SendFirstSequenceLocationDelegate?
    
    //MARK: View LifeCycle Function
    override func viewDidLoad() {
        //        if UserDefaults.standard.bool(forKey: "launchedBefore") == false {
        //            viewModel.saveLocation(city: "1111000000", latitude: 37, longtitude: 126, sequence: 0)
        //            UserDefaults.standard.set(true, forKey: "launchedBefore")
        //        }
        
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        self.view.addSubview(checkWeatherBasicNavigationView)
        self.view.addSubview(locationView)
        self.view.addSubview(weatherIndexView)
        self.view.addSubview(detailWeatherView)
        self.configureCheckWeatherBasicNavigationView()
        self.configureLocationView()
        self.configureWeatherIndexView()
        self.configureDetailWeatherView()
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
        // sequence 가 가장 낮은 Location 을 반환
        //        self.locations = viewModel.fetchLocations()
        //        self.firstSequenceLocation = self.locations[0]
        //
        //        self.cityInformation.forEach { info in
        //            if info.code == firstSequenceLocation.city {
        //                self.firstSequenceProvince = info.province
        //                self.firstSequenceCity = info.city
        //            }
        //        }
        //
        //        // 기상 데이터 요청
        //        self.fetchedWeatherInfo.$result
        //            .receive(on: DispatchQueue.main)
        //            .sink(receiveValue: { [weak self] _ in
        //                // add action
        //                self!.weatherData = (self?.fetchedWeatherInfo.result)!
        //                self!.setLocationWeatherView()
        //            })
        //            .store(in: &self.cancelBag)
        //        fetchedWeatherInfo.startLoad(province: self.firstSequenceProvince, city: self.firstSequenceCity)
//    }
    
    //MARK: Style Function
    private func configureCheckWeatherBasicNavigationView() {
        checkWeatherBasicNavigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
            $0.trailing.equalToSuperview().inset(21)
            $0.width.equalTo(103)
            $0.height.equalTo(20)
        }
//        checkWeatherBasicNavigationView.locationButton.addTarget(self, action: #selector(tapLocationButton), for: .touchUpInside)
        //        checkWeatherCellLabelView.addButton.addTarget(self, action: #selector(tapAddIndexButton), for: .touchUpInside)
    }
    
    //    @objc func tapLocationButton() {
    //        let locationSelectionView = LocationSelectionView()
    //        self.navigationController?.pushViewController(locationSelectionView, animated: true)
    //    }
    //
    //    @objc func tapAddIndexButton() {
    //        self.delegate?.sendFirstSequenceLocation(self.firstSequenceLocation)
    //        self.present(self.addLivingIndexCellView, animated: true)
    //    }
    func configureLocationView() {
        locationView.backgroundColor = .red
        locationView.snp.makeConstraints {
            $0.top.equalTo(checkWeatherBasicNavigationView.snp.bottom).offset(28)
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(203)
            $0.height.equalTo(150)
        }
    }
    func configureWeatherIndexView() {
        weatherIndexView.backgroundColor = .blue
        weatherIndexView.snp.makeConstraints {
            $0.top.equalTo(locationView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(350)
            $0.height.equalTo(360)
        }
    }
    func configureDetailWeatherView() {
        detailWeatherView.backgroundColor = .green
        detailWeatherView.snp.makeConstraints {
            $0.top.equalTo(weatherIndexView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(350)
            $0.height.equalTo(43)
        }
    }
    
}
