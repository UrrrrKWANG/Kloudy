//
//  SettingLocationAllowCellView.swift
//  Kloudy
//
//  Created by Geunil Park on 2022/11/16.
//

import UIKit
import SnapKit
import CoreLocation

class SettingLocationAllowCellView: UITableViewCell, CLLocationManagerDelegate {
    static let identifier = "SettingLocationAllowCellView"
    var locationManager = CLLocationManager()
    
    let locationAllowTextLabel: UILabel = {
        let locationAllowTextLabel = UILabel()
        locationAllowTextLabel.font = UIFont.KFont.appleSDNeoMedium18
        locationAllowTextLabel.textColor = UIColor.KColor.black
        return locationAllowTextLabel
    }()
    
    let locationAllowSwitch: UISwitch = {
        let locationAllowSwitch = UISwitch()
        locationAllowSwitch.onTintColor = UIColor.KColor.primaryBlue01
        
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
        locationAllowSwitch.addTarget(self, action: #selector(self.onClickSwitch(_:)), for: .valueChanged)
        locationAllowSwitch.transform = CGAffineTransform(scaleX: 0.97, y: 0.92)
        let currentStatus = CLLocationManager().authorizationStatus
        
        if currentStatus == .notDetermined || currentStatus == .restricted || currentStatus == .denied {
            locationAllowSwitch.isOn = false
        } else {
            locationAllowSwitch.isOn = true
        }
        
        [locationAllowTextLabel, locationAllowSwitch].forEach { self.addSubview($0) }
        
        locationAllowTextLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(28)
            $0.leading.equalToSuperview()
        }
        
        locationAllowSwitch.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(28)
            $0.trailing.equalToSuperview().inset(2)
        }
    }
    
    @objc func onClickSwitch(_ sender: UISwitch) {
        self.locationManager.delegate = self
        
        let currentStatus = CLLocationManager().authorizationStatus
        
        if self.locationAllowSwitch.isOn == false {
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
            self.locationAllowSwitch.setOn(false, animated: true)
        }
        else {
            if currentStatus == .notDetermined {
                self.locationManager.requestAlwaysAuthorization()
                locationManagerDidChangeAuthorization(self.locationManager)
            } else if currentStatus == .restricted || currentStatus == .denied {
                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                }
            }
        }
    }
}

extension UITableViewCell {
    open override func addSubview(_ view: UIView) {
        super.addSubview(view)
        sendSubviewToBack(contentView)
    }
}

extension SettingLocationAllowCellView {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            self.locationAllowSwitch.setOn(true, animated: true)
        } else {
            self.locationAllowSwitch.setOn(false, animated: true)
        }
    }
}
