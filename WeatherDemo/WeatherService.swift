//
//  WeatherService.swift
//  WeatherDemo
//
//  Created by Avinav Goel on 04/04/16.
//  Copyright © 2016 Avinav Goel. All rights reserved.
//

import Foundation

public class WeatherService {
    public typealias WeatherDataCompletionBlock = (data: WeatherData?) -> ()

    //http://api.openweathermap.org/data/2.5/weather?q=London,uk&appid=669bd6522c2678bde9ee0dc161aa3a65
    let openWeatherBaseAPI = "api.openweathermap.org/data/2.5/weather?q="
    let urlSession:NSURLSession = NSURLSession.sharedSession()

    public class func sharedWeatherService() -> WeatherService {
        return _sharedWeatherService
    }
    
    public func getCurrentWeather(location:String, completion: WeatherDataCompletionBlock) {
        let openWeatherAPI = "http://api.openweathermap.org/data/2.5/weather?q=" + location.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())! + "&appid=ad556107c38d033a20628db1bda1c930"
        
        
        print(openWeatherAPI)
        let request = NSURLRequest(URL: NSURL(string: openWeatherAPI)!)
        let weatherData = WeatherData()
        
        let task = urlSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
             guard let data = data else {
              if error != nil {
                  print("\n\(error)")
              }
                
              return
            }
            
            // Retrieve JSON data
            do {
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSDictionary
                
                // Parse JSON data
                let jsonWeather = jsonResult?["weather"] as! [AnyObject]
                
                for jsonCurrentWeather in jsonWeather {
                    weatherData.weather = jsonCurrentWeather["description"] as! String
                }
                
                let jsonMain = jsonResult?["main"] as! Dictionary<String, AnyObject>
                weatherData.temperature = jsonMain["temp"] as! Int
                
                completion(data: weatherData)

            } catch {
                print("hi\(error)")
            }
        })
        
        task.resume()
    
    }

}

let _sharedWeatherService: WeatherService = { WeatherService() }()