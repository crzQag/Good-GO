//
//  WeatherData.swift
//  Good GO
//
//  Created by QUANG on 1/27/17.
//  Copyright © 2017 Start Swift. All rights reserved.
//

import UIKit

class WeatherData: NSObject, NSCoding {
    
    //MARK: Types
    struct PropertyKey {
        static let sunrise = "sunrise" //UNIX
        static let sunset = "sunset" //UNIX
        static let main = "main" //Rain, Snow, Extreme etc.
        static let descrip = "descrip" //String (readable by human)
        static let temp = "temp" //Kelvin
        static let humidity = "humidity" //%
        static let temp_min = "temp_min" //Kelvin
        static let temp_max = "temp_max" //Kelvin
        static let windSpeed = "windSpeed" //meter/sec
        static let clouds = "clouds" //%
        static let dt = "dt" //UNIX
    }
    
    //MARK: Properties (All are optional)
    var sunrise: Int?
    var sunset: Int?
    var main: String?
    var descrip: String?
    var temp: Float? //7 digits
    var humidity: Int?
    var temp_min: Float?
    var temp_max: Float?
    var windSpeed: Float? //7 digits
    var clouds: Int?
    var dt: Int?
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("WeatherData")
    
    //MARK: Initialization
    init?(sunrise: Int?, sunset: Int?, main: String?, descrip: String?, temp: Float?, humidity: Int?, temp_min: Float?, temp_max: Float?, windSpeed: Float?, clouds: Int?, dt: Int?) {
        
        //Because everuthing is optional
        self.sunrise = sunrise
        self.sunset = sunset
        self.main = main
        self.descrip = descrip
        self.temp = temp
        self.humidity = humidity
        self.temp_min = temp_min
        self.temp_max = temp_max
        self.windSpeed = windSpeed
        self.clouds = clouds
        self.dt = dt
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(sunrise, forKey: PropertyKey.sunrise)
        aCoder.encode(sunset, forKey: PropertyKey.sunset)
        aCoder.encode(main, forKey: PropertyKey.main)
        aCoder.encode(descrip, forKey: PropertyKey.descrip)
        aCoder.encode(temp, forKey: PropertyKey.temp)
        aCoder.encode(humidity, forKey: PropertyKey.humidity)
        aCoder.encode(temp_min, forKey: PropertyKey.temp_min)
        aCoder.encode(temp_max, forKey: PropertyKey.temp_max)
        aCoder.encode(windSpeed, forKey: PropertyKey.windSpeed)
        aCoder.encode(clouds, forKey: PropertyKey.clouds)
        aCoder.encode(dt, forKey: PropertyKey.dt)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // Because everything is an optional property of WeatherData, just use conditional cast.
        let sunrise = aDecoder.decodeInteger(forKey: PropertyKey.sunrise)
        let sunset = aDecoder.decodeInteger(forKey: PropertyKey.sunset)
        let main = aDecoder.decodeObject(forKey: PropertyKey.main) as? String
        let descrip = aDecoder.decodeObject(forKey: PropertyKey.descrip) as? String
        let temp = aDecoder.decodeFloat(forKey: PropertyKey.temp)
        let humidity = aDecoder.decodeInteger(forKey: PropertyKey.humidity)
        let temp_min = aDecoder.decodeFloat(forKey: PropertyKey.temp_min)
        let temp_max = aDecoder.decodeFloat(forKey: PropertyKey.temp_max)
        let windSpeed = aDecoder.decodeFloat(forKey: PropertyKey.windSpeed)
        let clouds = aDecoder.decodeInteger(forKey: PropertyKey.clouds)
        let dt = aDecoder.decodeInteger(forKey: PropertyKey.dt)
        
        // Must call designated initializer.
        self.init(sunrise: sunrise, sunset: sunset, main: main, descrip: descrip, temp: temp, humidity: humidity, temp_min: temp_min, temp_max: temp_max, windSpeed: windSpeed, clouds: clouds, dt: dt)
    }
}
