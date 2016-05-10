//
//  CurrentTableViewController.swift
//  PocketTurchin
//
//  Created by Owner on 5/10/16.
//  Copyright © 2016 shuffleres. All rights reserved.
//

import UIKit

class CurrentTableViewController: UITableViewController {
    
    var currents = [Archive]()
    var photo: UIImage = UIImage(named: "defaultImage")!
    var desc: String = ""
    var name: String = ""
    var archive_count = -1
    var picture_count = 0
    
    func loadAllCurrent() {
        
        print("Loading all current")
        self.count_selection { (archive) in
            self.archive_count = archive[0] as! Int
            print(String(archive[0]))
        }
        
        func load_all() {
            self.load_all_archives { (archive) in
                var url_string = archive[2] as! String
                if (!url_string.isEmpty) {
                    
                    self.getImageFromServerById(String(archive[2])) { image in
                        func call_seque()
                        {
                            //self.photo = image!
                            self.currents[self.picture_count].photo = image!
                            self.picture_count = self.picture_count + 1
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.tableView.reloadData()
                                self.log("Reloading UI for image")
                            })
                        }
                        
                        dispatch_async(dispatch_get_main_queue(),call_seque)
                        
                    }
                }
                else {
                    self.picture_count = self.picture_count + 1
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                    })
                }
                self.desc = archive[1] as! String
                self.name = archive[0] as! String
                
                let archive_temp = Archive(name: self.name, desc: self.desc,photo: self.photo)
                self.currents += [archive_temp]
                
            }
        }
        dispatch_async(dispatch_get_main_queue(),load_all)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadAllCurrent()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return currents.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "CurrentTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CurrentTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let current = currents[indexPath.row]
        
        cell.archiveLabel.text = current.name
        cell.photoImageView.image = current.photo
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowDetail" {
            let currentDetailViewController = segue.destinationViewController as! ArchiveViewController
            
            // Get the cell that generated this segue.
            if let selectedCurrentCell = sender as? CurrentTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedCurrentCell)!
                let selectedCurrent = currents[indexPath.row]
                currentDetailViewController.archive = selectedCurrent
            }
        }
    }
    
    func load_all_archives(completionHandler: (archive: NSArray) -> ()) {
        let requestURL: NSURL = NSURL(string: "http://cs.appstate.edu/Turchin/currentGetter.php")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            if (statusCode == 200) {
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    if let datas = json["data"] as? [[String: AnyObject]] {
                        print(datas)
                        for data in datas {
                            if let name = data["name"] as? String {
                                if let desc = data["description"] as? String {
                                    if let picture = data["url"] as? String {
                                        let results = [name, desc, picture]
                                        //NSLog(" Name: %@ Description: %@ URL: %@",name,desc,picture)
                                        completionHandler(archive: results)
                                    }
                                    else {
                                        let results = [name, desc, "null"]
                                        completionHandler(archive: results)
                                    }
                                }
                                
                            }
                        }
                        
                    }
                    
                }catch {
                    print("Error with Json: \(error)")
                }
                
            }
        }
        
        task.resume()
    }
    
    func count_selection(completionHandler: (archive: NSArray) -> ()) {
        let requestURL: NSURL = NSURL(string: "http://cs.appstate.edu/Turchin/currentGetter.php")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            if (statusCode == 200) {
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    if let datas = json["data"] as? [[String: AnyObject]] {
                        let results = [datas.count]
                        completionHandler(archive: results)
                        
                    }
                    
                }catch {
                    print("Error with Json: \(error)")
                }
                
            }
        }
        
        task.resume()
    }
    
    func getImageFromServerById(imageId: String, completion: ((image: UIImage?) -> Void)) {
        let url:String = "\(imageId)"
        //print("URL is: "+url)
        let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) {(data, response, error) in
            //print(data?.description)
            if (data != nil) {
                self.log("Downloading image")
                completion(image: UIImage(data: data!))
            }
            //completion(image: UIImage(data: data!))
        }
        task.resume()
    }
    
    func log(text: String)
        {
            let isMain = NSThread.currentThread().isMainThread
            let name_of_thread = isMain ? "{Main }" : "{Child}"
            print("\(name_of_thread) \(text)")
        }

}
