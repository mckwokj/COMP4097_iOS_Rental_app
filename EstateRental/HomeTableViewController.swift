//
//  HomeTableViewController.swift
//  EstateRental
//
//  Created by Man Chun Kwok on 5/11/2020.
//

import UIKit
import CoreData

class HomeTableViewController: UITableViewController{
    
    let networkController = NetworkController()
    var estates: [Estate] = []
    var testImg: String?
    
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
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        print("viewWillAppear")
//        print(animated)
//
//        let dataController = (UIApplication.shared.delegate as? AppDelegate)!.dataController!
//        viewContext = dataController.persistentContainer.viewContext
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action:  #selector(reloadEstate), for: UIControl.Event.valueChanged)
        self.refreshControl = refreshControl
        
//        let dataController = (UIApplication.shared.delegate as? AppDelegate)!.dataController!
        let dataController = AppDelegate.dataController!
        viewContext = dataController.persistentContainer.viewContext
        
//        self.tableView.reloadData()
        
        //        networkController.fetchEstates(completionHandler: {(estates) in
        //            DispatchQueue.main.async {
        //                self.estates = estates
        //                self.tableView.reloadData()
        //            }
        //        }) {(error) in
        //            DispatchQueue.main.async {
        //                self.estates = []
        //                self.tableView.reloadData()
        //            }
        //        }
        
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
        //        return estates.count
        //        print(fetchedResultsController.sections?[section].numberOfObjects ?? 0)
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath)
        
        // Configure the cell...
        if let imageView = cell.viewWithTag(100) as? UIImageView {
            
            var url = fetchedResultsController.object(at: indexPath).image_URL!
            testImg = fetchedResultsController.object(at: indexPath).image_URL!
            
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
//                    imageView.image = UIImage(named: "house.fill")
                }
            }
            
        }
        
        if let cellLabel = cell.viewWithTag(200) as? UILabel {
            //            cellLabel.text = estates[indexPath.row].property_title
            cellLabel.text = fetchedResultsController.object(at: indexPath).property_title
        }
        
        if let cellLabel = cell.viewWithTag(300) as? UILabel {
            //            cellLabel.text = estates[indexPath.row].estate
            cellLabel.text = fetchedResultsController.object(at: indexPath).estate
        }
        
        if let cellLabel = cell.viewWithTag(400) as? UILabel {
            //            cellLabel.text = "Rent: $"+String(estates[indexPath.row].rent)
            cellLabel.text = "Rent: $"+String(fetchedResultsController.object(at: indexPath).rent)
        }
        
        return cell
    }
    
    @objc func reloadEstate() {
        let fetchRequest = NSFetchRequest<EstateManagedObject>(entityName:"EstateManagedObject")
        viewContext = AppDelegate.dataController!.persistentContainer.viewContext
        
        // user fetchImage function for checking internet connection
        guard Estate.estateData.count != 0 else {
            DispatchQueue.main.async {
                self.networkController.fetchEstates(completionHandler: {(estates) in
                    DispatchQueue.main.async {
                        Estate.estateData = estates
                        // call seedData after fetching estate data
                        AppDelegate.dataController?.seedData()
                        self.tableView.reloadData()
                    }
                }) {(error) in
                    DispatchQueue.main.async {
                        Estate.estateData = []
                        self.tableView.reloadData()
                    }
                }
            }
            self.refreshControl?.endRefreshing()
            return
        }
        
        networkController.fetchImage(for: testImg!,
                                     completionHandler: {_ in
                                        DispatchQueue.main.async {
                                            if let result = try? self.viewContext?.fetch(fetchRequest) {
                                                for object in result {
                                                    self.viewContext?.delete(object)
                                                }
//                                                print("(before saving) fetchResultsController:",self.fetchedResultsController.fetchedObjects)
                                                try? self.viewContext?.save()
                                                print("(after saving) fetchResultsController:",self.fetchedResultsController.fetchedObjects)
                                                
                                                DispatchQueue.main.async {
                                                    self.networkController.fetchEstates(completionHandler: {(estates) in
                                                        DispatchQueue.main.async {
                                                            Estate.estateData = estates
                                                            // call seedData after fetching estate data
                                                            AppDelegate.dataController?.seedData()
                                                            self.tableView.reloadData()
                                                            print("(after downloading) fetchResultsController:",self.fetchedResultsController.fetchedObjects)
                                                            
                                                        }
                                                    }) {(error) in
                                                        DispatchQueue.main.async {
                                                            Estate.estateData = []
                                                            self.tableView.reloadData()
                                                        }
                                                    }             
                                                }
                                            
                                            }
                                            self.refreshControl?.endRefreshing()
                                        }
                                     },
                                     errorHandler: {(error) in
                                        DispatchQueue.main.async {
                                            print(error)
                                            self.refreshControl?.endRefreshing()
                                        }
                                     })
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

            viewController.id = Int(fetchedResultsController.object(at: selectedIndex).id)
        }
        
     }
     
    
}

extension HomeTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                        didChange anObject: Any, at indexPath: IndexPath?,
                        for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
            
            tableView.reloadData()
        }
}
