//
//  QuizViewController.swift
//  WhatTheName
//
//  Created by Rafael on 12/22/23.
//

import UIKit

import AudioToolbox
import UIKit

class QuizViewController: UIViewController {
    
    private let quizView = QuizView()
    
    private var crawledTexts: [String] = []
    private var currentSymbolName: String?
    private var isUpdatingUI = false
    
    override func loadView() {
        view = quizView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddTargets()
        updateUIWithFetchedSymbols()
    }
    
    private func setupAddTargets() {
        quizView.exitButton.addTarget(
            self,
            action: #selector(exitButtonTapped),
            for: .touchUpInside
        )
        
        for (index, button) in quizView.nameButtons.enumerated() {
            button.tag = index
            button.addTarget(self, action: #selector(nameButtonTapped), for: .touchUpInside)
        }
    }
    
    private func updateUIWithFetchedSymbols() {
        quizView.loadingIndicator.startAnimating()
        let symbolManager = SymbolManager()
        
        symbolManager.fetchSymbols { [weak self] (symbols, error) in
            guard let self = self, let symbols = symbols else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                self?.isUpdatingUI = false  // 에러 발생 시 isUpdatingUI를 false로 설정
                return
            }
            
            let symbolNames = symbols.map { $0.name }
            self.crawledTexts = symbolNames.filter { $0 != self.currentSymbolName }
            
            let randomTexts = self.crawledTexts.shuffled().prefix(5)
            for (index, button) in quizView.nameButtons.enumerated() {
                if index < randomTexts.count {
                    let title = Array(randomTexts)[index]
                    button.setTitle(title, for: .normal)
                    button.isHidden = false
                } else {
                    button.isHidden = true
                }
            }
            
            if let randomSymbolName = randomTexts.randomElement() {
                self.currentSymbolName = randomSymbolName
                self.quizView.symbolImageView.image = UIImage(systemName: randomSymbolName)?
                    .withTintColor(.label, renderingMode: .alwaysOriginal)
            }
            
            self.quizView.loadingIndicator.isHidden = true
            self.quizView.loadingIndicator.stopAnimating()
            self.isUpdatingUI = false  // UI 업데이트가 완료되면 isUpdatingUI를 false로 설정
        }
    }
    
    @objc private func exitButtonTapped() {
        let alertController = UIAlertController(
            title: "Exit Confirmation",
            message: "Are you sure you want to exit the game?",
            preferredStyle: .alert
        )
        
        let confirm = UIAlertAction(title: "Yes", style: .default) { _ in
            self.dismiss(animated: true)
        }
        confirm.setValue(UIColor.systemRed, forKey: "titleTextColor")
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(confirm)
        alertController.addAction(cancel)
        
        present(alertController, animated: true)
    }
    
    @objc private func nameButtonTapped(_ sender: UIButton) {
        guard !isUpdatingUI,
              let symbolName = currentSymbolName,
              let title = sender.title(for: .normal)
        else {
            return
        }
        
        if title == symbolName {
            isUpdatingUI = true
            Vibration.heavy.vibrate()
            quizView.loadingIndicator.isHidden = false
            quizView.loadingIndicator.startAnimating()
            updateUIWithFetchedSymbols()
        } else {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            shakeAnimation()
            changeBackgroundColorTemporarily()
        }
    }
    
    private func shakeAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.duration = 0.1
        animation.repeatCount = 2
        animation.autoreverses = true
        
        let fromPoint = CGPoint(x: quizView.center.x - 10, y: quizView.center.y)
        let toPoint = CGPoint(x: quizView.center.x + 10, y: quizView.center.y)
        
        animation.values = [NSValue(cgPoint: fromPoint), NSValue(cgPoint: toPoint)]
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        quizView.layer.add(animation, forKey: "position")
    }
    
    private func changeBackgroundColorTemporarily() {
        UIView.animate(withDuration: 0.5, animations: {
            self.view.backgroundColor = .systemRed
        }) { _ in
            UIView.animate(withDuration: 0.5) {
                self.view.backgroundColor = .systemBackground
            }
        }
    }
    
}
