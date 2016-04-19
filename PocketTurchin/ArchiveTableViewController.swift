//
//  ArchiveTableViewController.swift
//  PocketTurchin
//
//  Created by Owner on 4/18/16.
//  Copyright © 2016 shuffleres. All rights reserved.
//

import UIKit

class ArchiveTableViewController: UITableViewController {
    
    //MARKED PROPERTIES 
    var archives = [Archive]()
    
    
    func loadSampleMeals() {
        let photo1 = UIImage(named: "defaultImage")!
        let archive1 = Archive(name: "Test 1", desc: "This is a much longer desc string for test1 This is a much longer desc string for test1 This is a much longer desc string for test1 This is a much longer desc string for test1 This is a much longer desc string for test1 This is a much longer desc string for test1 This is a much longer desc string for test1", photo: photo1)
        
        let photo2 = UIImage(named: "defaultImage")!
        let archive2 = Archive(name: "Test 2", desc: "This is a much longer desc string for test2",photo: photo2)
        
        let photo3 = UIImage(named: "defaultImage")!
        let archive3 = Archive(name: "Test 3", desc: "This is a much longer desc string for test3",photo: photo3)
        
        archives += [archive1, archive2, archive3]

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadSampleMeals()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return 0
        return archives.count

    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ArchiveTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ArchiveTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let archive = archives[indexPath.row]
        
        cell.archiveLabel.text = archive.name
        
        cell.photoImageView.image = archive.photo
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowDetail" {
            let archiveDetailViewController = segue.destinationViewController as! ArchiveViewController
            
            // Get the cell that generated this segue.
            if let selectedArchiveCell = sender as? ArchiveTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedArchiveCell)!
                let selectedArchive = archives[indexPath.row]
                archiveDetailViewController.archive = selectedArchive
            }
        }
    }
    
    
}
