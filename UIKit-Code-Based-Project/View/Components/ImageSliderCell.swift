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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        translatesAutoresizingMaskIntoConstraints = false
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with data: ProductData) {
        imageView.image = UIImage(named: data.imageName)
    }
}
