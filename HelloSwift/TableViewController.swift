//
//  TableViewController.swift
//  HelloSwift
//
//  Created by 黒田 樹 on 2014/06/06.
//  Copyright (c) 2014年 i2key. All rights reserved.
//

import UIKit
import Accounts
import Social

class TableViewController: UITableViewController {
    
    var tweets: String[] = []
    
    init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    init(coder aDecoder: NSCoder!)  {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        let sLRequestHandler = {
            (data:NSData!, response:NSHTTPURLResponse!, error:NSError!) -> () in
            if(response){
                var jsonError:NSError?
                let timeline : AnyObject! = NSJSONSerialization.JSONObjectWithData(data,options: NSJSONReadingOptions.MutableLeaves,error: &jsonError)
                if(timeline){
                    for tweet: Dictionary<String,String> in timeline as Dictionary<String,String>[] {
                        self.tweets += tweet["text"]!
                    }
                    
                    self.tableView.reloadData()
                    
                }else{
                    println(jsonError)
                }
            }
        }
        
        let completionHandler = {
            (granted:Bool, error:NSError!) ->() in
            if(granted){
                let accounts = accountStore.accountsWithAccountType(accountType)
                let account = accounts[0] as ACAccount
                
                let url = NSURL.URLWithString("https://api.twitter.com/1.1/statuses/home_timeline.json")
                let request = SLRequest(forServiceType: SLServiceTypeTwitter,requestMethod: SLRequestMethod.GET,URL: url, parameters: nil )
                request.account = account
                request.performRequestWithHandler(sLRequestHandler)
            }
        }
        accountStore.requestAccessToAccountsWithType(accountType, completionHandler)
    
     
        /*
        accountStore.requestAccessToAccountsWithType(accountType, {
            (granted:Bool, error:NSError!) ->() in
            if(granted){
                let accounts = accountStore.accountsWithAccountType(accountType)
                let account = accounts[0] as ACAccount
                
                let url = NSURL.URLWithString("https://api.twitter.com/1.1/statuses/home_timeline.json")
                let request = SLRequest(forServiceType: SLServiceTypeTwitter,requestMethod: SLRequestMethod.GET,URL: url, parameters: nil )
                request.account = account
                request.performRequestWithHandler({
                    (data:NSData!, response:NSHTTPURLResponse!, error:NSError!) -> () in
                    if(response){
                        var jsonError:NSError?
                        let timeline : AnyObject! = NSJSONSerialization.JSONObjectWithData(data,options: NSJSONReadingOptions.MutableLeaves,error: &jsonError)
                        if(timeline){
                            for tweet: Dictionary<String,String> in timeline as Dictionary<String,String>[] {
                                self.tweets += tweet["text"]!
                            }
                            
                            self.tableView.reloadData()
                            
                        }else{
                            println(jsonError)
                        }
                    }
                    }
                )
            }
            })
        
        */
        
        
    }
    
    func requestTimeline(){
        //var accounts =
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // #pragma mark - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func tableView(_: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel.text = self.tweets[indexPath.row]
        return cell
    }
    
    
    
}
