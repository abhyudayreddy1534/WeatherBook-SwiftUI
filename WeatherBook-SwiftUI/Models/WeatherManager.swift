//
//  WeatherManager.swift
//  WeatherBook
//
//  Created by Sravanthi Chinthireddy on 12/02/24.
//

import Foundation
import CoreLocation

class WeatherManager: ObservableObject {
    let weatherURL  = "https://api.openweathermap.org/data/2.5/weather?appid=7cf39db705583a23dd1c9b188bebb313&units=metric"
    
    @Published var city = ""
    @Published var imageName = ""
    @Published var tempString = ""
        
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
                    return
                }
                
                if let safeData = data {
                    if case let (image?,temp?,city?) = self.parseJSON(data: safeData) {
                        DispatchQueue.main.async {
                            self.city = city
                            self.tempString = temp
                            self.imageName = image
                        }
                        
                    }
                }
            }
            
            task.resume()
        }
        
    }
    
    func parseJSON(data: Data?) -> (String, String, String) {
        let decoder = JSONDecoder()
        do {
            let decodedJSON = try decoder.decode(WeatherData.self, from: data!)
            print(decodedJSON)
            let id = decodedJSON.weather[0].id
            let temp = decodedJSON.main.temp
            let name = decodedJSON.name
                        
            return (getConditionName(conditionID: id), String(format: "%.1f", temp), name)
        }
        catch {
            print(error)
            return ("","","")
        }
        return ("","","")
    }
    
    func getConditionName(conditionID: Int) -> String {
       return {
           switch conditionID {
           case 200...232:
               return "cloud.bolt"
           case 300...321:
               return "cloud.drizzle"
           case 500...531:
               return "cloud.rain"
           case 600...622:
               return "cloud.snow"
           case 700...781:
               return "cloud.fog"
           case 800:
               return "sun.max"
           case 801...804:
               return "cloud.bolt"
           default:
               return "cloud"
           }
       }()
    }
    
}
