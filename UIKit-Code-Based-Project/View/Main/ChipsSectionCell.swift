//
//  Untitled.swift
//  UIKit-Code-Based-Project
//
//  Created by switchMac on 10/23/24.
//

import UIKit
import RxSwift
import RxCocoa


class ChipsSectionCell: UICollectionViewCell {
    static let identifier = "ChipSelectionCell"

    let subTitleView = SubTitleView(title: "What you like", buttonName: "See All", isButtonVisible: true)
    let chipsSectionView = ChipsSectionView()
    var disposeBag = DisposeBag()
    
    var chipTapped: Observable<(Int, ChipData)> {
        return chipsSectionView.chipTapped.asObservable()
    }
    
    var subTitleViewButtonTapped: Observable<Void> {
        return subTitleView.buttonTapped.asObservable()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let stackView = UIStackView(arrangedSubviews: [subTitleView, chipsSectionView])
        stackView.axis = .vertical
        stackView.spacing = 0
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([

            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            subTitleView.heightAnchor.constraint(equalToConstant: Dimens.subTitleViewHeight),

            chipsSectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 70)
        ])
        
        
//        coloredDebug(stackView: stackView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func coloredDebug(stackView: UIStackView) {
        stackView.backgroundColor = .blue
        chipsSectionView.backgroundColor = .red
        subTitleView.backgroundColor = .magenta
    }
    
}
