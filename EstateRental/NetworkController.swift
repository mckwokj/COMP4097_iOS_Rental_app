//
//  NetworkController.swift
//  EstateRental
//
//  Created by Man Chun Kwok on 5/11/2020.
//

import Foundation

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
}

//struct Estates: Codable {
//    let id: Int
//    let property_title: String
//    let image_URL: String
//    let estate: String
//    let bedrooms: Int
//    let gross_area: Int
//    let expected_tenants: Int
//    let rent: Int
//}
