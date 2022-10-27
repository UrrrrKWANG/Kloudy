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
    static let images = ["rainIndex", "마스크_2단계"]
    static let labels = ["우산", "마스크"]
}

class AddLivingIndexCellView: UIViewController {
    
    let viewModel = AddLivingIndexCellViewModel()
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
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 36, bottom: 0, right: 36)
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
    var locationWeatherCellArray: [WeatherCell] = []
    
    // delegate 을 통해 전달받을 City
    var sentLocation: Location = Location() {
        didSet {
            locationWeatherCellArray = sentLocation.weatherCell?.sortedArray(using: [NSSortDescriptor.init(key: "id", ascending: true)]) as? [WeatherCell] ?? []
        }
    }
    
    //MARK: View Lifecycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.KColor.cellGray
        self.view.addSubview(titleLabel)
        self.view.addSubview(collectionView)
        self.view.addSubview(completeButton)
        self.styleFunction()
    }
    
    //MARK: Style Function
    private func styleFunction() {
        self.configureTitleLabel()
        self.configureCollectionView()
        self.configureCompleteButton()
    }
    
    private func configureTitleLabel() {
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(35)
            $0.leading.equalToSuperview().inset(21)
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
    
//    private func checkLocationHasWeatherCell() {
//        self.locationWeatherCellSet.forEach { weatherCell in
//            checkLocationCellTypes[weatherCell.type ?? ""] = true
//        }
//    }
    
    @objc private func tapCompleteButton() {
        self.dismiss(animated: true)
    }
}

extension AddLivingIndexCellView: SendFirstSequenceLocationDelegate {
    func sendFirstSequenceLocation(_ location: Location) {
        self.sentLocation = location
    }
}

extension AddLivingIndexCellView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewLabel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddLivingIndexCell.identifier, for: indexPath) as? AddLivingIndexCell else { return UICollectionViewCell() }
        
        cell.livingIndexCellLabel.text = collectionViewLabel[indexPath.row]
        cell.livingIndexCellImage.image = UIImage(named: "\(collectionViewImage[indexPath.row])")
        cell.livingIndexCellImage.tintColor = UIColor.KColor.primaryGreen
        
//        cell.layer.borderWidth = 2
//        cell.layer.borderColor = UIColor.KColor.primaryGreen.cgColor
        
        if self.checkLocationCellTypes["\(String(describing: cell.livingIndexCellLabel.text))"] ?? false {
            cell.livingIndexCellImage.layer.borderWidth = 2
            cell.livingIndexCellImage.layer.borderColor = UIColor.KColor.primaryGreen.cgColor
        }
        cell.contentView.isUserInteractionEnabled = false
        return cell
    }
}

extension AddLivingIndexCellView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 144, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
}

