//
//  File.swift
//  Clima
//
//  Created by main on 6/10/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=2c5c1b7b7d4a4c9e0a2c9e8a2a2c9e8a&units=metric"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        print(urlString)
        if let url = URL(string: urlString) {
            // create url session
            let session = URLSession(configuration: .default)
            
            // give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                print("handle result")
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    self.parseJSON(data: safeData)
                }
            }
            
            // start the task
            task.resume()
        }
    }
    
    func parseJSON(data: Data) {
        let decoer = JSONDecoder()
        // use .self to turn the struct into a type
        do {
            // can throw error, must catch
            let decoded = try decoer.decode(WeatherData.self, from: data)
            let id = decoded.weather[0].id
        } catch {
            print(error)
        }
    }
    
    func getConditionName(weatherId: Int) -> String {
        switch weatherId {
            case 200...232:
                return "cloud.bolt"
            case 300...321:
                return "cloud.drizzle"
            case 500...531:
                return "cloud.rain"
            case 600...622:
                return "cloud.snow"
            case 701...781:
                return "cloud.fog"
            case 800:
                return "sun.max"
            case 801...804:
                return "cloud.bolt"
            default:
                return "cloud"
        }
    }
}
