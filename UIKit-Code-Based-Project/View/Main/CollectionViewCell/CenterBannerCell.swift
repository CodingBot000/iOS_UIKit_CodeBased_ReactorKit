//
//  CenterBannerCell.swift
//  UIKit-Code-Based-Project
//
//  Created by switchMac on 10/23/24.
//


import UIKit
import RxSwift
import RxCocoa

class CenterBannerCell: UICollectionViewCell {
    static let identifier = "CenterBannerCell"
    
    let bannerSliderView = ImageSliderView(frame: .zero, imageSliderType: .centerBanner, isShowPageControl: false)
    var disposeBag = DisposeBag()
    
    var selectedSliderData: Observable<(ImageSliderData, Int)> {
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
