//
//  EstateDetailViewController.swift
//  EstateRental
//
//  Created by Man Chun Kwok on 6/11/2020.
//

import UIKit
import MapKit
import CoreData

class EstateDetailViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    var id: Int?
    let networkController = NetworkController()
    var estateLocation: CLLocation?
    var estate: [EstateManagedObject]?
    
    @IBOutlet weak var rentalBtn: UIButton!
    let loadingAlert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    
    var viewContext: NSManagedObjectContext?
    
    lazy var fetchedResultsController: NSFetchedResultsController<EstateManagedObject> = {
        
        let fetchRequest = NSFetchRequest<EstateManagedObject>(entityName:"EstateManagedObject")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending:true)]
        
        //        if let code = code {
        //            fetchRequest.predicate = NSPredicate(format: "dept_id = %@", code)
        //        }
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: viewContext!,
                                                    sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let dataController = (UIApplication.shared.delegate as? AppDelegate)!.dataController!
        let dataController = AppDelegate.dataController!
        viewContext = dataController.persistentContainer.viewContext
        
        print("id is ", id!-1)
        
        // Do any additional setup after loading the view.
        
        let myRentalId = UserDefaults.standard.object(forKey: "myRental") as? [Int]
        
        //        print(myRentalId)
        
        if myRentalId?.contains(id!) != nil && (myRentalId?.contains(id!))! {
            //            print("inside myRentalId.contains(id!)")
            rentalBtn.setTitle("Move-out", for: UIControl.init().state)
            rentalBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        }
        
        estate = fetchedResultsController.fetchedObjects?.filter {$0.id == id!}
        
        if let imageView = view.viewWithTag(100) as? UIImageView {
            
//            var url = Estate.estateData[id!-1].image_URL
//            fetchedResultsController.object(at: indexPath).property_title
            var url = estate![0].image_URL!
            
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
                    let id: Int = Int(self.estate![0].id)
                    let data = UserDefaults.standard.object(forKey: "estateImage/\(id)") as! Data
                    
                    print("imageData is:", data)
                    
                    imageView.image = UIImage(data: data , scale: 1)
                }
            }
            
        }
        
        if let viewLabel = view.viewWithTag(200) as? UILabel {
            //            viewLabel.text = estates[indexPath.row].property_title
//            viewLabel.text = Estate.estateData[id!-1].property_title
            viewLabel.text = estate![0].property_title
        }
        
        if let viewLabel = view.viewWithTag(300) as? UILabel {
            //            viewLabel.text = estates[indexPath.row].estate
//            viewLabel.text = "Estate: "+Estate.estateData[id!-1].estate+", Bedrooms: "+String(Estate.estateData[id!-1].bedrooms)
            viewLabel.text = "Estate: "+estate![0].estate!+", Bedrooms: "+String(estate![0].bedrooms)
        }
        
        if let viewLabel = view.viewWithTag(400) as? UILabel {
            //            viewLabel.text = "Rent: $"+String(estates[indexPath.row].rent)
//            viewLabel.text = "Rent: $"+String(Estate.estateData[id!-1].rent)+", Tenants: "+String(Estate.estateData[id!-1].expected_tenants)+", Area: "+String(Estate.estateData[id!-1].gross_area)
            viewLabel.text = "Rent: $"+String(estate![0].rent)+", Tenants: "+String(estate![0].expected_tenants)+", Area: "+String(estate![0].gross_area)
        }
//        Estate.location.forEach {
//            $0.display_name
//        }
        
        var locationNotFound: Bool = true
        
