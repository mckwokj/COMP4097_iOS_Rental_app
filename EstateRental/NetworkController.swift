//
//  NetworkController.swift
//  EstateRental
//
//  Created by Man Chun Kwok on 5/11/2020.
//

import Foundation
import MapKit

class NetworkController {
    func fetchEstates(completionHandler: @escaping ([Estate]) -> (),
                      errorHandler: @escaping (Error?) -> ()) {
        
        let url = URL(string: "https://morning-plains-00409.herokuapp.com/property/json")!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            if let error = error {
                // Server error encountered
                errorHandler(error)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode < 300 else {
                // Client error encountered
                errorHandler(error)
                return
            }
            
            guard let data = data, let estates = try? JSONDecoder().decode([Estate].self, from: data) else {
                errorHandler(nil)
                return
            }
            
            // Call our completion handler with our estates
            completionHandler(estates)
        }
        task.resume()
    }
    
    func fetchImage(for imageUrl: String, completionHandler: @escaping (Data) -> (), errorHandler: @escaping (Error?) -> ()) {
        
        let url = URL(string: imageUrl)!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                // Server error encountered
                errorHandler(error)
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode < 300 else {
                // Client error encountered
                errorHandler(nil)
                return
            }
            
            guard let data = data else {
                errorHandler(nil)
                return
            }
            
            // Call our completion handler with our images
            completionHandler(data)
        }
        task.resume()
    }
    
    func fetchLocations(estateName: String, errorHandler: @escaping (Error?) -> (), completionHandler: @escaping (CLLocation) -> ()) {
        //        var estateName = Estate.getEstateNames()
        var location = "Hong Kong, \(estateName)"
        location = location.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        var url = "https://us1.locationiq.com/v1/search.php?key=pk.626e37fcaf992bdb7b07200cd374fa5e&q=\(location)&format=json"
       
        var lat: Double? = nil
        var long: Double? = nil
        var coordinate: CLLocation?
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!) {(data, response, error) in
            if let error = error {
                // Server error encountered
                print("In first")
                errorHandler(error)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode < 300 else {
                // Client error encountered
                print("In second")
                errorHandler(error)
                return
            }
            
            guard let estates = try? JSONDecoder().decode([EstateLocation].self, from: data!) else {
                print("In last")
                errorHandler(nil)
                return
            }
        
            lat = Double(estates[0].lat)
            long = Double(estates[0].lon)
            
            if let latitude = lat, let longitude = long {
                coordinate = CLLocation(latitude: latitude, longitude: longitude)
                completionHandler(coordinate!)
                print("get corrdinate")
            }
        }
        task.resume()
        
//        return coordinate
    }
}

