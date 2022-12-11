//
//  MaskChartView.swift
//  Kloudy
//
//  Created by Hyeongjung on 2022/12/11.
//

import UIKit
import SnapKit
import Charts
import RxSwift

class MaskChartView: UIView {
    
    let disposeBag = DisposeBag()
    lazy var chartPMData = PublishSubject<MaskIndex>()
    
    let pmStackView = UIStackView()
    let pm10View = PM10View()
    let pm25View = PM25View()
    
    init() {
        super.init(frame: .zero)
        bind()
        addLayout()
        setLayout()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private func bind() {
        chartPMData
            .subscribe(onNext: {
                self.pm10View.pmDatas.onNext([$0.yesterdayPM10value, $0.todayPM10value])
                self.pm25View.pmDatas.onNext([$0.yesterdayPM25value, $0.todayPM25value])
            })
            .disposed(by: disposeBag)
    }
    
    private func addLayout() {
        self.addSubview(pmStackView)
        [pm10View, pm25View].forEach { pmStackView.addArrangedSubview($0) }
    }
    
    private func setLayout() {
        
        pmStackView.axis = .horizontal
        pmStackView.spacing = 8
        pmStackView.distribution = .fillEqually
        pmStackView.alignment = .bottom
        
        pmStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        pm10View.snp.makeConstraints {
            $0.height.equalToSuperview()
        }
        pm25View.snp.makeConstraints {
            $0.height.equalToSuperview()
        }
    }
}

class PM10View: BarChartView {
    
    var pmDatas = PublishSubject<[Double]>()
    let disposeBag = DisposeBag()
 
    var pm10Array: [Double] = []
    let days: [String] = ["어제".localized, "오늘".localized]
    
    init() {
        super.init(frame: .zero)
        bind()
        self.noDataText = "데이터가 없습니다.".localized
        self.noDataFont = UIFont.KFont.lexendLight14
        self.noDataTextColor = UIColor.KColor.gray05
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func bind() {
        pmDatas
            .subscribe(onNext: {
                self.pm10Array = $0
                self.setChart(dataPoints: self.days, values: $0)
            })
            .disposed(by: disposeBag)
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }

        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "미세먼지".localized)

        // 차트 컬러
        chartDataSet.colors = [UIColor.KColor.chartBlue.withAlphaComponent(0.5), UIColor.KColor.orange01]

        // 데이터 삽입
        let chartData = BarChartData(dataSet: chartDataSet)
        self.data = chartData
        
        self.xAxis.labelPosition = .top
        
        self.legend.enabled = false
        self.leftAxis.enabled = false
        self.rightAxis.enabled = true
        self.rightAxis.gridColor = UIColor.KColor.gray03
        self.rightAxis.axisLineColor = UIColor.KColor.clear
        self.rightAxis.labelFont = UIFont.KFont.lexendLight14
        self.rightAxis.setLabelCount(5, force: false)

        chartDataSet.highlightEnabled = false
        self.doubleTapToZoomEnabled = false
        
        self.animate(yAxisDuration: 1.0)
        self.backgroundColor = UIColor.KColor.clear
        self.borderColor = UIColor.KColor.clear
        self.drawBordersEnabled = true

        self.xAxis.labelPosition = .bottom
        self.xAxis.labelFont = UIFont.KFont.lexendLight12
        self.xAxis.labelTextColor = UIColor.KColor.black
        self.xAxis.setLabelCount(dataPoints.count, force: false)

        self.xAxis.drawAxisLineEnabled = false
        self.drawGridBackgroundEnabled = true

        self.xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        self.xAxis.granularity = 1

        self.xAxis.gridLineWidth = 1.0
        self.xAxis.gridLineDashPhase = 1.0
        self.xAxis.gridLineDashLengths = [5]
        self.xAxis.gridColor = UIColor.KColor.primaryBlue05
        self.gridBackgroundColor = UIColor.KColor.gray05
        
        // 미세먼지 최대 최소
        let compareMax = pm10Array.max() ?? 0
        
        self.leftAxis.axisMinimum = 0
        if compareMax > 150 {
            self.leftAxis.axisMaximum = compareMax
        } else {
            self.leftAxis.axisMaximum = 150
        }
        
        self.rightAxis.axisMinimum = 0
        if compareMax > 150 {
            self.rightAxis.axisMaximum = compareMax
        } else {
            self.rightAxis.axisMaximum = 150
        }
    }
}

class PM25View: BarChartView {
    
    var pmDatas = PublishSubject<[Double]>()
    let disposeBag = DisposeBag()
    
    var pm25Array: [Double] = []
    let days: [String] = ["어제".localized, "오늘".localized]
    
    init() {
        super.init(frame: .zero)
        bind()
        self.noDataText = "데이터가 없습니다.".localized
        self.noDataFont = UIFont.KFont.lexendLight14
        self.noDataTextColor = UIColor.KColor.gray05
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func bind() {
        pmDatas
            .subscribe(onNext: {
                self.pm25Array = $0
                self.setChart(dataPoints: self.days, values: $0)
            })
            .disposed(by: disposeBag)
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }

        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "초미세먼지".localized)

        // 차트 컬러
        chartDataSet.colors = [UIColor.KColor.chartBlue.withAlphaComponent(0.5), UIColor.KColor.orange01]

        // 데이터 삽입
        let chartData = BarChartData(dataSet: chartDataSet)
        self.data = chartData
        
        self.legend.enabled = false
        self.leftAxis.enabled = false
        self.rightAxis.enabled = true
        self.rightAxis.gridColor = UIColor.KColor.gray03
        self.rightAxis.axisLineColor = UIColor.KColor.clear
        self.rightAxis.labelFont = UIFont.KFont.lexendLight14
        self.rightAxis.setLabelCount(5, force: false)

        chartDataSet.highlightEnabled = false
        self.doubleTapToZoomEnabled = false
        
        self.animate(yAxisDuration: 1.0)
        self.backgroundColor = UIColor.KColor.clear
        self.borderColor = UIColor.KColor.clear
        self.drawBordersEnabled = true

        self.xAxis.labelPosition = .bottom
        self.xAxis.labelFont = UIFont.KFont.lexendLight12
        self.xAxis.labelTextColor = UIColor.KColor.black
        self.xAxis.setLabelCount(dataPoints.count, force: false)

        self.xAxis.drawAxisLineEnabled = false
        self.drawGridBackgroundEnabled = true

        self.xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        self.xAxis.granularity = 1

        self.xAxis.gridLineWidth = 1.0
        self.xAxis.gridLineDashPhase = 1.0
        self.xAxis.gridLineDashLengths = [5]
        self.xAxis.gridColor = UIColor.KColor.primaryBlue05
        self.gridBackgroundColor = UIColor.KColor.gray05
        
        // 미세먼지 최대 최소
        let compareMax = pm25Array.max() ?? 0
        
        self.leftAxis.axisMinimum = 0
        if compareMax > 100 {
            self.leftAxis.axisMaximum = compareMax
        } else {
            self.leftAxis.axisMaximum = 100
        }
        
        self.rightAxis.axisMinimum = 0
        if compareMax > 100 {
            self.rightAxis.axisMaximum = compareMax
        } else {
            self.rightAxis.axisMaximum = 100
        }
    }
    
}
