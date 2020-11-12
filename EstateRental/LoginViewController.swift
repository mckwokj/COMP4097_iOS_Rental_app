//
//  LoginViewController.swift
//  EstateRental
//
//  Created by Man Chun Kwok on 11/11/2020.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!

    
    let networkController = NetworkController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    @IBAction func back(_ sender: UIBarButtonItem) {
        print("backBtn clicked")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func login(_ sender: Any) {
        if let username = username.text, let password = password.text {
            networkController.login(username: "Evaleen", password: "Bend", completionHandler: {(user) in
                DispatchQueue.main.async{
                    print("Successful login")
//                    print(user)
                    UserDefaults.standard.set(user.avatar, forKey: "userImage")
                    UserDefaults.standard.set(user.username, forKey: "username")
//                    print("print saved result immediately")
//                    print(UserDefaults.standard.string(forKey: "userImage"))
//                    print(UserDefaults.standard.string(forKey: "username"))
                    print("Save to userDefaults")
                    self.networkController.myRental(errorHandler: {(error) in print(error)})
                    self.dismiss(animated: true, completion: nil)
                }
            }, errorHandler: {_ in print("error occured in login")})
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
