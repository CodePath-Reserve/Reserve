//
//  BookPostCell.swift
//  Reserve
//
//  Created by Edward Cluster on 4/12/22.
//

import UIKit
import Parse

class BookPostCell: UITableViewCell {
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var favorite: UIButton!
    
    @IBOutlet weak var checkout: UIButton!
    
    weak var delegate: BookPostCellDelegate?

    override func prepareForReuse() {
        super.prepareForReuse()
        self.delegate = nil
    }
    
    @IBAction func someButtonTapped(_ sender: UIButton) {
        self.delegate?.buttonTapped(cell: self)
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        self.delegate?.favoriteTapped(cell: self)
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


protocol BookPostCellDelegate: class {
    func buttonTapped(cell: BookPostCell)
    func favoriteTapped(cell: BookPostCell)
}
