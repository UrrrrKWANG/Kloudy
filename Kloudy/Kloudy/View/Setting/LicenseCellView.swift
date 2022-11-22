//
//  LicenseCellView.swift
//  Kloudy
//
//  Created by Geunil Park on 2022/11/16.
//

import UIKit
import SnapKit

class LicenseCellView: UITableViewCell {
    static let identifier = "LicenseCellView"
    
    let licenseNameLabel: UILabel = {
        let licenseNameLabel = UILabel()
        licenseNameLabel.font = UIFont.KFont.appleSDNeoBold15
        licenseNameLabel.textColor = UIColor.KColor.black
        licenseNameLabel.lineBreakMode = .byCharWrapping
        licenseNameLabel.numberOfLines = 0
        
        return licenseNameLabel
    }()
    
    let licenseContentLabel: UILabel = {
        let licenseContentLabel = UILabel()
        licenseContentLabel.font = UIFont.KFont.appleSDNeoMedium15
        licenseContentLabel.textColor = UIColor.KColor.gray02
        licenseContentLabel.lineBreakMode = .byCharWrapping
        licenseContentLabel.numberOfLines = 0
        
        return licenseContentLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.configureLocationLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    private func configureLocationLabel() {
        [licenseNameLabel, licenseContentLabel].forEach { self.addSubview($0) }
        
        licenseNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        licenseContentLabel.snp.makeConstraints {
            $0.top.equalTo(self.licenseNameLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(32)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = UIColor.KColor.gray05
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0))
        contentView.layer.cornerRadius = 12
    }
}

