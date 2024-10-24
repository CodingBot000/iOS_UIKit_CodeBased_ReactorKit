//
//  Extensions.swift
//
//
//  Created by switchMac on 8/24/24.
//
//

import UIKit

extension UIView {

    func pinToEdges(of parent: UIView, top: CGFloat = 0, leading: CGFloat = 0, trailing: CGFloat = 0, bottom: CGFloat = 0) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: parent.topAnchor, constant: top),
            self.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: leading),
            self.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: trailing),
            self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: bottom)
        ])
    }
}


extension Array where Element == ChipData {
   
    func splitByNameCharacterCount() -> (firstHalf: [ChipData], secondHalf: [ChipData]) {
  
        var firstHalf = Array(self.prefix((self.count) / 2))
        var secondHalf = Array(self.suffix(self.count - firstHalf.count))
        
        func totalCharacters(_ array: [ChipData]) -> Int {
            return array.reduce(0) { $0 + $1.name.count }
        }
        
        while totalCharacters(firstHalf) < totalCharacters(secondHalf) && !secondHalf.isEmpty {

            let element = secondHalf.removeLast()
            firstHalf.append(element)
        }

        return (firstHalf, secondHalf)
    }
}

extension UIViewController {
    func gotoDetailViewController(id: String) {
        let detailVC = DetailViewController(id: id)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}


