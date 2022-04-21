//
//  CheckedBookCell.swift
//  Reserve
//
//  Created by Edward Cluster on 4/19/22.
//

import UIKit

class CheckedBookCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var returnBook: UIButton!
    
    weak var delegate: CheckedBookCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.delegate = nil
    }
    
    @IBAction func someButtonTapped(_ sender: UIButton) {
        self.delegate?.buttonTapped(cell: self)
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

protocol CheckedBookCellDelegate: class {
    func buttonTapped(cell: CheckedBookCell)
}
