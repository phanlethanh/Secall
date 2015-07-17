//
//  ContactCell.swift
//  VoIPProject
//
//  Created by BrainBi on 3/25/15.
//  Copyright (c) 2015 ThuatCao. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    //    Mark: UIOutlet
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    @IBAction func buttonCallTabbed(sender: UIButton) {
        var callTo = phoneNumberLabel.text
        // Gửi notify đến main tabbar controller để thực hiện cuộc gọi
        NSNotificationCenter.defaultCenter().postNotificationName("callFromContact", object: nil, userInfo:["callTo":callTo!,"callName":contactNameLabel.text!])
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
