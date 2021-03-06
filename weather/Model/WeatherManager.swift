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
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=be33b8453f94a84e525b0c5bca064bfd&units=metric"
    
    //If some class or structs has set themeselves to Delegate then
    //We would be able to call the function didUpdateWeather
    var delegate: WeatherManagerDelegate?
    
    //It takes a city name and creates a url string from it
    func fetchWeather(cityName : String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        
        //perform the request with the url string
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitute: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitute)"
        performRequest(with: urlString)
    }
    
    //The request goes into this method and does the networking to fetch some data back from open weather map
    func performRequest(with urlString: String){
        
        //1.Create a URL
        if let url = URL(string: urlString){
            //2.Create a URLSession
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            //Returns a urlSession DataTask
            //This is a function which is triggered by the task when it's complete
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //4. Start the task
            task.resume()
        }
    }
    
    //Print the decoded data comming back from the WeatherData
    //Parse the weather to a Swift object
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedDate = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedDate.weather[0].id
            let temp = decodedDate.main.temp
            let name = decodedDate.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
