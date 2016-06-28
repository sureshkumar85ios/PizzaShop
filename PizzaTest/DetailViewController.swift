//
//  DetailViewController.swift
//  PizzaTest
//
//  Created by ADDC on 6/25/16.
//  Copyright © 2016 sureshkumar. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    var objects = [AnyObject]()
    var detailArry: NSDictionary?

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
         print(self.detailArry)
        
        let latt = (self.detailArry?.valueForKey("Latitude") as? NSString)?.doubleValue
        let long = (self.detailArry?.valueForKey("Longitude") as? NSString)?.doubleValue
        

        
        let location = CLLocationCoordinate2D(latitude: latt!, longitude: long!)
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
       
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = self.detailArry!.valueForKey("Title") as? String
        annotation.subtitle = self.detailArry!.valueForKey("Address") as? String
        mapView.addAnnotation(annotation)
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

