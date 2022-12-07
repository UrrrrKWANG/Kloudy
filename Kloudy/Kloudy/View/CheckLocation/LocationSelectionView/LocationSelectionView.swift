//
//  LocationSelectionView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/10/17.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import CoreLocation

enum TableType {
    case search
    case check
}

class LocationSelectionView: UIViewController {
    let disposeBag = DisposeBag()

    let locationSelectionNavigationView = LocationSelectionNavigationView()
    let searchBar = LocationSearchBar()
    let searchBarBackgroundView = UIView()
    let cancelSearchButton = UIButton()
    let tableView = UITableView()
    let nothingSearchedLocationLabel = UILabel()
    let magnifyingGlassImage = UIImageView()
    
    // csv 파일 데이터
    var cityData = [CityInformation]()
    let cityInformationModel = FetchWeatherInformation()
    var searchTableTypeData = [SearchingLocation]()
    var filteredSearchTableTypeData = [SearchingLocation]()
    
    // 초기 TableView Setting 값
    var tableType: TableType = .check
    var isLoadedFirst = false
    
    // Fetch CoreData Location Entity
    var locationList: [LocationData] = []
    var locationFromCoreData = [Location]()
    
    // Location 추가
    let additionalLocation = PublishSubject<Weather>()
    let deleteLocationCode = PublishSubject<String>()
    let exchangeLocationIndex = PublishSubject<[Int]>()
    
    // 지역 동의 버튼
    let authorizeButtonTapped = PublishRelay<Void>()
    
    // delegate 로 전달 받는 Weather Data
    var weatherData = [Weather]()
    
    var currentStatus = CLLocationManager().authorizationStatus

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        cityData = cityInformationModel.loadCityListFromCSV()
        initSearchTableTypeData()

        bind()
        layout()
        attribute()
        view.backgroundColor = UIColor.KColor.white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.KColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationFromCoreData = CoreDataManager.shared.fetchLocations()
        inputLocationCellData()
        
