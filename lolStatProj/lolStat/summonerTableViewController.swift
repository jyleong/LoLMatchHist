//
//  summonerTableViewController.swift
//  lolStat
//
//  Created by James Leong on 2015-10-04.
//  Copyright (c) 2015 James Leong. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class summonerTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {

    let summO = summonerObject.sharedInstance
    var championDict: NSDictionary = [:]
    
    var imageCache = [String:UIImage]()
    
    var favSummoners = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .Plain, target: self, action: "addSummoner")
        
        var nib = UINib(nibName: "MatchTableCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "MatchBriefTableCell")
        
        let path = NSBundle.mainBundle().pathForResource("champIDPlist", ofType: "plist")
        championDict = NSDictionary(contentsOfFile: path!)!
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewWillAppear(animated: Bool) {
        self.title = summO.name;
        
        self.tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return summO.matchHist.count
    }
    
    override func tableView(tableView: UITableView,heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("matchDetail", sender: indexPath)
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
        let cell = tableView.dequeueReusableCellWithIdentifier("MatchBriefTableCell", forIndexPath: indexPath) as! MatchBriefTableCell
        
        cell.champLevel.text = String(summO.matchHist[indexPath.row].champLevel)
        if (summO.matchHist[indexPath.row].winState == 1) {
            cell.winState.text = "Win"
            cell.winState.textColor = UIColor.greenColor()
        }
        else {
            cell.winState.text = "Lose"
            cell.winState.textColor = UIColor.redColor()
        }
        cell.gameType.text = summO.matchHist[indexPath.row].gameType
        var KDAtempArray: [Int] = summO.matchHist[indexPath.row].kdaArr!
        cell.KDA.text = ("\(KDAtempArray[0])/\(KDAtempArray[1])/\(KDAtempArray[2])")
        cell.gameMode.text = summO.matchHist[indexPath.row].gameMode
        cell.gameDate.text = getStringFromDate(summO.matchHist[indexPath.row].createDate!);
        // Configure the cell...
        
        
        var champID = summO.matchHist[indexPath.row].champID!;
        let champString = String(champID);
        var champImageString = championDict[champString]!;
        
        var urlString = "http://ddragon.leagueoflegends.com/cdn/\(summO.verNum)/img/champion/\(champImageString).png"
        
        var imgURL = NSURL(string: urlString)
        
        // If this image is already cached, don't re-download
        if let img = imageCache[urlString] {
            cell.champPic.image = img
        }
        else {
            // The image isn't cached, download the img data
            // We should perform this in a background thread
            let request: NSURLRequest = NSURLRequest(URL: imgURL!)
            let mainQueue = NSOperationQueue.mainQueue()
            NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                if error == nil {
                    
                    // Convert the downloaded data in to a UIImage object
                    let image = UIImage(data: data)
                    // Store the image in to our cache
                    self.imageCache[urlString] = image
                    // Update the cell
                    dispatch_async(dispatch_get_main_queue(), {
                        cell.champPic.image = image;
                    })
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
        }
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "matchDetail"
        {
            var detailViewController = ((segue.destinationViewController) as! DetailMatchViewController)
            detailViewController.matchIndex = self.tableView.indexPathForSelectedRow()?.row
            
            let indexPath = sender as! NSIndexPath
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! MatchBriefTableCell
            let imageToPass = cell.champPic.image;
            detailViewController.champPic = imageToPass;
        }
    }
    
    //Implement the addName IBAction
    func addSummoner() {
        
        let alert = UIAlertController(title: "Save to Favourites",
            message: "Add Summoner?",
            preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Destructive) { (action) in
            // ...
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (action) in
            // ...
            println("\(self.summO.id) this is id")
            self.saveName(self.summO.name, summonerID: self.summO.id)
            println("\(self.summO.name) saved")
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
    }
    
    
    func getStringFromDate(interval: Double) -> String{
        if (interval == 0)
        {
            return "";
        }
        var seconds: Double = interval/1000;
        var timeInterval: NSTimeInterval = seconds as NSTimeInterval
        
        var date: NSDate = NSDate(timeIntervalSince1970: timeInterval);
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        var stringDate = dateFormatter.stringFromDate(date)
        
        return stringDate;
    }
    
    func saveName(name: String, summonerID: Int) {
        var unique = true
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        
        let entity =  NSEntityDescription.entityForName("Summoner",
            inManagedObjectContext:managedContext!)
        
        let fetchRequest = NSFetchRequest(entityName: "Summoner")
        
        var error: NSError?
        let results = managedContext!.executeFetchRequest(fetchRequest, error:&error)
        
        favSummoners = results as! [NSManagedObject]
        // block of code to save
        
        if (favSummoners.count > 0) {
            for summoner in favSummoners {
                
                var tempsum = summoner.valueForKey("name") as? String
                if (tempsum == name) {
                    unique = false
                }
            }
            
            if(unique) {
                let summoner = NSManagedObject(entity: entity!,
                    insertIntoManagedObjectContext: managedContext)
                summoner.setValue(name, forKey: "name")
                summoner.setValue(summonerID, forKey: "summonerID")
                
                var error: NSError?
                
                managedContext?.save(&error)
                
                if let err = error {
                    println(err.localizedFailureReason)
                } else {
                    //favSummoners.append(summoner)
                    println("saved sucessful in the manager Context")
                }
            }
        }

    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
