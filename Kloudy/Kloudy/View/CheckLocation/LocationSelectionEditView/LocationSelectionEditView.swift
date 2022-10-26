//
//  LocationSelectionEditView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/10/17.
//

import UIKit
import SnapKit

// https://youtu.be/I7M9V579AaE

class LocationSelectionEditView: UIViewController {
    
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
    var cityInformation = [CityInformation]()
    var locationTableViewModel = [SearchingLocation]()
    var filteredLocationModel = [SearchingLocation]()
    

    //MARK: View Lifecycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        self.navigationController?.navigationBar.isHidden = true
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
                        
        collectionView.backgroundColor = .black
        
        self.view.addSubview(locationSelectionNavigationView)
        self.configureLocationSelectionNavigationView()
        self.locationSelectionNavigationView.isHidden = false

        // 스냅킷 사용하여 오토레이아웃 간략화하였습니다.
        collectionView.snp.makeConstraints {
            $0.top.equalTo(locationSelectionNavigationView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        [searchBar, cancelSearchButton, tableView, noCityInformationLabel].forEach { self.view.addSubview($0) }
        
        configureCancelSearchButton()
        configureSearchBar()
        configureTableView()
        configureNoCityInformationLabel()
        
        self.cityInformation = cityInformationModel.loadCityListFromCSV()
        self.initializeLocationTableViewModel()
                
        collectionView.register(LocationSelectionViewEditCell.self, forCellWithReuseIdentifier: LocationSelectionViewEditCell.cellID)
        
        // 롱탭제스쳐 활성화 함수
        setUpLongGestureRecognizerOnCollection()

    }
    
    @objc func tapBackButton() {
        self.navigationController?.popToRootViewController(animated: true)
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
        
    override func viewWillAppear(_ animated: Bool) {
        tableView.isHidden = true
        cancelSearchButton.isHidden = true
        noCityInformationLabel.isHidden = true
    }
    
    
    //MARK: Configure Function
    private func configureSearchBar() {
        searchBar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
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
            $0.top.equalToSuperview().inset(65)
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
        searchBar.endEditing(true)
        searchBar.text = ""
        filteredLocationModel = [SearchingLocation]()
        tableView.isHidden = true
        tableView.reloadData()
        collectionView.isHidden = false
        noCityInformationLabel.isHidden = true
    }
    
    private func initializeLocationTableViewModel() {
        cityInformation.forEach { info in
            var temporalString = String()
            temporalString = "\(info.province) " + "\(info.city)"
            self.locationTableViewModel.append(SearchingLocation(locationString: temporalString, locationCode: info.code))
        }
    }
}


// MARK: UICollectionViewDataSource 익스텐션
extension LocationSelectionEditView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationSelectionViewEditCell.cellID, for: indexPath) as! LocationSelectionViewEditCell
        
//        cell.layer.cornerRadius = 15
//
//        cell.backgroundColor = UIColor.KColor.gray02
//
        return cell
    }
}


// MARK: UICollectionViewDelegate 익스텐션
extension LocationSelectionEditView: UICollectionViewDelegate {
    
}


// MARK: UICollectionViewDelegateFlowLayout 익스텐션
extension LocationSelectionEditView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 30, height: view.frame.width / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30, left: 10, bottom: 10, right: 10)
    }
}

// MARK: 롱탭제스쳐 관련 코드
// http://yoonbumtae.com/?p=4418

extension LocationSelectionEditView: UIGestureRecognizerDelegate {
    
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

extension LocationSelectionEditView: UISearchBarDelegate {
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
                $0.leading.equalToSuperview().inset(8)
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
                $0.leading.trailing.equalToSuperview().inset(8)
                $0.top.equalTo(self.cancelSearchButton.snp.top)
                $0.height.equalTo(47)
            }
            searchBar.superview?.layoutIfNeeded()
        }
    }
}

extension LocationSelectionEditView: UITableViewDataSource {
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

extension LocationSelectionEditView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: CityInformation의 code 를 반환하는 테스트 코드입니다.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? LocationTableCell else { return }
        let searchingLocation = filteredLocationModel[indexPath.row]
    }
}
