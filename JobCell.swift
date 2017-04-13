//
//  JobCell.swift
//  WorkEmon
//
//  Created by Tomas on 7/22/16.
//  Copyright © 2016 Tomas Kihlman. All rights reserved.
//

import UIKit

class JobCell: UITableViewCell {

    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var jobCompany: UILabel!
    @IBOutlet weak var snippet: UILabel!
    @IBOutlet weak var relativetime : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
