//
//  SearchBarView.swift
//  Weather-app
//
//  Created by Daniel Medina Sada on 8/15/24.
//

import UIKit

class SearchBarView: UISearchBar {
    struct ViewModel {
        var placeholderText: String
    }
    
    init(viewModel: ViewModel) {
        super.init(frame: .zero)
        placeholder = viewModel.placeholderText
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // Not required as Storyboard or XIBs are not being used
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
