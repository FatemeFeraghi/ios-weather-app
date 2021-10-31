//
//  WeatherData.swift
//  weather
//
//  Created by english on 2021-09-28.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather] //An array of weather conditions
}

//The name of properties should match with the properties in JSON data comming from web
struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}

