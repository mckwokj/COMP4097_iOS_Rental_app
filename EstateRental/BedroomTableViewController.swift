//
//  BedroomTableViewController.swift
//  EstateRental
//
//  Created by Man Chun Kwok on 12/11/2020.
//

import UIKit

class BedroomTableViewController: UITableViewController {
    
//    var choiceRow: Int? = nil

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
        return 2
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        choiceRow = indexPath.row
//        print(choiceRow)
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

        let text = (sender as! UITableViewCell).textLabel!.text
        var estates: [Estate] = []
        
        if let choice = text {
            switch(choice) {
                case "Bedrooms <= 2":
                    print("Clicked Bedrooms <= 2")
                    
                    Estate.estateData.forEach {
                        if $0.bedrooms <= 2{
                            print($0.property_title)
                            estates.append($0)
                        }
                    }
                    
            case "Bedrooms >= 3":
                    print("Clicked Bedrooms >= 3")
                
                    Estate.estateData.forEach {
                        if $0.bedrooms >= 3{
                            print($0.property_title)
                            estates.append($0)
                        }
                    }
            default:
                print(choice)
            }
        }
        
        if let viewController = segue.destination as? EstateChoiceTableViewController {
            viewController.estate = "from bedrooms table"
            viewController.choices = estates
        }
    
    }
    

}
