//
//  File.swift
//  Clima
//
//  Created by main on 6/10/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=2c5c1b7b7d4a4c9e0a2c9e8a2a2c9e8a&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
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
                    if let weather = self.parseJSON(data: safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            // start the task
            task.resume()
        }
    }
    
    func parseJSON(data: Data) -> WeatherModel? {
        let decoer = JSONDecoder()
        // use .self to turn the struct into a type
        do {
            // can throw error, must catch
            let decoded = try decoer.decode(WeatherData.self, from: data)
            let id = decoded.weather[0].id
            let temp = decoded.main.temp
            let name = decoded.name
            
            return WeatherModel(conditionId: id, cityName: name, temperature: temp)
        } catch {
            print(error)
            return nil
        }
    }
}
