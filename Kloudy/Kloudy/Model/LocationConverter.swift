//
//  LocationConverter.swift
//  Kloudy
//
//  Created by Geunil Park on 2022/11/19.
//

import Foundation

struct MapGridData {
  let re = 6371.00877    // 사용할 지구반경  [ km ]
  let grid = 5.0         // 사용할 지구반경  [ km ]
  let slat1 = 30.0       // 표준위도       [degree]
  let slat2 = 60.0       // 표준위도       [degree]
  let olon = 126.0       // 기준점의 경도   [degree]
  let olat = 38.0        // 기준점의 위도   [degree]
  let xo = 42.0          // 기준점의 X좌표  [격자거리] // 210.0 / grid
  let yo = 135.0         // 기준점의 Y좌표  [격자거리] // 675.0 / grid
}

class LocationConverter {
    let map: MapGridData = MapGridData()
    
    let PI: Double = .pi
    let DEGRAD: Double = .pi / 180.0
    let RADDEG: Double = 180.0 / .pi
    
    var re: Double
    var slat1: Double
    var slat2: Double
    var olon: Double
    var olat: Double
    var sn: Double
    var sf: Double
    var ro: Double
    
    init() {
        re = map.re / map.grid
        slat1 = map.slat1 * DEGRAD
        slat2 = map.slat2 * DEGRAD
        olon = map.olon * DEGRAD
        olat = map.olat * DEGRAD
        
        sn = tan(PI * 0.25 + slat2 * 0.5) / tan(PI * 0.25 + slat1 * 0.5)
        sn = log(cos(slat1) / cos(slat2)) / log(sn)
        sf = tan(PI * 0.25 + slat1 * 0.5)
        sf = pow(sf, sn) * cos(slat1) / sn
        ro = tan(PI * 0.25 + olat * 0.5)
        ro = re * sf / pow(ro, sn)
    }
    
    func convertGrid(lon: Double, lat: Double) -> (Int, Int) {
        
        var ra: Double = tan(PI * 0.25 + lat * DEGRAD * 0.5)
        ra = re * sf / pow(ra, sn)
        var theta: Double = lon * DEGRAD - olon
        
        if theta > PI {
            theta -= 2.0 * PI
        }
        
        if theta < -PI {
            theta += 2.0 * PI
        }
        
        theta *= sn
        
        let x: Double = ra * sin(theta) + map.xo
        let y: Double = ro - ra * cos(theta) + map.yo
        
        return (Int(x + 1.5), Int(y + 1.5))
    }
}
