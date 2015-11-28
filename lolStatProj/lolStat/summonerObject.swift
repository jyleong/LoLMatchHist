//
//  summonerObject.swift
//  lolStat
//
//  Created by James Leong on 2015-10-03.
//  Copyright (c) 2015 James Leong. All rights reserved.
//

import Foundation

class summonerObject: Printable {
    var id: Int!
    var name: String!
    var verNum: String!
    var matchHist: [matchObject] = [] // should have as many match Objects as there are in the return of api
    
    var description: String {
        return "ID : \(self.id), name: \(self.name), version: \(self.verNum)"
    }
    // most of these vars must be refernes when passed to load detial view of tables
    
    class var sharedInstance: summonerObject {
        struct cSummoner {
            static let instance = summonerObject()
        }
        return cSummoner.instance
    }
    
    func addmatchObjectWrap(matchObj: matchObject) {
        self.matchHist.append(matchObj);
        //print("added match object to matchHist array\n")
    }
    
    func clearVar() {
        self.id = nil
        self.name = nil
        self.matchHist = []
        self.verNum = nil
        print("attempting to clear everyting\n")
    }
}

