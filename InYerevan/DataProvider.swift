//
//  DataProvider.swift
//  InYerevan
//
//  Created by Gev Darbinyan on 28/01/2019.
//  Copyright © 2019 InYerevan.am. All rights reserved.
//

import UIKit

final class DataProvider {
    
    static let object = DataProvider()
    
    var session = URLSession(configuration: .default)
    let apiKey = "49e4eb6b784938c7c7ef6c62494667ed" // Openweathermap API Account Key
    let cityID = "616051" // Yerevan ID
    
    func getWeather(callBack: @escaping ((Weather?, Bool) -> Void)) {
        
        let api = "http://api.openweathermap.org/data/2.5/weather?id=\(cityID)&appid=\(apiKey)"
        let url = URL(string: api)
        let weather = Weather()
        
        if url != nil {
            let task = session.dataTask(with: url!) { (data, response, error) in
                if error == nil {
                    if (response as! HTTPURLResponse).statusCode == 200 {
                        if data != nil {
                            if let object = (try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)) as? [String: Any] {
                                let objectMain = object["main"] as! [String: Any]
                                let wobjectWather = ((object["weather"] as! [Any])[0] as! [String: Any])
                                
                                weather.temperatureK = objectMain["temp"] as? Double
                                weather.temperatureC = 273.15 - weather.temperatureK!
                                weather.icon = self.getWeatherIcon(iconName: wobjectWather["icon"] as! String)
                                weather.weatherDescription = wobjectWather["description"] as? String
                                
                                callBack(weather, true)
                            } else {
                                callBack(nil, false)
                                print("Object error")
                            }
                        } else {
                            callBack(nil, false)
                            print("Data nil")
                        }
                    } else {
                        callBack(nil, false)
                        print("Response error \((response as! HTTPURLResponse).statusCode)")
                    }
                } else {
                    callBack(nil, false)
                    print(error!.localizedDescription)
                }
            }
            task.resume()
        } else {
            callBack(nil, false)
            print("Url nil")
        }
    }
    
    func getWeatherIcon(iconName: String) -> UIImage? {
        
        let iconAPI = "http://openweathermap.org/img/w/\(iconName).png"
        
        do {
            if let iconUrl = URL(string: iconAPI) {
                let data = try Data.init(contentsOf: iconUrl)
                if let icon = UIImage.init(data: data) {
                    return icon
                }
            }
        } catch {
            print("ERROR ----- \(error)")
        }
        return nil
    }
}
