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
    @IBOutlet weak var bookmarkButton: UIButton!

    var onBookmarked: (() -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func prepareForReuse() {
        setupView()
    }

    func setupView() {
        titleLabel.text = ""
        descriptionLabel.text = ""
        charImageView.image = nil
        bookmarkButton.isSelected = false
        bookmarkButton.isHidden = true
    }

    func configure(info: (name: String, desc: String, imageURL: String?, isBookmarked: Bool)) {
        titleLabel.text = info.name
        descriptionLabel.text = info.desc
        guard let urlString = info.imageURL,
              let imageURL = URL(string: urlString) else { return }
        charImageView.kf.setImage(with: imageURL, placeholder: UIImage(systemName: "person.fill"))
        bookmarkButton.isHidden = false
        bookmarkButton.isSelected = info.isBookmarked
    }

    @IBAction func bookmarkDidTap(_ sender: UIButton) {
        onBookmarked?()
        sender.isSelected.toggle()
    }
}
