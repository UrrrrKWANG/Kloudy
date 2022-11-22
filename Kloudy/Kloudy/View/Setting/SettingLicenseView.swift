//
//  SettingLicenseView.swift
//  Kloudy
//
//  Created by Geunil Park on 2022/11/16.
//

import UIKit
import SnapKit

struct License {
    let name: String
    let content: String
}

class SettingLicenseView: UIViewController {
    let settingLicenseNavigationView = SettingLicenseNavigationView()
    let tableView = UITableView()
    let licenses: [License] = [
        License(name: "출처 : 기상청 / 에어코리아".localized, content: "데이터는 실시간 관측된 자료이며 측정소 현지 사정이나 데이터의 수신상태에 따라 미수신될 수 있음".localized)
    ]
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.KColor.white
        layout()
        attribute()
    }
    
    private func layout() {
        [settingLicenseNavigationView, tableView].forEach { self.view.addSubview($0) }
        
        settingLicenseNavigationView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(62)
            $0.leading.trailing.equalToSuperview().inset(21)
            $0.height.equalTo(24)
        }
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(settingLicenseNavigationView.snp.bottom).offset(32)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func attribute() {
        self.navigationController?.navigationBar.isHidden = true
        self.configureBackButton()
        self.configureTableView()
    }
    
    private func configureBackButton() {
        settingLicenseNavigationView.backButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.KColor.white
        tableView.register(LicenseCellView.self, forCellReuseIdentifier: "LicenseCellView")
    }
    
    @objc func tapBackButton() {
       self.navigationController?.popViewController(animated: true)
   }
}

extension SettingLicenseView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return licenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LicenseCellView", for: indexPath) as? LicenseCellView else { return UITableViewCell() }
        
        cell.licenseNameLabel.text = licenses[indexPath.row].name
        cell.licenseContentLabel.text = licenses[indexPath.row].content
        cell.licenseContentLabel.setLineSpacing(spacing: 5.0)
        cell.selectionStyle = .none
        
        return cell
    }
}

// 나중에 쓸까봐 남겨둠.
extension SettingLicenseView: UITableViewDelegate {

}

// https://ios-development.tistory.com/739
// 행간 수정
extension UILabel {
    func setLineSpacing(spacing: CGFloat) {
        guard let text = text else { return }

        let attributeString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        attributeString.addAttribute(.paragraphStyle,
                                     value: style,
                                     range: NSRange(location: 0, length: attributeString.length))
        attributedText = attributeString
    }
}
