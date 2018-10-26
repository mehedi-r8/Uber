//
//  RoundedShadowView.swift
//  Uber
//
//  Created by MEHEDI.R8 on 10/24/18.
//  Copyright © 2018 R8soft. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedShadowView: UIView {
    
    override func awakeFromNib() {
        setupView()
    }

    func setupView() {
        self.layer.cornerRadius = 10
        self.layer.shadowOpacity = 0.9
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 20
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
    }

}
