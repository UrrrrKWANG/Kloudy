//
//  LocationTableCell.swift
//  Kloudy
//
//  Created by 이영준 on 2022/10/26.
//

import UIKit
import SnapKit

class LocationTableCell: UITableViewCell {
    static let identifier = "TableViewCell"
    
    let locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.font = UIFont.KFont.appleSDNeoRegularLarge
        locationLabel.textColor = UIColor.KColor.gray06
        return locationLabel
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
        self.backgroundColor = UIColor.KColor.black
        self.addSubview(locationLabel)
        
        locationLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(10)
        }
    }
}
