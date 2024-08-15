//
//  LoadingIndicatorView.swift
//  Weather-app
//
//  Created by Daniel Medina Sada on 8/15/24.
//

import UIKit

class LoadingIndicatorView: UIViewController {
    var spinner = UIActivityIndicatorView(style: .large)
    weak var vc: UIViewController?
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

    }
    
    func show(in vc: UIViewController) {
        self.vc = vc
        spinner.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        spinner.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        vc.addChild(self)
        view.frame = vc.view.frame
        vc.view.addSubview(view)
        didMove(toParent: self)

    }
    
    func hide() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
        vc = nil
    }
}
