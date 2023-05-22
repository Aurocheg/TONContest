//
//  PhrasesCollectionView.swift
//  TONApp
//
//  Created by Aurocheg on 5.04.23.
//

import UIKit

public final class PhrasesCollectionView: UICollectionView {
    public convenience init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.init(frame: .zero, collectionViewLayout: layout)
        isScrollEnabled = false
    }
}

