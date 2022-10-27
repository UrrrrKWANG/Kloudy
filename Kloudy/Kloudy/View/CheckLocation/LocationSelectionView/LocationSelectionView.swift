//
//  LocationSelectionView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/10/17.
//

import UIKit
import SnapKit
import SwiftUI
import Combine

// https://youtu.be/I7M9V579AaE

class LocationSelectionView: UIViewController {
    
    let collectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        
        return cv
    }()
    
    // 롱탭의 시작점과 끝점이 같을 경우에만 롱탭제스쳐를 활성화하기 위하여 설정한 변수
    var currentLongPressedCell: LocationSelectionCollectionViewCell?
    
    let locationSelectionNavigationView = LocationSelectionNavigationView()
    let searchBar = UISearchBar()
    let cancelSearchButton = UIButton()
    let tableView = UITableView()
    let noCityInformationLabel = UILabel()
    
    let cityInformationModel = FetchWeatherInformation()
    let viewModel = LocationSelectionViewModel()
    
    // csv 파일 데이터
    var cityInformation = [CityInformation]()
    
    // Fetch CoreData Location Entity
    var locationList = [Location]()
    
    var locationTableViewModel = [SearchingLocation]()
    var filteredLocationModel = [SearchingLocation]()
    var cellWeatherData: [LocationCellModel] = [LocationCellModel]()
    var weatherInfoArrary: [LocationCellModel] = []
    @ObservedObject var fetchedWeatherInfo = FetchWeatherInformation()
    var cancelBag = Set<AnyCancellable>()
    var isCheck: Bool = false
    //MARK: View Lifecycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.KColor.black
        collectionView.refreshControl = refreshControl
        self.navigationController?.navigationBar.isHidden = true
        self.locationSelectionNavigationView.isHidden = false
        
        [locationSelectionNavigationView, searchBar, cancelSearchButton, tableView, noCityInformationLabel, collectionView].forEach { self.view.addSubview($0) }
        
        configureLocationSelectionNavigationView()
        configureCancelSearchButton()
        configureSearchBar()
        configureTableView()
        configureNoCityInformationLabel()
        configureCollecionView()
        
        self.cityInformation = cityInformationModel.loadCityListFromCSV()
        self.initializeLocationTableViewModel()
        
        // 롱탭제스쳐 활성화 함수
        setUpLongGestureRecognizerOnCollection()
    }
    
    @objc func tapBackButton() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.isHidden = true
        cancelSearchButton.isHidden = true
        noCityInformationLabel.isHidden = true
        
        locationList = viewModel.fetchLocations()
        collectionView.reloadData()
        self.fetchedWeatherInfo.$result
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                if self!.isCheck {
                    self?.weatherInfoArrary.append(LocationCellModel(cellLocationName: "", cellTemperature: Int((self?.fetchedWeatherInfo.result.main[0].currentTemperature)!), cellWeatherImageInt: 0, cellDiurnalTemperature: [Int((self?.fetchedWeatherInfo.result.main[0].dayMaxTemperature)!),Int((self?.fetchedWeatherInfo.result.main[0].dayMinTemperature)!)]))
                }
                self?.isCheck = true
                self?.collectionView.reloadData()
            })
            .store(in: &self.cancelBag)
        
        locationList.forEach { location in
            var cellProvince: String = String()
            var cellCity: String = String()
            
            cityInformation.forEach { info in
                if info.code == location.city {
                    cellProvince = info.province
                    cellCity = info.city
                }
            }
            fetchedWeatherInfo.startLoad(province: cellProvince, city: cellCity)
        }
        
    }
    
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshReloadCollectView), for: .valueChanged)
        
        return refreshControl
    }()
    
    @objc func refreshReloadCollectView() {
        
        locationList = viewModel.fetchLocations()
        self.weatherInfoArrary.removeAll()
        self.collectionView.reloadData()

        locationList.forEach { location in
            var cellProvince: String = String()
            var cellCity: String = String()
            
            cityInformation.forEach { info in
                if info.code == location.city {
                    cellProvince = info.province
                    cellCity = info.city
                }
            }
            fetchedWeatherInfo.startLoad(province: cellProvince, city: cellCity)
        }
        self.refreshControl.endRefreshing()
    }
    
    
    //MARK: Configure Function
    private func configureCollecionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.KColor.black
        collectionView.register(LocationSelectionCollectionViewCell.self, forCellWithReuseIdentifier: LocationSelectionCollectionViewCell.cellID)
        
        // 스냅킷 사용하여 오토레이아웃 간략화하였습니다.
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureLocationSelectionNavigationView() {
        locationSelectionNavigationView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(47)
            $0.leading.trailing.equalToSuperview().inset(21)
            $0.width.equalTo(106)
            $0.height.equalTo(20)
        }
        locationSelectionNavigationView.backButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
    }
    
    private func configureSearchBar() {
        searchBar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.top.equalTo(cancelSearchButton.snp.top)
            $0.height.equalTo(47)
        }
        searchBar.delegate = self
        searchBar.placeholder = "지역을 검색해 보세요"
        searchBar.setImage(UIImage(), for: .search, state: .normal)
        searchBar.searchBarStyle = .prominent
        searchBar.backgroundImage = UIImage()
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor.KColor.gray02
            textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.KColor.gray06, NSAttributedString.Key.font : UIFont.KFont.appleSDNeoRegularLarge])
            textField.textColor = UIColor.KColor.white
        }
    }
    
    private func configureCancelSearchButton() {
        cancelSearchButton.setTitle("취소", for: .normal)
        cancelSearchButton.setTitleColor(UIColor.KColor.gray06, for: .normal)
        cancelSearchButton.titleLabel?.sizeToFit()
        cancelSearchButton.titleLabel?.font = UIFont.KFont.appleSDNeoRegularLarge
        cancelSearchButton.snp.makeConstraints {
            $0.top.equalTo(locationSelectionNavigationView.snp.bottom).offset(26)
            $0.height.equalTo(47)
            $0.trailing.equalToSuperview().inset(21)
        }
        cancelSearchButton.isHidden = true
        cancelSearchButton.addTarget(self, action: #selector(tapCancelSearchButton), for: .touchUpInside)
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LocationTableCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.separatorStyle = .none
        
        tableView.backgroundColor = UIColor.KColor.black
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(21)
            $0.top.equalTo(searchBar.snp.bottom).offset(10)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func configureNoCityInformationLabel() {
        noCityInformationLabel.text = "검색된 지역이 없습니다."
        noCityInformationLabel.font = UIFont.KFont.appleSDNeoRegularLarge
        noCityInformationLabel.textColor = UIColor.KColor.gray06
        noCityInformationLabel.sizeToFit()
        
        noCityInformationLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(31)
            $0.height.equalTo(22)
            $0.top.equalTo(searchBar.snp.bottom).offset(20)
        }
    }
    
    @objc func tapCancelSearchButton() {
        self.endSearchLocation()
    }
    
    private func initializeLocationTableViewModel() {
        cityInformation.forEach { info in
            var temporalString = String()
            temporalString = "\(info.province) " + "\(info.city)"
            self.locationTableViewModel.append(SearchingLocation(locationString: temporalString, locationCode: info.code))
        }
    }
    
    private func endSearchLocation() {
        searchBar.endEditing(true)
        searchBar.text = ""
        filteredLocationModel = [SearchingLocation]()
        tableView.isHidden = true
        tableView.reloadData()
        collectionView.isHidden = false
        noCityInformationLabel.isHidden = true
        locationList = viewModel.fetchLocations()
        collectionView.reloadData()
    }
}

