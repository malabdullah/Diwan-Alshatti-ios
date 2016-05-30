//
//  updateMember.swift
//  Diwan Alshatti
//
//  Created by Mohammad Alabdullah on 5/24/16.
//  Copyright © 2016 Mohammad Alabdullah. All rights reserved.
//

import UIKit

class updateMember: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    
    var nameValue:String?
    var dateValue:String?
    var commentValue:String?
    var idValue:String?
    let URL = "http://malabdullah.com/diwan/update_delete_json.php"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateButton.layer.cornerRadius = 5
        
        self.dateTextField.delegate = self
        
        self.nameTextField.text = nameValue
        self.dateTextField.text = dateValue
        self.commentTextField.text = commentValue
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
        let doneBtn = UIBarButtonItem(title: "Done", style: .Done, target: self, action: #selector(updateMember.doneFromDatePickerAction))
        let todayBtn = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.Plain,target: self, action: #selector(updateMember.setTodayDateAction))
        let spaceBtn = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
        toolbar.setItems([doneBtn, spaceBtn, todayBtn], animated: true)
        toolbar.userInteractionEnabled = true
        
        toolbar.barTintColor = updateButton.backgroundColor
        toolbar.tintColor = UIColor.whiteColor()
        toolbar.sizeToFit()
        
        //datePicker.addSubview(toolbar)
        textField.inputAccessoryView = toolbar
        textField.inputView = datePicker
    }
    
    func setTodayDateAction(){
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.dateTextField.text = formatter.stringFromDate(NSDate())
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

    
    @IBAction func updateClicked(sender: UIButton) {
        
        var checkResult:Bool
        let checkForCommentIfEmpty = commentTextField.text?.isEmpty
        let checkForCommentStringIfEmpty = commentValue == nil

        if checkForCommentStringIfEmpty && checkForCommentIfEmpty!{
            checkResult = true
        }
        else{
            checkResult = false
        }
        
        if nameTextField.text == nameValue && dateTextField.text == dateValue && checkResult{
            //alert the user that nothing is changed
        }
        else{
            updateMemberOnBackEnd()
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
    
    func updateMemberOnBackEnd() {
        let name = nameTextField.text!
        
        var isDateEmpty:Bool
        var date:String = ""
        if ((dateTextField.text?.isEmpty) == nil) {
            isDateEmpty = true
        }
        else {
            isDateEmpty = false
            date = dateTextField.text!
        }
        
        var isCommentEmpty:Bool
        var comment:String = ""
        if ((commentTextField.text?.isEmpty) != nil) {
            isCommentEmpty = true
        }
        else {
            isCommentEmpty = false
            comment = commentTextField.text!
        }
        
        let id = idValue!
        let type = "update"
        
        let url = NSURL(string: URL)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        
        var checkString:String!
        if (isCommentEmpty && isDateEmpty) {
            checkString = "name=\(name)&date=&comments=&id=\(id)&operation=\(type)"
        }
        else if (isCommentEmpty){
            checkString = "name=\(name)&date=\(date)&comments=&id=\(id)&operation=\(type)"
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
                print("error deleting member!")
            }
            else
            {
                let responseData = NSString (data: data!, encoding: NSUTF8StringEncoding) as! String
                print(responseData)
                
                if responseData == "update success"
                {
                    print("member updated successufully")
                }
            }
            
        }.resume()
    }
    
}
