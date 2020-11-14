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
        
//        print("fetchEstates:",url)
        
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
//            print(estates)
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
//                print("In first")
                errorHandler(error)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode < 300 else {
                // Client error encountered
//                print("In second")
                errorHandler(error)
                return
            }
            
            guard let estates = try? JSONDecoder().decode([EstateLocation].self, from: data!) else {
//                print("In last")
                errorHandler(nil)
                return
            }
            
            Estate.location.append(contentsOf: estates)
        
//            print("Display name")
//            print(estates[0].display_name)
            
            lat = Double(estates[0].lat)
            long = Double(estates[0].lon)
            
            if let latitude = lat, let longitude = long {
                coordinate = CLLocation(latitude: latitude, longitude: longitude)
                completionHandler(coordinate!)
//                print("get corrdinate")
            }
        }
        task.resume()
        
//        return coordinate
    }
    
    func login(username: String, password: String, completionHandler: @escaping (User) -> (),
               errorHandler: @escaping (Error?, Int?) -> ()){
        
        var url = URL(string: "https://morning-plains-00409.herokuapp.com/user/login")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let parameters: [String: Any] = [
            "username": username,
            "password": password
        ]
        
        var bodyData = "username=\(username)&password=\(password)"
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let error = error {
                // Server error encountered
//                print("first if")
                errorHandler(error, nil)
                return
            }
            
//            print("Status Code")
            print((response as? HTTPURLResponse)?.statusCode)
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            
            guard let response = response as? HTTPURLResponse, response.statusCode < 300 else {
                // Client error encountered
//                print("second if")
                errorHandler(error, statusCode)
                return
            }
            
            guard let data = data, let user = try? JSONDecoder().decode(User.self, from: data) else {
//                print("last if")
                errorHandler(error, nil)
                return
            }
            
//            print(data)
    
            // Call our completion handler with our User
            completionHandler(user)

        }
        task.resume()
    }
    
    func logout(errorHandler: @escaping (Error?) -> ()) {
        var url = URL(string: "https://morning-plains-00409.herokuapp.com/user/logout")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let error = error {
                // Server error encountered
//                print("first if")
                errorHandler(error)
                return
            }
            
//            print("Status Code")
            print((response as? HTTPURLResponse)?.statusCode)
            
            guard let response = response as? HTTPURLResponse, response.statusCode < 300 else {
                // Client error encountered
//                print("second if")
                errorHandler(error)
                return
            }
            
            UserDefaults.standard.set("user", forKey: "userImage")
            UserDefaults.standard.set(nil, forKey: "username")
            UserDefaults.standard.set([], forKey: "myRental")
//
//            guard let data = data, let user = try? JSONDecoder().decode(User.self, from: data) else {
//                print("last if")
//                errorHandler(nil)
//                return
//            }
    
            // Call our completion handler with our User
//            completionHandler(user)
        }
        task.resume()
        
//        print("Logout already")
    }
    
    func myRental (errorHandler: @escaping (Error?) -> ()) {
        var url = URL(string: "https://morning-plains-00409.herokuapp.com/user/myRentals/")!
        var request = URLRequest(url: url)
        
//        print("inside myRental")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let error = error {
//                print("first if")
                errorHandler(error)
                return
            }
            
//            print("Status Code")
            print((response as? HTTPURLResponse)?.statusCode)
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            
            guard let response = response as? HTTPURLResponse, response.statusCode < 300 else {
                // Client error encountered
//                print("second if")
                errorHandler(error)
                return
            }
            
            guard let data = data, let estates = try? JSONDecoder().decode([Estate].self, from: data) else {
//                print("last if")
                errorHandler(nil)
                return
            }
            
//            print("before saved in UserDefault")
            
            var myRentalList: [Int] = []
            
            estates.forEach {
                myRentalList.append($0.id)
            }
            
            UserDefaults.standard.set(myRentalList, forKey: "myRental")
//            print("my rentals saved in UserDefaults")
//            print(UserDefaults.standard.object(forKey: "myRental") as! [Int])
//            print("In func myRental")
//            print(estates)
            
        }
        task.resume()
    }
    
    func moveIn (id: Int, completionHandler: @escaping (Int?) -> (), errorHandler: @escaping (Error?, Int?) -> ()){
        var url = URL(string: "https://morning-plains-00409.herokuapp.com/user/rent/\(id)")!
//        print("before request")
        var request = URLRequest(url: url)
//        print("after request")
        request.httpMethod = "POST"
        
//        print(url)
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
//            print("inside task")
            if let error = error {
                // Server error encountered
//                print("first if")
                errorHandler(error, nil)
                return
            }
            
//            print("Status Code")
//            print((response as? HTTPURLResponse)?.statusCode)
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            
            guard let response = response as? HTTPURLResponse, response.statusCode < 300 else {
                // Client error encountered
//                print("second if")
                errorHandler(error, statusCode)
                return
            }
//            guard let data = data, let user = try? JSONDecoder().decode(User.self, from: data) else {
//                print("last if")
//                errorHandler(nil)
//                return
//            }
    
            // Call our completion handler with our User
            completionHandler(response.statusCode)

        }
        task.resume()
    }
    
    func moveOut(id: Int, completionHandler: @escaping (Int?) -> (), errorHandler: @escaping (Error?, Int?) -> ()) {
        var url = URL(string: "https://morning-plains-00409.herokuapp.com/user/rent/\(id)")!
//        print("before request")
        var request = URLRequest(url: url)
//        print("after request")
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
//            print("I am error", error)
//            print("inside task")
            if let error = error {
                // Server error encountered
//                print("first if")
                errorHandler(error, nil)
                return
            }
            
//            print("Status Code")
            print((response as? HTTPURLResponse)?.statusCode)
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            
            guard let response = response as? HTTPURLResponse, response.statusCode < 300 else {
                // Client error encountered
//                print("second if")
                errorHandler(error, statusCode)
                return
            }
            
            // Call our completion handler with our User
            completionHandler(response.statusCode)
        }
        task.resume()
        
    }
}

struct User: Codable {
    let avatar: String
    let username: String
}
