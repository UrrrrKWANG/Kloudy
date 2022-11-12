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
        let label = UILabel()
        label.configureLabel(text: "시간대별 날씨", font: UIFont.KFont.appleSDNeoMediumSmall, textColor: UIColor.KColor.white)
        label.textColor = .black
        return label
    }()
    
    lazy var labelInWeekCollectionView: UILabel = {
        let label = UILabel()
        label.configureLabel(text: "주간 날씨", font: UIFont.KFont.appleSDNeoMediumSmall, textColor: UIColor.KColor.white)
        label.textColor = .black
        return label
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.automaticallyAdjustsScrollIndicatorInsets = false
        
        return scrollView
    }()

    
    let viewModel = weatehrViewModel()
    let todayCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout() // collectionView layout설정
        layout.scrollDirection = .horizontal // collectionView 스크롤 방향 , 수평
        layout.itemSize = CGSize(width: 65, height: 100) // cellSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.cyan  // collectionView 배경색
        collectionView.layer.cornerRadius = 15 //collectionView radius
        collectionView.register(TodayWeatherdataCell.self, forCellWithReuseIdentifier: TodayWeatherdataCell.identifier) // cell 등록
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) // cell 여백
        return collectionView
    }()
    
    let weekCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout() // collectionView layout설정
        layout.scrollDirection = .vertical  // collectionView 스크롤 방향 , 수직
        layout.itemSize = CGSize(width: 348, height: 60) // cellSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.cyan // collectionView 배경색
        collectionView.layer.cornerRadius = 15 //collectionView radius
        collectionView.register(WeekWeatherdataCell.self, forCellWithReuseIdentifier: WeekWeatherdataCell.identifier) // cell 등록
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0) // cell 여백
        return collectionView
    }()
    
    let weatherCondition = UIImageView()
    
    let currentTemperature: UILabel = {
        var label = UILabel()
        label.font = UIFont.KFont.lexendMedium
        label.textColor = .white
        return label
    }()
    
    let minMaxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.KFont.lexendSmall
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        label.backgroundColor = .white
        label.textColor = .blue
        label.textAlignment = .center
        return label
    }()
    
    lazy var titleWeatherView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.blue
        uiView.layer.cornerRadius = 15
        [weatherCondition, currentTemperature, minMaxTemperatureLabel].forEach() {
            uiView.addSubview($0)
        }
        self.weatherCondition.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(10)
            $0.size.equalTo(42)
            $0.centerY.equalToSuperview()
        }
        self.currentTemperature.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(weatherCondition.snp.trailing).offset(10)
        }
        self.minMaxTemperatureLabel.snp.makeConstraints{
            $0.height.equalTo(38)
            $0.trailing.equalToSuperview().offset(-10)
            $0.leading.trailing.equalTo(260)
            $0.centerY.equalToSuperview()
        }
        return uiView
    }()
    
    let dividingLineView: UIView = {
        let uiView = UIView()
        uiView.frame = CGRect(x: 0, y: 0, width: 330, height: 13)
        uiView.backgroundColor = .gray
        return uiView
    }()
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        addLayout()
        setUplayout()
        bind()

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
            $0.top.equalToSuperview().offset(30)
            $0.height.equalTo(62)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(350)
        }
        
        labelInWeekCollectionView.snp.makeConstraints{
            $0.top.equalTo(dividingLineView.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(10)
        }
        
        labelInTodayCollectionView.snp.makeConstraints{
            $0.top.equalTo(titleWeatherView.snp.bottom).offset(50)
            $0.leading.equalToSuperview().offset(10)
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
                                            self.todayCollectionView.rx.items(cellIdentifier: TodayWeatherdataCell.identifier, cellType:  TodayWeatherdataCell.self))
        { index, datas, cell in
            
            if index == 0 {
                cell.time.text = "지금"
            } else {
                cell.time.text =  self.getTimeOfDay(hour: index)
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
                                            self.weekCollectionView.rx.items(cellIdentifier: WeekWeatherdataCell.identifier, cellType: WeekWeatherdataCell.self))
        { index, datas, cell in
            if index == 0 {
                cell.dayLabel.text = "지금"
            } else {
                cell.dayLabel.text = self.getDayOfWeek(day: index)
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
    
    private func getDayOfWeek(day: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEEEE"
        formatter.locale = Locale(identifier: "ko_KR")
        let convertStr = formatter.string(from:  Date() + TimeInterval(86400 * day))
        return convertStr
    }
    
    private func getTimeOfDay(hour: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h시"
        formatter.locale = Locale(identifier: "ko_KR")
        let convertStr = formatter.string(from:  Date() + TimeInterval(3600 * hour))
        return convertStr
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