        // 위치 서비스 Authorize 변경 시 currentStatus 갱신 및 Cell Reload
        currentStatus = CLLocationManager().authorizationStatus
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationFromCoreData = []
    }
    
    // https://github.com/PLREQ/PLREQ
    func inputLocationCellData() {
        locationList = []
        for i in 0 ..< locationFromCoreData.count {
            let locationCellData = locationFromCoreData[i]
            let code = locationCellData.dataToString(forKey: "code")
            let city = locationCellData.dataToString(forKey: "city")
            let province = locationCellData.dataToString(forKey: "province")
            guard let indexArray = locationCellData.indexArray else { return }
            let location = LocationData(code: code, city: city, province: province, indexArray: indexArray)
            locationList.append(location)
        }
    }
    
    private func bind() {
        searchBar.searchFieldTapped
            .subscribe(onNext: {
                self.changeTableType($0)
            })
            .disposed(by: disposeBag)
        
        searchBar.searchFieldText
            .map { $0.lowercased() }
            .subscribe(onNext: {
                self.searchedText($0)
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        self.navigationController?.navigationBar.isHidden = true
        self.configureCancelSearchButton()
        self.configureTableView()
        self.configureNothingSearchedLocationLabel()
        self.configureMagnifyingGlassImage()
        self.configureSearchBarBackgroundView()
        self.configureDragAndDrop()
        self.configureBackButton()
    }
    
    private func layout() {
        [tableView, locationSelectionNavigationView, cancelSearchButton, searchBarBackgroundView, searchBar, nothingSearchedLocationLabel, magnifyingGlassImage].forEach { view.addSubview($0) }
        
        locationSelectionNavigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(9)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        searchBarBackgroundView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(locationSelectionNavigationView.snp.bottom).offset(16)
            $0.height.equalTo(47)
        }
        
        searchBar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(searchBarBackgroundView.snp.top).offset(-4)
        }
        
        cancelSearchButton.snp.makeConstraints {
            $0.top.equalTo(searchBarBackgroundView)
            $0.height.equalTo(47)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(12.5)
            $0.top.equalTo(searchBarBackgroundView.snp.bottom).offset(10)
            $0.bottom.equalToSuperview()
        }
        
        nothingSearchedLocationLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(31)
            $0.height.equalTo(22)
            $0.top.equalTo(searchBar.snp.bottom).offset(20)
        }
        
        magnifyingGlassImage.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.top.equalTo(searchBarBackgroundView.snp.top).offset(13)
            $0.trailing.equalTo(searchBar.snp.trailing).offset(-17)
        }
    }
    
    // bind funcation
    private func changeTableType(_ isSearching: Bool) {
        if isSearching {
            self.tableType = .search
        } else {
            self.tableType = .check
            searchBar.text = ""
            searchBar.endEditing(true)
            nothingSearchedLocationLabel.isHidden = true
            filteredSearchTableTypeData = [SearchingLocation]()
            locationFromCoreData = CoreDataManager.shared.fetchLocations()
        }
        changeCancelButtonState(isSearching)
        tableView.reloadData()
    }
    
    private func changeCancelButtonState(_ isSearching: Bool) {
        if isSearching {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
                self.magnifyingGlassImage.isHidden = true
                self.cancelSearchButton.isHidden = false
                self.searchBarBackgroundView.snp.remakeConstraints {
                    $0.leading.equalToSuperview().inset(20)
                    $0.top.equalTo(self.locationSelectionNavigationView.snp.bottom).offset(16)
                    $0.height.equalTo(47)
                    $0.trailing.equalTo(self.cancelSearchButton.snp.leading).offset(-12)
                }
                self.searchBar.snp.remakeConstraints {
                    $0.leading.trailing.equalTo(self.searchBarBackgroundView)
                    $0.top.equalTo(self.searchBarBackgroundView.snp.top).offset(-4)
                }
                self.searchBar.superview?.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
                self.magnifyingGlassImage.isHidden = false
                self.cancelSearchButton.isHidden = true
                if self.isLoadedFirst {
                    self.searchBarBackgroundView.snp.remakeConstraints {
                        $0.leading.trailing.equalToSuperview().inset(20)
                        $0.top.equalTo(self.locationSelectionNavigationView.snp.bottom).offset(16)
                        $0.height.equalTo(47)
                    }
                    self.searchBar.snp.remakeConstraints {
                        $0.leading.trailing.equalToSuperview().inset(20)
                        $0.top.equalTo(self.searchBarBackgroundView.snp.top).offset(-4)
                    }
                }
                self.isLoadedFirst = true
                self.searchBar.superview?.layoutIfNeeded()
            }
        }
    }
    
    private func searchedText(_ text: String) {
        if text == "" {
            nothingSearchedLocationLabel.isHidden = true
            self.filteredSearchTableTypeData = self.searchTableTypeData.filter({ $0.locationString.localizedStandardContains(text)})
        } else {
            nothingSearchedLocationLabel.isHidden = true
            self.filteredSearchTableTypeData = self.searchTableTypeData.filter({ $0.locationString.localizedStandardContains(text)})
            if filteredSearchTableTypeData.count == 0 {
                nothingSearchedLocationLabel.isHidden = false
            }
        }
        self.tableView.reloadData()
    }
    
    private func initSearchTableTypeData() {
        cityData.forEach { info in
            var temporalString = String()
            temporalString = "\(info.province) " + "\(info.city)"
            self.searchTableTypeData.append(SearchingLocation(locationString: temporalString, locationCode: info.code))
        }
    }
    
    //MARK: attribute function
    private func configureCancelSearchButton() {
        cancelSearchButton.setTitle("취소".localized, for: .normal)
        cancelSearchButton.setTitleColor(UIColor.KColor.gray01, for: .normal)
        cancelSearchButton.titleLabel?.sizeToFit()
        cancelSearchButton.titleLabel?.font = UIFont.KFont.appleSDNeoRegularLarge
        cancelSearchButton.addTarget(self, action: #selector(endSearching), for: .touchUpInside)
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.KColor.clear
        tableView.clipsToBounds = false
        tableView.register(SearchLocationCell.self, forCellReuseIdentifier: "SearchLocationCell")
        tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: "locationCell")
        tableView.register(CurrentLocationTableViewCell.self, forCellReuseIdentifier: "currentCell")
    }
    
    private func configureNothingSearchedLocationLabel() {
        nothingSearchedLocationLabel.text = "검색된 지역이 없습니다.".localized
        nothingSearchedLocationLabel.font = UIFont.KFont.appleSDNeoRegularLarge
        nothingSearchedLocationLabel.textColor = UIColor.KColor.gray01
        nothingSearchedLocationLabel.sizeToFit()
        nothingSearchedLocationLabel.isHidden = true
    }
    
    private func configureMagnifyingGlassImage() {
        magnifyingGlassImage.image = UIImage(named: "magnifyingGlass")
        magnifyingGlassImage.contentMode = .scaleAspectFit
    }
    
    private func configureSearchBarBackgroundView() {
        searchBarBackgroundView.layer.cornerRadius = 15
        searchBarBackgroundView.backgroundColor = UIColor.KColor.gray04
    }
    
    // drag, drop delegate 설정
    private func configureDragAndDrop() {
        switch tableType {
        case .search:
            return
        case .check:
            tableView.dragInteractionEnabled = true
            tableView.dragDelegate = self
            tableView.dropDelegate = self
        }
    }
     
    private func configureBackButton() {
        locationSelectionNavigationView.backButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
    }
    
    @objc func endSearching() {
        searchBar.endEditing(true)
    }
    
    @objc func tapBackButton() {
        changeTableType(false)
        self.navigationController?.popViewController(animated: true)
    }
}

