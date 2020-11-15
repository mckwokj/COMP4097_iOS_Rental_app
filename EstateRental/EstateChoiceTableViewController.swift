//
//  EstateChoiceTableViewController.swift
//  EstateRental
//
//  Created by Man Chun Kwok on 3/11/2020.
//

import UIKit
import CoreData

class EstateChoiceTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var estate: String?
    var choices: [Estate] = []
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataController = AppDelegate.dataController!
        viewContext = dataController.persistentContainer.viewContext
        
        if let unwrappedEstate = estate {
            self.title = unwrappedEstate
            self.estate = unwrappedEstate
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
        
        if estate != "from bedrooms table" {
//            choices = Estate.estateData.filter {$0.estate == estate}
            let filteredChoices = fetchedResultsController.fetchedObjects?.forEach {
                if $0.estate == estate {
                    
                    let exist = choices.filter {$0.id == $0.id}
                                        
                    let id: Int = Int($0.id)
                    let property_title: String = $0.property_title!
                    let image_URL: String = $0.image_URL!
                    let estate: String = $0.estate!
                    let bedrooms: Int = Int($0.bedrooms)
                    let gross_area: Int = Int($0.gross_area)
                    let expected_tenants: Int = Int($0.expected_tenants)
                    let rent: Int = Int($0.rent)
                    
                    let estateObj = Estate(id: id, property_title: property_title, image_URL: image_URL, estate: estate, bedrooms: bedrooms, gross_area: gross_area, expected_tenants: expected_tenants, rent: rent)
                    
                    if (exist.count == 0) {
                        choices.append(estateObj)
                    }
                }
            }
            
        }
        
        // #warning Incomplete implementation, return the number of rows
        
        print("Bedrooms choices")
        print(choices.count)
        
        return choices.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChoiceCell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = choices[indexPath.row].property_title
        cell.detailTextLabel?.text = choices[indexPath.row].estate
        
        return cell
    }
    

    @IBAction func back(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
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
            
            viewController.id = choices[selectedIndex.row].id
        }
    }
}
