//
//  GridSectionCell.swift
//  UIKit-Code-Based-Project
//
//  Created by switchMac on 10/23/24.
//

import UIKit
import RxSwift
import RxCocoa


class GridSectionCell: UICollectionViewCell {
    static let identifier = "GridSectionCell"

    let subTitleView = SubTitleView(title: "", isButtonVisible: false)
    var gridScrollView: HorizontalGridScrollView!
    var disposeBag = DisposeBag()
    private var stackView: UIStackView!
    
    var itemTapped: Observable<ProductData> {
        return gridScrollView.itemTapped.asObservable()
    }
    
    var buttonTapped: Observable<Void> {
        return subTitleView.buttonTapped.asObservable()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stackView = UIStackView(arrangedSubviews: [subTitleView])
        stackView.axis = .vertical
        stackView.spacing = 0
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            subTitleView.heightAnchor.constraint(equalToConstant: Dimens.subTitleViewHeight),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        if gridScrollView != nil {
            gridScrollView.removeFromSuperview()
            stackView.removeArrangedSubview(gridScrollView)
            gridScrollView = nil
        }
    }
    
    func configure(title: String, buttonName: String?, isButtonVisible: Bool, repositoryDataType: RepositoryDataType, gridType: GridType) {
        subTitleView.configure(
            title: title, buttonName: buttonName, isButtonVisible: isButtonVisible)

        if gridScrollView != nil {
            gridScrollView.removeFromSuperview()
            stackView.removeArrangedSubview(gridScrollView)
        }
        
        gridScrollView = HorizontalGridScrollView(frame: .zero, repositoryDataType: repositoryDataType, gridType: gridType)
        stackView.addArrangedSubview(gridScrollView)
        gridScrollView.translatesAutoresizingMaskIntoConstraints = false
        gridScrollView.heightAnchor.constraint(equalToConstant: Dimens.gridSectionHeight).isActive = true
        
//        coloredDebug()
    }
    
    private func coloredDebug() {
        stackView.backgroundColor = .blue
        gridScrollView.backgroundColor = .red
    }
    
}