// MARK: UICollectionViewDataSource 익스텐션
extension LocationSelectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locationList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationSelectionCollectionViewCell.cellID, for: indexPath) as! LocationSelectionCollectionViewCell
        let location = locationList[indexPath.row]
        var cellCity: String = String()
        
        //TODO: 메인 화면에서 delegate 를 통해 날씨 정보를 전달해서 Cell 에 표현
        cityInformation.forEach { info in
            if info.code == location.city {
                cellCity = info.city
            }
        }
        cell.locationNameLabel.configureLabel(text: cellCity, font: UIFont.KFont.appleSDNeoBoldMedium, textColor: UIColor.KColor.white)
        if indexPath.row < weatherInfoArrary.count {
            cell.diurnalTemperatureLabel.configureLabel(text: "\(weatherInfoArrary[indexPath.row].cellDiurnalTemperature[0])° | \(weatherInfoArrary[indexPath.row].cellDiurnalTemperature[1])°", font: UIFont.KFont.lexendMini, textColor: UIColor.KColor.gray05, attributeString: ["|"], attributeColor: [UIColor.KColor.gray03])
            cell.temperatureLabel.configureLabel(text: "\(weatherInfoArrary[indexPath.row].cellTemperature)°", font: UIFont.KFont.lexendLarge, textColor: UIColor.KColor.white, attributeString: ["°"], attributeColor: [UIColor.KColor.primaryGreen])
        } else {
            cell.diurnalTemperatureLabel.configureLabel(text: "- | -", font: UIFont.KFont.lexendMini, textColor: UIColor.KColor.gray05, attributeString: ["|"], attributeColor: [UIColor.KColor.gray03])
            cell.temperatureLabel.configureLabel(text: "-", font: UIFont.KFont.lexendLarge, textColor: UIColor.KColor.white, attributeString: ["°"], attributeColor: [UIColor.KColor.primaryGreen])
        }
        
        cell.backgroundColor = UIColor.KColor.gray02
        cell.layer.cornerRadius = 15
        return cell
    }
}

