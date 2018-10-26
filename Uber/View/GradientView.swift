//
//  GradientView.swift
//  Uber
//
//  Created by MEHEDI.R8 on 10/24/18.
//  Copyright © 2018 R8soft. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    let gradient = CAGradientLayer()
    
    override func awakeFromNib() {
        setupGradientView()
    }
    
    func setupGradientView() {
        gradient.frame = self.bounds
        gradient.colors = [UIColor.white.cgColor, UIColor.init(white: 1.0, alpha: 0.0).cgColor]
        gradient.startPoint = CGPoint.zero
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.locations = [0.8, 1.0]
        self.layer.insertSublayer(gradient, at: 0)
    }
}
