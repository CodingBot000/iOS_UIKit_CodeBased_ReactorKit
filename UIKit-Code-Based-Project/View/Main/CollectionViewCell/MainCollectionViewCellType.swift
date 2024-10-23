//
//  MainCollectionViewCell.swift
//  UIKit-Code-Based-Project
//
//  Created by switchMac on 10/14/24.
//

import UIKit
import RxSwift
import RxCocoa


enum MainCollectionViewCellType {
    case fullBanner
    case centerBanner
    case narrowBanner
    case chipsSection
    case gridSection(title: String, buttonName: String?, isButtonVisible: Bool, repositoryDataType: RepositoryDataType, gridType: GridType)
}

