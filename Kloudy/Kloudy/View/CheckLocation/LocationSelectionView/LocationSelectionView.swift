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

    let searchButton: UIButton = {
        let searchBar = UIButton()
        searchBar.setTitle("지역을 검색해 보세요", for: .normal)
        searchBar.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchBar.imageView?.contentMode = .scaleAspectFill
        searchBar.backgroundColor = UIColor.KColor.gray02
        searchBar.contentHorizontalAlignment = .center
        searchBar.semanticContentAttribute = .forceRightToLeft
        searchBar.titleEdgeInsets = .init(top:0, left: -10, bottom: 0, right: 0)
        searchBar.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: -10)
        
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        view.addSubview(searchButton)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = .black

        searchButton.translatesAutoresizingMaskIntoConstraints = false
        
        searchButton.layer.cornerRadius = 10
        
        searchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//        searchButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        searchButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        searchButton.bottomAnchor.constraint(equalTo: collectionView.topAnchor).isActive = true
        searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        searchButton.widthAnchor.constraint(equalToConstant: view.frame.width - 30).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
                
        collectionView.topAnchor.constraint(equalTo: searchButton.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
                
        collectionView.register(LocationSelectionCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
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
