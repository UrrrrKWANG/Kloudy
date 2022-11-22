//
//  CurrentLocationTableViewCell.swift
//  Kloudy
//
//  Created by Seulki Lee on 2022/11/23.
//

import UIKit

class CurrentLocationTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    var locationName: String = "현재 위치".localized
    static let identifier = "currentCell"
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
        label.configureLabel(text: locationName.localized, font: UIFont.KFont.appleSDNeoBoldMedium, textColor: UIColor.KColor.gray01)
        return label
    }()
    
    var agreeButton: UIButton = {
        let button = UIButton()
        let agreement = "위치 동의 "
        let arrowImage = UIImage(systemName: "chevron.right")
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(agreement, for: .normal)
        button.setImage(arrowImage, for: .normal)
        button.setTitleColor(UIColor.KColor.gray02, for: .normal)
        button.titleLabel?.font = UIFont.KFont.lexendMini
        button.setPreferredSymbolConfiguration(.init(pointSize: 10, weight: .regular, scale: .default), forImageIn: .normal)
        button.contentHorizontalAlignment = .center
        button.semanticContentAttribute = .forceRightToLeft
        
        return button
    }()
    
    private func addView() {
        [locationNameLabel, agreeButton].forEach() {
            contentView.addSubview($0)
        }
    }
    
    private func setLayout() {
        locationNameLabel.snp.makeConstraints {
            $0.leading.equalTo(20)
            $0.centerY.equalToSuperview()
        }
        
        agreeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = UIColor.KColor.white
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        
        contentView.layer.cornerRadius = contentView.frame.height / 5
        
        contentView.layer.applySketchShadow(color: UIColor.KColor.gray02, alpha: 0.1, x: 0, y: 0, blur: 40, spread: 0)
    }
}
