//
//  HomeViewController.swift
//  WhatTheName
//
//  Created by Rafael on 12/22/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let homeView = HomeView()
    
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddTarget()
    }
    
    private func setupAddTarget() {
        homeView.startButton.addTarget(
            self,
            action: #selector(startButtonTapped),
            for: .touchUpInside
        )
    }
    
    @objc private func startButtonTapped() {
        print("Start button tapped")
    }
    
}