// MARK: UICollectionViewDelegate 익스텐션
extension LocationSelectionView: UICollectionViewDelegate {
    
}


// MARK: UICollectionViewDelegateFlowLayout 익스텐션
extension LocationSelectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 42, height: 96)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 18, left: 10, bottom: 10, right: 10)
    }
}

// MARK: 롱탭제스쳐 관련 코드
// http://yoonbumtae.com/?p=4418

extension LocationSelectionView: UIGestureRecognizerDelegate {
    
    // 롱탭제스쳐 recognizer 함수
    private func setUpLongGestureRecognizerOnCollection() {
        
        // 롱탭제스쳐 기본 설정 코드
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        collectionView.addGestureRecognizer(longPressedGesture)
    }
    
    // 롱탭제스쳐 핸들 함수
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        
        let location = gestureRecognizer.location(in: collectionView)
        
        // 롱탭제스쳐 시작할 때의 코드
        if gestureRecognizer.state == .began {
            if let indexPath = collectionView.indexPathForItem(at: location) {
                UIView.animate(withDuration: 0.2) { [self] in
                    if let cell = self.collectionView.cellForItem(at: indexPath) as? LocationSelectionCollectionViewCell {
                        self.currentLongPressedCell = cell
                        cell.transform = .init(scaleX: 0.95, y: 0.95) // 임시코드입니다.
                    }
                }
            }
        } else if gestureRecognizer.state == .ended { // 롱탭제스쳐 끝날 때의 코드
            if let indexPath = collectionView.indexPathForItem(at: location) {
                UIView.animate(withDuration: 0.2) { [self] in
                    if let cell = self.currentLongPressedCell {
                        cell.transform = .init(scaleX: 1, y: 1)
                        
                        if cell == self.collectionView.cellForItem(at: indexPath) as? LocationSelectionCollectionViewCell {
                            // .began에서 저장했던 cell과 현재 위치에 있는 셀이 같다면 동작을 실행하고, 아니라면 아무것도 하지 않습니다.
                            // 코드 추가 예정
                        }
                    }
                }
            }
        } else {
            return
        }
    }
}

extension LocationSelectionView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text?.lowercased() else { return }
        if text == "" {
            noCityInformationLabel.isHidden = false
            self.filteredLocationModel = self.locationTableViewModel.filter({ $0.locationString.localizedStandardContains(text)})
        } else {
            noCityInformationLabel.isHidden = true
            self.filteredLocationModel = self.locationTableViewModel.filter({ $0.locationString.localizedStandardContains(text)})
            if filteredLocationModel.count == 0 {
                noCityInformationLabel.isHidden = false
            }
        }
        self.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = false
        tableView.reloadData()
        collectionView.isHidden = true
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
            self.cancelSearchButton.isHidden = false
            searchBar.snp.remakeConstraints {
                $0.leading.equalToSuperview().inset(12)
                $0.top.equalTo(self.cancelSearchButton.snp.top)
                $0.height.equalTo(47)
                $0.trailing.equalTo(self.cancelSearchButton.snp.leading)
            }
            searchBar.superview?.layoutIfNeeded()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = true
        tableView.reloadData()
        collectionView.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
            self.cancelSearchButton.isHidden = true
            searchBar.snp.remakeConstraints {
                $0.leading.trailing.equalToSuperview().inset(12)
                $0.top.equalTo(self.cancelSearchButton.snp.top)
                $0.height.equalTo(47)
            }
            searchBar.superview?.layoutIfNeeded()
        }
    }
}

extension LocationSelectionView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLocationModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? LocationTableCell else { return UITableViewCell() }
        let searchingLocation = filteredLocationModel[indexPath.row]
        cell.locationLabel.text = searchingLocation.locationString
        return cell
    }
}

extension LocationSelectionView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchingLocation = filteredLocationModel[indexPath.row]
        self.cityInformation.forEach { information in
            if information.code == searchingLocation.locationCode {
                if viewModel.checkLocationIsSame(locationCode: searchingLocation.locationCode) {
                    viewModel.saveLocation(city: information.code, latitude: Double(information.latitude), longtitude: Double(information.longitude), sequence: viewModel.countLocations())
                    self.endSearchLocation()
                } else {
                    self.isSameLocationAlert()
                }
            }
        }
        self.viewDidLoad()
    }
    
    private func isSameLocationAlert() {
        let alert = UIAlertController(title: "이미 동일한 지역을 추가했어요.", message: "다른 지역을 추가해주세요.", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default) { _ in
            self.dismiss(animated: true)
        }
        alert.addAction(confirm)
        self.present(alert, animated: true)
    }
}
