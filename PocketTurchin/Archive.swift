//
//  Archive.swift
//  PocketTurchin
//
//  Created by Owner on 4/18/16.
//  Copyright © 2016 shuffleres. All rights reserved.
//

import UIKit

class Archive {
    var name: String
    var desc: String
    var photo: UIImage?
    
    // MARK: Initialization
    init(name: String, desc: String,photo: UIImage?) {
        self.name = name
        self.desc = desc
        self.photo = photo
    }
}
