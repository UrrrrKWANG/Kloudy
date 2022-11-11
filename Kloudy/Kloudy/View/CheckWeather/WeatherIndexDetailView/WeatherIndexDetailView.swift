//
//  WeatherIndexDetailView.swift
//  Kloudy
//
//  Created by 이영준 on 2022/11/07.
//

import UIKit
import SnapKit
import Charts

class WeatherIndexDetailView: UIViewController {
    
    let baseIndexView = UIView()
    let baseBackgroundView = UIView()
    let titleLabel = UILabel()
    let chartView = LineChartView()
    
    
    // chart data
    let data: [Int : Double] = [ 0 : 0, 1 : 1.0, 2 : 1.0, 3 : 1.0, 4 : 1.0, 5 : 1.0, 6 : 1.0,
                                 7 : 1.0, 8 : 0, 9 : 1.0, 10 : 1.0, 11 : 1.0, 12 : 1.0,
                                 13 : 3.0, 14 : 0, 15 : 1.0, 16 : 0, 17 : 1.0, 18 : 1.0,
                                 19 : 4.0, 20 : 5.0, 21 : 1.0, 22 : 5.0, 23 : 1.0, 24 : 3.0]
    
    var lineChartEntry = [ChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        attribute()
        
        //
        for (key, value) in data {
            let value = ChartDataEntry(x: Double(key), y: value)
            lineChartEntry.append(value)
        }
        lineChartEntry = lineChartEntry.sorted(by: {$0.x < $1.x})
        
        let lineChartDataSet = LineChartDataSet(entries: lineChartEntry, label: "")
        lineChartDataSet.colors = [UIColor.init(red: 102/255, green: 200/255, blue: 1, alpha: 1.0)]
        lineChartDataSet.drawCirclesEnabled = false
//        lineChartDataSet.highlightEnabled = false
        lineChartDataSet.highlightColor = .red
        lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
        lineChartDataSet.mode = .linear
        lineChartDataSet.lineWidth = 2
        
        lineChartDataSet.fill = ColorFill(color: NSUIColor(red: 102/255, green: 200/255, blue: 1, alpha: 1.0))
        lineChartDataSet.fillAlpha = 0.2
        lineChartDataSet.drawFilledEnabled = true
        
        
        let chartData = LineChartData(dataSet: lineChartDataSet)
        chartData.setDrawValues(false)
        chartView.data = chartData
        
        // 왼 X
        chartView.leftAxis.enabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.drawBordersEnabled = true
        chartView.backgroundColor = .clear
        chartView.borderColor = .clear
        
        let yAxis = chartView.rightAxis
        yAxis.labelFont = UIFont.KFont.lexendMini
        yAxis.labelTextColor = .black
        yAxis.setLabelCount(6, force: false)
        yAxis.axisMinLabels = 0
        yAxis.axisMaximum = chartData.yMax + 1
//        yAxis.setLabelCount(Int(chartData.yMax + 1 / 3), force: true)
        
        // background 격자
        yAxis.gridColor = UIColor(red: 233/255, green: 237/255, blue: 248/255, alpha: 1	)
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = UIFont.KFont.appleSDNeoSemiBoldMini
        chartView.xAxis.labelTextColor = .black
        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        
        // 0, 6, 12, 18, 24
        chartView.xAxis.setLabelCount(5, force: true)
        chartView.xAxis.forceLabelsEnabled = true
        // 0, 24 안쪽으로
        chartView.xAxis.avoidFirstLastClippingEnabled = true
        
        chartView.xAxis.axisMinimum = chartData.xMin
        
        // x 축 line 제외
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.gridLineDashPhase = 1.0
        
    }
    
    private func layout() {
        [baseBackgroundView, baseIndexView].forEach { view.addSubview($0) }
        
        baseBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        baseIndexView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(490)
        }
        
        [titleLabel, chartView].forEach { baseIndexView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18)
            $0.leading.equalToSuperview().inset(16)
        }
        
        chartView.snp.makeConstraints {
            // 하루 강수량 view 에 맞게 top constraint 재부여 필요
            $0.top.equalTo(titleLabel).offset(120)
            $0.height.equalTo(190)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func attribute() {
        self.view.backgroundColor = UIColor.KColor.clear
        configureBaseBackgroundView()
        configurebBaseIndexView()
        configureTitleLabel()
    }
    
    private func configureBaseBackgroundView() {
        baseBackgroundView.backgroundColor = UIColor.KColor.clear.withAlphaComponent(0.5)
        baseBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapBackgroundView)))
    }
    
    private func configurebBaseIndexView() {
        baseIndexView.backgroundColor = UIColor.KColor.white
        baseIndexView.layer.cornerRadius = 10
    }
    
    private func configureTitleLabel() {
        titleLabel.text = "우산 지수"
        titleLabel.textColor = UIColor.KColor.black
        titleLabel.font = UIFont.KFont.appleSDNeoBoldLarge
        titleLabel.sizeToFit()
    }
    
    private func configureChartView() {
        
    }
    
    @objc private func tapBackgroundView() {
        self.dismiss(animated: true)
    }
}
