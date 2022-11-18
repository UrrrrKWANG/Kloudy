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
    case six = 6
    case noon = 12
    case eighteen = 18
    case midNight = 24
    
    var label: String {
        switch self {
        case .zero: return "오전 0시"
        case .six: return "오전 6시"
        case .noon: return "오후 12시"
        case .eighteen: return "오후 6시"
        case .midNight: return ""
        }
    }
}

final class CustomAxisValueFormatter: IndexAxisValueFormatter {
    override func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let intValue = Int(value)
        let customAxis = ChartsAxisValue(rawValue: intValue)
        return customAxis?.label ?? ""
    }
}

class IndexChartView: UIView {
    // chart data
    let temporalData: [Int : Double] = [ 0 : 0.1, 1 : 1.0, 2 : 1.0, 3 : 1.0, 4 : 1.0, 5 : 1.0, 6 : 1.0,
                                 7 : 1.0, 8 : 0.1, 9 : 1.0, 10 : 1.0, 11 : 1.0, 12 : 1.0,
                                 13 : 3.0, 14 : 0.1, 15 : 1.0, 16 : 0.1, 17 : 1.0, 18 : 1.0,
                                 19 : 4.0, 20 : 5.0, 21 : 1.0, 22 : 5.0, 23 : 1.0, 24 : 3.0]
    var lineChartEntry = [ChartDataEntry]()
    
    let disposeBag = DisposeBag()
    let chartView = LineChartView()
    let chartLabel = UILabel()
    let chartUnit = UILabel()
    
    let chartLabelText: BehaviorSubject<String> = BehaviorSubject(value: "")
    let chartUnitText: BehaviorSubject<String> = BehaviorSubject(value: "")

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        for (key, value) in temporalData {
            let value = ChartDataEntry(x: Double(key), y: value)
            lineChartEntry.append(value)
        }
        lineChartEntry = lineChartEntry.sorted(by: {$0.x < $1.x})
        
        bind()
        layout()
        attribute()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        chartLabelText
            .subscribe(onNext: {
                self.chartLabel.text = $0
            })
            .disposed(by: disposeBag)
        
        chartUnitText
            .subscribe(onNext: {
                self.chartUnit.text = $0
            })
            .disposed(by: disposeBag)
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
    
    private func attribute() {
        configureChartLabel()
        configureChart()
    }
    
    private func configureChartLabel() {
        chartLabel.font = UIFont.KFont.appleSDNeoMedium14
        chartLabel.textColor = UIColor.KColor.gray01
        chartLabel.sizeToFit()
        
        chartUnit.font = UIFont.KFont.appleSDNeoSemiBold20
        chartUnit.textColor = UIColor.KColor.black
        chartUnit.sizeToFit()
    }
    
    private func configureChart() {
        let lineChartDataSet = LineChartDataSet(entries: lineChartEntry)
        lineChartDataSet.colors = [UIColor.KColor.chartBlue]
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.highlightColor = UIColor.KColor.chartBlue
        lineChartDataSet.highlightLineWidth = 2
        lineChartDataSet.highlightLineDashLengths = [5]
        lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
        lineChartDataSet.mode = .cubicBezier
        lineChartDataSet.lineWidth = 2
        
        // Chart Fill
        lineChartDataSet.fill = ColorFill(color: NSUIColor.KColor.chartBlue)
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
        yAxis.setLabelCount(6, force: false)
        yAxis.axisMinLabels = 0
        yAxis.axisMaximum = chartData.yMax + 1
        yAxis.axisLineColor = UIColor.KColor.clear
//        yAxis.setLabelCount(Int(chartData.yMax + 1 / 3), force: true)
        
        // background 격자
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
