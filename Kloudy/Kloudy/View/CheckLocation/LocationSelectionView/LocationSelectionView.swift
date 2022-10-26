//
//  LocationSelectionView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/10/17.
//

import UIKit
import SnapKit

let cellID = "Cell"

class LocationSelectionView: UIViewController {

    let collectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        
        return cv
    }()
    let searchBar = UISearchBar()
    let cancelSearchButton = UIButton()
    let tableView = UITableView()
    
    let cityInformationModel = FetchWeatherInformation()
    
    var cityInformation = [CityInformation]()
    var locationTableViewModel = [SearchingLocation]()
    var filteredLocationModel = [SearchingLocation]()
    

    //MARK: View Lifecycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        [searchBar, cancelSearchButton, tableView].forEach { self.view.addSubview($0) }
        
        
        //test
        collectionView.isHidden = true
        
        configureCancelSearchButton()
        configureSearchBar()
        configureTableView()
        self.cityInformation = cityInformationModel.loadCityListFromCSV()
        self.initializeLocationTableViewModel()
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .black
        collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
                
        collectionView.register(LocationSelectionCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cancelSearchButton.isHidden = true
    }
    
    
    //MARK: Configure Function
    private func configureSearchBar() {
        searchBar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.top.equalTo(cancelSearchButton.snp.top)
            $0.height.equalTo(47)
            $0.trailing.equalTo(cancelSearchButton.snp.leading)
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
    
    @objc func tapCancelSearchButton() {
        searchBar.endEditing(true)
    }
    
    //MARK: Location
    private func initializeLocationTableViewModel() {
        cityInformation.forEach { info in
            var addString = String()
            addString = "\(info.province) " + "\(info.city)"
            self.locationTableViewModel.append(SearchingLocation(locationString: addString, locationCode: info.code))
        }
    }
}

extension LocationSelectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! LocationSelectionCollectionViewCell
        
        cell.layer.cornerRadius = 15
        
        cell.backgroundColor = UIColor.KColor.gray02
        
        return cell
    }
}

extension LocationSelectionView: UICollectionViewDelegate {
    
}

extension LocationSelectionView: UICollectionViewDelegateFlowLayout {
    
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

extension LocationSelectionView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text?.lowercased() else { return }
        if text == "" {
            self.filteredLocationModel = self.locationTableViewModel.filter({ $0.locationString.localizedStandardContains(text)})
        } else {
            self.filteredLocationModel = self.locationTableViewModel.filter({ $0.locationString.localizedStandardContains(text)})
            if filteredLocationModel.count == 0 {
                // 추후 저장된 도시 정보가 없다는 Label 이나 Image 가 요구된다
            }
        }
        self.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
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
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
            self.cancelSearchButton.isHidden = true
            searchBar.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(12)
                $0.top.equalTo(self.cancelSearchButton.snp.top)
                $0.height.equalTo(47)
                $0.trailing.equalTo(self.cancelSearchButton.snp.leading)
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
        //TODO: CityInformation의 code 를 반환하는 테스트 코드입니다.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? LocationTableCell else { return }
        let searchingLocation = filteredLocationModel[indexPath.row]
        print(searchingLocation.locationCode)
    }
}
