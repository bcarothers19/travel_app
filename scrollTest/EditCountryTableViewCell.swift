//
//  EditCountryTableViewCell.swift
//  scrollTest
//
//  Created by Brian Carothers on 1/7/18.
//  Copyright © 2018 Brian Carothers. All rights reserved.
//

import UIKit

class EditCountryTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
