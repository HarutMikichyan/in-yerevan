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
                                weather.temperatureC = weather.temperatureK! - 273.15
                                
                                let iconAPI = "http://openweathermap.org/img/w/\((wobjectWather["icon"] as! String)).png"
                                weather.icon = self.getImage(imageUrl: iconAPI)
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
    
    func getYerevanImagesInfo(callBack: @escaping ((UIImage?, Bool) -> Void)) {
        
        let apiQuery = "Yerevan"
        let clientID = "b8c48448dcf4da7bbee5a8d59c8618ee4ccfa89d85edaf1fb0a7951104728719"
        let api = "https://api.unsplash.com/search/photos?query=\(apiQuery)&client_id=\(clientID)"
        
        for i in 1...4 {
            let url = URL(string: "\(api)&page=\(i)")

            if url != nil {
                let task = session.dataTask(with: url!) { (data, response, error) in
                    if error == nil {
                        if (response as! HTTPURLResponse).statusCode == 200 {
                            if data != nil {
                                if let object = (try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)) as? [String: Any] {
                                    let results = object["results"] as! [[String: Any]]

                                    for item in results {
                                        let urls = item["urls"] as! [String: String]
                                        let image = self.getImage(imageUrl: urls["small"]!)
                                        
                                        if image != nil {
                                            callBack(image!, true)
                                        }
                                    }
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
    }
    
    func getImage(imageUrl: String) -> UIImage? {
        
        do {
            if let imageURL = URL(string: imageUrl) {
                let data = try Data.init(contentsOf: imageURL)
                if let image = UIImage.init(data: data) {
                    return image
                }
            }
        } catch {
            print("ERROR ----- \(error)")
        }
        return nil
    }
}
