//
//  GridImageItemView.swift
//  UIKit-Code-Based-Project
//
//  Created by switchMac on 10/8/24.
//
//

import UIKit
import RxSwift
import RxCocoa

class GridImageItemView: UIView {
    var disposeBag = DisposeBag()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tapSubject = PublishSubject<ProductData>()
    var tapObservable: Observable<ProductData> {
        return tapSubject.asObservable()
    }
    
    private var productData: ProductData?
    private var gridType: GridType

    init(productData: ProductData, gridType: GridType) {
        self.productData = productData
        self.gridType = gridType
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
   
        setupView()
        setupConstraints()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        imageView.image = UIImage(named: productData?.imageName ?? "")
        titleLabel.text = productData?.name
        subtitleLabel.text = productData?.subName
        
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
    }
    
    private func setupConstraints() {
        let imageAspectRatio = gridType.aspectRatio
        
        if (gridType == GridType.wideWidth) {
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: self.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                imageView.widthAnchor.constraint(equalToConstant: Dimens.gridImageWideWidth),
                imageView.heightAnchor.constraint(equalToConstant: Dimens.gridImageRectangleSize)

            ])
        } else {
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: self.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),

                imageView.widthAnchor.constraint(equalToConstant: Dimens.gridImageRectangleSize),
                imageView.heightAnchor.constraint(equalToConstant: Dimens.gridImageRectangleSize)
            ])
        }
        NSLayoutConstraint.activate([

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4),
            subtitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setupGesture() {

        let tapGesture = UITapGestureRecognizer()
        self.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .bind { [weak self] _ in
                guard let self = self, let data = self.productData else { return }
                self.tapSubject.onNext(data)
            }
            .disposed(by: disposeBag)
    }
}

