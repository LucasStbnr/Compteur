//
//  CompteurTableViewCell.swift
//  Compteur
//
//  Created by Lucas Stoebner on 14/03/2019.
//  Copyright © 2019 LucasStbnr. All rights reserved.
//

import UIKit

class CompteurTableViewCell: UITableViewCell {
	
	//MARK: Properties
	
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var valueLabel: UILabel!
	

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
