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
        versionTextLabel.font = UIFont.KFont.appleSDNeoMediumMedium
        versionTextLabel.textColor = UIColor.KColor.black
        return versionTextLabel
    }()
    
    let versionNumberLabel: UILabel = {
        let versionNumberLabel = UILabel()
        versionNumberLabel.font = UIFont.KFont.appleSDNeoMediumMedium
        versionNumberLabel.textColor = UIColor.KColor.primaryBlue01
        
        return versionNumberLabel
    }()
    
    let versionCheckLabel: UILabel = {
        let versionCheckLabel = UILabel()
        versionCheckLabel.font = UIFont.KFont.appleSDNeoMediumSmall
        versionCheckLabel.textColor = UIColor.KColor.black
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
        self.addSubview(versionTextLabel)
        self.addSubview(versionNumberLabel)
        self.addSubview(versionCheckLabel)
        
        versionTextLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.bottom.equalToSuperview().inset(28)
            $0.leading.equalToSuperview().inset(0)
        }
        
        versionNumberLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.bottom.equalToSuperview().inset(28)
            $0.leading.equalTo(self.versionTextLabel.snp.trailing).inset(-5)
        }
        
        versionCheckLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.bottom.equalToSuperview().inset(28)
            $0.trailing.equalToSuperview().inset(0)
        }
    }
}
