//
//  NetworkUnreachableView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/11/30.
//

import UIKit
import SnapKit

class NetworkUnreachableView: UIViewController {
    let imageView = UIImageView()
    let label = UILabel()
    
    override func viewDidLoad() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        networkUnreachableAlert()
        layout()
        attribute()
    }
    
    private func layout() {
        [imageView, label].forEach { view.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(300)
            $0.size.equalTo(150)
        }
        
        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(20)
        }
    }
    
    private func attribute() {
        view.backgroundColor = UIColor.KColor.primaryBlue05
        configureImageView()
        configureLabel()
    }
    
    private func configureImageView() {
        imageView.image = UIImage(named: "logo")
    }
    
    private func configureLabel(){
        label.numberOfLines = 2
        label.font = UIFont.KFont.lexendLight14
        label.textColor = UIColor.KColor.black
        label.textAlignment = .center
        label.text = "현재 인터넷이 불안정할 수 있어요.\n인터넷 연결을 확인해 주세요."
    }
    // localization
    private func networkUnreachableAlert() {
        let alert = UIAlertController(title: "인터넷 연결 불안정".localized, message: "인터넷 연결을 확인해 주세요.".localized, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인".localized, style: .default) { _ in
            self.dismiss(animated: true)
        }
        alert.addAction(confirm)
        self.present(alert, animated: true)
    }
}
