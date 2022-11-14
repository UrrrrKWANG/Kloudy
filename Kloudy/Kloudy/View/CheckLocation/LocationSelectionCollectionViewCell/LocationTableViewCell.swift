//
//  LocationTableViewCell.swift
//  Kloudy
//
//  Created by Seulki Lee on 2022/11/10.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    static let identifier = "locationCell"
    let sampleUILabel = UILabel() //
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = UIColor.KColor.red
        // top 인셋을 주면 글자가 height상 가운데로 안가고 조금 더 밑으로 내려감
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        
//        contentView.backgroundColor = .lightGray
        contentView.layer.cornerRadius = contentView.frame.height / 5
    }
}
