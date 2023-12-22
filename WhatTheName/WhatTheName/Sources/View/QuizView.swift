//
//  QuizView.swift
//  WhatTheName
//
//  Created by Rafael on 12/22/23.
//

import UIKit

import SnapKit
import Then

class QuizView: UIView {
    
    private lazy var scrollView = UIScrollView()
    
    private lazy var containerView = UIView()
    
    lazy var exitButton = UIButton().then {
        $0.setImage(UIImage(systemName: "door.left.hand.open")?
            .withTintColor(.systemRed, renderingMode: .alwaysOriginal)
            .withConfiguration(
                UIImage.SymbolConfiguration(pointSize: 30.0, weight: .medium)
            ), for: .normal
        )
    }
    
    lazy var symbolImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var nameButtons: [UIButton] = []
    
    lazy var loadingIndicator = UIActivityIndicatorView().then {
        $0.style = .large
        $0.color = .mainColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        configureSubviews()
        configureConstraints()
    }
    
    private func configureSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(containerView)
        [exitButton, symbolImageView, loadingIndicator].forEach { containerView.addSubview($0) }
        createNameButtons()
        containerView.addSubview(loadingIndicator)
    }
    
    private func configureConstraints() {
        makeScrollViewConstraints()
        makeContainerViewConstraints()
        makeExitButtonConstraints()
        makeSymbolImageViewConstraints()
        makeNameButtonsConstraints()
        makeLoadingIndicatorViewConstraints()
    }
    
    private func makeScrollViewConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func makeContainerViewConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
        }
    }
    
    private func makeExitButtonConstraints() {
        exitButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalTo(-20)
        }
    }
    
    private func makeSymbolImageViewConstraints() {
        symbolImageView.snp.makeConstraints {
            $0.centerX.leading.equalToSuperview()
            $0.top.equalTo(exitButton.snp.bottom).offset(30)
            $0.height.equalTo(250)
        }
    }
    
    private func makeNameButtonsConstraints() {
        for (index, button) in nameButtons.enumerated() {
            button.snp.makeConstraints {
                if index == 0 {
                    $0.top.equalTo(symbolImageView.snp.bottom).offset(60)
                } else {
                    $0.top.equalTo(nameButtons[index - 1].snp.bottom).offset(20)
                }
                $0.centerX.equalToSuperview()
                $0.leading.equalTo(20)
                $0.height.equalTo(55)
                
                // 마지막 버튼의 경우 컨테이너뷰의 bottom과 연결
                if index == nameButtons.count - 1 {
                    $0.bottom.equalTo(-20)
                }
            }
        }
    }
    
    private func makeLoadingIndicatorViewConstraints() {
        loadingIndicator.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    private func createNameButtons() {
        for _ in 0..<5 {
            let button = UIButton().then {
                var config = UIButton.Configuration.filled()
                config.baseBackgroundColor = .systemBackground
                config.baseForegroundColor = .label
                config.titleAlignment = .center
                config.titlePadding = 10.0
                
                $0.configuration = config
                $0.clipsToBounds = true
                $0.layer.borderWidth = 1.0
                $0.layer.borderColor = UIColor.mainColor.cgColor
                $0.layer.cornerRadius = 10.0
            }
            nameButtons.append(button)
            containerView.addSubview(button)
        }
        makeNameButtonsConstraints()
    }
    
}
