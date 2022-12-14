//
//  DetailWeatherView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/11/07.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class DetailWeatherView: UIViewController {
    
    var todayWeatherDatas = Observable.of([HourlyWeather]())
    var weekWeatherDatas = Observable.of([WeeklyWeather]())
    var currentLocationName = String()
    var temperatureList: [Int] = []
    var weather: Weather?
    
    init(weatherDatas: Weather) {
        super.init(nibName: nil, bundle: nil)
        self.weather = weatherDatas
        let todayWeatherDatas = Observable.of(weatherDatas.localWeather[0].hourlyWeather
            .filter({$0.hour >= 2}))
        let weekWeatherDatas = Observable.of(weatherDatas.localWeather[0].weeklyWeather)
        self.todayWeatherDatas = todayWeatherDatas
        self.weekWeatherDatas = weekWeatherDatas
        self.currentLocationName = weatherDatas.localWeather[0].localName
        temperatureList = weatherDatas.localWeather[0].minMaxTemperature()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private let disposeBag = DisposeBag()
    lazy var labelInTodayCollectionView: UILabel = {
        let uiLabel = UILabel()
        uiLabel.configureLabel(text: "시간대별 날씨".localized, font: UIFont.KFont.appleSDNeoBold20, textColor: UIColor.KColor.black)
        return uiLabel
    }()
    
    lazy var labelInWeekCollectionView: UILabel = {
        let label = UILabel()
        label.configureLabel(text: "주간 날씨".localized, font: UIFont.KFont.appleSDNeoBold20, textColor: UIColor.KColor.black)
        return label
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = UIColor.KColor.white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.automaticallyAdjustsScrollIndicatorInsets = false
        return scrollView
    }()
    
    lazy var todayCollectionView = makeCollectionView(direction: .horizontal, itemSizeWith: 65, itemSizeheight: 100, cell: TodayWeatherDataCell.self, identifier: TodayWeatherDataCell.identifier, contentInsetLeft: -2, contentInsetRight: 0, isScroll: true, minimumLineSpacing: 15)
    lazy var weekCollectionView = makeCollectionView(direction: .vertical, itemSizeWith: 348, itemSizeheight: 59, cell: WeekWeatherDataCell.self, identifier: WeekWeatherDataCell.identifier, contentInsetLeft: 0, contentInsetRight: 0, isScroll: false, minimumLineSpacing: 0)
    
    lazy var titleWeatherCondition: UIImageView = {
        let uiImageView = UIImageView()
        uiImageView.contentMode = .scaleAspectFit
        uiImageView.image = UIImage(named: "location_mark")
        return uiImageView
    }()
    
    lazy var currentLocationLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.configureLabel(text: self.currentLocationName.localized, font: UIFont.KFont.appleSDNeoBold18, textColor: UIColor.KColor.white)
        return uiLabel
    }()
    
    lazy var currentTemperature: UILabel = {
        let uiLabel = UILabel()
        uiLabel.configureLabel(text: String(self.temperatureList[0]) + "°", font: UIFont.KFont.lexendRegular26, textColor: UIColor.KColor.white)
        return uiLabel
    }()
    
    let minMaxTemperatureLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.configureLabel(text: "", font: UIFont.KFont.lexendRegular17, textColor:  UIColor.KColor.primaryBlue01)
        uiLabel.clipsToBounds = true
        uiLabel.backgroundColor = UIColor.KColor.white
        uiLabel.textAlignment = .center
        uiLabel.layer.cornerRadius = 10
        return uiLabel
    }()
    
    lazy var titleWeatherView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.KColor.primaryBlue01
        uiView.layer.cornerRadius = 15
        [titleWeatherCondition, currentLocationLabel, currentTemperature, minMaxTemperatureLabel].forEach() {
            uiView.addSubview($0)
        }
        self.titleWeatherCondition.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(18)
            $0.top.equalToSuperview().inset(22)
            $0.height.equalTo(18)
            $0.width.equalTo(15)
        }
        
        self.currentLocationLabel.snp.makeConstraints{
            $0.leading.equalTo(titleWeatherCondition.snp.trailing).offset(8)
            $0.top.equalToSuperview().inset(21)
            $0.bottom.equalToSuperview().inset(19)
        }
        
        self.currentTemperature.snp.makeConstraints{
            $0.trailing.equalTo(minMaxTemperatureLabel.snp.leading).offset(-8)
            $0.top.bottom.equalToSuperview().inset(12)
        }
        self.minMaxTemperatureLabel.snp.makeConstraints{
            $0.trailing.top.bottom.equalToSuperview().inset(12)
            $0.width.equalTo(96)
        }
        return uiView
    }()
    
    let dividingLineView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.KColor.primaryBlue06
        return uiView
    }()
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.KColor.white
        addLayout()
        setUplayout()
        bind()
    }
    
    func makeCollectionView(direction: UICollectionView.ScrollDirection, itemSizeWith: Int, itemSizeheight: Int, cell: AnyClass, identifier: String, contentInsetLeft: Int, contentInsetRight: Int, isScroll: Bool, minimumLineSpacing: CGFloat) -> UICollectionView {
        
        let layout = UICollectionViewFlowLayout() // collectionView layout설정
        layout.scrollDirection = direction // collectionView 스크롤 방향 , 수평
        layout.itemSize = CGSize(width: itemSizeWith, height: itemSizeheight) // cellSize
        layout.minimumLineSpacing = minimumLineSpacing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = isScroll
        collectionView.backgroundColor = UIColor.KColor.primaryBlue07  // collectionView 배경색
        collectionView.layer.cornerRadius = 15 //collectionView radius
        collectionView.contentInset = UIEdgeInsets(top: 10, left: CGFloat(contentInsetLeft), bottom: 0, right: CGFloat(contentInsetRight)) // cell 여백
        collectionView.register(cell, forCellWithReuseIdentifier:identifier) // cell 등록
        return collectionView
    }
    
    private func addLayout() {
        self.view.addSubview(scrollView)
        [titleWeatherView, labelInWeekCollectionView, labelInTodayCollectionView, todayCollectionView, dividingLineView,weekCollectionView].forEach() {
            scrollView.addSubview($0)
        }
    }
    
    private func setUplayout() {
        scrollView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.size.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        titleWeatherView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.height.equalTo(62)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        labelInTodayCollectionView.snp.makeConstraints{
            $0.top.equalTo(titleWeatherView.snp.bottom).offset(40)
            $0.leading.equalToSuperview().inset(20)
        }
        
        todayCollectionView.snp.makeConstraints{
            $0.top.equalTo(labelInTodayCollectionView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(146)
            $0.centerX.equalToSuperview()
        }
        
        dividingLineView.snp.makeConstraints{
            $0.top.equalTo(todayCollectionView.snp.bottom).offset(40)
            $0.height.equalTo(2)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.centerX.equalToSuperview()
        }
        
        labelInWeekCollectionView.snp.makeConstraints{
            $0.top.equalTo(dividingLineView.snp.bottom).offset(40)
            $0.leading.equalToSuperview().inset(20)
        }
        
        weekCollectionView.snp.makeConstraints{
            $0.top.equalTo(labelInWeekCollectionView.snp.bottom).offset(12)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(440)
        }
    }
    
    private func bind() {
        self.todayBind()
        self.weekBind()
    }
    
    private func todayBind() {
        todayWeatherDatas.bind(to:self.todayCollectionView.rx.items(cellIdentifier: TodayWeatherDataCell.identifier, cellType:  TodayWeatherDataCell.self))
        { index, datas, cell in
            
            if index == 0 {
                cell.time.text = "지금".localized
                cell.temperature.text = String(self.temperatureList[0]) + "°"
                guard let weather = self.weather else { return }
                cell.weatherCondition.image = UIImage(named: "hourWeather-\(weather.localWeather[0].main[0].currentWeather)")
            } else {
                cell.time.text =  Date().getTimeOfDay(hour: index)
                cell.temperature.text = String(Int(datas.temperature)) + "°"
                let weatherCondition = self.findWeatehrCondition(weatherCondition: datas.status)
                cell.weatherCondition.image = UIImage(named: weatherCondition[0])
            }
            
           
        }
        .disposed(by: disposeBag)
    }
    
    private func weekBind() {
        weekWeatherDatas.bind(to:
                                self.weekCollectionView.rx.items(cellIdentifier: WeekWeatherDataCell.identifier, cellType: WeekWeatherDataCell.self))
        { [self] index, datas, cell in
            if index == 0 {
                cell.dayLabel.text = "오늘".localized
            } else {
                cell.dayLabel.text = Date().getDayOfWeek(day: index)
            }
            let weatherCondition = self.findWeatehrCondition(weatherCondition: datas.status)
            
            if index == 0 {
                self.minMaxTemperatureLabel.text = String(self.temperatureList[2]) + "°" + " |  " + String(self.temperatureList[1]) + "°"
                let attribtuedMaxTemperature = NSMutableAttributedString(string: minMaxTemperatureLabel.text ?? "")
                let maxStringRange = (minMaxTemperatureLabel.text! as NSString).range(of: String(self.temperatureList[1]) + "°")
                attribtuedMaxTemperature.addAttribute(.foregroundColor, value: UIColor.KColor.orange01, range: maxStringRange)
                minMaxTemperatureLabel.attributedText = attribtuedMaxTemperature
                let dividingStringRange = (minMaxTemperatureLabel.text! as NSString).range(of: " |  ")
                attribtuedMaxTemperature.addAttribute(.foregroundColor, value: UIColor.KColor.primaryBlue05, range: dividingStringRange)
                minMaxTemperatureLabel.attributedText = attribtuedMaxTemperature
                
                cell.minTemperature.text = String(self.temperatureList[2]) + "°"
                cell.maxTemperature.text = String(self.temperatureList[1]) + "°"
            } else {
                cell.minTemperature.text = String(Int(datas.minTemperature)) + "°"
                cell.maxTemperature.text = String(Int(datas.maxTemperature)) + "°"
            }
            cell.weatherCondition.image = UIImage(named: weatherCondition[1])
            
            
            
        }
        .disposed(by: disposeBag)
    }
    
    private func findWeatehrCondition(weatherCondition: Int) -> [String] {
        switch weatherCondition {
        case 0:  return ["hourWeather-0", "weekDetailWeather-0"]
        case 1:  return ["hourWeather-1", "weekDetailWeather-1"]
        case 2:  return ["hourWeather-2", "weekDetailWeather-2"]
        case 3:  return ["hourWeather-3", "weekDetailWeather-3"]
        case 4:  return ["hourWeather-4", "weekDetailWeather-4"]
        case 5:  return ["hourWeather-5", "weekDetailWeather-5"]
        default:
            return [""]
        }
    }
}

extension Date {
    public func getDayOfWeek(day: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat =  "EEEEEE"
        formatter.locale = Locale(identifier: "ko_KR")
        let convertStr = formatter.string(from:  Date() + TimeInterval(86400 * day)).localized
        return convertStr
    }
    
    public func getTimeOfDay(hour: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h시"
        formatter.locale = Locale(identifier: "ko_KR")
        let convertStr = formatter.string(from:  Date() + TimeInterval(3600 * hour)).localized
        return convertStr
    }
    
    public func getTimeOfDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        formatter.locale = Locale(identifier: "ko_KR")
        let convertStr = formatter.string(from:  Date())
        return convertStr
    }
    
    public func getHourOfDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        formatter.locale = Locale(identifier: "ko_KR")
        let convertStr = formatter.string(from: Date())
        return convertStr
    }
}
