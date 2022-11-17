//
//  TableViewLicenseCell.swift
//  Kloudy
//
//  Created by Geunil Park on 2022/11/16.
//

import UIKit
import SnapKit

class SettingLicenseCellView: UITableViewCell {
    static let identifier = "SettingLicenseCellView"
    
    
    let licenseLabel: UILabel = {
        let licenseLabel = UILabel()
        licenseLabel.font = UIFont.KFont.appleSDNeoMedium18
        licenseLabel.textColor = UIColor.KColor.black
        return licenseLabel
    }()
    
    let rightIcon: UIImageView = {
        let rightIcon = UIImageView()
        rightIcon.image = UIImage(named: "rightSilver")
        rightIcon.contentMode = .scaleToFill
        return rightIcon
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
        [licenseLabel, rightIcon].forEach { self.addSubview($0) }
        
        licenseLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(14)
            $0.leading.equalToSuperview()
        }
        
        rightIcon.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(14)
            $0.trailing.equalToSuperview()
        }
    }
}
