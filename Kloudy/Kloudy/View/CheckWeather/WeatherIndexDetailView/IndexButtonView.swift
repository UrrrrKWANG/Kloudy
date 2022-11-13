//
//  IndexButtonView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/11/12.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SequenceLabelCell: UICollectionViewCell {
    static let identifier = "sequenceLabel"
    
    let sequenceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.KFont.lexendMedius
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.cellSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func cellSetting() {
        self.layer.cornerRadius = 8
        self.addSubview(sequenceLabel)
        sequenceLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}


class IndexButtonView: UIView {
    let disposeBag = DisposeBag()
    let presentButtonImage = UIImageView()
    var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.KColor.clear
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    var indexStatus: BehaviorSubject<Int> = BehaviorSubject(value: 4)
    var status: Int = 4
    
    let presentButtonTapped: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        // API 데이터 받을 시 저장
        indexStatus
            .subscribe(onNext: {
                self.status = $0
            })
            .disposed(by: disposeBag)
    }
    
    private func layout() {
        [presentButtonImage, collectionView].forEach { self.addSubview($0) }
        
        presentButtonImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(130)
//            $0.width.equalTo(5)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(presentButtonImage.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(30)
        }
    }
    
    private func attribute() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SequenceLabelCell.self, forCellWithReuseIdentifier: "sequenceLabel")
        presentButtonImage.image = UIImage(named: "chevron_up")
    }
}

extension IndexButtonView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 분기 처리
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SequenceLabelCell.identifier, for: indexPath) as? SequenceLabelCell else { return UICollectionViewCell() }
        cell.backgroundColor = self.status - 1 == indexPath.row ? UIColor.init(red: 244/255, green: 247/255, blue: 255/255, alpha: 1) : UIColor.KColor.clear
        cell.sequenceLabel.textColor = self.status - 1 == indexPath.row ? UIColor.init(red: 77/255, green: 115/255, blue: 244/255, alpha: 1) : UIColor.KColor.black
        cell.sequenceLabel.text = "\(indexPath.row + 1)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing = 20
        return CGSize(width: (Int(collectionView.frame.width) - itemSpacing * 4) / 5, height: 32)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
}