extension LocationSelectionView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableType {
        case .search:
            return filteredSearchTableTypeData.count
        case .check:
            if self.currentStatus == .authorizedAlways || self.currentStatus == .authorizedWhenInUse {
                return weatherData.count
            } else {
                return weatherData.count + 1
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableType {
        case .search:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchLocationCell", for: indexPath) as? SearchLocationCell else { return UITableViewCell() }
            let searchingLocation = filteredSearchTableTypeData[indexPath.row]
            cell.locationLabel.text = searchingLocation.locationString
            return cell
        case .check:
            
            if indexPath.row == 0 {
                if (currentStatus == .denied || currentStatus == .notDetermined || currentStatus == .restricted)
                {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "currentCell", for: indexPath) as? CurrentLocationTableViewCell else {
                        return UITableViewCell() }
                    cell.locationNameLabel.text = "현재 위치".localized
                    cell.agreeButton.rx.tap
                        .asObservable()
                        .bind(to: authorizeButtonTapped)
                        .disposed(by: disposeBag)
                    cell.backgroundColor = UIColor.KColor.clear
                    cell.selectionStyle = .none
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as? LocationTableViewCell else {
                        return UITableViewCell()
                    }
                    cell.locationNameLabel.text = "현재 위치".localized
                    cell.temperatureLabel.text = String(Int(weatherData[indexPath.row].localWeather[0].minMaxTemperature()[0])) + "°"
                    cell.diurnalTemperatureLabel.text = "\(Int(weatherData[indexPath.row].localWeather[0].minMaxTemperature()[2]))° | \(Int(weatherData[indexPath.row].localWeather[0].minMaxTemperature()[1]))°"
                    cell.backgroundColor = UIColor.KColor.clear
                    cell.selectionStyle = .none
                    return cell
                }
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as? LocationTableViewCell else {
                    return UITableViewCell()
                }
                cell.backgroundColor = UIColor.KColor.clear
                cell.selectionStyle = .none
                
                if (currentStatus == .denied || currentStatus == .notDetermined || currentStatus == .restricted) {
                    cell.locationNameLabel.text = weatherData[indexPath.row - 1].localWeather[0].localName.localized
                    cell.temperatureLabel.text = String(Int(weatherData[indexPath.row - 1].localWeather[0].minMaxTemperature()[0])) + "°"
                    cell.diurnalTemperatureLabel.text = "\(Int(weatherData[indexPath.row - 1].localWeather[0].minMaxTemperature()[2]))° | \(Int(weatherData[indexPath.row - 1].localWeather[0].minMaxTemperature()[1]))°"
                } else {
                    cell.locationNameLabel.text = weatherData[indexPath.row].localWeather[0].localName.localized
                    cell.temperatureLabel.text = String(Int(weatherData[indexPath.row].localWeather[0].minMaxTemperature()[0])) + "°"
                    cell.diurnalTemperatureLabel.text = "\(Int(weatherData[indexPath.row].localWeather[0].minMaxTemperature()[2]))° | \(Int(weatherData[indexPath.row - 1].localWeather[0].minMaxTemperature()[1]))°"
                }
                
                return cell
            }
        }
    }
    
    // MARK: 스와이프해서 삭제하기
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch tableType {
        case .search:
            return false
        case .check:
            return true
        }
    }
        
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        switch tableType {
        case .search:
            return nil
        case .check:
            if indexPath.row != 0 {
                if self.currentStatus == .authorizedAlways || self.currentStatus == .authorizedWhenInUse {
                    let configuration = UISwipeActionsConfiguration(actions: [deleteLocation(indexPath: indexPath)])
                    return configuration
                } else {
                    if indexPath.row != 1 {
                        let configuration = UISwipeActionsConfiguration(actions: [deleteLocation(indexPath: indexPath)])
                        return configuration
                    } else {
                        return nil
                    }
                }
            } else {
                return nil
            }
        }
    }
    
    private func deleteLocation(indexPath: IndexPath) -> UIContextualAction {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, completionHandler in
            
            CoreDataManager.shared.deleteLocation(location: self.locationFromCoreData[indexPath.row - 1])
            self.locationFromCoreData = CoreDataManager.shared.fetchLocations()
            
            self.locationList.remove(at: indexPath.row - 1)
            
            if self.currentStatus == .authorizedAlways || self.currentStatus == .authorizedWhenInUse {
                self.deleteLocationCode.onNext(self.weatherData[indexPath.row].localWeather[0].localCode)
                self.weatherData.remove(at: indexPath.row)
            } else {
                self.deleteLocationCode.onNext(self.weatherData[indexPath.row - 1].localWeather[0].localCode)
                self.weatherData.remove(at: indexPath.row - 1)
            }
            
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }
        
        deleteAction.image = UIGraphicsImageRenderer(size: CGSize(width: 50, height: 93)).image { _ in
            UIImage(named: "deleteButton")?.draw(in: CGRect(x: 0, y: 3.8, width: 50, height: 86))
        }

        deleteAction.backgroundColor = .systemBackground
        
        return deleteAction
    }
}

