//
//  CityList.swift
//  Kloudy
//
//  Created by Geunil Park on 2022/10/24.
//

import Foundation

public class CityList: Codable {
    var cityList: [CityInformation] = []
    
    private func parseCSVAt(url: URL) {
        do {
            // url을 받은 data
            let data = try Data(contentsOf: url)
            // 해당 data를 encoding 합니다.
            let dataEncoded = String(data: data, encoding: .utf8)
            if let dataArr = dataEncoded?.components(separatedBy: "\n").map({$0.components(separatedBy: ",")}) {
                                for item in dataArr {
                                    let city = CityInformation(code: item[0], province: item[1], city: item[2], airCoditionMeasuring: item[3], xCoordination: Int(item[4]) ?? 0, yCoordination: Int(item[5]) ?? 0, longitude: Double(item[6]) ?? 0, latitude: Double(item[7]) ?? 0)
                                    cityList.append(city)
                                }
                            }
        } catch {
            print("Error reading CSV file")
        }
    }
    
    private func loadCalorieFromCSV() {
        // bundle에 있는 경로 > Calorie라는 이름을 가진 csv 파일 경로
        let path = Bundle.main.path(forResource: "CityInformation", ofType: "csv")!
        parseCSVAt(url: URL(fileURLWithPath: path))
    }
}
