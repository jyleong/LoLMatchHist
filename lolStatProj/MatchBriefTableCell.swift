//
//  MatchBriefTableCell.swift
//  lolStatProj
//
//  Created by James Leong on 2015-10-05.
//  Copyright (c) 2015 James Leong. All rights reserved.
//

import UIKit

class MatchBriefTableCell: UITableViewCell {
    
    @IBOutlet var gameDate: UILabel!
    @IBOutlet var gameType: UILabel!
    @IBOutlet var winState: UILabel!
    @IBOutlet var champLevel: UILabel!
    @IBOutlet var champion: UILabel!
    @IBOutlet var KDA: UILabel!

    @IBOutlet weak var gameMode: UILabel!
    @IBOutlet weak var champPic: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