extension LocationSelectionView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableType {
        case .search:
            let searchingLocation = filteredSearchTableTypeData[indexPath.row]
            self.cityData.forEach { information in
                if information.code == searchingLocation.locationCode {
                    if CoreDataManager.shared.checkLocationIsSame(locationCode: searchingLocation.locationCode) {
                        CoreDataManager.shared.saveLocation(code: information.code, city: information.city, province: information.province, sequence: CoreDataManager.shared.countLocations(), indexArray: Storage.defaultIndexArray)
                        self.locationList.append(LocationData(code: information.code, city: information.city, province: information.province, indexArray: Storage.defaultIndexArray))
                        
                        self.changeTableType(false)
                        self.weatherData.append(FetchWeatherInformation().dummyData)
                        CityWeatherNetwork().fetchCityWeather(code: information.code)
                            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .default))
                            .subscribe { event in
                                switch event {
                                case .success(let data):
                                    self.additionalLocation.onNext(data)
                                    DispatchQueue.main.async {
                                        self.weatherData[self.weatherData.count - 1] = data
                                        self.tableView.reloadData()
                                    }
                                case .failure(let error):
                                    print("Error: ", error)
                                }
                            }
                            .disposed(by: disposeBag)
                        
                    } else {
                        self.isSameLocationAlert()
                    }
                }
            }
        case .check:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableType {
        case .search:
            return 50
        case .check:
            return 100
        }
    }
    
    // Select already Saved Location
    private func isSameLocationAlert() {
        let alert = UIAlertController(title: "이미 동일한 지역을 추가했어요.".localized, message: "다른 지역을 추가해주세요.".localized, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인".localized, style: .default) { _ in
            self.dismiss(animated: true)
        }
        alert.addAction(confirm)
        self.present(alert, animated: true)
    }
}

// MARK: 롱탭으로 셀 위치 변경하기

extension LocationSelectionView: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
}

extension LocationSelectionView: UITableViewDropDelegate {
        
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        switch tableType {
        case .search:
            return false
        case .check:
            return true
        }
    }
    
    // 첫 번째 셀 옮기지 못하게 하는 메서드
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if sourceIndexPath.row == 0 {
            return sourceIndexPath
        }
        return proposedDestinationIndexPath
    }
    
    // 셀 위치 변경 함수
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard sourceIndexPath.row != 0 else { return }
        
        let itemMove = locationList[sourceIndexPath.row - 1] //Get the item that we just moved
        locationList.remove(at: sourceIndexPath.row - 1) // Remove the item from the array
        locationList.insert(itemMove, at: destinationIndexPath.row - 1) //Re-insert back into array
        CoreDataManager.shared.getLocationSequence(locationList: locationList)
        
        if self.currentStatus == .authorizedAlways || self.currentStatus == .authorizedWhenInUse {
            let itemMove2 = weatherData[sourceIndexPath.row]
            weatherData.remove(at: sourceIndexPath.row)
            weatherData.insert(itemMove2, at: destinationIndexPath.row)
            exchangeLocationIndex.onNext([sourceIndexPath.row, destinationIndexPath.row])
        } else {
            let itemMove2 = weatherData[sourceIndexPath.row - 1]
            weatherData.remove(at: sourceIndexPath.row - 1)
            weatherData.insert(itemMove2, at: destinationIndexPath.row - 1)
            exchangeLocationIndex.onNext([sourceIndexPath.row - 1, destinationIndexPath.row - 1])
        }
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if session.localDragSession != nil {
            if destinationIndexPath?.row == 0 {
                return UITableViewDropProposal(operation: .move, intent: .unspecified)
            }
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
    }
}

extension LocationSelectionView: LocationSelectionDelegate {
    func sendWeatherData(weatherData: [Weather]) {
        self.weatherData = weatherData
    }
}
