//
//  UserCollectionViewCell.swift
//  YALLayoutTransitioning
//
//  Created by Roman on 23.02.16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import DisplaySwitcher
import SDWebImage
import Material

private let avatarListLayoutSize: CGFloat = 200.0

class UserCollectionViewCell: UICollectionViewCell, CellInterface {

    @IBOutlet fileprivate weak var avatarImageView: UIImageView!
    @IBOutlet fileprivate weak var backgroundGradientView: UIView!
    @IBOutlet fileprivate weak var nameListLabel: UILabel!
    @IBOutlet fileprivate weak var nameGridLabel: UILabel!
    @IBOutlet weak var statisticLabel: UILabel!

    @IBOutlet weak var Image_fav: UIImageView!
    // avatarImageView constraints
    @IBOutlet fileprivate weak var avatarImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var avatarImageViewHeightConstraint: NSLayoutConstraint!

    // nameListLabel constraints
    @IBOutlet var nameListLabelLeadingConstraint: NSLayoutConstraint! {
        didSet {
            initialLabelsLeadingConstraintValue = nameListLabelLeadingConstraint.constant
        }
    }

    // statisticLabel constraints
    @IBOutlet weak var statisticLabelLeadingConstraint: NSLayoutConstraint!

    fileprivate var avatarGridLayoutSize: CGFloat = 0.0
    fileprivate var initialLabelsLeadingConstraintValue: CGFloat = 0.0

    func setImage(image: UIImage) {
        avatarImageView.image = image
    }

    func setImage(image: String) {

        avatarImageView.sd_setImage(with: URL(string: image), placeholderImage: nil, options: .highPriority, progress: nil, completed: nil)
       // avatarImageView.sd_setImage(with: <#T##StorageReference#>, placeholderImage: <#T##UIImage?#>)
    }

    func setTitle(title: String) {
        nameListLabel.text = title
        nameGridLabel.text = title
    }

    func setTextColor(color: UIColor) {
        nameGridLabel.textColor = color
        nameListLabel.textColor = color
    }

    func setBackgroundColor(color: UIColor) {
        backgroundGradientView.backgroundColor = color
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.sd_cancelCurrentImageLoad()
        avatarImageView.image = nil
    }

    func setupGridLayoutConstraints(_ transitionProgress: CGFloat, cellWidth: CGFloat) {
         avatarImageViewHeightConstraint.constant = ceil((cellWidth - avatarListLayoutSize) * transitionProgress + avatarListLayoutSize)
        avatarImageViewWidthConstraint.constant = avatarImageViewHeightConstraint.constant/1.3
        nameListLabelLeadingConstraint.constant = avatarImageViewWidthConstraint.constant/2 * transitionProgress + initialLabelsLeadingConstraintValue
        // statisticLabelLeadingConstraint.constant = nameListLabelLeadingConstraint.constant
        backgroundGradientView.alpha = transitionProgress <= 0.5 ? 1 - transitionProgress : transitionProgress
        nameListLabel.alpha =  transitionProgress
        //statisticLabel.alpha = transitionProgress
    }

    func setupListLayoutConstraints(_ transitionProgress: CGFloat, cellWidth: CGFloat) {
        avatarImageViewHeightConstraint.constant = ceil(avatarGridLayoutSize - (avatarGridLayoutSize - avatarListLayoutSize) * transitionProgress)
        avatarImageViewWidthConstraint.constant = avatarImageViewHeightConstraint.constant/1.3
        nameListLabelLeadingConstraint.constant = avatarImageViewWidthConstraint.constant/2 * transitionProgress + initialLabelsLeadingConstraintValue
       // statisticLabelLeadingConstraint.constant = nameListLabelLeadingConstraint.constant
        backgroundGradientView.alpha = transitionProgress <= 0.5 ? 1 - transitionProgress : transitionProgress
        nameListLabel.alpha =  transitionProgress
        //statisticLabel.alpha = transitionProgress
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? DisplaySwitchLayoutAttributes {
            if attributes.transitionProgress > 0 {
                if attributes.layoutState == .grid {
                    setupGridLayoutConstraints(attributes.transitionProgress, cellWidth: attributes.nextLayoutCellFrame.width)
                    avatarGridLayoutSize = attributes.nextLayoutCellFrame.width
                } else {
                    setupListLayoutConstraints(attributes.transitionProgress, cellWidth: attributes.nextLayoutCellFrame.width)
                }
            }
        }
    }
}
