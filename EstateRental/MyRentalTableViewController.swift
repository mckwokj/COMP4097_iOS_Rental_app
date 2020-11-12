//
//  MyRentalTableViewController.swift
//  EstateRental
//
//  Created by Man Chun Kwok on 12/11/2020.
//

import UIKit

class MyRentalTableViewController: UITableViewController {
    
    var myRentals: [Estate] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if UserDefaults.standard.string(forKey: "userImage") == "user" {
            DispatchQueue.main.async {
                let alert = UIAlertController(
                    title: "Not yet logged in",
                    message: "You haven't logged in.",
                    preferredStyle: .alert
                )

                alert.addAction(
                    UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        print("OK button pressed!")
                    })
                )
                self.present(alert, animated: true, completion: nil)
            }
            self.dismiss(animated: true, completion: nil)
        }
        else if (UserDefaults.standard.object(forKey: "myRental") as! [Int]).count == 0{
            DispatchQueue.main.async {
                let alert = UIAlertController(
                    title: "No rented estate",
                    message: "You haven't rent any estate.",
                    preferredStyle: .alert
                )

                alert.addAction(
                    UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        print("OK button pressed!")
                    })
                )
                self.present(alert, animated: true, completion: nil)
            }
            self.dismiss(animated: true, completion: nil)
        }
        
        return (UserDefaults.standard.object(forKey: "myRental") as! [Int]).count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RentalCell", for: indexPath)

        // Configure the cell...
        let rentalId = UserDefaults.standard.object(forKey: "myRental") as! [Int]
        myRentals = Estate.estateData.filter { rentalId.contains($0.id) }
        
        cell.textLabel?.text = myRentals[indexPath.row].property_title
        cell.detailTextLabel?.text = myRentals[indexPath.row].estate

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let viewController = segue.destination as? EstateDetailViewController {
            let selectedIndex = tableView.indexPathForSelectedRow!
//            print(selectedIndex.row)
            viewController.id = myRentals[selectedIndex.row].id
        }
        
    }
    

}