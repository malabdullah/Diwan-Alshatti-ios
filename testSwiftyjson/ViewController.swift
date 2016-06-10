//
//  ViewController.swift
//  testSwiftyjson
//
//  Created by Mohammad Alabdullah on 4/20/16.
//  Copyright © 2016 Mohammad Alabdullah. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UITableViewController {
    @IBOutlet weak var bannerView: GADBannerView!

    let baseURL = "http://malabdullah.com/diwan/JSONnames.php"
    var list_count:Int=0
    let refereshList:UIRefreshControl = UIRefreshControl()
    
    var member:[Member] = []
    
    var list_names = [String]()
    var list_dates = [String]()
    var list_comments = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refereshList.attributedTitle = NSAttributedString(string: "Pull Down To Refresh")
        self.refereshList.backgroundColor = UIColor.lightGrayColor()
        self.refereshList.addTarget(self, action: #selector(ViewController.didRefresh), forControlEvents: .ValueChanged)
        self.tableView.addSubview(self.refereshList)
        
        self.title = "Diwan Alshatti"
        
        parseJson()
        
        
        bannerView.adUnitID = "ca-app-pub-8587947849564336/4942193200"
        bannerView.rootViewController = self
        bannerView.loadRequest(GADRequest())
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func parseJson(){
        let url = NSURL(string: baseURL)
        let data = NSData(contentsOfURL: url!)
        
        do{
            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
            let jsonData = json.valueForKey("names") as! NSArray
            
            for item in jsonData
            {
                let name = item["name"] as? String
                let date = item["date"] as? String
                let memberId = item["id"] as? String
                
                let newMember = Member(name: name!, date: date!, id: memberId!)
                if let comment = item["comment"] where comment != nil{
                    newMember.comment = comment as? String
                }
                
                member.append(newMember)
            }
            
            self.list_count = member.count
        }
        catch let error as NSError{
         print(error.localizedDescription)
        }
    }
    
    func didRefresh(){
        self.member.removeAll()
        parseJson()
        self.tableView.reloadData()
        refereshList.endRefreshing()
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list_count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell_names = tableView.dequeueReusableCellWithIdentifier("cell_prototype", forIndexPath: indexPath) as! NamesTableViewCell
        
        cell_names.name_value.text = self.member[indexPath.row].name
        cell_names.date_value.text = self.member[indexPath.row].date
        cell_names.comment_value.text = self.member[indexPath.row].comment
        
        return cell_names
    }

}

