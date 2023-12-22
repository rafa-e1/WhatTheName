//
//  HomeView.swift
//  WhatTheName
//
//  Created by Rafael on 12/22/23.
//

import UIKit

import SnapKit
import Then

class HomeView: UIView {
    
    private lazy var backgroundImageView = UIImageView().then {
        $0.image = UIImage(named: "background")
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var gameNameLabel = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.attributedText = NSAttributedString(
            string: "What the Name of Symbols? 🤯",
            attributes: [
                .font: UIFont.systemFont(ofSize: 30.0, weight: .bold),
                .foregroundColor: UIColor.white
            ]
        )
    }
    
    lazy var startButton = UIButton().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10.0
        $0.setAttributedTitle(NSAttributedString(
            string: "Start",
            attributes: [
                .font: UIFont.systemFont(ofSize: 20.0, weight: .medium),
                .foregroundColor: UIColor.black
            ]
        ), for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        configureSubviews()
        configureConstraints()
    }
    
    private func configureSubviews() {
        [backgroundImageView, gameNameLabel, startButton].forEach {
            addSubview($0)
        }
    }
    
    private func configureConstraints() {
        makeBackgroundImageViewConstraints()
        makeGameNameLabelConstraints()
        makeStartButtonConstraints()
    }
    
    private func makeBackgroundImageViewConstraints() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func makeGameNameLabelConstraints() {
        gameNameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.equalTo(20)
        }
    }
    
    private func makeStartButtonConstraints() {
        startButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.equalTo(100)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(50)
        }
    }
    
}
