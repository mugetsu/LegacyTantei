//
//  UITableView++.swift
//  Tantei-san
//
//  Created by Randell on 29/9/22.
//

import UIKit

public extension UITableView {
    
    func registerCell<T: UITableViewCell>(cellClass: T.Type) {
        self.register(T.self, forCellReuseIdentifier: T.defaultIdentifier)
    }
    
    func dequeue<T: UITableViewCell>(cellClass: T.Type, indexPath: IndexPath) -> T {
        return self.dequeue(withIdentifier: cellClass.defaultIdentifier, indexPath: indexPath)
    }
    
    private func dequeue<T: UITableViewCell>(withIdentifier id: String, indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: id, for: indexPath) as! T
    }
}
