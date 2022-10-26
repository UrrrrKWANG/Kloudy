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

    // 롱탭의 시작점과 끝점이 같을 경우에만 롱탭제스쳐를 활성화하기 위하여 설정한 변수
    var currentLongPressedCell: LocationSelectionCollectionViewCell?
    
    let locationSelectionNavigationView = LocationSelectionNavigationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        self.navigationController?.navigationBar.isHidden = true
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
                
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = .black
        
        self.view.addSubview(locationSelectionNavigationView)
        self.configureLocationSelectionNavigationView()
        self.locationSelectionNavigationView.isHidden = false

        // 스냅킷 사용하여 오토레이아웃 간략화하였습니다.
        collectionView.snp.makeConstraints {
            $0.top.equalTo(locationSelectionNavigationView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
                
        collectionView.register(LocationSelectionCollectionViewCell.self, forCellWithReuseIdentifier: LocationSelectionCollectionViewCell.cellID)
        
        // 롱탭제스쳐 활성화 함수
        setUpLongGestureRecognizerOnCollection()

    }
    
    private func configureLocationSelectionNavigationView() {
        locationSelectionNavigationView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(47)
            $0.leading.trailing.equalToSuperview().inset(21)
            $0.width.equalTo(106)
            $0.height.equalTo(20)
        }
//        locationSelectionNavigationView.backButton.addTarget(self, action: #selector(tapLocationButton), for: .touchUpInside)
    }
    
}


// MARK: UICollectionViewDataSource 익스텐션
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


// MARK: UICollectionViewDelegate 익스텐션
extension LocationSelectionView: UICollectionViewDelegate {
    
}


// MARK: UICollectionViewDelegateFlowLayout 익스텐션
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
