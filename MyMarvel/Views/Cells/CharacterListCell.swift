//
//  CharacterListCell.swift
//  MyMarvel
//
//  Created by Sahil Ratnani on 13/05/23.
//

import Foundation
import UIKit
import Kingfisher

class CharacterListCell: UITableViewCell {
    @IBOutlet weak var charImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(info: (name: String, desc: String, imageURL: String?)) {
        titleLabel.text = info.name
        descriptionLabel.text = info.desc
        guard let urlString = info.imageURL,
              let imageURL = URL(string: urlString) else { return }
        charImageView.kf.setImage(with: imageURL, placeholder: UIImage(systemName: "person.fill"))

    }
}
