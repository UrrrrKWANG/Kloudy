//
//  SettingLocationAllowCellView.swift
//  Kloudy
//
//  Created by Geunil Park on 2022/11/16.
//

import UIKit
import SnapKit

class SettingLocationAllowCellView: UITableViewCell {
    static let identifier = "SettingLocationAllowCellView"
    
    let locationAllowTextLabel: UILabel = {
        let locationAllowTextLabel = UILabel()
        locationAllowTextLabel.font = UIFont.KFont.appleSDNeoMediumMedium
        locationAllowTextLabel.textColor = UIColor.KColor.black
        return locationAllowTextLabel
    }()
    
    let locationAllowSwitch: UISwitch = {
        let locationAllowSwitch = UISwitch()
        return locationAllowSwitch
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
        self.addSubview(locationAllowTextLabel)
        self.addSubview(locationAllowSwitch)
        
        locationAllowTextLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(28)
            $0.leading.equalToSuperview().inset(0)
        }
        
        locationAllowSwitch.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(28)
            $0.trailing.equalToSuperview().inset(2)
        }
    }
}
