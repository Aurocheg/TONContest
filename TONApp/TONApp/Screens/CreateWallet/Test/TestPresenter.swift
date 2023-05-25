//
//  TestPresenter.swift
//  TONApp
//
//  Created by Aurocheg on 7.04.23.
//

import WalletUI

protocol TestPresenterProtocol: AnyObject {
    func setupWordList()
    func searchSuitableWords(_ searchText: String, maxSearchResults: Int) -> [String]
    func continueButtonTapped()
    func seeWordsTapped()
}

final class TestPresenter {
    weak var view: TestViewProtocol!
    public var router: TestRouterProtocol!
    public var possibleWordListManager: PossibleWordListManagerProtocol!
    
    private var possibleWordList: [String] = []
    
    required init(view: TestViewProtocol) {
        self.view = view
    }
}

// MARK: - TestPresenterProtocol
extension TestPresenter: TestPresenterProtocol {
    func setupWordList() {
        possibleWordList = possibleWordListManager.getPossibleWordList()
    }
    
    func searchSuitableWords(_ searchText: String, maxSearchResults: Int) -> [String] {
        var results: [String] = []
        for word in possibleWordList {
            if word.lowercased().hasPrefix(searchText.lowercased()) {
                results.append(word)
            }
            if results.count == maxSearchResults {
                break
            }
        }
        return results
    }
    
    func continueButtonTapped() {
        router.showPasscode()
    }
    
    func seeWordsTapped() {
        router.dismiss()
    }
}
