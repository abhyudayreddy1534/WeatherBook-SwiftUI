//
//  WeatherManager.swift
//  WeatherBook
//
//  Created by Sravanthi Chinthireddy on 12/02/24.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager:WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL  = "https://api.openweathermap.org/data/2.5/weather?appid=7cf39db705583a23dd1c9b188bebb313&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func fetchWeather(withLatitude lat: CLLocationDegrees, andLogitude lng: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lng)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(data: safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                        
                    }
                }
            }
            
            task.resume()
        }
        
    }
    
    func parseJSON(data: Data?) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedJSON = try decoder.decode(WeatherData.self, from: data!)
            let id = decodedJSON.weather[0].id
            let temp = decodedJSON.main.temp
            let name = decodedJSON.name
            
            let weather = WeatherModel(conditionID: id, cityName: name, temperature: temp)
            
            return weather
        }
        catch {
            print(error)
            delegate?.didFailWithError(error: error)
            return nil
        }
        return nil
    }
    
}
