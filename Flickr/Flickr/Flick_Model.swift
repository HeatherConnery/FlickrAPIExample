//
//  Flick_Model.swift
//  Flickr
//
//  Created by Heather Connery on 2015-11-04.
//  Copyright © 2015 HConnery. All rights reserved.
//

import UIKit

class Flick_Model: NSObject {
    
    //private => only this class has access to these vars - can only be used through initialier
    private var photoImageView: UIImageView!
    private var photoTitle: UILabel!
    
    init(photoView:UIImageView, myTitle:UILabel) {
        photoImageView = photoView
        photoTitle = myTitle
    }
    
    func getImageFromFlickr() {
        // 1. create a session
        //we only need one session - create singleton with sharedSession method of the class NSURLSession
        let session = NSURLSession.sharedSession()
        // 2. create a URL string
        let urlString = BASE_URL + escapedParameters(METHOD_ARGUMENTS)
        // 3. encode string for NSURL
        let url = NSURL(string: urlString)!
        // 4. create a url request
        let request = NSURLRequest(URL: url)
        print(request)
        // 5. initialize task for getting data
        let task = session.dataTaskWithRequest(request) { (data , response, downloadError) -> Void in
            //check if we are successful
            if let error = downloadError {
                print("could not complete request \(error)")
            } else {
                //we are successful
                var parseError:NSError? = nil
                let parsedResult:AnyObject!
                do {
                    parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                } catch let error as NSError {
                    parseError = error
                    print("\(parseError)")
                    parsedResult = nil
                } catch {
                    fatalError()
                }
                //print(parsedResult)
                //dictionary with array inside it, each one being a dictionary
                if let photosDictionary = parsedResult.valueForKey("photos") as? NSDictionary {
                    if let photoArray = photosDictionary.valueForKey("photo") as? [[String: AnyObject]] {
                        //grab a single image
                        let randomPhotoIndex = Int(arc4random_uniform(UInt32(photoArray.count)))
                        let photoDictionary = photoArray[randomPhotoIndex] as [String:AnyObject]
                        //grab the image url and title
                        let photoTitle = photoDictionary["title"] as? String
                        let imageUrlString = photoDictionary["url_m"] as? String
                        let imageURL = NSURL(string: imageUrlString!)
                        //if an image exists at the url, set the image and title
                        if let imageData = NSData(contentsOfURL: imageURL!) {
                            //asyn // submits a block for asynchronous execution on a dispatch queue
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                // set the image and title for the view
                                self.photoImageView.image = UIImage(data: imageData)
                                self.photoImageView.layer.cornerRadius = self.photoImageView.frame.size.width / 2
                                self.photoImageView.clipsToBounds = true
                                self.photoImageView.layer.borderWidth = 5
                                self.photoImageView.layer.borderColor = UIColor.whiteColor().CGColor
                                self.photoTitle.text = photoTitle
                            })
                        } else {
                            print("image does not exist")
                        }
                    } else {
                        print("can't find key photo")
                    }
                } else {
                    print("can't find key parsed result")
                }
            }
        }
        //asynchronous task
        task.resume()
        
    }
    
    //Helper function: Given a dictionary of parameters and convert a str for url
    func escapedParameters(parameters: [String: AnyObject]) -> String {
        var urlVars = [String] ()
        for (key,value) in parameters {
            // make sure that it is a string b/c of type AnyObject
            let stringValue = "\(value)"
            // are any of these values not in the allowed set?
            _ = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            // if there are replace eg space => +
            _ = stringValue.stringByReplacingOccurrencesOfString("", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
            //append it 
            urlVars += [key + "=" + "\(value)"]
        }
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    

    
    
    

    
}






