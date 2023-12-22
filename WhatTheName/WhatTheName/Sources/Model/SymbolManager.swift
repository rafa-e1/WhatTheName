//
//  SymbolManager.swift
//  WhatTheName
//
//  Created by Rafael on 12/22/23.
//

import Foundation

import SwiftSoup

class SymbolManager {
    
    func fetchSymbols(completion: @escaping ([Symbol]?, Error?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let urlAddress = "https://developer.apple.com/sf-symbols/release-notes/"
            guard let url = URL(string: urlAddress) else {
                completion(
                    nil,
                    NSError(
                        domain: "",
                        code: 0,
                        userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]
                    )
                )
                return
            }
            
            do {
                let html = try String(contentsOf: url, encoding: .utf8)
                let doc: Document = try SwiftSoup.parse(html)
                let firstItems: Elements = try doc.select("ul.column-list list-1").select("li")
                let secondItems: Elements = try doc.select("ul.column-list list-2").select("li")
                let thirdItems: Elements = try doc.select("ul.no-bullet").select("li")
                
                var symbols: [Symbol] = []
                
                let simpleItems = [firstItems, secondItems]
                for items in simpleItems {
                    for listItem in items {
                        let name = try listItem.text().trimmingCharacters(in: .whitespaces)
                        if !name.isEmpty {
                            symbols.append(Symbol(name: name))
                        }
                    }
                }
                
                for listItem in thirdItems {
                    let text = try listItem.text()
                    let components = text.components(separatedBy: "->").map { $0.trimmingCharacters(in: .whitespaces) }
                    if let name = components.last, name != "" {
                        symbols.append(Symbol(name: name))
                    }
                }
                
                DispatchQueue.main.async {
                    completion(symbols, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    
}
