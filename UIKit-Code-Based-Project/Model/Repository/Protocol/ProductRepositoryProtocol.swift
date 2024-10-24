//
//  ProductCommonRepository.swift
//  UIKit-Code-Based-Project
//
//  Created by switchMac on 10/8/24.
//

import RxSwift

protocol ProductRepositoryProtocol {
    func fetchDatas() -> Observable<[ProductData]>
}
