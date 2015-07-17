//
//  CustomCell.swift
//  VoIPProject
//
//  Created by BrainBi on 3/24/15.
//  Copyright (c) 2015 ThuatCao. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
//  Mark: IBOutlet
    @IBOutlet weak var actionImageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var modifyButton: UIButton!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var passwordImageView: UIImageView!
    @IBOutlet weak var labelCell: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    @IBAction func textFieldEdited(sender: UITextField) {
        textField.enabled = false        
    }

}
