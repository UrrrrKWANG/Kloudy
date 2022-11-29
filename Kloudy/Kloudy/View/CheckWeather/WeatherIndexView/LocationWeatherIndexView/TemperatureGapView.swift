//
//  TemperatureGapView.swift
//  Kloudy
//
//  Created by Hyeongjung on 2022/11/27.
//

import UIKit
import SnapKit
import RxSwift

class TemperatureGapView: UIView {
    let sentWeather = PublishSubject<Weather>()
    let disposeBag = DisposeBag()
    var weathers: Weather?
    
    let maxTemperatureStackView = UIStackView()
    let minTemperatureStackView = UIStackView()
    let maxTemperatureTextStackView = UIStackView()
    let minTemperatureTextStackView = UIStackView()
    let todayMaxTemperatureView = UIView()
    let todayMinTemperatureView = UIView()
    let yesterdayMaxTemperatureView = UIView()
    let yesterdayMinTemperatureView = UIView()
    let todayMaxTemperatureLabel = UILabel()
    let todayMinTemperatureLabel = UILabel()
    let yesterdayMaxTemperatureLabel = UILabel()
    let yesterdayMinTemperatureLabel = UILabel()
    let maxTemperatureTextLabel: UILabel = {
        let maxTemperatureTextLabel = UILabel()
        maxTemperatureTextLabel.configureLabel(text: "최고", font: UIFont.KFont.appleSDNeoBold15, textColor: UIColor.KColor.black)
        return maxTemperatureTextLabel
    }()
    let minTemperatureTextLabel: UILabel = {
        let minTemperatureTextLabel = UILabel()
        minTemperatureTextLabel.configureLabel(text: "최저", font: UIFont.KFont.appleSDNeoBold15, textColor: UIColor.KColor.black)
        return minTemperatureTextLabel
    }()
    let maxTemperatureView = UIView()
    let minTemperatureView = UIView()
    let maxTemperatureLabel = UILabel()
    let minTemperatureLabel = UILabel()
    let maxTemperatureImage = UIImageView()
    let minTemperatureImage = UIImageView()
    
    var yesterdayMaxHeight: Int = 0
    var todayMaxHeight: Int = 0
    var yesterdayMinHeight: Int = 0
    var todayMinHeight: Int = 0
    
    init() {
        super.init(frame: .zero)
        bind()
    }
    
