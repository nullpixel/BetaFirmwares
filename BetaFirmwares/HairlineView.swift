//
//  HairlineView.swift
//  BetaFirmwares
//
//  Created by AppleBetas on 2016-07-03.
//  Copyright © 2016 nullpixelLabs. All rights reserved.
//

import UIKit

class HairlineView: UIView {
    let hairlineWidth = (1.0 / UIScreen.main.scale) / 2
    var bottomBorder = CALayer()

    override func awakeFromNib() {
        super.awakeFromNib()
        bottomBorder.frame = CGRect(x: 0, y: self.frame.size.height - hairlineWidth, width: self.frame.size.width, height: hairlineWidth)
        bottomBorder.backgroundColor = UIColor(white: 0.3, alpha: 0.2).cgColor
        self.layer.addSublayer(bottomBorder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomBorder.frame = CGRect(x: 0, y: self.frame.size.height - hairlineWidth, width: self.frame.size.width, height: hairlineWidth)
    }
    
}
