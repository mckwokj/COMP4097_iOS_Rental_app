//
//  HomeTableViewController.swift
//  EstateRental
//
//  Created by Man Chun Kwok on 5/11/2020.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    let networkController = NetworkController()
    var estates: [Estate] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        networkController.fetchEstates(completionHandler: {(estates) in
            DispatchQueue.main.async {
                self.estates = estates
                self.tableView.reloadData()
            }
        }) {(error) in
            DispatchQueue.main.async {
                self.estates = []
                self.tableView.reloadData()
            }
        }
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
        return estates.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath)

        // Configure the cell...
        if let imageView = cell.viewWithTag(100) as? UIImageView {
            
            networkController.fetchImage(for: estates[indexPath.row].image_URL, completionHandler: { (data) in
                DispatchQueue.main.async {
                    imageView.image = UIImage(data: data, scale:1)
                }
            }) { (error) in
                DispatchQueue.main.async {
                    imageView.image = UIImage(named: "house.fill")
                }
            }
        }
        
        if let cellLabel = cell.viewWithTag(200) as? UILabel {
            cellLabel.text = estates[indexPath.row].property_title
        }
        
        if let cellLabel = cell.viewWithTag(300) as? UILabel {
            cellLabel.text = estates[indexPath.row].estate
        }
        
        if let cellLabel = cell.viewWithTag(400) as? UILabel {
            cellLabel.text = "Rent: $"+String(estates[indexPath.row].rent)
        }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
