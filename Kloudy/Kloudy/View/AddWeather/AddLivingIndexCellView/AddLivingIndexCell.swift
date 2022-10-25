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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        self.backgroundColor = UIColor.KColor.gray02
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        contentView.addSubview(livingIndexCellImage)
        contentView.addSubview(livingIndexCellLabel)
        
        livingIndexCellImage.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(0)
            $0.bottom.equalTo(-24)
        }
        livingIndexCellImage.contentMode = .scaleAspectFit
        
        livingIndexCellLabel.textColor = UIColor.KColor.white
        livingIndexCellLabel.backgroundColor = .clear
        livingIndexCellLabel.textAlignment = .center
        livingIndexCellLabel.snp.makeConstraints {
            $0.leading.bottom.trailing.equalTo(0)
            $0.top.equalTo(livingIndexCellImage.snp.bottom)
        }
    }
}
