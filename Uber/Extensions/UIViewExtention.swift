//
//  UIViewExtention.swift
//  Uber
//
//  Created by MEHEDI.R8 on 10/25/18.
//  Copyright © 2018 R8soft. All rights reserved.
//

import UIKit

extension UIView {
    func fadeTo(alphaValue: CGFloat, withDuration duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.alpha = alphaValue
        }
    }

}
