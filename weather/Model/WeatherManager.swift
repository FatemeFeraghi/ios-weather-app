//
//  WeatherManager.swift
//  weather
//
//  Created by english on 2021-09-28.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather:WeatherModel)
    func didFailWithError(error: Error)
    
}

struct WeatherManager {

}
