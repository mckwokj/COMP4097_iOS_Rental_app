//
//  Estate.swift
//  EstateRental
//
//  Created by Man Chun Kwok on 3/11/2020.
//

import Foundation
import MapKit

class EstateLocation: NSObject, MKAnnotation {
    let title: String?
    let zh_title: String
    let location: String // Festival city, ...
    let coordinate: CLLocationCoordinate2D
    
    var subtitle: String? {
        return "\(zh_title), \(location)"
    }
    
    init(
        title: String?,
        zh_title: String,
        location: String,
        coordinate: CLLocationCoordinate2D
    ) {
        self.title = title
        self.zh_title = zh_title
        self.location = location
        self.coordinate = coordinate
    }
}

extension EstateLocation {
    
    static let estates: [EstateLocation] = [
        EstateLocation(title: "AC Hall",
               zh_title: "大學會堂", location: "Ho Sin Hang",
                 coordinate: CLLocationCoordinate2D(latitude: 22.341280, longitude: 114.179768)),
        EstateLocation(title: "Lam Woo International Conference Center",
               zh_title: "林護國際會議中心", location: "Shaw",
                 coordinate: CLLocationCoordinate2D(latitude: 22.337716, longitude: 114.182013)),
        EstateLocation(title: "Communication and Visual Arts Building",
                 zh_title: "傳理大樓", location: "BU Road",
                 coordinate: CLLocationCoordinate2D(latitude: 22.334382, longitude: 114.182528))
    ]
    
}
