//
//  RecentTableView.swift
//  TONApp
//
//  Created by Aurocheg on 19.04.23.
//

import UIKit

public final class RecentTableView: UITableView {
    public convenience init() {
        self.init(frame: .zero, style: .insetGrouped)
        contentInset = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        showsVerticalScrollIndicator = false
        rowHeight = 60
        backgroundColor = .clear
    }
}
