//
//  RiotAPIConn.swift
//  lolStat
//
//  Created by James Leong on 2015-10-03.
//  Copyright (c) 2015 James Leong. All rights reserved.
//

import Foundation
import UIKit


/*"https://na.api.pvp.net/api/lol/na/v1.4/summoner/by-name/arangodlith?api_key=8bc2e322-92f9-4e3c-9377-1133748e5041"
*/

/*"https://na.api.pvp.net/api/lol/na/v1.3/game/by-summoner/38014155/recent?api_key=8bc2e322-92f9-4e3c-9377-1133748e5041"
*/

/*https://global.api.pvp.net/api/lol/static-data/na/v1.2/versions?api_key=8bc2e322-92f9-4e3c-9377-1133748e5041
*/

// grab later version to check, take first element of list


class RiotAPIConn: NSObject, NSURLConnectionDataDelegate {
    
    let riotAPIKey = "8bc2e322-92f9-4e3c-9377-1133748e5041"
    let session = NSURLSession.sharedSession()
    /*
    // this function just to get summoner name and id
    func retrieveSumID(sumName: String,completionHandler: (sumDict: [String:AnyObject]) -> ()) {
        let trimmedsumName = sumName.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        print("\(trimmedsumName) this is name to pass in\n")
        var urlString = "https://na.api.pvp.net/api/lol/na/v1.4/summoner/by-name/\(sumName)?api_key=\(riotAPIKey)"
        var urlStringEscaped : String = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!;
        
        let sumURLquery = NSURL(string:urlStringEscaped)
        println("des is go here?")
        //print("sum url query: \(sumURLquery) \n")
        var task = session.dataTaskWithURL(sumURLquery!,completionHandler: {data, response, error -> Void in
            println("Task completed")
            if(error != nil) {
                // If there is an error in the web request, print it to the console
                println("error getting sum ID \(error.localizedDescription)")
            }
            var jsonError: NSError?

            if let jsonResult = NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers, error: &jsonError) as? [String: AnyObject], sumDict = jsonResult[trimmedsumName] as? [String: AnyObject] {
                print("check if it goes here now( retrieveal) \n")
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0) ) {
                    dispatch_async(dispatch_get_main_queue()) {
                        summonerObject.sharedInstance.id = sumDict["id"] as! Int
                        summonerObject.sharedInstance.name = sumDict["name"] as! String
                        
                        completionHandler(sumDict: sumDict)
                    }
                }
            }
            else {
                print("found error \n")
                if let unwrapperError = jsonError {
                    println("json error getting sum ID: \(unwrapperError)")
                }
            }
        })
        task.resume()
        
        return
    }*/
    
