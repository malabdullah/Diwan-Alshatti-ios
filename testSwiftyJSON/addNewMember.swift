//
//  addNewMember.swift
//  Diwan Alshatti
//
//  Created by Mohammad Alabdullah on 5/24/16.
//  Copyright © 2016 Mohammad Alabdullah. All rights reserved.
//

import UIKit

class addNewMember: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    let baseURL:String = "http://www.malabdullah.com/diwan/insert_json.php"
    var list_count:Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        dateTextField.delegate = self
        addButton.layer.cornerRadius = 5
    }
    
    // when add button clicked to insert new member
    
    @IBAction func addClicked(sender: UIButton) {
        if let text = nameTextField.text where text.isEmpty
        {
            print("please fill in the name field!")
            return
        }
        else
        {
            jsonDataInsert()
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    //to hide the keyboard when the user touch anywhere in the view
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //hide keyboard when the user hits the return key
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    //show date picker when dateTextField is in focus to edit
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .Date
        datePicker.addTarget(self, action: #selector(addNewMember.datePickerAction), forControlEvents: UIControlEvents.ValueChanged)
        
        let toolbar = UIToolbar()
        let doneBtn = UIBarButtonItem(title: "Done", style: .Done, target: self, action: #selector(addNewMember.doneFromDatePickerAction))
        let todayBtn = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.Plain,target: self, action: #selector(addNewMember.setTodayDateAction))
        let spaceBtn = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
        toolbar.setItems([doneBtn, spaceBtn, todayBtn], animated: true)
        toolbar.userInteractionEnabled = true
        
        toolbar.barTintColor = addButton.backgroundColor
        toolbar.tintColor = UIColor.whiteColor()
        toolbar.sizeToFit()
        
        //datePicker.addSubview(toolbar)
        textField.inputAccessoryView = toolbar
        textField.inputView = datePicker
    }
    
    func setTodayDateAction(){
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dateTextField.text = formatter.stringFromDate(NSDate())
        self.dateTextField.resignFirstResponder()
    }
    
    func doneFromDatePickerAction(sender: UITextField){
        self.dateTextField.resignFirstResponder()
    }
    
    func datePickerAction(sender:UIDatePicker){
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dateTextField.text = formatter.stringFromDate(sender.date)
    }
    
    //HTTP Request to insert new record to the back end on the server
    
    func jsonDataInsert(){
        let url = NSURL(string: baseURL)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        
        
        let postData = "name=\(nameTextField.text!)&date=\(dateTextField.text!)&comments=\(commentTextField.text!)"
        request.HTTPBody = postData.dataUsingEncoding(NSUTF8StringEncoding)
        
        NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data , response, error in
            
            dispatch_async(dispatch_get_main_queue()){
                if error != nil
                {
                    print("error= \(error)")
                    //self.errorLabel.text = "Error: \(error)"
                    //self.errorLabel.hidden = false
                    print("error adding new member!")
                    return
                }
                
                let responseData = NSString (data: data!, encoding: NSUTF8StringEncoding)
                
                if responseData == "success"
                {
                    print("member added successufully")
                }
            }
        }.resume()
    }
}
