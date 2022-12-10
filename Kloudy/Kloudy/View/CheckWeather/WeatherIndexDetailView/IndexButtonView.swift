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
    
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = isSelected ? UIColor.KColor.primaryBlue06 : UIColor.KColor.clear
            self.sequenceLabel.textColor = isSelected ? UIColor.KColor.primaryBlue01 : UIColor.KColor.black
        }
    }
    
    let sequenceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.KFont.lexendRegular16
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
    let dismissButton = UIButton()
    let presentButton = UIButton()
    let clearButton = UIButton()
    var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        collectionView.backgroundColor = UIColor.KColor.clear
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    var indexStatus: BehaviorSubject<Int> = BehaviorSubject(value: 0)
    var status: Int = 0
    
    
    // 지수 별 단계 갯수
    var totalIndexStep = PublishSubject<Int>()
    var totalIndexStepCount: Int = 0
    var stepCellSpacing: Int = 0
    
    var isDismissButtonTapped = PublishSubject<Bool>()
    let presentButtonIndex = PublishSubject<Int>()
    
    var isPresented = false {
        didSet {
            collectionView.reloadData()
        }
    }
    var firstTap = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
        attribute()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        // 추후 API 데이터 받을 시 저장
        indexStatus
            .subscribe(onNext: {
                self.status = $0
            })
            .disposed(by: disposeBag)
        
        // 지수별 Step 수에 따른 Cell 간 Spacing
        totalIndexStep
            .subscribe(onNext: {
                self.totalIndexStepCount = $0
                if $0 == 5 {
                    self.stepCellSpacing = 20
                } else {
                    self.stepCellSpacing = 38
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func layout() {
        [presentButton, dismissButton, collectionView, clearButton].forEach { self.addSubview($0) }
        
        presentButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(21)
        }
        
        dismissButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(21)
        }
        
        collectionView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(32)
        }
        
        clearButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func attribute() {
        self.backgroundColor = UIColor.KColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsSelection = false
        collectionView.register(SequenceLabelCell.self, forCellWithReuseIdentifier: "sequenceLabel")
        presentButton.setImage(UIImage(named: "chevron_up"), for: .normal)
        presentButton.isHidden = false
        presentButton.addTarget(self, action: #selector(presentStepView), for: .touchUpInside)
        dismissButton.setImage(UIImage(named: "chevron_down"), for: .normal)
        dismissButton.isHidden = true
        dismissButton.addTarget(self, action: #selector(dismissStepView), for: .touchUpInside)
        clearButton.isHidden = false
        clearButton.addTarget(self, action: #selector(presentStepView), for: .touchUpInside)
        clearButton.backgroundColor = UIColor.KColor.clear
    }
    
    @objc private func dismissStepView() {
        isDismissButtonTapped.onNext(true)
        isPresented = false
    }
    
    @objc private func presentStepView() {
        isDismissButtonTapped.onNext(false)
        isPresented = true
    }
}

extension IndexButtonView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.totalIndexStepCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SequenceLabelCell.identifier, for: indexPath) as? SequenceLabelCell else { return UICollectionViewCell() }

        cell.backgroundColor = self.status == indexPath.row ? UIColor.KColor.primaryBlue06 : UIColor.KColor.clear
        cell.sequenceLabel.textColor = self.status == indexPath.row ? UIColor.KColor.primaryBlue01 : UIColor.KColor.black
        cell.sequenceLabel.text = "\(indexPath.row + 1)"
        if indexPath.row == self.status {
            presentButtonIndex.onNext(indexPath.row)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 38, height: 32)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(stepCellSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presentButtonIndex.onNext(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if !firstTap {
            firstTap = true
            var fetchIndex = collectionView.indexPathsForSelectedItems?.last ?? IndexPath(item: 0, section: 0)
            fetchIndex.row = self.status
            let cell = collectionView.cellForItem(at: fetchIndex) as! SequenceLabelCell
            cell.isSelected = false
        }
        return true
    }
}

