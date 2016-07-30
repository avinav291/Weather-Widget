//
//  TodayViewController.swift
//  Weather Widget
//
//  Created by Avinav Goel on 04/04/16.
//  Copyright © 2016 Avinav Goel. All rights reserved.
//

import UIKit
import NotificationCenter
import WeatherInfoKit

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var City: UILabel!
    @IBOutlet weak var Weather: UILabel!
    @IBOutlet weak var Temp: UILabel!
    var location = "Paris, France"
    var defaults = NSUserDefaults(suiteName: "group.com.Avinav.WeatherDemo")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        City.text = location
        
        WeatherService.sharedWeatherService().getCurrentWeather(location){ (data)->() in
            
            NSOperationQueue.mainQueue().addOperationWithBlock({() -> Void in
                if let weatherdata = data{
                    self.Weather.text = weatherdata.weather.capitalizedString
                    self.Temp.text = String(format : "%d", weatherdata.temperature) + "\u{00B0}"
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        // Get the location from defaults
        if let defaultLocation = defaults.valueForKey("location") as? String {
            location = defaultLocation
        }
        
        City.text = location
    
        
        WeatherService.sharedWeatherService().getCurrentWeather(location) { (data) -> () in
            guard let weatherData = data else {
            completionHandler(NCUpdateResult.NoData)
            return
            }
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.Weather.text = weatherData.weather.capitalizedString
                self.Temp.text = String(format: "%d", weatherData.temperature) + "\u{00B0}"
                })


        completionHandler(NCUpdateResult.NewData)
    }
}
}