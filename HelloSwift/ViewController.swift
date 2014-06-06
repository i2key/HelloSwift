//
//  ViewController.swift
//  HelloSwift
//
//  Created by 黒田 樹 on 2014/06/06.
//  Copyright (c) 2014年 i2key. All rights reserved.
//

import UIKit
import Social

class ViewController: UIViewController {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapTweetButton(sender : AnyObject) {
        postMessage(SLServiceTypeTwitter)
    }
    
    @IBAction func tapPostToFacebook(sender : AnyObject) {
        postMessage(SLServiceTypeFacebook)
    }
    
    func postMessage(serviceType:NSString){
        if SLComposeViewController.isAvailableForServiceType(serviceType) {
            let socialClient = SLComposeViewController(forServiceType: serviceType)
            socialClient.setInitialText("Hello Swift.")
            socialClient.completionHandler = {
                //this is "Closure Expression Syntax"
                (result:SLComposeViewControllerResult) ->() in
                    switch (result) {
                        case SLComposeViewControllerResult.Done: println("SLComposeViewControllerResult.Done")
                        case SLComposeViewControllerResult.Cancelled: println("SLComposeViewControllerResult.Cancelled")
                    }
            }
            self.presentViewController(socialClient, animated: true, completion: nil)

        } else {
            println("This service is not available")
        }
    }
    
    
    
}

