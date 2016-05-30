//
//  AdminViewController.swift
//  Diwan Alshatti
//
//  Created by Mohammad Alabdullah on 5/23/16.
//  Copyright © 2016 Mohammad Alabdullah. All rights reserved.
//

import UIKit

class AdminViewController: UITableViewController{
    
    var refreshTableView = UIRefreshControl()
    var userDefault = NSUserDefaults.standardUserDefaults()
    let baseURL = "http://malabdullah.com/diwan/JSONnames.php"
    let deleteURL = "http://malabdullah.com/diwan/update_delete_json.php"
    var json:NSArray!
    var member:[Member] = []
    
    var list_count:Int=0
    var refreshContents: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !userDefault.boolForKey("isLoggedIn")
        {
            self.performSegueWithIdentifier("loginView", sender: self)
        }
        self.refreshTableView.attributedTitle = NSAttributedString(string: "Pull To Refresh")
        self.refreshTableView.backgroundColor = UIColor.lightGrayColor()
        self.refreshTableView.addTarget(self,
                                        action: #selector(AdminViewController.refreshContentOfTableView),
                                        forControlEvents: .ValueChanged)
        self.tableView.addSubview(refreshTableView)
        parseJson()
    }
    
    override func viewDidAppear(animated: Bool) {
        refreshContentOfTableView()
    }
    
    @IBAction func LogoutClicked(sender: UIButton) {
        
        userDefault.setBool(false, forKey: "isLoggedIn")
        userDefault.synchronize()
        
        self.performSegueWithIdentifier("loginView", sender: self)
    }
    
    func refreshContentOfTableView(){
        self.member.removeAll()
        parseJson()
        self.tableView.reloadData()
        self.refreshTableView.endRefreshing()
    }

    func parseJson(){
        let url = NSURL(string: baseURL)
        let data = NSData(contentsOfURL: url!)
        
        do{
            let JSONResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
            json = JSONResult.valueForKey("names") as! NSArray
            
            for item in json{
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
            
            if ((refreshContents?.refreshing) != nil){
                refreshContents?.endRefreshing()
            }
        }
        catch let error as NSError{
            print(error)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list_count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! adminNamesCellTableViewCell
        
        cell.name_value.text = member[indexPath.row].name
        cell.date_value.text = member[indexPath.row].date
        cell.comment_value.text = member[indexPath.row].comment
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { (action, indexPath) in
            self.deleteFromBackEnd(indexPath)
            self.member.removeAtIndex(indexPath.row)
            self.list_count = self.member.count
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        
        delete.backgroundColor = UIColor.redColor()
        
        return [delete]
    }
    
    func deleteFromBackEnd(indexPath: NSIndexPath){
        
        let name = member[indexPath.row].name!
        
        let date = member[indexPath.row].date
        let comment = member[indexPath.row].comment
        let id = member[indexPath.row].id!
        let type = "delete"
        
        let url = NSURL(string: deleteURL)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        
        var checkString:String!
        if ((comment?.isEmpty) == nil && (date?.isEmpty) == nil) {
            checkString = "name=\(name)&date=&comments=&id=\(id)&operation=\(type)"
        }
        else if ((comment?.isEmpty) == nil){
            checkString = "name=\(name)&date=\(date!)&comments=&id=\(id)&operation=\(type)"
        }else{
            checkString = "name=\(name)&date=&comments=\(comment)&id=\(id)&operation=\(type)"
        }
        
        let postData = checkString
        request.HTTPBody = postData.dataUsingEncoding(NSUTF8StringEncoding)
        
        NSURLSession.sharedSession().dataTaskWithRequest(request) {
            
            (data:NSData?, response:NSURLResponse?, error:NSError?) in
            
            
            if error != nil
            {
                print("error= \(error)")
                //self.errorLabel.text = "Error: \(error)"
                //self.errorLabel.hidden = false
                print("error deleting member!")
            }
            else
            {
                let responseData = NSString (data: data!, encoding: NSUTF8StringEncoding) as! String
                print(responseData)
                
                if responseData == "delete success"
                {
                    print("member deleted successufully")
                }
            }

        }.resume()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "updateSegue" {
            
            let index = self.tableView.indexPathForSelectedRow!.row
            
            let updateVC = segue.destinationViewController as! updateMember
            updateVC.nameValue = self.member[index].name
            updateVC.dateValue = self.member[index].date
            updateVC.commentValue = self.member[index].comment
            updateVC.idValue = self.member[index].id
            
            //updateVC.performSegueWithIdentifier("updateSegue", sender: self)
        }
    }
}
