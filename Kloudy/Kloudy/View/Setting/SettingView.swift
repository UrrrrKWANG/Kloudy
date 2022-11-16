//
//  SettingView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/11/07.
//

import UIKit
import SnapKit

class SettingView: UIViewController {
    let settingNavigationView = SettingNavigationView()
    let tableView = UITableView()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.KColor.white
        layout()
        attribute()
    }
    
    private func layout() {
        [tableView, settingNavigationView].forEach { self.view.addSubview($0) }
        
        settingNavigationView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(62)
            $0.leading.trailing.equalToSuperview().inset(21)
            $0.height.equalTo(24)
        }
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(settingNavigationView.snp.bottom).offset(18)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func attribute() {
        self.navigationController?.navigationBar.isHidden = true
        self.configureTableView()
        self.configureBackButton()
    }
    
    private func configureBackButton() {
        settingNavigationView.backButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.KColor.white
        tableView.register(SettingLicenseCellView.self, forCellReuseIdentifier: "SettingLicenseCellView")
        tableView.register(SettingVersionCellView.self, forCellReuseIdentifier: "SettingVersionCellView")
        tableView.register(SettingLocationAllowCellView.self, forCellReuseIdentifier: "SettingLocationAllowCellView")
    }
    
    @objc func tapBackButton() {
       self.navigationController?.popToRootViewController(animated: true)
   }
}

extension SettingView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingLicenseCellView", for: indexPath) as? SettingLicenseCellView else { return UITableViewCell() }
            cell.licenseLabel.text = "라이센스"
            
            return cell
        }
        
        else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingVersionCellView", for: indexPath) as? SettingVersionCellView else { return UITableViewCell() }
            cell.versionTextLabel.text = "버전정보"
            cell.versionNumberLabel.text = "1.0.0"
            cell.versionCheckLabel.text = "최신 버전입니다"
            cell.selectionStyle = .none
            return cell
        }
        
        else if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingLocationAllowCellView", for: indexPath) as? SettingLocationAllowCellView else { return UITableViewCell() }
            cell.locationAllowTextLabel.text = "위치 서비스 약관 동의"
            cell.selectionStyle = .none
            cell.layer.addBorder([.top], color: UIColor.KColor.gray03, width: 1.0)
            
            return cell
        }
        
        return UITableViewCell()
    }
}

extension SettingView: UITableViewDelegate {

}

extension CALayer {
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width + 30, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
}
