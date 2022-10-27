//
//  AddLivingIndexCell.swift
//  Kloudy
//
//  Created by 이영준 on 2022/10/21.
//

import UIKit
import SnapKit

class AddLivingIndexCell: UICollectionViewCell {
    static let identifier = "AddLivingIndexCell"
    let livingIndexCellImage = UIImageView()
    let livingIndexCellLabel = UILabel()
    let viewModel = AddLivingIndexCellViewModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        self.backgroundColor = UIColor.KColor.black
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 15
        contentView.addSubview(livingIndexCellImage)
        contentView.addSubview(livingIndexCellLabel)
        
        livingIndexCellImage.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        livingIndexCellImage.contentMode = .scaleAspectFit
        livingIndexCellImage.layer.cornerRadius = 15
        
        livingIndexCellLabel.textColor = UIColor.KColor.white
        livingIndexCellLabel.layer.cornerRadius = 15
        livingIndexCellLabel.backgroundColor = UIColor.KColor.black
        livingIndexCellLabel.textAlignment = .center
        livingIndexCellLabel.snp.makeConstraints {
            $0.height.equalTo(36)
            $0.leading.bottom.trailing.equalTo(0)
            $0.top.equalTo(livingIndexCellImage.snp.bottom).offset(20)
        }
    }
}
