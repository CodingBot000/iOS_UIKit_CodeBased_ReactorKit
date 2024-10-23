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
    case banner
    case chipsSection
    case gridSection(title: String, buttonName: String?, isButtonVisible: Bool, repositoryDataType: RepositoryDataType, gridType: GridType)
}

