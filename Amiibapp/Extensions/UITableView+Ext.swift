//
//  UITableView+Ext.swift
//  Amiibapp
//
//  Created by Miguel Planckensteiner on 2/12/21.
//

import UIKit

extension UITableView {
    
    func reloadDataOnMainThread() {
        DispatchQueue.main.async { self.reloadData() }
    }
    
    
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
