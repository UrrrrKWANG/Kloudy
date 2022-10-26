//
//  LocationSelectionView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/10/17.
//

import UIKit
import SnapKit


class LocationSelectionView: UIViewController {
    
    let collectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        
        return cv
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = .black

        collectionView.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
                
        collectionView.register(LocationSelectionCollectionViewCell.self, forCellWithReuseIdentifier: LocationSelectionCollectionViewCell.cellID)
    }
    
    
}

extension LocationSelectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationSelectionCollectionViewCell.cellID, for: indexPath) as! LocationSelectionCollectionViewCell
        
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
