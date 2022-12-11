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
        pmStackView.spacing = 10
        pmStackView.distribution = .fillProportionally
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
    
    var yesterdayPM10: Double = 0
    var todayPM10: Double = 0
    let days: [String] = ["어제", "오늘"]
    
    init() {
        super.init(frame: .zero)
        bind()

        self.noDataText = "데이터가 없습니다."
        self.noDataFont = .systemFont(ofSize: 20)
        self.noDataTextColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private func bind() {
        pmDatas
            .subscribe(onNext: {
                self.yesterdayPM10 = $0[0]
                self.todayPM10 = $0[1]
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

        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "미세먼지")

        // 차트 컬러
        chartDataSet.colors = [UIColor.KColor.gray04, UIColor.KColor.orange01]

        // 데이터 삽입
        let chartData = BarChartData(dataSet: chartDataSet)
        self.data = chartData
        
        // 축 커스텀
        self.xAxis.labelPosition = .bottom
        self.rightAxis.enabled = false
        self.xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        
        // X축 레이블 갯수 최대로 설정 (이 코드 안쓸 시 Jan Mar May 이런식으로 띄엄띄엄 조금만 나옴)
        self.xAxis.setLabelCount(dataPoints.count, force: false)
        
        // 줌 안되게
        chartDataSet.highlightEnabled = false
        self.doubleTapToZoomEnabled = false
        
        // 미세먼지 최대 최소
        self.leftAxis.axisMinimum = 0
        
        let compareMax = max(yesterdayPM10, todayPM10)
        if compareMax > 150 {
            self.leftAxis.axisMaximum = compareMax
        } else {
            self.leftAxis.axisMaximum = 150
        }
        
        self.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
}

class PM25View: BarChartView {
    
    var pmDatas = PublishSubject<[Double]>()
    let disposeBag = DisposeBag()
    
    var yesterdayPM25: Double = 0
    var todayPM25: Double = 0
    let days: [String] = ["어제", "오늘"]
    
    init() {
        super.init(frame: .zero)
        bind()

        self.noDataText = "데이터가 없습니다."
        self.noDataFont = .systemFont(ofSize: 20)
        self.noDataTextColor = .lightGray
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private func bind() {
        pmDatas
            .subscribe(onNext: {
                self.yesterdayPM25 = $0[0]
                self.todayPM25 = $0[1]
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

        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "초미세먼지")

        // 차트 컬러
        chartDataSet.colors = [UIColor.KColor.gray04, UIColor.KColor.orange01]

        // 데이터 삽입
        let chartData = BarChartData(dataSet: chartDataSet)
        self.data = chartData
        
        // 축 커스텀
        self.xAxis.labelPosition = .bottom
        self.rightAxis.enabled = false
        self.xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        
        // X축 레이블 갯수 최대로 설정 (이 코드 안쓸 시 Jan Mar May 이런식으로 띄엄띄엄 조금만 나옴)
        self.xAxis.setLabelCount(dataPoints.count, force: false)
        
        // 줌 안되게
        chartDataSet.highlightEnabled = false
        self.doubleTapToZoomEnabled = false
        
        // 미세먼지 최대 최소
        self.leftAxis.axisMinimum = 0
        
        let compareMax = max(yesterdayPM25, todayPM25)
        if compareMax > 80 {
            self.leftAxis.axisMaximum = compareMax
        } else {
            self.leftAxis.axisMaximum = 80
        }
        
        self.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
}
