//
//  MapViewController.swift
//  ferriestimetable2
//
//  Created by b123400 on 14/7/14.
//  Copyright (c) 2014 b123400. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet var mapView: MKMapView
    var ferry : Ferry?
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if ferry? {
            mapView.region = MKCoordinateRegionMake(ferry!.island.location, MKCoordinateSpanMake(0.1, 0.1))

            let annotation = MKPointAnnotation()
            annotation.setCoordinate(ferry!.island.location)
            annotation.title = ferry!.island.name
            mapView.addAnnotation(annotation)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
