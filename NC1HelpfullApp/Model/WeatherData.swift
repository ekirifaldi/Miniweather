//
//  WeatherData.swift
//  NC1HelpfullApp
//
//  Created by Eki Rifaldi on 08/03/20.
//  Copyright © 2020 Eki Rifaldi. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}
