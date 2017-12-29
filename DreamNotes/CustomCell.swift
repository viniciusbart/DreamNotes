//
//  CustomCell.swift
//  DreamNotes
//
//  Created by Vinícius Bazanelli on 04/10/14.
//  Copyright (c) 2014 Baza Inc. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
