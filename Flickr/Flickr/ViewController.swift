//
//  ViewController.swift
//  Flickr
//
//  Created by Heather Connery on 2015-11-04.
//  Copyright © 2015 HConnery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var photoTitle: UILabel!
    
    @IBOutlet weak var photoImageView: UIImageView!
    //create instance of model
    var myFlickrModel:Flick_Model!

    @IBAction func getImageFromFlickr(sender: AnyObject) {
        //each time we click button get an image
        myFlickrModel.getImageFromFlickr()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //init the instance of the model
        myFlickrModel = Flick_Model(photoView: photoImageView, myTitle: photoTitle)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

