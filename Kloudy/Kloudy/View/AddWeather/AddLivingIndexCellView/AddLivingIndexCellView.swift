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

class AddLivingIndexCellView: UIViewController {
    private let titleLabel = UILabel()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.KColor.cellGray
        self.view.addSubview(titleLabel)
        self.view.addSubview(collectionView)
        self.styleFunction()
    }
    
    private func styleFunction() {
        self.configureTitleLabel()
        self.configureCollectionView()
    }
    
    private func configureTitleLabel() {
        self.titleLabel.text = "생활 지수"
        self.titleLabel.textColor = UIColor.KColor.white
        self.titleLabel.font = UIFont.KFont.appleSDNeoBoldLarge
        
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
