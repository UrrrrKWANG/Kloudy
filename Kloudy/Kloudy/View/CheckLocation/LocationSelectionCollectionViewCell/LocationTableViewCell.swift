//
//  LocationTableViewCell.swift
//  Kloudy
//
//  Created by Seulki Lee on 2022/11/10.
//

import UIKit
import SnapKit

class LocationTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    var locationName: String = "현재 위치"
    var temperature: Int = 0
    var diurnalTemperature: [Int] = [0, 0]
    static let identifier = "locationCell"
    var indexPath: Int = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addView()
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    lazy var locationNameLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(text: locationName, font: UIFont.KFont.appleSDNeoBoldMedium, textColor: UIColor.KColor.white)
        return label
    }()
    
    lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(text: "\(temperature)°", font: UIFont.KFont.lexendLarge, textColor: UIColor.KColor.white, attributeString: ["°"], attributeColor: [UIColor.KColor.primaryGreen])
        return label
    }()
    
    lazy var diurnalTemperatureLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(text: "\(diurnalTemperature[0])° | \(diurnalTemperature[1])°", font: UIFont.KFont.lexendMini, textColor: UIColor.KColor.gray05, attributeString: ["|"], attributeColor: [UIColor.KColor.gray03])
        return label
    }()
    
    private func addView() {
        [locationNameLabel, temperatureLabel, diurnalTemperatureLabel].forEach() {
            contentView.addSubview($0)
        }
    }
    
    private func setLayout() {
        locationNameLabel.snp.makeConstraints {
            $0.leading.equalTo(20)
            $0.centerY.equalToSuperview()
        }
        
        temperatureLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        diurnalTemperatureLabel.snp.makeConstraints {
            $0.trailing.equalTo(-88)
            $0.centerY.equalToSuperview()
        }
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
