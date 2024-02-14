//
//  WeatherData.swift
//  WeatherBook
//
//  Created by Sravanthi Chinthireddy on 12/02/24.
//

import Foundation

struct WeatherData: Codable {
    var name: String
    var main: Main
    var weather: [Weather]
}

struct Main: Codable {
    var temp: Double
}

struct Weather : Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

