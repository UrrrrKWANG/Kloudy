//
//  IndexChartView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/11/12.
//

import UIKit
import Charts
import SnapKit

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

class IndexChartView: LineChartView {
    // chart data
    let temporalData: [Int : Double] = [ 0 : 0.1, 1 : 1.0, 2 : 1.0, 3 : 1.0, 4 : 1.0, 5 : 1.0, 6 : 1.0,
                                 7 : 1.0, 8 : 0.1, 9 : 1.0, 10 : 1.0, 11 : 1.0, 12 : 1.0,
                                 13 : 3.0, 14 : 0.1, 15 : 1.0, 16 : 0.1, 17 : 1.0, 18 : 1.0,
                                 19 : 4.0, 20 : 5.0, 21 : 1.0, 22 : 5.0, 23 : 1.0, 24 : 3.0]
    var lineChartEntry = [ChartDataEntry]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        for (key, value) in temporalData {
            let value = ChartDataEntry(x: Double(key), y: value)
            lineChartEntry.append(value)
        }
        lineChartEntry = lineChartEntry.sorted(by: {$0.x < $1.x})
        
        configureChart()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureChart() {
        let lineChartDataSet = LineChartDataSet(entries: lineChartEntry)
        lineChartDataSet.colors = [UIColor.init(red: 102/255, green: 200/255, blue: 1, alpha: 1.0)]
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.highlightColor = UIColor.init(red: 102/255, green: 200/255, blue: 1, alpha: 1.0)
        lineChartDataSet.highlightLineWidth = 2
        lineChartDataSet.highlightLineDashLengths = [5]
        lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
        lineChartDataSet.mode = .cubicBezier
        lineChartDataSet.lineWidth = 2
        
        // Chart Fill
        lineChartDataSet.fill = ColorFill(color: NSUIColor(red: 102/255, green: 200/255, blue: 1, alpha: 1.0))
        lineChartDataSet.fillAlpha = 0.2
        lineChartDataSet.drawFilledEnabled = true
        
        let chartData = LineChartData(dataSet: lineChartDataSet)
        chartData.setDrawValues(false)
        self.data = chartData
        
        self.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        self.leftAxis.enabled = false
        self.legend.enabled = false
        self.doubleTapToZoomEnabled = false
        self.drawBordersEnabled = true
        self.backgroundColor = UIColor.KColor.clear
        self.borderColor = UIColor.KColor.clear
        
        let yAxis = self.rightAxis
        yAxis.labelFont = UIFont.KFont.lexendMini
        yAxis.labelTextColor = UIColor.KColor.black
        yAxis.setLabelCount(6, force: false)
        yAxis.axisMinLabels = 0
        yAxis.axisMaximum = chartData.yMax + 1
        yAxis.axisLineColor = .clear
//        yAxis.setLabelCount(Int(chartData.yMax + 1 / 3), force: true)
        
        // background 격자
        yAxis.gridColor = UIColor(red: 233/255, green: 237/255, blue: 248/255, alpha: 1)
        
        self.xAxis.labelPosition = .bottom
        self.xAxis.labelFont = UIFont.KFont.appleSDNeoSemiBoldMini
        self.xAxis.labelTextColor = UIColor.KColor.black
        
        // 0, 6, 12, 18, 24
        self.xAxis.labelCount = 5
        self.xAxis.forceLabelsEnabled = true
        
        // 0, 24 안쪽으로
        self.xAxis.avoidFirstLastClippingEnabled = true
        
        self.xAxis.axisMinimum = chartData.xMin
        
        // x 축 line 제외
        self.xAxis.drawAxisLineEnabled = false

        self.xAxis.gridLineWidth = 1.0
        self.xAxis.gridLineDashPhase = 1.0
        self.xAxis.gridLineDashLengths = [5]
        self.xAxis.gridColor = UIColor(red: 233/255, green: 237/255, blue: 248/255, alpha: 1)
        
        self.drawGridBackgroundEnabled = true
        self.gridBackgroundColor = UIColor(red: 247/255, green: 248/255, blue: 252/255, alpha: 1)
        
        self.xAxis.valueFormatter = CustomAxisValueFormatter()
        self.xAxis.granularity = 1
    }
}
