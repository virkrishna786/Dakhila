//
//  SupportTicketCell.swift
//  Dakhila
//
//  Created by Saurabh Mishra on 02/07/17.
//  Copyright © 2017 Krishan Vir. All rights reserved.
//

import UIKit

class SupportTicketCell: UITableViewCell {

    @IBOutlet weak var RepliedDateLabel: UILabel!
    @IBOutlet weak var repliedByLabel: UILabel!
    @IBOutlet weak var replyLabel: UILabel!
    @IBOutlet weak var queryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var TIcketCategoryLabel: UILabel!
   
    @IBOutlet weak var TicketCategoryWritingSupport: UILabel!
    @IBOutlet weak var ticketIdLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
