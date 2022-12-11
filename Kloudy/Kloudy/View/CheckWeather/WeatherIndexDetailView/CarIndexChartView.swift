//
//  CarIndexChartView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/12/11.
//

import UIKit
import Charts
import SnapKit
import RxSwift

class CarChartView: UIView {
    var data = [Double]()
    let xAxis = ["1일 후".localized, "2일 후".localized, "3일 후".localized, "4일 후".localized, "5일 후".localized, "6일 후".localized, "7일 후".localized]
    var barChartEntry = [BarChartDataEntry]()
    
    let disposeBag = DisposeBag()
    let chartView = BarChartView()
    let chartLabel = UILabel()
    let chartUnit = UILabel()
    
    let chartLabelText: BehaviorSubject<String> = BehaviorSubject(value: "")
    let chartUnitText: BehaviorSubject<String> = BehaviorSubject(value: "")
    let chartWeeklyPrecipitationData = PublishSubject<[PrecipitationDaily]>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        chartLabelText
            .subscribe(onNext: {
                self.configureChartLabel(text: $0)
            })
            .disposed(by: disposeBag)
        
        chartUnitText
            .subscribe(onNext: {
                self.configureChartUnit(text: $0)
            })
            .disposed(by: disposeBag)
        
        chartWeeklyPrecipitationData
            .subscribe(onNext: {
                $0.forEach { weeklyData in
                    self.data.append(weeklyData.precipitation)
                }
                self.deliverChartData()
            })
            .disposed(by: disposeBag)
    }
    
    private func deliverChartData() {
        for index in data.indices {
            let value = BarChartDataEntry(x: Double(index), y: round(data[index] * 10) / 10)
            barChartEntry.append(value)
        }
        configureChart(chartEntry: barChartEntry)
    }
    
    private func layout() {
        [chartLabel, chartUnit, chartView].forEach{ self.addSubview($0) }
        
        chartLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5)
            $0.leading.equalToSuperview().inset(10)
            $0.height.equalTo(17)
        }
        
        chartUnit.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(chartLabel.snp.trailing).offset(4)
            $0.height.equalTo(25)
        }
        
        chartView.snp.makeConstraints {
            $0.top.equalTo(chartUnit.snp.top).offset(17)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(190)
        }
    }

    private func configureChartLabel(text: String) {
        chartLabel.configureLabel(text: text, font: UIFont.KFont.appleSDNeoMedium14, textColor: UIColor.KColor.gray01)
    }
    
    private func configureChartUnit(text: String) {
        chartUnit.configureLabel(text: text, font: UIFont.KFont.appleSDNeoSemiBold20, textColor: UIColor.KColor.black)
    }
    
    private func configureChart(chartEntry: [ChartDataEntry]) {
        let barChartDataSet = BarChartDataSet(entries: chartEntry)
        barChartDataSet.colors = [UIColor.KColor.chartBlue.withAlphaComponent(0.5)]
        barChartDataSet.highlightEnabled = false
        
        let chartData = BarChartData(dataSet: barChartDataSet)
        chartData.setDrawValues(false)
        chartView.data = chartData
        
        chartView.legend.enabled = false
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = true
        chartView.rightAxis.gridColor = UIColor.KColor.gray03
        chartView.rightAxis.axisLineColor = UIColor.KColor.clear
        chartView.rightAxis.labelFont = UIFont.KFont.lexendLight14
        chartView.rightAxis.setLabelCount(5, force: false)
        
        chartView.doubleTapToZoomEnabled = false
        chartView.animate(yAxisDuration: 1.0)
        chartView.backgroundColor = UIColor.KColor.clear
        chartView.borderColor = UIColor.KColor.clear
        chartView.drawBordersEnabled = true
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = UIFont.KFont.lexendLight12
        chartView.xAxis.labelTextColor = UIColor.KColor.black
        chartView.xAxis.setLabelCount(xAxis.count, force: false)
        chartView.xAxis.drawAxisLineEnabled = false
        
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxis)
        chartView.xAxis.granularity = 1
        
        chartView.xAxis.gridLineWidth = 1.0
        chartView.xAxis.gridLineDashPhase = 1.0
        chartView.xAxis.gridLineDashLengths = [5]
        chartView.xAxis.gridColor = UIColor.KColor.primaryBlue05
        chartView.drawGridBackgroundEnabled = true
        chartView.gridBackgroundColor = UIColor.KColor.gray05
    }
}
