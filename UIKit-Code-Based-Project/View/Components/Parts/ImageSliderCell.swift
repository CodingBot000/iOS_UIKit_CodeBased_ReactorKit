//
//  ImageSliderCell.swift
//  UIKit-Code-Based-Project
//
//  Created by switchMac on 10/7/24.
//
import UIKit
import SnapKit

class ImageSliderCell: UICollectionViewCell {
    static let identifier = "ImageSliderCell"
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        label.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    override init(frame: CGRect) {
       super.init(frame: frame)
       setupCell()
   }

   required init?(coder: NSCoder) {
       super.init(coder: coder)
       setupCell()
   }

    private func setupCell() {
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        
        setupConstraints()
        
        imageView.clipsToBounds = true
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Dimens.bannerViewDescPadding)
            make.bottom.equalTo(descriptionLabel.snp.top).offset(Dimens.bannerViewDescPadding * -1)
            make.right.lessThanOrEqualToSuperview().offset(Dimens.bannerViewDescPadding * -1)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Dimens.bannerViewDescPadding)
            make.bottom.equalToSuperview().offset(Dimens.bannerViewDescPadding * -1)
            make.width.equalTo(imageView.snp.width).multipliedBy(0.5)

        }
        
        nameLabel.setContentHuggingPriority(.required, for: .horizontal)
        nameLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        descriptionLabel.setContentHuggingPriority(.required, for: .horizontal)
        descriptionLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    func configure(
        with data: ImageSliderData,
        imageSliderType: ImageSliderType
    ) {
        if (imageSliderType == ImageSliderType.centerBanner) {
            imageView.layer.cornerRadius = 7.0
        }
        imageView.image = UIImage(named: data.imageName)
        nameLabel.text = data.name
        descriptionLabel.text = data.description
        
        
        switch imageSliderType {
            case .narrowBanner:
                nameLabel.isHidden = true
                descriptionLabel.isHidden = true
            case .centerBanner:
                descriptionLabel.isHidden = true
            case .fullBanner:
                nameLabel.isHidden = false
                descriptionLabel.isHidden = false
        }
    }
}
