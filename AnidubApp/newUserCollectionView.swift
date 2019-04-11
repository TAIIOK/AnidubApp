//
//  newUserCollectionView.swift
//  AnidubApp
//
//  Created by Roman Efimov on 30/10/2018.
//  Copyright © 2018 Roman Efimov. All rights reserved.
//

import UIKit
import DisplaySwitcher
import SDWebImage

class newUserCollectionViewCell: UICollectionViewCell, CellInterface {

    @IBOutlet weak var avatarImageView: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var genresLabel: UILabel!

    @IBOutlet weak var currentRating: UILabel!

    @IBOutlet weak var episodesLabel: UILabel!

    func setImage(image: UIImage) {
        avatarImageView.image = image
        avatarImageView.layer.cornerRadius = 8.0
        avatarImageView.clipsToBounds = true
    }

    func setImage(image: String) {

        avatarImageView.sd_setImage(with: URL(string: image), placeholderImage: nil, options: .highPriority, progress: nil, completed: nil)
        // avatarImageView.sd_setImage(with: <#T##StorageReference#>, placeholderImage: <#T##UIImage?#>)
    }

    func setTitle(title: String) {
        nameLabel.text = title

    }

    func setGenres(genres: String) {
        genresLabel.text = genres
    }

    func setEpisodes(episodes: String) {
        episodesLabel.text = episodes
    }

    func setRating(rating: String) {
        currentRating.text = rating
    }

    func setTextColor(color: UIColor) {
        nameLabel.textColor = color

        //genresLabel.textColor = color
        currentRating.textColor = color
        //episodesLabel.textColor = color

    }

    func setBackgroundColor(color: UIColor) {
        //backgroundGradientView.backgroundColor = color
        self.backgroundColor = color
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.sd_cancelCurrentImageLoad()
        avatarImageView.image = nil
        avatarImageView.layer.cornerRadius = 8.0
        avatarImageView.clipsToBounds = true
    }

}
