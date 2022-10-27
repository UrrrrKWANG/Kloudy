//
//  AddLivingIndexCellView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/10/17.
//

import UIKit
import SnapKit

// 임시 Image, Label
struct CollectionViewData {
    static let images = ["umbrella", "facemask"]
    static let labels = ["우산", "마스크"]
}

class AddLivingIndexCellView: UIViewController, LocationDataProtocol{
    
    func locationData(_ location: String) {
        sentText = location
    }
    let viewModel = AddLivingIndexCellViewModel()
    
    var sentText = ""
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "생활 지수"
        titleLabel.textColor = UIColor.KColor.white
        titleLabel.font = UIFont.KFont.appleSDNeoBoldLarge
        return titleLabel
    }()
    private let collectionViewImage = CollectionViewData.images
    private let collectionViewLabel = CollectionViewData.labels
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.KColor.cellGray
        collectionView.register(AddLivingIndexCell.self, forCellWithReuseIdentifier: AddLivingIndexCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    private let completeButton: UIButton = {
        let completeButton = UIButton()
        completeButton.setTitle("지수 추가", for: .normal)
        completeButton.setTitleColor(UIColor.KColor.black, for: .normal)
        completeButton.titleLabel?.font = UIFont.KFont.appleSDNeoBoldSmall
        completeButton.backgroundColor = UIColor.KColor.primaryGreen
        completeButton.layer.cornerRadius = 15
        return completeButton
    }()
    var checkLocationCellTypes: [String:Bool] = ["우산" : false, "마스크" : false]
    var locationWeatherCellSet = Set<WeatherCell>()
    
    //MARK: View Lifecycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.KColor.cellGray
        self.view.addSubview(titleLabel)
        self.view.addSubview(collectionView)
        self.view.addSubview(completeButton)
        self.styleFunction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 추후 delegate 를 통해 전달 받을 city 이름을 대입
//        self.locationWeatherCellSet = self.viewModel.fetchLocationCells(cityName: "마스크")
        self.checkLocationHasWeatherCell()
    }
    
    //MARK: Style Function
    private func styleFunction() {
        self.configureTitleLabel()
        self.configureCollectionView()
        self.configureCompleteButton()
    }
    
    private func configureTitleLabel() {
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(50)
            $0.leading.equalToSuperview().inset(24)
        }
    }
    
    private func configureCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureCompleteButton() {
        self.completeButton.snp.makeConstraints {
            $0.height.equalTo(54)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(21)
            $0.bottom.equalTo(collectionView.snp.bottom).offset(-46)
        }
        self.completeButton.addTarget(self, action: #selector(tapCompleteButton), for: .touchUpInside)
    }
    
    private func checkLocationHasWeatherCell() {
        self.locationWeatherCellSet.forEach { weatherCell in
            if weatherCell.type == "우산" {
                checkLocationCellTypes["우산"] = true
            } else if weatherCell.type == "마스크" {
                checkLocationCellTypes["마스크"] = true
            }
        }
    }
    
    @objc private func tapCompleteButton() {
        self.dismiss(animated: true)
    }
}

extension AddLivingIndexCellView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewLabel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddLivingIndexCell.identifier, for: indexPath) as? AddLivingIndexCell else { return UICollectionViewCell() }
        
        cell.livingIndexCellLabel.text = collectionViewLabel[indexPath.row]
        cell.livingIndexCellImage.image = UIImage(systemName: "\(collectionViewImage[indexPath.row])")
        cell.livingIndexCellImage.tintColor = UIColor.KColor.primaryGreen
        
        if self.checkLocationCellTypes["\(cell.livingIndexCellLabel.text)"] ?? false {
            cell.livingIndexCellImage.layer.borderWidth = 2
            cell.livingIndexCellImage.layer.borderColor = UIColor.KColor.primaryGreen.cgColor
        }
        cell.contentView.isUserInteractionEnabled = false
        return cell
    }
}

extension AddLivingIndexCellView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSpacing = 24
        let itemWidth = (Int(UIScreen.main.bounds.width) - cellSpacing - 48) / 2
        return CGSize(width: itemWidth, height: itemWidth + 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
}

protocol LocationDataProtocol: AnyObject {
    func locationData(_ location : String)
}
