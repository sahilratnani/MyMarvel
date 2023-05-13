//
//  UITableViewCell.swift
//  MyMarvel
//
//  Created by Sahil Ratnani on 13/05/23.
//

import Foundation
import UIKit

public extension UITableViewCell {
    
    /** Return identifier with the same name of the subclass */
    static var defaultIdentifier: String {
        return String(describing: self)
    }

    static var defaultNib: UINib {
        return UINib(nibName: defaultIdentifier, bundle: nil)
    }
}
