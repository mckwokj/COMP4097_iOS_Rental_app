//
//  Estate.swift
//  EstateRental
//
//  Created by Man Chun Kwok on 3/11/2020.
//

import Foundation

struct Estate {
    let id: Int
    let property_title: String
    let image_URL: String
    let estate: String
    let bedrooms: Int
    let gross_area: Int
    let expected_tenants: Int
    let rent: Int
}

extension Estate: Decodable {
    
    static var estateData: [Estate] = []
//
//    static var estateData: [Estate] = {
//        do {
//            guard let rawEstateData = try? Data(contentsOf: Bundle.main.bundleURL.appendingPathComponent("estates.json")) else {
//                return []
//            }
//            return try JSONDecoder().decode([Estate].self, from: rawEstateData)
//
//        } catch {
//            print("estates.json was not found or is not decodable")
//            print(error)
//        }
//
//        return []
//    }()
//
    static func getEstateNames() -> [String] {
        var estateName: [String] = []

        for estate in Estate.estateData {
            if !estateName.contains(estate.estate) {
                estateName.append(estate.estate)
            }
        }
        return estateName
    }
}
