//
//  InfoPairView.swift
//  Weather-app
//
//  Created by Daniel Medina Sada on 8/15/24.
//

import UIKit

class InfoPairView: UIStackView {
    struct ViewModel {
        var header: String?
        var titleLeft: String
        var valueLeft: String
        var titleRight: String
        var valueRight: String
    }
    
    private lazy var header: UILabel = {
        return UILabel()
    }()
    
    private lazy var leftLbl: UILabel = {
        return UILabel()
    }()
    
    private lazy var rightLbl: UILabel = {
        return UILabel()
    }()
    
    private lazy var dataStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = stackViewAxis
        stackView.spacing = 8
        return stackView
    }()
    
    private var stackViewAxis: NSLayoutConstraint.Axis {
        traitCollection.horizontalSizeClass == .compact ? .vertical : .horizontal
    }
    
    init() {
        super.init(frame: .zero)
        axis = .vertical
        addArrangedSubview(header)
        dataStackView = UIStackView(arrangedSubviews: [leftLbl, rightLbl])
        addArrangedSubview(dataStackView)
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(viewModel: ViewModel) {
        if let headerTxt = viewModel.header {
            header.isHidden = false
            header.text = headerTxt.asTitle
        } else {
            header.isHidden = true
        }
        leftLbl.text = "\(viewModel.titleLeft.asTitle) \(viewModel.valueLeft)"
        rightLbl.text = "\(viewModel.titleRight.asTitle) \(viewModel.valueRight)"
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        dataStackView.axis = stackViewAxis
    }
}
