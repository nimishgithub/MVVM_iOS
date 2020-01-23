//
//  PickMediaCVCell.swift
//  MVVM Project
//
//  Created by Nimish Sharma on 23/01/20.
//  Copyright © 2020 Nimish Sharma. All rights reserved.
//

import UIKit

class PickMediaCVCell: UICollectionViewCell {
    
    enum SetupAs {
        case pickAttachment
        case imageThumbnail
    }

    @IBOutlet weak var iconIV: UIImageView!
    
    
    var setupType: SetupAs = .pickAttachment {
        didSet {
            switch setupType {
            case .pickAttachment:
                iconIV.image = AppImages.addAttachment
            default:
                iconIV.image = nil
                iconIV.contentMode = .scaleAspectFill
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconIV.layer.cornerRadius = 8
        iconIV.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconIV.image = nil
    }

}
