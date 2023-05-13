//
//  UITableView+Extension.swift
//  MyMarvel
//
//  Created by Sahil Ratnani on 13/05/23.
//

import Foundation
import UIKit

public extension UITableView {
    /// Register a cell with his Default name and identifier on the main bundle.
    func registerCell<T: UITableViewCell>(cellClass: T.Type) {
        self.register(T.defaultNib, forCellReuseIdentifier: T.defaultIdentifier)
    }
    
    ///Dequeue a cell with his default Class Name.
    func dequeue<T: UITableViewCell>(cellClass: T.Type, indexPath: IndexPath) -> T {
        return self.dequeue(withIdentifier: cellClass.defaultIdentifier, indexPath: indexPath)
    }
    
    private func dequeue<T: UITableViewCell>(withIdentifier id: String, indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: id, for: indexPath) as! T
    }
}
