//
//  LocationSelectionView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/10/17.
//

import UIKit
import SnapKit

// https://youtu.be/I7M9V579AaE

class LocationSelectionView: UIViewController {
    
    let collectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        
        return cv
    }()

    var currentLongPressedCell: LocationSelectionCollectionViewCell?
    
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
        
        setUpLongGestureRecognizerOnCollection()
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

// http://yoonbumtae.com/?p=4418

extension LocationSelectionView: UIGestureRecognizerDelegate {

    private func setUpLongGestureRecognizerOnCollection() {

        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        collectionView.addGestureRecognizer(longPressedGesture)
    }

    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {

        let location = gestureRecognizer.location(in: collectionView)

        if gestureRecognizer.state == .began {
            if let indexPath = collectionView.indexPathForItem(at: location) {
                UIView.animate(withDuration: 0.2) { [self] in
                    if let cell = self.collectionView.cellForItem(at: indexPath) as? LocationSelectionCollectionViewCell {
                        self.currentLongPressedCell = cell
                        cell.transform = .init(scaleX: 0.95, y: 0.95)
                    }
                }
            }
        } else if gestureRecognizer.state == .ended {
            if let indexPath = collectionView.indexPathForItem(at: location) {
                UIView.animate(withDuration: 0.2) { [self] in
                    if let cell = self.currentLongPressedCell {
                        cell.transform = .init(scaleX: 1, y: 1)

                        if cell == self.collectionView.cellForItem(at: indexPath) as? LocationSelectionCollectionViewCell {
                            // .began에서 저장했던 cell과 현재 위치에 있는 셀이 같다면 동작을 실행하고, 아니라면 아무것도 하지 않습니다.
                        }
                    }
                }
            }
        } else {
            return
        }

    }
}
