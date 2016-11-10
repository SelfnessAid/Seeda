//
//  ShareTableViewCell.swift
//  Seeda
//
//  Created by Golden.Eagle on 6/22/16.
//  Copyright © 2016 Илья Железников. All rights reserved.
//

import UIKit

class ShareTableViewCell: UITableViewCell {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var checkImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
