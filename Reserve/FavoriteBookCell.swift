//
//  FavoriteBookCell.swift
//  Reserve
//
//  Created by Edward Cluster on 4/19/22.
//

import UIKit

class FavoriteBookCell: UITableViewCell {
    
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var unfavoriteBook: UIButton!
    
    weak var delegate: FavoriteBookCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func unfavoriteTapped(_ sender: Any) {
        self.delegate?.unfavoriteTapped(cell: self)
    }
    
}

protocol FavoriteBookCellDelegate: class {
    func unfavoriteTapped(cell: FavoriteBookCell)
}
