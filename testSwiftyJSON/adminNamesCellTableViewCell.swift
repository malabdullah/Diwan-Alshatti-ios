//
//  adminNamesCellTableViewCell.swift
//  Diwan Alshatti
//
//  Created by Mohammad Alabdullah on 5/24/16.
//  Copyright © 2016 Mohammad Alabdullah. All rights reserved.
//

import UIKit

class adminNamesCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name_value: UILabel!
    @IBOutlet weak var date_value: UILabel!
    @IBOutlet weak var comment_value: UILabel!
    @IBOutlet weak var id_value: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
