//
//  PointListRepository.swift
//  UIKit-Code-Based-Project
//
//  Created by switchMac on 10/8/24.
//


import RxSwift


protocol PointListRepository {
    func fetchDatas() -> Observable<[ChipData]>
}

class PointListRepositoryImpl: PointListRepository {

    func fetchDatas() -> Observable<[ChipData]> {

        let chipDatas = DataStores.getChipDatas()
        return Observable.just(chipDatas)
    }
}
