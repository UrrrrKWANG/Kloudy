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
    
    private let disposeBag = DisposeBag()
    
    lazy var labelInTodayCollectionView: UILabel = {
        let uiLabel = UILabel()
        uiLabel.configureLabel(text: "시간대별 날씨", font: UIFont.KFont.appleSDNeoMediumSmall, textColor: UIColor.KColor.black)
        return uiLabel
    }()
    
    lazy var labelInWeekCollectionView: UILabel = {
        let label = UILabel()
        label.configureLabel(text: "주간 날씨", font: UIFont.KFont.appleSDNeoMediumSmall, textColor: UIColor.KColor.black)
        return label
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.KColor.white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.automaticallyAdjustsScrollIndicatorInsets = false
        
        return scrollView
    }()

    
    let viewModel = weatehrViewModel()
    
    lazy var todayCollectionView = makeCollectionView(direction: .horizontal, itemSizeWith: 65, itemSizeheight: 100, cell: TodayWeatherDataCell.self, identifier: TodayWeatherDataCell.identifier, contentInsetLeft: 0, contentInsetRight: 0)
    lazy var weekCollectionView = makeCollectionView(direction: .vertical, itemSizeWith: 348, itemSizeheight: 60, cell: WeekWeatherDataCell.self, identifier: WeekWeatherDataCell.identifier, contentInsetLeft: 16, contentInsetRight: 16)
    
    let weatherCondition = UIImageView()
    
    let currentTemperature: UILabel = {
        let uiLabel = UILabel()
        uiLabel.configureLabel(text: "", font: UIFont.KFont.lexendMedium, textColor: .white)
        return uiLabel
    }()
    
    let minMaxTemperatureLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.configureLabel(text: "", font: UIFont.KFont.lexendSmall, textColor:  UIColor.KColor.primaryBlue01)
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
        [weatherCondition, currentTemperature, minMaxTemperatureLabel].forEach() {
            uiView.addSubview($0)
        }
        self.weatherCondition.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(10)
            $0.size.equalTo(42)
            $0.centerY.equalToSuperview()
        }
        self.currentTemperature.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(weatherCondition.snp.trailing).offset(10)
        }
        self.minMaxTemperatureLabel.snp.makeConstraints{
            $0.height.equalTo(38)
            $0.trailing.equalToSuperview().inset(10)
            $0.leading.trailing.equalTo(260)
            $0.centerY.equalToSuperview()
        }
        return uiView
    }()
    
    let dividingLineView: UIView = {
        let uiView = UIView()
        uiView.frame = CGRect(x: 0, y: 0, width: 330, height: 13)
        uiView.backgroundColor = UIColor.KColor.primaryBlue06
        return uiView
    }()
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.KColor.white
        addLayout()
        setUplayout()
        bind()

    }
    
    func makeCollectionView(direction: UICollectionView.ScrollDirection, itemSizeWith: Int, itemSizeheight: Int, cell: AnyClass, identifier: String, contentInsetLeft: Int, contentInsetRight: Int) -> UICollectionView {

        let layout = UICollectionViewFlowLayout() // collectionView layout설정
        layout.scrollDirection = direction // collectionView 스크롤 방향 , 수평
        layout.itemSize = CGSize(width: itemSizeWith, height: itemSizeheight) // cellSize
       
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.KColor.primaryBlue06  // collectionView 배경색
        collectionView.layer.cornerRadius = 15 //collectionView radius
        collectionView.contentInset = UIEdgeInsets(top: 0, left: CGFloat(contentInsetLeft), bottom: 0, right: CGFloat(contentInsetRight)) // cell 여백
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
            $0.top.equalToSuperview().inset(30)
            $0.height.equalTo(62)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(350)
        }
        
        labelInWeekCollectionView.snp.makeConstraints{
            $0.top.equalTo(dividingLineView.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(10)
        }
        
        labelInTodayCollectionView.snp.makeConstraints{
            $0.top.equalTo(titleWeatherView.snp.bottom).offset(50)
            $0.leading.equalToSuperview().inset(10)
        }
        
        todayCollectionView.snp.makeConstraints{
            $0.top.equalTo(labelInTodayCollectionView.snp.bottom).offset(10)
            $0.width.equalTo(350)
            $0.height.equalTo(146)
            $0.centerX.equalToSuperview()
        }
        
        dividingLineView.snp.makeConstraints{
            $0.top.equalTo(todayCollectionView.snp.bottom).offset(30)
            $0.height.equalTo(1)
            $0.width.equalTo(330)
            $0.centerX.equalToSuperview()
        }
        
        weekCollectionView.snp.makeConstraints{
            $0.top.equalTo(labelInWeekCollectionView.snp.bottom).offset(10)
            $0.bottom.equalToSuperview()
            $0.width.equalTo(350)
            $0.height.equalTo(520)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func bind() {
        self.todayBind()
        self.weekBind()
    }
    
    private func todayBind() {
        viewModel.todayWeatherDatas.bind(to:
                                            self.todayCollectionView.rx.items(cellIdentifier: TodayWeatherDataCell.identifier, cellType:  TodayWeatherDataCell.self))
        { index, datas, cell in
            
            if index == 0 {
                cell.time.text = "지금"
            } else {
                cell.time.text =  Date().getTimeOfDay(hour: index)
            }
            let weatherCondition = self.findWeatehrCondition(weatherCondition: datas.status)
            cell.weatherCondition.image = UIImage(named: weatherCondition)
            if index == 0 {
                self.currentTemperature.text = String(Int(datas.temperature)) + "°"
            }
            cell.temperature.text = String(Int(datas.temperature)) + "°"
        }
        .disposed(by: disposeBag)
    }
    private func weekBind() {
        viewModel.weekWeatherDatas.bind(to:
                                            self.weekCollectionView.rx.items(cellIdentifier: WeekWeatherDataCell.identifier, cellType: WeekWeatherDataCell.self))
        { index, datas, cell in
            if index == 0 {
                cell.dayLabel.text = "지금"
            } else {
                cell.dayLabel.text = Date().getDayOfWeek(day: index)
            }
            let weatherCondition = self.findWeatehrCondition(weatherCondition: datas.status)
            if index == 0 {
                self.weatherCondition.image = UIImage(named: weatherCondition)
                self.minMaxTemperatureLabel.text = String(Int(datas.minTemperature)) + "°" + " |  " + String(Int(datas.maxTemperature)) + "°"
            }
            cell.weatherCondition.image = UIImage(named: weatherCondition)
            cell.minTemperature.text = String(Int(datas.minTemperature)) + "°"
            cell.maxTemperature.text = String(Int(datas.maxTemperature)) + "°"
        }
        .disposed(by: disposeBag)
    }
    
    private func findWeatehrCondition(weatherCondition: Int) -> String {
        switch weatherCondition {
        case 0:  return "detailWeather-0"
        case 1:  return "detailWeather-1"
        case 2:  return "detailWeather-2"
        case 3:  return "detailWeather-3"
        case 4:  return "detailWeather-4"
        case 5:  return "detailWeather-5"
        default:
            return ""
        }
    }
}

extension Date {
    public func getDayOfWeek(day: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat =  "EEEEEE"
        formatter.locale = Locale(identifier: "ko_KR")
        let convertStr = formatter.string(from:  Date() + TimeInterval(86400 * day))
        return convertStr
    }
    
    public func getTimeOfDay(hour: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h시"
        formatter.locale = Locale(identifier: "ko_KR")
        let convertStr = formatter.string(from:  Date() + TimeInterval(3600 * hour))
        return convertStr
    }
}