    private func bind() {
        sentWeather
            .subscribe(onNext: {
                self.weathers = $0
                self.addLayout()
                self.addData()
                self.setLayout()
            })
            .disposed(by: disposeBag)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addLayout() {
        [maxTemperatureStackView, minTemperatureStackView, maxTemperatureTextStackView, minTemperatureTextStackView].forEach { self.addSubview($0) }
        [yesterdayMaxTemperatureView, todayMaxTemperatureView].forEach { maxTemperatureStackView.addArrangedSubview($0) }
        [yesterdayMinTemperatureView, todayMinTemperatureView].forEach { minTemperatureStackView.addArrangedSubview($0) }
        yesterdayMaxTemperatureView.addSubview(yesterdayMaxTemperatureLabel)
        todayMaxTemperatureView.addSubview(todayMaxTemperatureLabel)
        yesterdayMinTemperatureView.addSubview(yesterdayMinTemperatureLabel)
        todayMinTemperatureView.addSubview(todayMinTemperatureLabel)
        
        [maxTemperatureTextLabel, maxTemperatureView].forEach { maxTemperatureTextStackView.addArrangedSubview($0) }
        [minTemperatureTextLabel, minTemperatureView].forEach { minTemperatureTextStackView.addArrangedSubview($0) }
        [maxTemperatureLabel, maxTemperatureImage].forEach { maxTemperatureView.addSubview($0) }
        [minTemperatureLabel, minTemperatureImage].forEach { minTemperatureView.addSubview($0) }
    }
    
    private func addData() {
        guard let weathers = weathers else { return }
        let todayMaxTemperature = weathers.localWeather[0].minMaxTemperature()[1]
        let todayMinTemperature = weathers.localWeather[0].minMaxTemperature()[2]
        let yesterdayMaxTemperature = Int(weathers.localWeather[0].weatherIndex[0].compareIndex[0].yesterdayMaxTemperature)
        let yesterdayMinTemperature = Int(weathers.localWeather[0].weatherIndex[0].compareIndex[0].yesterdayMinTemperature)
        let maxTemp = max(todayMaxTemperature, yesterdayMaxTemperature)
        let minTemp = min(todayMinTemperature, yesterdayMinTemperature)
        let total = minTemp > 0 ? maxTemp : Int(abs(maxTemp) + abs(minTemp))
        let compareMax = todayMaxTemperature - yesterdayMaxTemperature
        let compareMin = todayMinTemperature - yesterdayMinTemperature
        
        yesterdayMaxHeight = (Int(150 * yesterdayMaxTemperature / total)) + 30
        todayMaxHeight = (Int(150 * todayMaxTemperature / total)) + 30
        yesterdayMinHeight = (Int(150 * yesterdayMinTemperature / total)) + 30
        todayMinHeight = (Int(150 * todayMinTemperature / total)) + 30
        
        maxTemperatureLabel.configureLabel(text: "\(abs(compareMax))°", font: UIFont.KFont.lexendRegular24, textColor: UIColor.KColor.black)
        minTemperatureLabel.configureLabel(text: "\(abs(compareMin))°", font: UIFont.KFont.lexendRegular24, textColor: UIColor.KColor.black)
        yesterdayMaxTemperatureLabel.configureLabel(text: "\(Int(yesterdayMaxTemperature))", font: UIFont.KFont.lexendRegular16, textColor: UIColor.KColor.gray02)
        todayMaxTemperatureLabel.configureLabel(text: "\(Int(todayMaxTemperature))", font: UIFont.KFont.lexendRegular16, textColor: UIColor.KColor.white)
        yesterdayMinTemperatureLabel.configureLabel(text: "\(Int(yesterdayMinTemperature))", font: UIFont.KFont.lexendRegular16, textColor: UIColor.KColor.gray02)
        todayMinTemperatureLabel.configureLabel(text: "\(Int(todayMinTemperature))", font: UIFont.KFont.lexendRegular16, textColor: UIColor.KColor.white)
        
        switch compareMax {
        case _ where compareMax > 0:
            configureUIImageView(view: maxTemperatureImage, named: "max_up")
        case _ where compareMax < 0:
            configureUIImageView(view: maxTemperatureImage, named: "max_down")
        case _ where compareMax == 0:
            configureUIImageView(view: maxTemperatureImage, named: "max_same")
        default:
            break
        }
        switch compareMin {
        case _ where compareMin > 0:
            configureUIImageView(view: minTemperatureImage, named: "min_up")
        case _ where compareMin < 0:
            configureUIImageView(view: minTemperatureImage, named: "min_down")
        case _ where compareMin == 0:
            configureUIImageView(view: minTemperatureImage, named: "min_same")
        default:
            break
        }
    }
    
    private func setLayout() {
        self.backgroundColor = UIColor.KColor.clear
        yesterdayMaxTemperatureView.backgroundColor = UIColor.KColor.gray04
        todayMaxTemperatureView.backgroundColor = UIColor.KColor.orange01
        yesterdayMinTemperatureView.backgroundColor = UIColor.KColor.gray04
        todayMinTemperatureView.backgroundColor = UIColor.KColor.primaryBlue01
        [yesterdayMaxTemperatureView, todayMaxTemperatureView, yesterdayMinTemperatureView, todayMinTemperatureView].forEach {
            $0.layer.cornerRadius = 8
        }
        
        [maxTemperatureStackView, minTemperatureStackView, maxTemperatureTextStackView, minTemperatureTextStackView].forEach { self.addSubview($0) }
        [yesterdayMaxTemperatureView, todayMaxTemperatureView].forEach { maxTemperatureStackView.addArrangedSubview($0) }
        [yesterdayMinTemperatureView, todayMinTemperatureView].forEach { minTemperatureStackView.addArrangedSubview($0) }
        [maxTemperatureTextLabel, maxTemperatureView].forEach { maxTemperatureTextStackView.addArrangedSubview($0) }
        [minTemperatureTextLabel, minTemperatureView].forEach { minTemperatureTextStackView.addArrangedSubview($0) }
        yesterdayMaxTemperatureView.addSubview(yesterdayMaxTemperatureLabel)
        todayMaxTemperatureView.addSubview(todayMaxTemperatureLabel)
        yesterdayMinTemperatureView.addSubview(yesterdayMinTemperatureLabel)
        todayMinTemperatureView.addSubview(todayMinTemperatureLabel)
        
        [maxTemperatureStackView, minTemperatureStackView].forEach {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.distribution = .fillProportionally
            $0.alignment = .bottom
        }
        [minTemperatureTextStackView, maxTemperatureTextStackView].forEach {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.distribution = .fillProportionally
            $0.alignment = .center
        }
        
        maxTemperatureTextStackView.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview().inset(7)
            $0.height.equalTo(31.5)
        }
        minTemperatureTextStackView.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(7)
            $0.height.equalTo(31.5)
        }
        maxTemperatureView.snp.makeConstraints {
            $0.height.equalToSuperview()
        }
        [maxTemperatureLabel, minTemperatureLabel].forEach { label in
            label.snp.makeConstraints {
                $0.top.leading.equalToSuperview()
                $0.bottom.equalToSuperview().inset(1.5)
            }
        }
        maxTemperatureImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(7)
            $0.leading.equalTo(maxTemperatureLabel.snp.trailing).offset(3)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(12)
            $0.height.equalTo(16)
        }
        minTemperatureImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(7)
            $0.leading.equalTo(minTemperatureLabel.snp.trailing).offset(3)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(12)
            $0.height.equalTo(16)
        }
        
        // 차트 스택뷰
        maxTemperatureStackView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.bottom.equalTo(maxTemperatureTextStackView.snp.top).offset(-12)
            $0.width.equalTo(88)
        }
        minTemperatureStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(maxTemperatureTextStackView.snp.top).offset(-12)
            $0.width.equalTo(88)
        }
        
        yesterdayMaxTemperatureView.snp.makeConstraints {
            $0.height.equalTo(yesterdayMaxHeight)
        }
        todayMaxTemperatureView.snp.makeConstraints {
            $0.height.equalTo(todayMaxHeight)
        }
        yesterdayMinTemperatureView.snp.makeConstraints {
            $0.height.equalTo(yesterdayMinHeight)
        }
        todayMinTemperatureView.snp.makeConstraints {
            $0.height.equalTo(todayMinHeight)
        }
        
        [yesterdayMaxTemperatureLabel, todayMaxTemperatureLabel, yesterdayMinTemperatureLabel, todayMinTemperatureLabel].forEach { label in
            label.snp.makeConstraints {
                $0.bottom.equalToSuperview().inset(8)
                $0.centerX.equalToSuperview()
                $0.height.equalTo(20)
            }
        }
    }
    private func configureUIImageView(view: UIImageView, named: String) {
        view.image = UIImage(named: named)
        view.contentMode = .scaleAspectFit
    }
}

class maxTemperatureLabel: UILabel {
    private var padding = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        
        return contentSize
    }
}

class minTemperatureTextLabel: UILabel {
    private var padding = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        
        return contentSize
    }
}