//        let location = Estate.location.filter {$0.display_name == estate![0].estate!}
        
        Estate.location.forEach {
//            print("Location:",$0.display_name.contains(estate![0].estate!))
            if $0.display_name.contains(estate![0].estate!) {
                locationNotFound = false
            }
        }
        
        if locationNotFound == true {
//            print("Location: location not in here")
            networkController.fetchLocations(estateName: estate![0].estate!, errorHandler: {(error) in
                self.estateLocation = nil
                print("In MapViewController, the error is:", error)
            }, completionHandler: {(location) in
                self.estateLocation = location
            })
        } else {
//            print("Location: location in here already")
            let location = Estate.location.filter {$0.display_name.contains(estate![0].estate!)}
            estateLocation = CLLocation(latitude: Double(location[0].lat)!, longitude: Double(location[0].lon)!)
        }
    }
    
    @IBAction func address(_ sender: UIButton) {
        print("I am address btn")
        return
    }
    
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
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
                    self.dismiss(animated: true, completion: nil)
                })
            )
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        networkController.isOnline {
            if (buttonTxt == "Move-in") {
                DispatchQueue.main.async {
                    let alert = UIAlertController(
                        title: "Are you sure?",
                        message: "to move in this apartment?",
                        preferredStyle: .alert
                    )
                    
                    alert.addAction(
                        UIAlertAction(title: "No", style: .default, handler: { (action) in
                            print("No button pressed!")
                            //                        self.dismiss(animated: true, completion: nil)
                            //                        self.navigationController?.popToRootViewController(animated: true)
                        })
                    )
                    alert.addAction(
                        UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                            print("Yes button pressed!")
                            
                            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
                            loadingIndicator.hidesWhenStopped = true
                            loadingIndicator.style = UIActivityIndicatorView.Style.gray
                   
                            loadingIndicator.startAnimating()
                            
                            self.loadingAlert.view.addSubview(loadingIndicator)
                            self.present(self.loadingAlert, animated: true, completion: nil)
                            
                            self.networkController.moveIn(id: self.id!,
                                                          completionHandler: {(statusCode) in
                                                            if let code = statusCode {
                                                                if code == 200 {
                                                                    DispatchQueue.main.async {
                                                                        self.dismiss(animated: false, completion: {
                                                                            let alert = UIAlertController(
                                                                                title: "Move-in successfully",
                                                                                message: "The rental has successfully been moved-in.",
                                                                                preferredStyle: .alert
                                                                            )
                                                                            
                                                                            alert.addAction(
                                                                                UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                                                                    print("OK button pressed!")
                                                                                    self.dismiss(animated: true, completion: nil)
                                                                                    self.navigationController?.popToRootViewController(animated: true)
                                                                                })
                                                                            )
                                                                            self.present(alert, animated: true, completion: nil)
                                                                        })
                                                                    }
                                                                }
                                                            }
                                                            
                                                            self.networkController.myRental(errorHandler: {(error) in
                                                                print(error)
                                                            })
                                                            
                                                          }, errorHandler: {(error, statusCode) in
                                                            print("error occured in move-in")
                                                            
                                                            var msg: String? = nil
                                                            
                                                            if statusCode == nil {
                                                                msg = "Internet connection problem."
                                                            }
                                                            
                                                            //                print(error)
                                                            print(statusCode)
                                                            if let code = statusCode {
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
                                                            }
                                                            DispatchQueue.main.async {
                                                                self.dismiss(animated: false, completion: {
                                                                    let alert = UIAlertController(
                                                                        title: "Unsuccessful Move-in",
                                                                        message: msg,
                                                                        preferredStyle: .alert
                                                                    )
                                                                    
                                                                    alert.addAction(
                                                                        UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                                                            print("OK button pressed!")
                                                                            self.dismiss(animated: true, completion: nil)
                                                                            self.navigationController?.popToRootViewController(animated: true)
                                                                        })
                                                                    )
                                                                    self.present(alert, animated: true, completion: nil)
                                                                })
                                                                
                                                            }
                                                          })
                            
                        })
                    )
                    self.present(alert, animated: true, completion: nil)
                    
                }
            } else if (buttonTxt == "Move-out") {
                DispatchQueue.main.async {
                    let alert = UIAlertController(
                        title: "Are you sure?",
                        message: "to move out this apartment?",
                        preferredStyle: .alert
                    )
                    
                    alert.addAction(
                        UIAlertAction(title: "No", style: .default, handler: { (action) in
                            print("No button pressed!")
                            //                        self.dismiss(animated: true, completion: nil)
                            //                        self.navigationController?.popToRootViewController(animated: true)
                        })
                    )
                    alert.addAction(
                        UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                            print("Yes button pressed!")
                            
                            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
                            loadingIndicator.hidesWhenStopped = true
                            loadingIndicator.style = UIActivityIndicatorView.Style.gray
                            loadingIndicator.startAnimating();
                            
                            self.loadingAlert.view.addSubview(loadingIndicator)
                            self.present(self.loadingAlert, animated: true, completion: nil)
                            
                            self.networkController.moveOut(id: self.id!,
                                                           completionHandler: {(statusCode) in
                                                            if let code = statusCode {
                                                                if code == 200 {
                                                                    DispatchQueue.main.async {
                                                                        self.dismiss(animated: false, completion: {
                                                                            let alert = UIAlertController(
                                                                                title: "Move-out successfully",
                                                                                message: "The rental has successfully been moved-out.",
                                                                                preferredStyle: .alert
                                                                            )
                                                                            
                                                                            alert.addAction(
                                                                                UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                                                                    print("OK button pressed!")
                                                                                    self.dismiss(animated: true, completion: nil)
                                                                                    self.navigationController?.popToRootViewController(animated: true)
                                                                                })
                                                                            )
                                                                            
                                                                            self.present(alert, animated: true, completion: nil)
                                                                        })
                                                                    }
                                                                }
                                                            }
                                                            self.networkController.myRental(errorHandler: {(error) in
                                                                print(error)
                                                            })
                                                           },
                                                           errorHandler: {(error, statusCode) in
                                                            var msg: String? = nil
                                                            
                                                            if statusCode == nil {
                                                                msg = "Internet connection problem."
                                                            }
                                                            
                                                            if let code = statusCode {
                                                                switch code {
                                                                case 404:
                                                                    msg = "Property not found."
                                                                case 409:
                                                                    msg = "Nothing to delete."
                                                                default:
                                                                    msg = "Server error"
                                                                }
                                                            }
                                                            DispatchQueue.main.async {
                                                                self.dismiss(animated: false, completion: {
                                                                    let alert = UIAlertController(
                                                                        title: "Unsuccessful Move-out",
                                                                        message: msg,
                                                                        preferredStyle: .alert
                                                                    )
                                                                    
                                                                    alert.addAction(
                                                                        UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                                                            print("OK button pressed!")
                                                                            self.dismiss(animated: true, completion: nil)
                                                                            self.navigationController?.popToRootViewController(animated: true)
                                                                        })
                                                                    )
                                                                    self.present(alert, animated: true, completion: nil)
                                                                })
                                                            }
                                                           })
                            
                        })
                    )
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } errorHandler: {
            DispatchQueue.main.async {
                let alert = UIAlertController(
                    title: "Internet connection problem",
                    message: "Please check your internet connection.",
                    preferredStyle: .alert
                )
                
                alert.addAction(
                    UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        print("OK button pressed!")
                        self.dismiss(animated: true, completion: nil)
                        self.navigationController?.popToRootViewController(animated: true)
                    })
                )
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        
        
    }
    
