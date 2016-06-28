//
//  MasterViewController.swift
//  PizzaTest
//
//  Created by ADDC on 6/25/16.
//  Copyright © 2016 sureshkumar. All rights reserved.
//

import UIKit
import CoreLocation

class MasterViewController: UITableViewController,CLLocationManagerDelegate {
    
    
    let locationManager = CLLocationManager()
    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        //location
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = kCLLocationAccuracyThreeKilometers
        //locationManager.headingFilter = 5
        locationManager.startUpdatingLocation()
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {

        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        webserviceCall(locValue.latitude,longitude:locValue.longitude )
    }
    
    func webserviceCall( latitute:Double, longitude:Double)
    {
        print("locations = \(latitute) \(longitude)")

  let url = NSURL(string: "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20local.search%20where%20latitude%3D\(String(latitute))%20and%20query%3D'pizza'and%20longitude%3D\(String(longitude))&format=json&diagnostics=true&callback=")
       
        
        let request = NSURLRequest(URL: url!)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in

            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                
                if let item = json["query"] as? [String: AnyObject] {
                    
   
                       if let person = item["results"] as? [String: AnyObject]{

                        self.objects.removeAll()
                        let valuearr = Array(person.values).flatMap { $0 }
                        
                        for element in valuearr {
                            
                            for i in 0 ..< element.count {
                                self.objects.append(element[i])
                            }
                            
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.tableView.reloadData()
                        })

                    }

                }
                

            } catch {
                print("error serializing JSON: \(error)")
            }
            



            
        });
        
        // do whatever you need with the task e.g. run
        task.resume()
    }
    

    
   
    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    func insertNewObject(sender: AnyObject) {
//        objects.insert(NSDate(), atIndex: 0)
//        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
//        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row] as! NSDictionary
                
                print(object)
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = objects[indexPath.row]
                controller.detailArry = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
       }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

  
        
        (cell.contentView.viewWithTag(20) as! UILabel).text = self.objects[indexPath.row].valueForKey("Title") as? String
        (cell.contentView.viewWithTag(21) as! UILabel).text = self.objects[indexPath.row].valueForKey("Address") as? String
        (cell.contentView.viewWithTag(22) as! UILabel).text = self.objects[indexPath.row].valueForKey("Phone") as? String
         (cell.contentView.viewWithTag(25) as! UILabel).text = self.objects[indexPath.row].valueForKey("Distance") as? String

        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            objects.removeAtIndex(indexPath.row)
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//        } else if editingStyle == .Insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//        }
//    }


}
