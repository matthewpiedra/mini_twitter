//
//  UIImageView.swift
//  Twitter
//
//  Created by Matthew Piedra on 9/30/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func roundedImage() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}
