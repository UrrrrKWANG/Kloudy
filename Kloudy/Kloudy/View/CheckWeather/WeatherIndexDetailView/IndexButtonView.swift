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
    let indexStepView = IndexStepView()
    let presentButton = UIButton()
    var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        collectionView.backgroundColor = UIColor.KColor.clear
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    var indexStatus: BehaviorSubject<Int> = BehaviorSubject(value: 4)
    var status: Int = 4
    var stepCellSpacing = 20
    
    var isDissmissButtonTapped: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
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
        [presentButton, collectionView].forEach { self.addSubview($0) }
        
        presentButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(26)
            $0.height.equalTo(21)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(presentButton.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(32)
        }
    }
    
    private func attribute() {
        self.backgroundColor = UIColor.KColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SequenceLabelCell.self, forCellWithReuseIdentifier: "sequenceLabel")
        presentButton.setImage(UIImage(named: "chevron_up"), for: .disabled)
        presentButton.isEnabled = false
        presentButton.addTarget(self, action: #selector(dismissStepView), for: .touchUpInside)
    }
    
    @objc private func dismissStepView() {
        isDissmissButtonTapped.onNext(true)
    }
}

extension IndexButtonView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 분기 처리
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SequenceLabelCell.identifier, for: indexPath) as? SequenceLabelCell else { return UICollectionViewCell() }
        cell.backgroundColor = (self.status - 1) == indexPath.row ? UIColor.KColor.primaryBlue06 : UIColor.KColor.clear
        cell.sequenceLabel.textColor = (self.status - 1) == indexPath.row ? UIColor.KColor.primaryBlue01 : UIColor.KColor.black
        cell.sequenceLabel.text = "\(indexPath.row + 1)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (Int(collectionView.frame.width) - stepCellSpacing * 4 - 48) / 5 , height: 32)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    // 추후 생성
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        <#code#>
//    }
}
