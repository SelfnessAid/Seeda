//
//  HistoryTableViewCell.swift
//  Seeda
//
//  Created by Mobile Expert on 10/6/16.
//  Copyright © 2016 Илья Железников. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var check_button: UIButton!
    
    var delegate: HistoryTableViewCellDelegate?
    var indexPath: NSIndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onPressCheck(sender: AnyObject) {
        self.check_button.selected = !self.check_button.selected
        delegate?.historyCellPressCheck?(sender, indexPath: indexPath)
    }

}

@objc
protocol HistoryTableViewCellDelegate {
    optional func historyCellPressCheck(sender: AnyObject, indexPath: NSIndexPath) -> Void
}