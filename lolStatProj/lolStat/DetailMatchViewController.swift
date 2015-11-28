//
//  DetailMatchViewController.swift
//  lolStatProj
//
//  Created by James Leong on 2015-10-12.
//  Copyright (c) 2015 James Leong. All rights reserved.
//

///////////////////////////////////////////////////////////
//notes: convert and get the string png of the summoner spell here?


//http://ddragon.leagueoflegends.com/cdn/5.19.1/img/item/2049.png

//http://ddragon.leagueoflegends.com/cdn/5.19.1/img/spell/SummonerHaste.png

import UIKit

class DetailMatchViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var gamelengthLabel: UILabel!
    @IBOutlet weak var IPlabel: UILabel!
    @IBOutlet weak var minionsLabel: UILabel!
    @IBOutlet weak var goldLabel: UILabel!
    @IBOutlet weak var champUIImage: UIImageView!
    @IBOutlet weak var DetailScrollView: UIScrollView!
    
    @IBOutlet weak var spell2Image: UIImageView!
    @IBOutlet weak var spell1Image: UIImageView!
    
    @IBOutlet weak var item7Image: UIImageView!
    @IBOutlet weak var item6Image: UIImageView!
    @IBOutlet weak var item5Image: UIImageView!
    @IBOutlet weak var item4Image: UIImageView!
    @IBOutlet weak var item3Image: UIImageView!
    @IBOutlet weak var item2Image: UIImageView!
    @IBOutlet weak var item1Image: UIImageView!
    
    let summO = summonerObject.sharedInstance
    var sumSpellDict: NSDictionary = [:];
    var matchIndex: Int?
    var champPic: UIImage?
    var imageCache = [String:UIImage]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.DetailScrollView.delegate = self;
        
        let path = NSBundle.mainBundle().pathForResource("sumSpells", ofType: "plist")
        sumSpellDict = NSDictionary(contentsOfFile: path!)!
        
        var sumspellDictIndex = summO.matchHist[matchIndex!].sumSpell1!;
        print("this is example of sum spell entry: \(sumSpellDict[String(sumspellDictIndex)]![1]) \n")
        
        champUIImage.image = champPic;
        
        goldLabel.text = "Gold: \(summO.matchHist[matchIndex!].goldEarned!)"
        println("\(goldLabel.text)")

        minionsLabel.text = "Minions: \(summO.matchHist[matchIndex!].minionsKilled!)";
        IPlabel.text = "IP: \(summO.matchHist[matchIndex!].ipEarned!)";
        gamelengthLabel.text = secondsToMinutesSeconds(summO.matchHist[matchIndex!].timePlayed!)

        loadSpellImagestoView()
        loadItemImagestoView()
        // Do any additional setup after loading the view.
        // think about moving this later
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x>0 {
            scrollView.contentOffset.x = 0
        }
    }
    

    //http://ddragon.leagueoflegends.com/cdn/5.19.1/img/item/2049.png
    
    func loadItemImagestoView() {
        var urlStringArray: [String] = [];
        let ImageViewArray: [UIImageView] = [item1Image, item2Image, item3Image, item4Image, item5Image, item6Image, item7Image];
        if let unwrappedItemArray : [Int] = summO.matchHist[matchIndex!].itemArray {
            print("itemarray: \(unwrappedItemArray)\n")
            
            for item in unwrappedItemArray {
                urlStringArray.append("http://ddragon.leagueoflegends.com/cdn/\(summO.verNum)/img/item/\(item).png")
            }
            print("urlstring array count: \(urlStringArray.count) \n")
            
            for var index = 0; index < urlStringArray.count; index++ {
                print("index is \(index)")
                print("checking the urls : \(urlStringArray[index]) \n")
                var imgURL = NSURL(string: urlStringArray[index])
                
                if let img = imageCache[urlStringArray[index]] {
                    ImageViewArray[index].image? = img
                }
                else {
                    let request: NSURLRequest = NSURLRequest(URL: imgURL!)
                    var response: NSURLResponse?
                    var error: NSError?
                    let urlData = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
                    if error == nil {
                        println("gest past here? \(index)")
                        // Convert the downloaded data in to a UIImage object
                        let image = UIImage(data: urlData!)
                        self.imageCache[urlStringArray[index]] = image
                        ImageViewArray[index].image = image
                    }
                    else {
                        println("Error: \(error!.localizedDescription)")
                    }

                }
            }
            
        }
    }
    
    func loadSpellImagestoView() {
        
        // if spell1image or 2 image different cases in for loop
        if IJReachability.isConnectedToNetwork() {
            print("Network Connection: Available\n")
            //do first image spell1
            
            var sumspell1Index = summO.matchHist[matchIndex!].sumSpell1!;
            var sumspell2Index = summO.matchHist[matchIndex!].sumSpell2!;

            
            var urlString1 = "http://ddragon.leagueoflegends.com/cdn/\(summO.verNum)/img/spell/\(sumSpellDict[String(sumspell1Index)]![1])"
            var urlString2 = "http://ddragon.leagueoflegends.com/cdn/\(summO.verNum)/img/spell/\(sumSpellDict[String(sumspell2Index)]![1])"
            var imgURL = NSURL(string: urlString1)
            
            // If this image is already cached, don't re-download
            if let img = imageCache[urlString1] {
                spell1Image.image = img
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
                        self.imageCache[urlString1] = image
                        // Update the cell
                        dispatch_async(dispatch_get_main_queue(), {
                            self.spell1Image.image = image;
                        })
                    }
                    else {
                        println("Error: \(error.localizedDescription)")
                    }
                })
            }
            
            imgURL = NSURL(string: urlString2)
            
            // If this image is already cached, don't re-download
            if let img = imageCache[urlString2] {
                spell2Image.image = img
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
                        self.imageCache[urlString2] = image
                        // Update the cell
                        dispatch_async(dispatch_get_main_queue(), {
                            self.spell2Image.image = image;
                        })
                    }
                    else {
                        println("Error: \(error.localizedDescription)")
                    }
                })
            }
            
        } else {
            print("Network Connection: Unavailable\n")
            
            var alert = UIAlertController(title: "Alert", message: "Network Connection: Unavailable", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
    }
    
    func secondsToMinutesSeconds (seconds : Int) -> String {
        //untested
        var minutes = (seconds / 60);
        var second = (seconds % 60);
        return "\(minutes):\(second)"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