//    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
//
//        var performSegue = false
//
//        let a = networkController.isOnline {
//            performSegue = true
//            print("I am address btn (completion):", performSegue)
//        } errorHandler: {
//            DispatchQueue.main.async {
//                let alert = UIAlertController(
//                    title: "Internet connection problem",
//                    message: "Please check your internet connection.",
//                    preferredStyle: .alert
//                )
//
//                alert.addAction(
//                    UIAlertAction(title: "OK", style: .default, handler: { (action) in
//                        print("OK button pressed!")
//                        self.dismiss(animated: true, completion: nil)
//                        self.navigationController?.popToRootViewController(animated: true)
//                    })
//                )
//                self.present(alert, animated: true, completion: nil)
//
//            }
//            performSegue = false
//            print("I am address btn (error):", performSegue)
//        }
//
//        print("I am address btn:", performSegue)
//        print("I am address btn: (a)",a)
//        return performSegue
//    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        
        if let viewController = segue.destination as? MapViewController {
            
            print("I am prepare")
            
            networkController.isOnline {
//                viewController.estate = Estate.estateData[self.id!-1].estate
                if let estate = self.estate![0].estate, let estateLocation = self.estateLocation {
                    viewController.estate = estate
                    viewController.estateLocation = estateLocation
                } else {
                    DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: {
                        let alert = UIAlertController(
                            title: "Error occured when finding the corrdinate",
                            message: "Please try again.",
                            preferredStyle: .alert
                        )
                        
                        alert.addAction(
                            UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                print("OK button pressed!")
                                self.dismiss(animated: true, completion: nil)
                                self.navigationController?.popToRootViewController(animated: true)
                            })
                        )
                        self.present(alert, animated: true, completion: nil)
                    })
                }
                }
                
//                self.estateLocation
            } errorHandler: {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: {
                        let alert = UIAlertController(
                            title: "Internet connection problem",
                            message: "Please check your internet connection.",
                            preferredStyle: .alert
                        )
                        
                        alert.addAction(
                            UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                print("OK button pressed!")
                                self.dismiss(animated: true, completion: nil)
                                self.navigationController?.popToRootViewController(animated: true)
                            })
                        )
                        self.present(alert, animated: true, completion: nil)
                    })
                }
            }
        }
    }
    
    
}
