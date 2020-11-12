//
//  MapViewController.swift
//  EstateRental
//
//  Created by Man Chun Kwok on 3/11/2020.
//

import UIKit
import MapKit

//class MapViewController: UIViewController, MKAnnotation {
class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
//    var coordinate: CLLocationCoordinate2D
    let networkController = NetworkController()
    // set initial location in HKBU
//    let campusLocation = CLLocation(latitude: 22.33787, longitude: 114.18131)
    var estateLocation: CLLocation?
    var estate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        if let estate = estate {
//            networkController.fetchLocations(estateName: estate, errorHandler: {(error) in
//                self.estateLocation = nil
//                print("In MapViewController, the error is:", error)
//            }, completionHandler: {(location) in
//                self.estateLocation = location
//            })
//        }
//        
        print("In MapViewController, the estateLocation:", self.estateLocation)
//        
        if let estateLocation = estateLocation {
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = estateLocation
            
            print("in second if")
            mapView.setCenterLocation(estateLocation)
//            mapView.addAnnotation(estateLocation)
            addAnnotations(coord: estateLocation)
//            mapView.setCenterLocation(estateLocation)
        }
    }

    @IBAction func back(_ sender: UIButton) {
        print("backBtn clicked")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetPosition(_ sender: UIButton) {
        if let estateLocation = self.estateLocation {
            mapView.setCenterLocation(estateLocation)
        }
    }
    
    func addAnnotations(coord: CLLocation){

        let CLLCoordType = CLLocationCoordinate2D(latitude: coord.coordinate.latitude,
                                                  longitude: coord.coordinate.longitude)
        let anno = MKPointAnnotation()
        anno.coordinate = CLLCoordType
        anno.title = estate
        mapView.addAnnotation(anno)

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
