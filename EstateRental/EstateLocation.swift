//
//  Estate.swift
//  EstateRental
//
//  Created by Man Chun Kwok on 3/11/2020.
//

import Foundation
import MapKit

//class EstateLocation: NSObject, MKAnnotation {
class EstateLocation: NSObject, Decodable{
//    let place_id: Int
//    let licence: String
//    let osm_type: String
//    let osm_id: String
//    let boundingbox: [Double]
//    let `class`: String
//    let type: String
//    let title: String
    let importance: Double
    let lat: String
    let lon: String
    let display_name: String

    
    init(
        importance: Double,
        lat: String,
        lon: String,
        display_name: String
    ) {
        self.display_name = display_name
        self.importance = importance
        self.lat = lat
        self.lon = lon
//        self.title = display_name
    }
}

//extension EstateLocation: MKAnnotation {
//    var coordinate: CLLocationCoordinate2D {
//        return CLLocationCoordinate2D(latitude: CLLocationDegrees(lat)!, longitude: CLLocationDegrees(lon)!)
//    }
    
//    static let estates: [EstateLocation] = [
//        EstateLocation(title: "AC Hall",
//               zh_title: "大學會堂", location: "Ho Sin Hang",
//                 coordinate: CLLocationCoordinate2D(latitude: 22.341280, longitude: 114.179768)),
//        EstateLocation(title: "Lam Woo International Conference Center",
//               zh_title: "林護國際會議中心", location: "Shaw",
//                 coordinate: CLLocationCoordinate2D(latitude: 22.337716, longitude: 114.182013)),
//        EstateLocation(title: "Communication and Visual Arts Building",
//                 zh_title: "傳理大樓", location: "BU Road",
//                 coordinate: CLLocationCoordinate2D(latitude: 22.334382, longitude: 114.182528))
//    ]
    
//}
