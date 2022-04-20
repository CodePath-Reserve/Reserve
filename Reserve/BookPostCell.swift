//
//  BookPostCell.swift
//  Reserve
//
//  Created by Edward Cluster on 4/12/22.
//

import UIKit

class BookPostCell: UITableViewCell {
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!

    @IBAction func onCheckoutButton(_ sender: Any) {
    }
    @IBAction func onFavoriteButton(_ sender: Any) {
    }
    @IBAction func onCommentButton(_ sender: Any) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
