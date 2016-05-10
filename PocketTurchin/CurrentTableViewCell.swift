//
//  CurrentTableViewCell.swift
//  PocketTurchin
//
//  Created by Owner on 4/4/16.
//  Copyright © 2016 shuffleres. All rights reserved.
//

import UIKit

class CurrentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    //MARKED PROPERTIES
    //@IBOutlet weak var archiveLabel: UILabel!
    //@IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var archiveLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
