//
//  SettingVersionCellView.swift
//  Kloudy
//
//  Created by Geunil Park on 2022/11/16.
//

import UIKit
import SnapKit

class SettingVersionCellView: UITableViewCell {
    static let identifier = "SettingVersionCellView"
    
    let versionTextLabel: UILabel = {
        let versionTextLabel = UILabel()
        versionTextLabel.font = UIFont.KFont.appleSDNeoMedium18
        versionTextLabel.textColor = UIColor.KColor.black
        return versionTextLabel
    }()
    
    let versionNumberLabel: UILabel = {
        let versionNumberLabel = UILabel()
        versionNumberLabel.font = UIFont.KFont.appleSDNeoMedium18
        versionNumberLabel.textColor = UIColor.KColor.primaryBlue01
        
        return versionNumberLabel
    }()
    
    let versionCheckLabel: UILabel = {
        let versionCheckLabel = UILabel()
        versionCheckLabel.font = UIFont.KFont.appleSDNeoMedium14
        versionCheckLabel.textColor = UIColor.KColor.gray01
        return versionCheckLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.configureLocationLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.backgroundColor = selected ? .init(UIColor(white: 1.0, alpha: 0.1)) : .none
    }
 
    private func configureLocationLabel() {
        [versionTextLabel, versionNumberLabel, versionCheckLabel].forEach { addSubview($0) }
        
        versionTextLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.bottom.equalToSuperview().inset(28)
            $0.leading.equalToSuperview()
        }
        
        versionNumberLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.bottom.equalToSuperview().inset(28)
            $0.leading.equalTo(self.versionTextLabel.snp.trailing).offset(5)
        }
        
        versionCheckLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.bottom.equalToSuperview().inset(28)
            $0.trailing.equalToSuperview()
        }
    }
}
