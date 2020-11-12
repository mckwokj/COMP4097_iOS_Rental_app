//
//  EstateDetailViewController.swift
//  EstateRental
//
//  Created by Man Chun Kwok on 6/11/2020.
//

import UIKit
import MapKit

class EstateDetailViewController: UIViewController {
    
    var id: Int?
    let networkController = NetworkController()
    var estateLocation: CLLocation?
    
    @IBOutlet weak var rentalBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("id is ", id!-1)

        // Do any additional setup after loading the view.
        
        let myRentalId = UserDefaults.standard.object(forKey: "myRental") as! [Int]
        
//        print(myRentalId)
        if myRentalId.contains(id!) {
//            print("inside myRentalId.contains(id!)")
            rentalBtn.setTitle("Move-out", for: UIControl.init().state)
        }
        
        if let imageView = view.viewWithTag(100) as? UIImageView {
            
            var url = Estate.estateData[id!-1].image_URL
            
            if !url.contains("https") {
                let index = url.index(url.endIndex, offsetBy: 4-url.count)
                let mySubstring = url.suffix(from: index) // Hello
                
//                print("https"+mySubstring)
                url = "https"+mySubstring
            }

            networkController.fetchImage(for: url, completionHandler: {(data) in
                DispatchQueue.main.async {
                    imageView.image = UIImage(data: data, scale: 1)
                }
            }) { (error) in
                DispatchQueue.main.async {
                    imageView.image = UIImage(named: "house.fill")
                }
            }

        }

        if let viewLabel = view.viewWithTag(200) as? UILabel {
            //            viewLabel.text = estates[indexPath.row].property_title
            viewLabel.text = Estate.estateData[id!-1].property_title
        }

        if let viewLabel = view.viewWithTag(300) as? UILabel {
            //            viewLabel.text = estates[indexPath.row].estate
            viewLabel.text = "Estate: "+Estate.estateData[id!-1].estate+", Bedrooms: "+String(Estate.estateData[id!-1].bedrooms)
        }

        if let viewLabel = view.viewWithTag(400) as? UILabel {
            //            viewLabel.text = "Rent: $"+String(estates[indexPath.row].rent)
            viewLabel.text = "Rent: $"+String(Estate.estateData[id!-1].rent)+", Tenants: "+String(Estate.estateData[id!-1].expected_tenants)+", Area: "+String(Estate.estateData[id!-1].gross_area)
        }
        
            networkController.fetchLocations(estateName: Estate.estateData[id!-1].estate, errorHandler: {(error) in
                self.estateLocation = nil
                print("In MapViewController, the error is:", error)
            }, completionHandler: {(location) in
                self.estateLocation = location
            })
    }
    

    @IBAction func moveEstate(_ sender: UIButton) {
        
        let buttonTxt = sender.titleLabel?.text
//        let image = UserDefaults.standard.string(forKey: "userImage")
        let username = UserDefaults.standard.string(forKey: "username")
        
        guard buttonTxt != nil else {
            print("Button text not found")
            return
        }
        
        guard username != nil else {
            
            let alert = UIAlertController(
                title: "Not yet logged in",
                message: "Please login first.",
                preferredStyle: .alert
            )

            alert.addAction(
                UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    print("OK button pressed!")
                })
            )

            self.present(alert, animated: true, completion: nil)
            
            return
        }
            
        if (buttonTxt == "Move-in") {
            networkController.moveIn(id: id!,
                                     completionHandler: {(statusCode) in
                                        if let code = statusCode {
                                            if code == 200 {
                                                DispatchQueue.main.async {
                                                    let alert = UIAlertController(
                                                        title: "Successful Move-in",
                                                        message: "The rental has successfully been moved-out.",
                                                        preferredStyle: .alert
                                                    )

                                                    alert.addAction(
                                                        UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                                            print("OK button pressed!")
                                                        })
                                                    )

                                                    self.present(alert, animated: true, completion: nil)
                                                    self.dismiss(animated: true, completion: nil)
                                                }
                                            }
                                        }
                                        
                                     }, errorHandler: {(error, statusCode) in
                                            print("error occured in move-in")
                            //                print(error)
                                            print(statusCode)
                                            if let code = statusCode {
                                                var msg: String? = nil
                                                switch code {
                                                case 404:
                                                    msg = "Property not found."
                                                case 409:
                                                    msg = "Already rented."
                                                case 422:
                                                    msg = "Already Full."
                                                default:
                                                    msg = "Server error"
                                                }
                                                
                                                DispatchQueue.main.async {
                                                    let alert = UIAlertController(
                                                        title: "Unsuccessful Move-in",
                                                        message: msg,
                                                        preferredStyle: .alert
                                                    )

                                                    alert.addAction(
                                                        UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                                            print("OK button pressed!")
                                                        })
                                                    )
                                                    self.present(alert, animated: true, completion: nil)
                                                }
                                            }
            })
        } else if (buttonTxt == "Move-out") {
            networkController.moveOut(id: id!,
                                      completionHandler: {(statusCode) in
                                        if let code = statusCode {
                                            if code == 200 {
                                                DispatchQueue.main.async {
                                                    let alert = UIAlertController(
                                                        title: "Successful Move-out",
                                                        message: "The rental has successfully been moved-out.",
                                                        preferredStyle: .alert
                                                    )

                                                    alert.addAction(
                                                        UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                                            print("OK button pressed!")
                                                        })
                                                    )
                                                    self.present(alert, animated: true, completion: nil)
                                                    self.dismiss(animated: true, completion: nil)
                                                }
                                            }
                                        }
                                      },
                                      errorHandler: {(error, statusCode) in
                                        if let code = statusCode {
                                            var msg: String? = nil
                                            switch code {
                                            case 404:
                                                msg = "Property not found."
                                            case 409:
                                                msg = "Nothing to delete."
                                            default:
                                                msg = "Server error"
                                            }
                                            
                                            DispatchQueue.main.async {
                                                let alert = UIAlertController(
                                                    title: "Unsuccessful Move-out",
                                                    message: msg,
                                                    preferredStyle: .alert
                                                )

                                                alert.addAction(
                                                    UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                                        print("OK button pressed!")
                                                    })
                                                )

                                                self.present(alert, animated: true, completion: nil)
                                            }
                                        }})
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let viewController = segue.destination as? MapViewController {
            
            viewController.estate = Estate.estateData[id!-1].estate
            viewController.estateLocation = estateLocation
        }
    }
    

}
