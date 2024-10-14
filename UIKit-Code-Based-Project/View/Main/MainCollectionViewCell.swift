//
//  MainCollectionViewCell.swift
//  UIKit-Code-Based-Project
//
//  Created by switchMac on 10/14/24.
//

import UIKit
import RxSwift
import RxCocoa


enum MainCollectionViewItem {
    case banner
    case chipsSection
    case gridSection(title: String, buttonName: String?, isButtonVisible: Bool, repositoryDataType: RepositoryDataType, gridType: GridType)
}


class BannerCell: UICollectionViewCell {
    static let identifier = "BannerCell"
    
    let bannerSliderView = ImageSliderView()
    var disposeBag = DisposeBag()
    
    var selectedSliderData: Observable<(ProductData, Int)> {
        return bannerSliderView.selectedSliderData.asObservable()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(bannerSliderView)
        bannerSliderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bannerSliderView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bannerSliderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bannerSliderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bannerSliderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bannerSliderView.heightAnchor.constraint(equalToConstant: Dimens.bannerSliderHeight)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        if gridScrollView != nil {
            gridScrollView.removeFromSuperview()
            stackView.removeArrangedSubview(gridScrollView)
            gridScrollView = nil
        }
    }
    
    private func coloredDebug() {
        stackView.backgroundColor = .blue
        gridScrollView.backgroundColor = .red
    }
    
}
