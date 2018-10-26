//
//  CenterVCDelegate.swift
//  Uber
//
//  Created by MEHEDI.R8 on 10/24/18.
//  Copyright © 2018 R8soft. All rights reserved.
//

import UIKit

protocol CenterVCDelegate {
    func toggleLeftPanel()
    func addLeftPanelViewController()
    func animateLeftPanel(shouldExpend: Bool)
}

