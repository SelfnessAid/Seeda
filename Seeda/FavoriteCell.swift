//
//  FavoriteCell.swift
//  Seeda
//
//  Created by Golden.Eagle on 6/9/16.
//  Copyright © 2016 Илья Железников. All rights reserved.
//

import UIKit

protocol FavoriteCellDelegate:class {
    
    func editButtonPressed(cell: FavoriteCell)
    func deleteButtonPressed(cell: FavoriteCell)
    
}

class FavoriteCell: UITableViewCell {
    
    weak var cellDelegate:FavoriteCellDelegate?
    
    @IBOutlet weak var edit: UIButton!
    @IBOutlet weak var delete: UIButton!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detail: UILabel!
    var row:Int!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func editButtonPressed(sender: AnyObject) {
        self.cellDelegate?.editButtonPressed(self)
    }
    
    @IBAction func deleteButtonPressed(sender: AnyObject) {
        self.cellDelegate?.deleteButtonPressed(self)
    }
}
