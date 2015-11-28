//
//  matchObject.swift
//  lolStat
//
//  Created by James Leong on 2015-10-04.
//  Copyright (c) 2015 James Leong. All rights reserved.
//

import Foundation

class matchObject {
    
    var createDate: Double?
    var gameType: String?
    var winState: Int? // 1 or 0 i believe
    var itemArray: [Int]? // array of size 6
    var champLevel: Int
    var kdaArr: [Int]?
    var goldEarned: Int?
    var ipEarned: Int?
    var gameMode: String? // or w.e it is
    var champID: Int?
    var gameID: Int?
    var sumSpell1: Int?
    var sumSpell2: Int?
    var minionsKilled: Int?
    var timePlayed: Int?
    
    init(dict_createDate: Double, dict_gameType: String, dict_winState: Int, dict_itemArray: [Int],
        dict_champLevel: Int, dict_KDA: [Int], dict_gold: Int, dict_IP: Int, dict_gameMode: String, dict_champ: Int, dict_gameID: Int, dict_sumSpell1: Int, dict_sumSpell2: Int, dict_minionsKilled: Int, dict_timePlayed: Int) {
            self.createDate = dict_createDate;
            self.gameType = dict_gameType;
            self.winState = dict_winState;
            self.itemArray = dict_itemArray;
            self.champLevel = dict_champLevel;
            self.kdaArr = dict_KDA;
            self.goldEarned = dict_gold;
            self.ipEarned = dict_IP;
            self.gameMode = dict_gameMode;
            self.champID = dict_champ;
            self.gameID = dict_gameID;
            self.sumSpell1 = dict_sumSpell1;
            self.sumSpell2 = dict_sumSpell2;
            self.minionsKilled = dict_minionsKilled;
            self.timePlayed = dict_timePlayed;
            //print("Match object made successfully\n")
        
    }
    
    // and metod to print out?
    
}