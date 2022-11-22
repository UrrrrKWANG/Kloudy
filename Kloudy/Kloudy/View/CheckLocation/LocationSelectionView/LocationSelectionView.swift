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
    
    // delegate 로 전달 받는 Weather Data
    var weatherData = [Weather]()

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
    }
    
    // https://github.com/PLREQ/PLREQ
    func inputLocationCellData() {
        locationList = []
        for i in 0 ..< locationFromCoreData.count {
            let locationCellData = locationFromCoreData[i]
            let code = locationCellData.dataToString(forKey: "code")
            let city = locationCellData.dataToString(forKey: "city")
            let province = locationCellData.dataToString(forKey: "province")
            let location = LocationData(code: code, city: city, province: province)
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
//        tableView.reloadData()
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
        cancelSearchButton.setTitle("취소", for: .normal)
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
    }
    
    private func configureNothingSearchedLocationLabel() {
        nothingSearchedLocationLabel.text = "검색된 지역이 없습니다."
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
        self.navigationController?.popViewController(animated: true)
    }
}

extension LocationSelectionView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableType {
        case .search:
            return filteredSearchTableTypeData.count
        case .check:
            return weatherData.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableType {
        case .search:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchLocationCell", for: indexPath) as? SearchLocationCell else { return UITableViewCell() }
            // snapkit remakeConstraint 처리 유무 체크 필요
            let searchingLocation = filteredSearchTableTypeData[indexPath.row]
            cell.locationLabel.text = searchingLocation.locationString
            return cell
        case .check:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as? LocationTableViewCell else {
                return UITableViewCell()
            }
            cell.backgroundColor = UIColor.KColor.clear
            cell.selectionStyle = .none
            // 추후에 코드 사용할 예정
//            if indexPath.row == 0 {
//                cell.locationNameLabel.text = "현재 위치"
//            } else {
//                cell.locationNameLabel.text = locationList[indexPath.row - 1].city
//            }
            cell.locationNameLabel.text = weatherData[indexPath.row].localWeather[0].localName
            cell.temperatureLabel.text = String(Int(weatherData[indexPath.row].localWeather[0].hourlyWeather[2].temperature)) + "°"
            cell.diurnalTemperatureLabel.text = "\(Int(weatherData[indexPath.row].localWeather[0].main[0].dayMinTemperature))° | \(Int(weatherData[indexPath.row].localWeather[0].main[0].dayMaxTemperature))°"
            
            return cell
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
                let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, completionHandler in
                    self.deleteLocationCode.onNext(self.locationFromCoreData[indexPath.row].code ?? "")
                    CoreDataManager.shared.locationDelete(location: self.locationFromCoreData[indexPath.row])
                    self.weatherData.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    completionHandler(true)
                }
                
                deleteAction.image = UIGraphicsImageRenderer(size: CGSize(width: 50, height: 93)).image { _ in
                    UIImage(named: "deleteButton")?.draw(in: CGRect(x: 0, y: 3.8, width: 50, height: 86))
                }

                deleteAction.backgroundColor = .systemBackground
                let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
                return configuration
            } else {
                return nil
            }
        }
    }
}

extension LocationSelectionView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: 전날과 온도를 비교하는 지수 추가 이후 주석 사용
//        let defaultIndexArray =  ["rain", "mask", "laundry", "car", "outer", "temperatureGap"]
        let defaultIndexArray =  ["rain", "mask", "laundry", "car", "outer"]
        switch tableType {
        case .search:
            let searchingLocation = filteredSearchTableTypeData[indexPath.row]
            self.cityData.forEach { information in
                if information.code == searchingLocation.locationCode {
                    if CoreDataManager.shared.checkLocationIsSame(locationCode: searchingLocation.locationCode) {
                        CoreDataManager.shared.saveLocation(code: information.code, city: information.city, province: information.province, sequence: CoreDataManager.shared.countLocations(), indexArray: defaultIndexArray)
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
        let alert = UIAlertController(title: "이미 동일한 지역을 추가했어요.", message: "다른 지역을 추가해주세요.", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default) { _ in
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
                
        // +1로 해줘야할듯
        let itemMove = locationList[sourceIndexPath.row] //Get the item that we just moved
        locationList.remove(at: sourceIndexPath.row) // Remove the item from the array
        locationList.insert(itemMove, at: destinationIndexPath.row) //Re-insert back into array
        CoreDataManager.shared.getLocationSequence(locationList: locationList)
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
