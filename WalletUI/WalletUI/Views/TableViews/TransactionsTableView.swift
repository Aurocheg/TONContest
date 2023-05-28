//
//  TransactionsTableView.swift
//  TONApp
//
//  Created by Aurocheg on 15.04.23.
//

import UIKit

public final class TranscationsTableView: UITableView {
    public convenience init() {
        self.init(frame: .zero, style: .grouped)
        separatorStyle = .none
        isScrollEnabled = false
        showsVerticalScrollIndicator = false
        backgroundColor = .clear
        estimatedRowHeight = 121
        contentInset = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 292, right: 0.0)
        rowHeight = UITableView.automaticDimension
    }
}
