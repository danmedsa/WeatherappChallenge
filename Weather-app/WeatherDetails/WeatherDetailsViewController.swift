//
//  ViewController.swift
//  Weather-app
//
//  Created by Daniel Medina Sada on 8/15/24.
//

import UIKit

class WeatherDetailsViewController: UIViewController {
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // not needed as Storyboard is not used
    required init?(coder: NSCoder) {
        fatalError("View Controller Should not be used with Storyboard")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        view.backgroundColor = .white
        addMainStackView()
        addSearchBar()
        addTemperatureDataView()
    }
    
    private func addMainStackView() {
        guard let view else { return }
        view.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: view.safeAreaLayoutGuide, attribute: .top, relatedBy: .equal, toItem: mainStackView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view.safeAreaLayoutGuide, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: mainStackView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: mainStackView, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: mainStackView, attribute: .right, multiplier: 1, constant: 0),
        ])
    }
    
    private func addSearchBar() {
        let viewModel = SearchBarView.ViewModel(placeholderText: "search City or State in the US")
        let searchBar = SearchBarView(viewModel: viewModel)
        mainStackView.addArrangedSubview(searchBar)
        mainStackView.setCustomSpacing(8,after: searchBar)
    }
    
    private func addTemperatureDataView() {
        let weather = Weather(id: 500, main: "Rain", description: "light rain", icon: "10n")
        let viewModel = TemperatureDataView.ViewModel(title: "Current weather:", weather: weather)
        let tempView = TemperatureDataView(viewModel: viewModel)
        
        mainStackView.addArrangedSubview(tempView)
    }
}
