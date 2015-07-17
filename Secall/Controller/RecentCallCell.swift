//
//  RecentCallCell.swift
//  VoIPProject
//
//  Created by BrainBi on 3/25/15.
//  Copyright (c) 2015 ThuatCao. All rights reserved.
//

import UIKit

class RecentCallCell: UITableViewCell {
//  Mark: IBOutlet
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var displaynameLabel: UILabel!
    @IBOutlet weak var datatimeLabel: UILabel!
    @IBOutlet weak var typecallImageView: UIImageView!
    @IBOutlet weak var durationLabel: UILabel!
    
    var phoneNumber = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func buttonCallTabbed(sender: UIButton) {
        // change
        var callTo = phoneNumber
        NSNotificationCenter.defaultCenter().postNotificationName("callFromRecent", object: nil, userInfo:["callTo":callTo,"callName":displaynameLabel.text!])
    }

    func setBorderForProfileImage(){
        if(profileImageView.image != nil){
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
            self.profileImageView.clipsToBounds = true
            self.profileImageView.layer.borderWidth = 1.0;
            self.profileImageView.layer.borderColor =  Utility.UIColorFromRGB(0xff9600).CGColor
        }
    }

}
