//
//  TransactionDetailsTableView.swift
//  TONApp
//
//  Created by Aurocheg on 28.04.23.
//

import UIKit

public final class TransactionDetailsTableView: UITableView {
    public convenience init() {
        self.init(frame: .zero, style: .plain)
        isScrollEnabled = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        rowHeight = 44
        backgroundColor = .clear
    }
}
