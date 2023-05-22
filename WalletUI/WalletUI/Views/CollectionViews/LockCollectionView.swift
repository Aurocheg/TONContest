//
//  LockCollectionView.swift
//  TONApp
//
//  Created by Aurocheg on 26.04.23.
//

import UIKit

public final class LockCollectionView: UICollectionView {
    public convenience init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 78, height: 78)
        layout.minimumLineSpacing = 24
        
        self.init(frame: .zero, collectionViewLayout: layout)
        
        isScrollEnabled = false
        backgroundColor = .clear
    }
}
