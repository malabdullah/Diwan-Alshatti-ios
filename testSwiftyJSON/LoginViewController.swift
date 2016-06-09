//
//  LoginViewController.swift
//  Diwan Alshatti
//
//  Created by Mohammad Alabdullah on 5/22/16.
//  Copyright © 2016 Mohammad Alabdullah. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var rememberSwitch: UISwitch!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let baseURL = "http://www.malabdullah.com/diwan/json_login.php"
    var userDefaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginClicked(sender: UIButton) {
        
        if let text = usernameTextField.text where text.isEmpty
        {
            //alert message
            showAlert("Please Enter username in the username field!", actionTitle: "OK")
            
        }
        else if let text = passwordTextField.text where text.isEmpty
        {
            //alert message
            showAlert("Please Enter password in the password field!", actionTitle: "OK")
        }
        else
        {
           jsonData()
        }
    }
    
    func jsonData(){
        let url = NSURL(string: baseURL)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        let postData = "username=\(usernameTextField.text!)&password=\(passwordTextField.text!)"
        request.HTTPBody = postData.dataUsingEncoding(NSUTF8StringEncoding)
        
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?,error: NSError?) in
            
            dispatch_async(dispatch_get_main_queue()){
                if error != nil
                {
                    //alert error message
                    self.showAlert((error?.localizedDescription)!, actionTitle: "OK")
                    print("error= \(error)")
                    
                    return
                }
                
                let responseData = NSString (data: data!, encoding: NSUTF8StringEncoding)
                
                if responseData == "success"
                {
                    print("login successufully")
                    if self.rememberSwitch.on
                    {
                        self.userDefaults.setObject(self.usernameTextField.text, forKey: "username")
                        self.userDefaults.setObject(self.passwordTextField.text, forKey: "password")
                        self.userDefaults.setObject(true, forKey: "isLoggedIn")
                        self.userDefaults.synchronize()
                    }
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }

        }.resume()
    }
    
    func showAlert(messageBody:String, actionTitle:String){
        let alertMessage = UIAlertController(title: "Error", message: messageBody, preferredStyle: .Alert)
        let actionButton = UIAlertAction(title: actionTitle, style: .Default, handler: nil)
        alertMessage.addAction(actionButton)
        self.presentViewController(alertMessage, animated: true, completion: nil)
    }
}
