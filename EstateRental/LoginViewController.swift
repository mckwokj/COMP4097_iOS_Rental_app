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
    
    let loadingAlert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    
    let networkController = NetworkController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let userImage = UserDefaults.standard.string(forKey: "userImage")
        
        guard userImage != nil else {
            return
        }
        
        if userImage != "user" {
            DispatchQueue.main.async {
                
//                let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
//                loadingIndicator.hidesWhenStopped = true
//                loadingIndicator.style = UIActivityIndicatorView.Style.gray
//
//                loadingIndicator.startAnimating()
//
//                self.loadingAlert.view.addSubview(loadingIndicator)
//                self.present(self.loadingAlert, animated: true, completion: nil)
                
//                self.dismiss(animated: false, completion: {
//                    let alert = UIAlertController(
//                        title: "Successful logout",
//                        message: "You have successfully logged out.",
//                        preferredStyle: .alert
//                    )
//
//                    alert.addAction(
//                        UIAlertAction(title: "OK", style: .default, handler: { (action) in
//                            print("OK button pressed!")
//                            //                            self.dismiss(animated: true, completion: nil)
//                        })
//                    )
//                    self.present(alert, animated: true, completion: nil)
//                })
                let alert = UIAlertController(
                    title: "Successful logout",
                    message: "You have successfully logged out.",
                    preferredStyle: .alert
                )
                
                alert.addAction(
                    UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        print("OK button pressed!")
                        //                            self.dismiss(animated: true, completion: nil)
                    })
                )
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        print("backBtn clicked")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func login(_ sender: Any) {
        if let username = username.text, let password = password.text {
            networkController.login(username: "Evaleen", password: "Bend", completionHandler: {(user) in
                
                DispatchQueue.main.async{
                    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
                    loadingIndicator.hidesWhenStopped = true
                    loadingIndicator.style = UIActivityIndicatorView.Style.gray
                    
                    loadingIndicator.startAnimating()
                    
                    self.loadingAlert.view.addSubview(loadingIndicator)
                    self.present(self.loadingAlert, animated: true, completion: nil)
                    
                    UserDefaults.standard.set(user.avatar, forKey: "userImage")
                    UserDefaults.standard.set(user.username, forKey: "username")
                    //                    self.networkController.myRental(errorHandler: {(error) in print(error)})
                    self.dismiss(animated: false, completion: {
                        let alert = UIAlertController(
                            title: "Successful login",
                            message: "Welcome back, \(user.username)!",
                            preferredStyle: .alert
                        )
                        
                        alert.addAction(
                            UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                print("OK button pressed!")
                                self.networkController.myRental(errorHandler: {(error) in
                                    print(error)
                                })
                                self.dismiss(animated: true, completion: nil)
                            })
                        )
                        self.present(alert, animated: true, completion: nil)
                        
                    })
                }
            }, errorHandler: {(error, statusCode) in
                print(error)
                print(statusCode)
                
                let msg: String?
                
                if statusCode == nil {
                    msg = "Please try again."
                } else {
                    switch(statusCode) {
                    case 400:
                        msg = "Bad request."
                    case 401:
                        msg = "User not found or Wrong Password."
                    case 500:
                        msg = "Server error."
                    default:
                        msg = "Please try again."
                    }
                }
                DispatchQueue.main.async {
                    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
                    loadingIndicator.hidesWhenStopped = true
                    loadingIndicator.style = UIActivityIndicatorView.Style.gray
                    
                    loadingIndicator.startAnimating()
                    
                    self.loadingAlert.view.addSubview(loadingIndicator)
                    self.present(self.loadingAlert, animated: true, completion: nil)
                    
                    self.dismiss(animated: false, completion: {
                        let alert = UIAlertController(
                            title: "Fail to login",
                            message: msg,
                            preferredStyle: .alert
                        )
                        
                        alert.addAction(
                            UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                print("OK button pressed!")
                                //                                self.dismiss(animated: true, completion: nil)
                            })
                        )
                        self.present(alert, animated: true, completion: nil)
                    })
                }
            })
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
