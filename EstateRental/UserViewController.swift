//
//  UserViewController.swift
//  EstateRental
//
//  Created by Man Chun Kwok on 12/11/2020.
//

import UIKit

class UserViewController: UIViewController {

//    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userTable: UIView!
    
    let networkController = NetworkController()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let userImage = UserDefaults.standard.string(forKey: "userImage")
        let username = UserDefaults.standard.string(forKey: "username")

        if let image = userImage, let username = username {
//            print(image)
//            print(username)
            self.username.text = username
            networkController.fetchImage(for: image, completionHandler: {(data) in
                DispatchQueue.main.async {
                    self.userImage.image = UIImage(data: data, scale: 1)
                }
            }) { (error) in
                DispatchQueue.main.async {
                    self.userImage.image = UIImage(named: "user")
                }
            }
        } else {
            self.username.text = "Not yet logged in"
            self.userImage.image = UIImage(named: "user")
        }
        
//        userTable.
//        use userTable entry to determine whether it is login in or myRental button
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        // Do any additional setup after loading the view.
//        let decoded = UserDefaults.standard.object(forKey: "userInfo") as? Data
//        var userData: User? = nil
//
//        print("Outside decoded")
//        if let decoded = decoded {
//            print("Inside decoded")
//            userData = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! User
//        }
//
//        if let user = userData {
//            print(user.avatar)
//            print(user.username)
//            username.text = user.username
//            networkController.fetchImage(for: user.avatar, completionHandler: {(data) in
//                DispatchQueue.main.async {
//                    self.userImage.image = UIImage(data: data, scale: 1)
//                }
//            }) { (error) in
//                DispatchQueue.main.async {
//                    self.userImage.image = UIImage(named: "house.fill")
//                }
//            }
//        }
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
