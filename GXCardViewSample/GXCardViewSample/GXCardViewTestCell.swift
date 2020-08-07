//
//  GXCardViewTestCell.swift
//  GXCardViewSample
//
//  Created by Gin on 2020/8/7.
//  Copyright © 2020 gin. All rights reserved.
//

import UIKit

class GXCardViewTestCell: GXCardViewCell {
    @IBOutlet weak var iconIView: UIImageView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 10.0;
        self.layer.borderColor = UIColor.gray.cgColor;
        self.layer.borderWidth = 1.0;
        self.layer.masksToBounds = true
    }
}
