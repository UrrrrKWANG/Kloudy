//
//  IndexChartView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/11/12.
//

import UIKit
import Charts
import SnapKit
import RxSwift

enum ChartsAxisValue: Int {
    case zero = 0
    case six = 5
    case noon = 11
    case eighteen = 17
    
    var label: String {
        switch self {
        case .zero: return "\(getHourLabel(hourString: Date().getHourOfDay(), plus: 0))"
        case .six: return "\(getHourLabel(hourString: Date().getHourOfDay(), plus: 6))"
        case .noon: return "\(getHourLabel(hourString: Date().getHourOfDay(), plus: 12))"
        case .eighteen: return "\(getHourLabel(hourString: Date().getHourOfDay(), plus: 18))"
        }
    }
    
    private func getHourLabel(hourString: String, plus: Int) -> String {
        let hourInt = (Int(hourString) ?? 0) + plus
        if hourInt > 12 {
            if hourInt > 23 {
                return "\(hourInt - 24)AM"
            } else {
                return "\(hourInt - 12)PM"
            }
        } else {
            return "\(hourInt)AM"
        }
    }
}

enum ChartType {
    case precipitation
    case temperature
}

final class CustomAxisValueFormatter: IndexAxisValueFormatter {
    override func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let intValue = Int(value)
        let customAxis = ChartsAxisValue(rawValue: intValue)
        return customAxis?.label ?? ""
    }
}

class IndexChartView: UIView {
    var data = [Int : Double]()
    var lineChartEntry = [ChartDataEntry]()
    
    let disposeBag = DisposeBag()
    let chartView = LineChartView()
    let chartLabel = UILabel()
    let chartUnit = UILabel()
    
    let chartLabelText: BehaviorSubject<String> = BehaviorSubject(value: "")
    let chartUnitText: BehaviorSubject<String> = BehaviorSubject(value: "")
    
    lazy var chartPrecipitationHourlyData = PublishSubject<[UmbrellaHourly]>()
    lazy var chartHumidityData = PublishSubject<[HumidityHourly]>()
    lazy var chartPrecipitationDailyData = PublishSubject<[PrecipitationDaily]>()
    lazy var chartTemperatureData = PublishSubject<[HourlyWeather]>()
    
    var isTemperatureData: Bool = false
    
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
        
        chartPrecipitationHourlyData
            .subscribe(onNext: {
                $0.forEach { hourlyData in
                    self.data[hourlyData.time] = hourlyData.precipitation
                }
                self.isTemperatureData = false
                self.deliverChartData()
            })
            .disposed(by: disposeBag)
        
        chartHumidityData
            .subscribe(onNext: {
                $0.forEach { hourlyData in
                    self.data[hourlyData.time] = hourlyData.humidity
                }
                self.isTemperatureData = false
                self.deliverChartData()
            })
            .disposed(by: disposeBag)
        
        chartTemperatureData
            .subscribe(onNext: {
                $0.forEach { hourlyData in
                    self.data[hourlyData.hour] = hourlyData.temperature
                }
                self.isTemperatureData = true
                self.deliverChartData()
            })
            .disposed(by: disposeBag)
    }
    
    private func deliverChartData() {
        for (key, value) in data {
            let value = ChartDataEntry(x: Double(key), y: value)
            lineChartEntry.append(value)
        }
        lineChartEntry = lineChartEntry.sorted(by: {$0.x < $1.x})
        configureChart(chartEntry: lineChartEntry)
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
        let lineChartDataSet = LineChartDataSet(entries: chartEntry)
        lineChartDataSet.colors = isTemperatureData ? [UIColor.KColor.orange01.withAlphaComponent(0.6)] : [UIColor.KColor.chartBlue]
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.highlightColor = isTemperatureData ? UIColor.KColor.orange01.withAlphaComponent(0.4) : UIColor.KColor.chartBlue
        lineChartDataSet.highlightLineWidth = 2
        lineChartDataSet.highlightLineDashLengths = [5]
        lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
        lineChartDataSet.mode = .cubicBezier
        lineChartDataSet.lineWidth = 2
        
        // Chart Fill
        lineChartDataSet.fill = isTemperatureData ? ColorFill(color: NSUIColor.KColor.orange01.withAlphaComponent(0.4)) : ColorFill(color: NSUIColor.KColor.chartBlue)
        lineChartDataSet.fillAlpha = 0.2
        lineChartDataSet.drawFilledEnabled = true
        
        let chartData = LineChartData(dataSet: lineChartDataSet)
        chartData.setDrawValues(false)
        chartView.data = chartData
        
        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        chartView.leftAxis.enabled = false
        chartView.legend.enabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.drawBordersEnabled = true
        chartView.backgroundColor = UIColor.KColor.clear
        chartView.borderColor = UIColor.KColor.clear
        
        let yAxis = chartView.rightAxis
        yAxis.labelFont = UIFont.KFont.lexendLight14
        yAxis.labelTextColor = UIColor.KColor.black
        yAxis.setLabelCount(6, force: true)
        yAxis.axisMaximum = chartData.yMax
        yAxis.axisMinimum = chartData.yMin
        yAxis.axisLineColor = UIColor.KColor.clear
        yAxis.gridColor = UIColor.KColor.primaryBlue05
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = UIFont.KFont.lexendLight12
        chartView.xAxis.labelTextColor = UIColor.KColor.black
        
        // 0, 6, 12, 18, 24
        chartView.xAxis.labelCount = 5
        chartView.xAxis.forceLabelsEnabled = true
        
        // 0, 24 안쪽으로
        chartView.xAxis.avoidFirstLastClippingEnabled = true
        
        chartView.xAxis.axisMinimum = chartData.xMin
        
        // x 축 line 제외
        chartView.xAxis.drawAxisLineEnabled = false

        chartView.xAxis.gridLineWidth = 1.0
        chartView.xAxis.gridLineDashPhase = 1.0
        chartView.xAxis.gridLineDashLengths = [5]
        chartView.xAxis.gridColor = UIColor.KColor.primaryBlue05
        
        chartView.drawGridBackgroundEnabled = true
        chartView.gridBackgroundColor = UIColor.KColor.gray05
        
        chartView.xAxis.valueFormatter = CustomAxisValueFormatter()
        chartView.xAxis.granularity = 1
    }
}
