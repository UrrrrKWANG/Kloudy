//
//  CityWeatherNetwork.swift
//  Kloudy
//
//  Created by 이영준 on 2022/11/17.
//

import RxSwift
import Foundation

enum FetchCityWeatherError: Error {
    case networkError
    case invalidURL
    case invalidJSON
}

class CityWeatherNetwork {
    private let session: URLSession
    let api = CityWeatherAPI()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchCityWeather(code: String) -> Single<Result<Weather, FetchCityWeatherError>> {
        guard let url = api.requestCityWeather(code: code).url else { return .just(.failure(.invalidURL)) }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        
        return session.rx.data(request: request as URLRequest)
            .map { data in
                do {
                    let weatherData = try JSONDecoder().decode(Weather.self, from: data)
                    return .success(weatherData)
                } catch {
                    return .failure(.invalidJSON)
                }
            }
            .catch { _ in
                    .just(.failure(.networkError))
            }
            .asSingle()
    }
}


