//
//  EstateDetailViewController.swift
//  EstateRental
//
//  Created by Man Chun Kwok on 6/11/2020.
//

import UIKit

class EstateDetailViewController: UIViewController {
    
    var id: Int?
    let networkController = NetworkController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("id is ", id!-1)

        // Do any additional setup after loading the view.
        
        
        
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
