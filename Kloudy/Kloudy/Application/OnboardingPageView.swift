//
//  OnboardingPageView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/12/06.
//

import UIKit
import SnapKit

class OnboardingPageView: UIViewController {
    
    let imageView = UIImageView()
    
    let mainLabel: UILabel = {
        let mainLabel = UILabel()
        mainLabel.font = UIFont.KFont.appleSDNeoBold24
        mainLabel.textColor = UIColor.KColor.primaryBlue08
        mainLabel.textAlignment = .center
        return mainLabel
    }()
    
    let subLabel: UILabel = {
        let subLabel = UILabel()
        subLabel.font = UIFont.KFont.appleSDNeoMedium18
        subLabel.textColor = UIColor.KColor.gray02
        subLabel.textAlignment = .center
        subLabel.numberOfLines = 2
        return subLabel
    }()
    
    init(imageName: String, mainLabelText: String, subLabelText: String) {
        self.imageView.image = UIImage(named: imageName)
        self.mainLabel.text = mainLabelText
        self.subLabel.text = subLabelText
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    
    private func layout() {
        view.backgroundColor = UIColor.KColor.white
        [imageView, mainLabel, subLabel].forEach { view.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.equalTo(266)
            $0.height.equalTo(310)
        }
        
        mainLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(36)
            $0.leading.trailing.equalToSuperview().inset(62)
            $0.height.equalTo(29)
        }
        
        subLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(mainLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(62)
            $0.height.equalTo(48)
        }
    }
}
