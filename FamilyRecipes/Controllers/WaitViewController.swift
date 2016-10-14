//
//  WaitViewController.swift
//  FamilyRecipes
//
//  Created by Foster, Jake on 10/14/16.
//  Copyright © 2016 SideBuild. All rights reserved.
//

import UIKit

class WaitViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        spinner.color = UIColor.blue
        spinner.startAnimating()
        view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
