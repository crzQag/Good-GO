//
//  TableViewController.swift
//  Good GO
//
//  Created by QUANG on 1/27/17.
//  Copyright © 2017 Start Swift. All rights reserved.
//

import UIKit
import CoreLocation

class TableViewController: UITableViewController, CLLocationManagerDelegate {
    
    //MARK: Properties:
    let locationManager = CLLocationManager() //For location detection
    var userCity: String = ""
    var weatherData = [WeatherData]()

    //MARK: Outlets
    
    //MARK: Defaults
    override func viewDidLoad() {
        super.viewDidLoad()

        getUserCity()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    //MARK: Private Methods
    func getUserCity() {
        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    //Tuan complete this ok? Using JSON
    func getDataFrom(city: String) {
        let query = URL(string: getQueryLink(city: city))
        //print(query!)
        
        let task = URLSession.shared.dataTask(with: query!) { (data, response, error) in
            if error == nil {
                if let content = data {
                    /////////////////////////////////////////////////////////////
                    
                    //Tuan start here
                    //Init data got to weatherData (override index weatherData[0]
                    
                    
                    /////////////////////////////////////////////////////////////
                    if !self.weatherData.isEmpty {
                        self.saveData()
                    }
                }
            }
            else {
                print("Somthing went wrong")
            }
        }
        task.resume()
    }
    
    func getQueryLink(city: String) -> String {
        let statement = "select * from weather.forecast where woeid in (select woeid from geo.places(1) where text='\(city), vn')"
        let query_prefix = "https://query.yahooapis.com/v1/public/yql?q="
        let query_suffix = "&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
        
        let query = "\(query_prefix)\(statement.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)\(query_suffix)"
        
        print(query)
        return query
    }
    
    private func loadData() -> [WeatherData]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: WeatherData.ArchiveURL.path) as? [WeatherData]
    }
    
    private func loadSavedData(){
        if let savedData = loadData() {
            weatherData.removeAll()
            weatherData += savedData
        }
        else {
            print("No data to load")
        }
    }
    
    private func saveData() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(weatherData, toFile: WeatherData.ArchiveURL.path)
        if isSuccessfulSave {
            print("Successfully saved.")
        } else {
            print("Failed to save...")
        }
    }
    
    //MARK: Location Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Get latitude and longitude
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        locationManager.stopUpdatingLocation()
        
        //Convert from latitude and longitude to city
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            if error == nil {
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                
                // City
                if let city = placeMark.addressDictionary!["City"] as? NSString {
                    self.userCity = city as String
                    print(self.userCity)
                    self.getDataFrom(city: self.userCity)
                }
            }
            else {
                print("Something happened")
            }
            
        })
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Table view data source

    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
