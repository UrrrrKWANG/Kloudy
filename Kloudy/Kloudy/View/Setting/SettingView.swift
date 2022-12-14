//
//  SettingView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/11/07.
//

import UIKit
import RxSwift
import SafariServices
import SnapKit

class SettingView: UIViewController {
    let settingNavigationView = SettingNavigationView()
    let tableView = UITableView()
    let disposeBag = DisposeBag()
    let changeAuthorityTrue = PublishSubject<Weather>()
    let changeAuthorityFalse = PublishSubject<Bool>()
    let blogUrl = NSURL(string: "https://spiffy-mum-6af.notion.site/Klody-open-source-license-c0c62e1198974fad995fed9fcd6f7504")
    lazy var blogSafariView: SFSafariViewController = SFSafariViewController(url: blogUrl! as URL)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.KColor.white
        layout()
        attribute()
    }
    
    private func layout() {
        [tableView, settingNavigationView].forEach { self.view.addSubview($0) }
        
        settingNavigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(9)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(settingNavigationView.snp.bottom).offset(10)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func attribute() {
        self.navigationController?.navigationBar.isHidden = true
        self.configureTableView()
        self.configureBackButton()
    }
    
    private func configureBackButton() {
        settingNavigationView.backButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.KColor.white
        tableView.register(SettingLicenseCellView.self, forCellReuseIdentifier: "SettingLicenseCellView")
        tableView.register(SettingVersionCellView.self, forCellReuseIdentifier: "SettingVersionCellView")
        tableView.register(SettingLocationAllowCellView.self, forCellReuseIdentifier: "SettingLocationAllowCellView")
    }
    
    @objc func tapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SettingView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var resultCell = UITableViewCell()
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingLicenseCellView", for: indexPath) as? SettingLicenseCellView else { return UITableViewCell() }
            cell.licenseLabel.text = "라이센스".localized
            resultCell = cell
            
            let gesture = UITapGestureRecognizer()
            cell.addGestureRecognizer(gesture)
            gesture.rx.event.bind {_ in
                self.present(self.blogSafariView, animated: true, completion: nil)
            }.disposed(by: disposeBag)
        }
        
        else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingVersionCellView", for: indexPath) as? SettingVersionCellView else { return UITableViewCell() }
            cell.versionTextLabel.text = "버전정보".localized
            cell.versionNumberLabel.text = "1.0.5"
            cell.versionCheckLabel.text = "".localized
            cell.selectionStyle = .none
            resultCell = cell
        }
        
        else if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingLocationAllowCellView", for: indexPath) as? SettingLocationAllowCellView else { return UITableViewCell() }
            cell.locationAllowTextLabel.text = "위치 서비스 약관 동의".localized
            cell.selectionStyle = .none
            cell.layer.addBorder([.top], color: UIColor.KColor.gray04, width: 1.0)
            cell.changeAuthorityCell
                .subscribe(onNext: {
                    if $0 {
                        self.fetchCurrentLocationWeatherData()
                    } else {
                        self.changeAuthorityFalse.onNext(true)
                    }
                })
                .disposed(by: disposeBag)
            
            resultCell = cell
        }
        
        return resultCell
    }
    
    private func fetchCurrentLocationWeatherData() {
        LocationManager.shared.requestNowLocationInfoCity(completion: { (cityInfo) in
            guard let cityInfo = cityInfo else { return }
            let (province, city) = (cityInfo[0], cityInfo[1])
            let nowLocation = FetchWeatherInformation.shared.getLocationInfo(province: province, city: city)
            guard let nowLocation = nowLocation else { return }
            CityWeatherNetwork().fetchCityWeather(code: nowLocation.code)
                .subscribe { event in
                    switch event {
                    case .success(let data):
                        self.changeAuthorityTrue.onNext(data)
                    case .failure(let error):
                        print("Error: ", error)
                    }
                }
                .disposed(by: self.disposeBag)
        })
    }
    
//    private func fetchCurrentLocationWeatherData() {
//        let XY = LocationManager.shared.requestNowLocationInfo()
//        let nowLocation = FetchWeatherInformation.shared.getLocationInfoByXY(x: XY[0], y: XY[1])
//        guard let nowLocation = nowLocation else { return }
//
//        CityWeatherNetwork().fetchCityWeather(code: nowLocation.code)
//            .subscribe { event in
//                switch event {
//                case .success(let data):
//                    self.changeAuthorityTrue.onNext(data)
//                case .failure(let error):
//                    print("Error: ", error)
//                }
//            }
//            .disposed(by: disposeBag)
//    }
}

extension SettingView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let settingLicenseView = SettingLicenseView()
            self.navigationController?.pushViewController(settingLicenseView, animated: true)
        }
    }
}

extension CALayer {
    
}
