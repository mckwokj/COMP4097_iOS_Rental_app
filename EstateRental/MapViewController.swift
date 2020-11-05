//
//  MapViewController.swift
//  EstateRental
//
//  Created by Man Chun Kwok on 3/11/2020.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    // set initial location in HKBU
    let campusLocation = CLLocation(latitude: 22.33787, longitude: 114.18131)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mapView.setCenterLocation(campusLocation)
        
        for estate in EstateLocation.estates {
            mapView.addAnnotation(estate)
        }
    }

    @IBAction func resetPosition(_ sender: UIButton) {
        mapView.setCenterLocation(campusLocation)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

private extension MKMapView {
    
    func setCenterLocation(_ location: CLLocation,
                           regionRadius: CLLocationDistance = 500) {
        
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        
        setRegion(coordinateRegion, animated: true)
    }
}
