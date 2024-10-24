//
//  DataStores.swift
//  Shopping
//
//  Created by switchMac on 8/23/24.
//

import Foundation

final class DataStores {
    private static var productDatas: [ProductData] = []  
    
    static func getProductDatas() -> [ProductData] {
        return buidProductDatas()
    }
    
    private static func buidProductDatas() -> [ProductData] {
        let loadedData: [ProductData] = loadJson("productDataJson.json")
        productDatas = loadedData
        return productDatas
    }
    
    static func getBannerDatas() -> [ProductData] {
        let bannerIDData: BannerData = loadJson("bannerDataJson.json")
        let bannerIDs = bannerIDData.ids
        let bannerDatas = buidProductDatas().filter { bannerIDs.contains($0.id) }
        
        return bannerDatas
    }
    static func getTopBannerDatas() -> [ImageSliderData] {

        let bannerIDData: BannerData = loadJson("bannerDataJson.json")
        let bannerIDs = bannerIDData.ids
        let bannerDataOfProducts = buidProductDatas().filter { bannerIDs.contains($0.id) }
        var imageSliderDatas: [ImageSliderData] = []
        for (index, data) in bannerDataOfProducts.enumerated() {
            let data = bannerDataOfProducts[index]
            imageSliderDatas.append(
                ImageSliderData(id: data.id,
                                name: data.name,
                                description: data.description,
                                imageName: data.imageName))
        }
        
        return imageSliderDatas
    }

    static func getCenterBannerDatas() -> [ImageSliderData] {

        let bannerDatas: [CenterBannerData] = loadJson("centerBannerDataJson.json")
        
        var imageSliderDatas: [ImageSliderData] = []
        for (index, data) in bannerDatas.enumerated() {
            let data = bannerDatas[index]
            imageSliderDatas.append(
                ImageSliderData(id: data.id,
                                name: data.name,
                                description: "",
                                imageName: data.imageName))
        }
        
        return imageSliderDatas
    }
    
    static func getNarrowBannerDatas() -> [ImageSliderData] {
        let bannerDatas: [NarrowBannerData] = loadJson("narrowBannerDataJson.json")
        
        var imageSliderDatas: [ImageSliderData] = []
        for (index, data) in bannerDatas.enumerated() {
            let data = bannerDatas[index]
            imageSliderDatas.append(
                ImageSliderData(id: data.id,
                                name: data.name,
                                description: "",
                                imageName: data.imageName))
        }
        
        return imageSliderDatas
    }

    
    static func getProductDataByID(id: String) -> ProductData? {
        if let productData = buidProductDatas().first(where: { id == $0.id }) {
            return productData
        } else {
            return nil
        }
        
    }
    
    static func getChipDatas() -> [ChipData] {
        return loadJson("chipDataJson.json")
    }
    
    static func getDisplayItemDatas(limit :Int = 0) -> [ProductData] {
        let displayItems = buidProductDatas().shuffled()
        return limit > 0 ? Array(displayItems.prefix(limit)) : displayItems
    }
}