    func retrieveSumID(sumName: String,completionHandler: (sumDict: [String:AnyObject]?, error: NSError?) -> ()) {
        let trimmedsumName = sumName.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        print("\(trimmedsumName) this is name to pass in\n")
        var urlString = "https://na.api.pvp.net/api/lol/na/v1.4/summoner/by-name/\(sumName)?api_key=\(riotAPIKey)"
        var urlStringEscaped : String = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!;
        
        let sumURLquery = NSURL(string:urlStringEscaped)
        println("des is go here?")
        //print("sum url query: \(sumURLquery) \n")
        var task = session.dataTaskWithURL(sumURLquery!,completionHandler: {data, response, error -> Void in
            println("Task completed")
            if(error != nil) {
                // If there is an error in the web request, print it to the console
                println("error getting sum ID \(error.localizedDescription)")
            }
            var jsonError: NSError?
            
            if let jsonResult = NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers, error: &jsonError) as? [String: AnyObject], sumDict = jsonResult[trimmedsumName] as? [String: AnyObject] {
                print("check if it goes here now( retrieveal) \n")
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0) ) {
                    dispatch_async(dispatch_get_main_queue()) {
                        summonerObject.sharedInstance.id = sumDict["id"] as! Int
                        summonerObject.sharedInstance.name = sumDict["name"] as! String
                        
                        completionHandler(sumDict: sumDict, error: jsonError)
                    }
                }
            }
            else {
                print("found error \n")
                if let unwrapperError = jsonError {
                    println("json error getting sum ID: \(unwrapperError)")
                    completionHandler(sumDict: nil, error: jsonError)
                }
            }
        })
        task.resume()
        
        return
    }
    
    func retrieveRecentMatch(sumID: Int, completionHandler: (matchA: [AnyObject]) -> ()){
        var urlString = "https://na.api.pvp.net/api/lol/na/v1.3/game/by-summoner/\(sumID)/recent?api_key=\(riotAPIKey)"
        
        print("this is the sumoner ID: \(sumID) \n")

        let verURLquery = NSURL(string:urlString)
        
        var task = session.dataTaskWithURL(verURLquery!,completionHandler: {data, response, error -> Void in
            println("Task completed")
            if(error != nil) {
                // If there is an error in the web request, print it to the console
                println("error getting match info \(error.localizedDescription)")
            }
            var jsonError: NSError?
            
            if let var jsonrecentResult = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: &jsonError) as? [String: AnyObject], matchA = jsonrecentResult["games"] as? [AnyObject] {
                
                //print("\(matchA)")
                self.MatchDatatsummonerO(matchA)
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0) ) {
                    dispatch_async(dispatch_get_main_queue()) {
                        completionHandler(matchA: matchA)
                    }
                }
            }
            else {
                if let jsonError = jsonError {
                    println("json error within gettign match info: \(jsonError)")
                }
            }
        })
        task.resume()
        return
    }
    
    func retrieveVer(completionHandler: (verArray: [AnyObject]) -> ()) {
        var urlString = "https://global.api.pvp.net/api/lol/static-data/na/v1.2/versions?api_key=\(riotAPIKey)"
        
        
        let sumURLquery = NSURL(string:urlString)
        
        var task = session.dataTaskWithURL(sumURLquery!) {
            (data,response, error) -> Void in
            
            var jsonError: NSError?
            
            if let var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: &jsonError) as? [AnyObject] {
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0) ) {
                    dispatch_async(dispatch_get_main_queue()) {
                        summonerObject.sharedInstance.verNum = jsonResult[0] as! String;
                        
                        completionHandler(verArray: jsonResult)
                    }
                }
            }
            else {
                if let jsonError = jsonError {
                    println("json error while gettign version number: \(jsonError)")
                }
            }
        }
        task.resume()
        
        return
    }
    
    // take in array of recntmatch history and proces to summoner object
    func MatchDatatsummonerO(array: [AnyObject]) {
        //print(array.count);
        for item in array {
            var indivDict = item as! [String: AnyObject];
            
            var champID: Int = indivDict["championId"] as! Int
            var createdate: Double = indivDict["createDate"] as! Double
            var gameMode: String = indivDict["gameMode"] as! String
            var gameType: String = indivDict["gameType"] as! String
            var statsDict:[String: AnyObject] = indivDict["stats"] as! [String: AnyObject]
            var KDA:[Int] = []
            var sumSpell1: Int = indivDict["spell1"] as! Int
            var sumSpell2: Int = indivDict["spell2"] as! Int
            
            
            if statsDict["championsKilled"] != nil {
                KDA.append(statsDict["championsKilled"] as! Int)
            }
            else { KDA.append(0)}
            if statsDict["numDeaths"] != nil {
                KDA.append(statsDict["numDeaths"] as! Int)
            }
            else { KDA.append(0)}
            if statsDict["assists"] != nil {
                KDA.append(statsDict["assists"] as! Int)
            }
            else { KDA.append(0)}
            
            var goldEarned: Int = statsDict["goldEarned"] as! Int
            var level: Int = statsDict["level"] as! Int
            var timePlayed: Int = statsDict["timePlayed"] as! Int
            var minionsKilled: Int = statsDict["minionsKilled"] as! Int
            var win: Int = statsDict["win"] as! Int
            var ipEarned: Int = indivDict["ipEarned"] as! Int
            var gameID: Int = indivDict["gameId"] as! Int
            var itemArray: [Int] = []
            
            if statsDict["item0"] != nil {
                itemArray.append(statsDict["item0"] as! Int)
            }
            if statsDict["item1"] != nil {
                itemArray.append(statsDict["item1"] as! Int)
            }
            if statsDict["item2"] != nil {
                itemArray.append(statsDict["item2"] as! Int)
            }
            if statsDict["item3"] != nil {
                itemArray.append(statsDict["item3"] as! Int)
            }
            if statsDict["item4"] != nil {
                itemArray.append(statsDict["item4"] as! Int)
            }
            if statsDict["item5"] != nil {
                itemArray.append(statsDict["item5"] as! Int)
            }
            if statsDict["item6"] != nil {
                itemArray.append(statsDict["item6"] as! Int)
            }
            // make match object
            
            var indivmatchO = matchObject(dict_createDate: createdate, dict_gameType: gameType, dict_winState: win, dict_itemArray: itemArray, dict_champLevel: level, dict_KDA: KDA, dict_gold: goldEarned, dict_IP: ipEarned, dict_gameMode: gameMode, dict_champ: champID, dict_gameID: gameID, dict_sumSpell1: sumSpell1, dict_sumSpell2: sumSpell2, dict_minionsKilled: minionsKilled, dict_timePlayed: timePlayed)
            summonerObject.sharedInstance.addmatchObjectWrap(indivmatchO);
        }
    }
}

