//
//  CenterBannersRepository.swift
//  UIKit-Code-Based-Project
//
//  Created by switchMac on 10/24/24.
//

import RxSwift

protocol CenterBannersRepository: ImageSldiderRepositoryProtocol {
    func fetchDatas() -> Observable<[ImageSliderData]>
}


class CenterBannersRepositoryImpl: CenterBannersRepository {

    func fetchDatas() -> Observable<[ImageSliderData]> {
        let dataList = DataStores.getCenterBannerDatas()
        
        return Observable.just(dataList)
    
    }
}
