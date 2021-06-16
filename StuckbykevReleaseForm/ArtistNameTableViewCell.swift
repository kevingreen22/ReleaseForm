//
//  ArtistNameTableViewCell.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 11/7/16.
//  Copyright © 2016 Kevin Green. All rights reserved.
//

import UIKit

class ArtistNameTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artistPhotoView: UIImageView!    
    
}
