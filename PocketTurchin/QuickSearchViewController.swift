//
//  QuickSearchViewController.swift
//  PocketTurchin
//
//  Created by Owner on 4/18/16.
//  Copyright © 2016 shuffleres. All rights reserved.
//

import UIKit

class QuickSearchViewController: UIViewController, UISearchBarDelegate {
    
    var dispatch_semaphore_t = dispatch_semaphore_create(0)
    var photo1 = UIImage(named: "defaultImage")
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    var archives = [Archive]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(QuickSearchViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        //print("searchText \(searchText)")
    }
    
    
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        dispatch_async(dispatch_get_main_queue(), {
            self.did_load { (archive) in
                //print("View Controller: \(archive)")
                let picture = archive[2] as! String
                if (picture != "null") {
                    print("setting downloaded image")
                    self.getImageFromServerById(archive[2] as! String) { image in
                        //dispatch_semaphore_signal(self.dispatch_semaphore_t)
                        //print(self.photo1?.description)
                        //self.photo1 = image
                        print(image)
                        if (image != "null") {
                            self.archives[self.archives.count - 1].photo = image
                        }
                        
                        //print(self.photo1?.description)
                        //print("SETTING THE PHOTO")
                        func call_seque()
                        {
                            //print("CALLING SEGUE")
                            self.performSegueWithIdentifier("ShowDetail", sender: nil)
                        }
                        dispatch_async(dispatch_get_main_queue(),call_seque)
                        
                    }
                }
                else {
                    print("setting default image")
                    self.photo1 = UIImage(named: "defaultImage")
                    
                    func call_seque()
                    {
                        //print("CALLING SEGUE")
                        self.performSegueWithIdentifier("ShowDetail", sender: nil)
                    }
                    dispatch_async(dispatch_get_main_queue(),call_seque)
                }
                
                let newArchive = Archive(name: archive[0] as! String, desc: archive[1] as! String, photo: self.photo1)
                self.archives += [newArchive]
                
            }            });
        
        //print("searchText \(searchBar.text)")
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func did_load(completionHandler: (archive: NSArray) -> ()) {
        print((searchBar.text))
        let requestURL: NSURL = NSURL(string: "http://www.cs.appstate.edu/Turchin/search.php?id=" + searchBar.text!)!
        //let requestURL: NSURL = NSURL(string: "http://www.learnswiftonline.com/Samples/subway.json")!
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
                        for data in datas {
                            if let name = data["name"] as? String {
                                if let desc = data["description"] as? String {
                                    if let picture = data["url"] as? String {
                                        //self.load_image(picture)
                                        //let newArchive = Archive(name: name, desc: year, photo: self.photo1)
                                        //self.archives += [newArchive]
                                        //print("In task")
                                        //self.load_image(picture)
                                        //self.load_image(picture)
                                        //print(self.archives.count)
                                        print("inside loop picture is: " + picture)
                                        let results = [name, desc, picture]
                                        //NSLog(" Name: %@ Description: %@ URL: %@",name,desc,picture)
                                        completionHandler(archive: results)
                                    }
                                    else {
                                        print("inside loop else")
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
    
    func getImageFromServerById(imageId: String, completion: ((image: UIImage?) -> Void)) {
        let url:String = "\(imageId)"
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) {(data, response, error) in
            if (data != nil) {
                completion(image: UIImage(data: data!))
            }
            //completion(image: UIImage(data: data!))
        }
        
        task.resume()
    }
    
    func load_image(urlString:String)
    {
        let imgURL: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            
            if (error == nil && data != nil)
            {
                func display_image()
                {
                    //print(self.photo1?.description)
                    self.photo1 = UIImage(data: data!)
                    //print(self.photo1?.description)
                }
                
                dispatch_async(dispatch_get_main_queue(), display_image)
            }
            
        }
        
        task.resume()
    }
    
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
            //print("In quick search")
            let archiveDetailViewController = segue.destinationViewController as! ArchiveViewController
            
            // Get the cell that generated this segue.
            //if let selectedArchiveCell = sender as? ArchiveTableViewCell {
            //let indexPath = .indexPathForCell(selectedArchiveCell)!
            //print(self.archives.count)
            if (self.archives.count != 0) {
                let selectedArchive = self.archives[self.archives.count-1]
                archiveDetailViewController.self.archive = selectedArchive
            }
            else {
                print("Archives array is empty")
            }
            //}
            
        }
    }
    
}
