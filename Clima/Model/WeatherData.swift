//
//  WeatherData.swift
//  Clima
//
//  Created by main on 6/11/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
}

struct Main: Decodable {
    let temp: Double
}
