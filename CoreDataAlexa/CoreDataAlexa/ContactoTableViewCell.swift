//
//  ContactoTableViewCell.swift
//  CoreDataAlexa
//
//  Created by Mac18 on 20/05/21.
//

import UIKit

class ContactoTableViewCell: UITableViewCell {

    @IBOutlet weak var imagenContactp: UIImageView!
    @IBOutlet weak var correoLabel: UILabel!
    @IBOutlet weak var numeroLabel: UILabel!
    @IBOutlet weak var nombreLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backView.layer.masksToBounds = false

              backView.layer.cornerRadius = 9

              backView.layer.shadowColor = UIColor.black.cgColor

              backView.layer.shadowOpacity = 0.5

              backView.layer.shadowOffset = .zero

              backView.layer.shadowRadius = 5 
    }
    @IBOutlet weak var backView: UIView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
