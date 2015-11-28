//
//  FavouritesTableViewController.swift
//  lolStatProj
//
//  Created by James Leong on 2015-11-01.
//  Copyright (c) 2015 James Leong. All rights reserved.
//

import UIKit
import CoreData

class FavouritesTableViewController: UITableViewController,UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    var favSummoners = [NSManagedObject]()
    var riotAPI = RiotAPIConn()
    let summO = summonerObject.sharedInstance
    var deleteSummonerIndexPath: NSIndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Favourites";
        summO.clearVar();
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Summoner")
        
        var error: NSError?
        let results = managedContext!.executeFetchRequest(fetchRequest, error:&error)
        favSummoners = results as! [NSManagedObject]
        self.tableView.reloadData()
        println("number of saved entries: \(favSummoners.count)")

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
        return favSummoners.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath:indexPath) as! UITableViewCell

        // Configure the cell...
        let summoner = favSummoners[indexPath.row]
        cell.textLabel!.text = summoner.valueForKey("name") as? String
        
        print("\(cell.textLabel!.text) this line \n")
        var numtoconv = summoner.valueForKey("summonerID") as! Int
        cell.detailTextLabel!.text = String(stringInterpolationSegment: numtoconv)

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        
        if IJReachability.isConnectedToNetwork() {
            print("Network Connection: Available\n")
            summO.clearVar(); // clear everything since treat as new request
            summO.name = tableView.cellForRowAtIndexPath(indexPath)?.textLabel!.text
            print(tableView.cellForRowAtIndexPath(indexPath)?.detailTextLabel!.text!)
            if let summID = tableView.cellForRowAtIndexPath(indexPath)?.detailTextLabel!.text! {
                summO.id = summID.toInt()
            }
            
            
            self.riotAPI.retrieveVer() { verArray in
                self.riotAPI.retrieveRecentMatch(self.summO.id) {matchA in
                    
                    self.performSegueWithIdentifier("favoritesSegue", sender: nil)
                }
                //print("check if we get the version after segue")
                    
            }
            
        } else {
            print("Network Connection: Unavailable\n")
            
            var alert = UIAlertController(title: "Alert", message: "Network Connection: Unavailable", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == .Delete ) {
            // Find the LogItem object the user is trying to delete
            let Summoner = favSummoners[indexPath.row]
            favSummoners.removeAtIndex(indexPath.row)
            let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context = appDel.managedObjectContext!
            
            // remove your object
            
            
            context.deleteObject(Summoner as NSManagedObject)
            // save your changes 
            context.save(nil)
            
            // Tell the table view to animate out that row
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
        }
    }
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
