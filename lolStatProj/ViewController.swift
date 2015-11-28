//
//  ViewController.swift
//  lolStatProj
//
//  Created by James Leong on 2015-10-04.
//  Copyright (c) 2015 James Leong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var summonerNameField: UITextField!
    var summId: String?
    var riotAPI = RiotAPIConn()
    let summO = summonerObject.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        summonerNameField.delegate = self
        self.title = "Match History Viewer"
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        
        summId = textField.text
        textField.text = "";
        if IJReachability.isConnectedToNetwork() {
            print("Network Connection: Available\n")
            summO.clearVar(); // clear everything since treat as new request
            riotAPI.retrieveSumID(summId!) { sumDict in
                
                self.riotAPI.retrieveVer() { verArray in
                    self.riotAPI.retrieveRecentMatch(summonerObject.sharedInstance.id!) {matchA in
                        //print("check if theres context\n")
                        self.performSegueWithIdentifier("firstapiSeg", sender: nil)
                    }
                    //print("check if we get the version after segue")
                }
            }
        } else {
            print("Network Connection: Unavailable\n")
            
            var alert = UIAlertController(title: "Alert", message: "Network Connection: Unavailable", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        return true;
    }

    
    @IBAction func didTap(sender: UIButton) {
        summonerNameField.resignFirstResponder()
        summId = summonerNameField.text
        summonerNameField.text = "";
        if IJReachability.isConnectedToNetwork() {
            print("Network Connection: Available\n")
            summO.clearVar(); // clear everything since treat as new request
            riotAPI.retrieveSumID(summId!){ sumDict, error in
                print("this is sumDict\(sumDict) \n")
                if sumDict != nil {
                    self.riotAPI.retrieveVer() { verArray in
                        self.riotAPI.retrieveRecentMatch(summonerObject.sharedInstance.id!) {matchA in
                            //print("check if theres context\n")
                            self.performSegueWithIdentifier("firstapiSeg", sender: nil)
                        }
                        //print("check if we get the version after segue")
                    }
                }
                else {
                    //means error
                    var alert = UIAlertController(title: "Alert", message: "Summoner not found", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                
            }
        } else {
            print("Network Connection: Unavailable\n")
            
            var alert = UIAlertController(title: "Alert", message: "Network Connection: Unavailable", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


