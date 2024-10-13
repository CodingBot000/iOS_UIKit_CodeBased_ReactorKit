//
//  MemoryStores.swift
//  UIKit-Code-Based-Project
//
//  Created by switchMac on 10/11/24.
//

import RxSwift


final class MemoryStores {
    private static var productHistory: [ProductData] = []
    private static var trackingIdx: Int = 0

    private static let historyChagneSubject = PublishSubject<(Int, ProductData)>()
    static var historyChagneObservable: Observable<(Int, ProductData)> {
        return historyChagneSubject.asObservable()
    }
    

    private static func notifyChangeData(data: ProductData) {
        historyChagneSubject.onNext((trackingIdx, data))
    }
    
    static func getProductHistory() -> [ProductData] {
        return productHistory
    }

    static func addProdcutHistory(prodcutData: ProductData) {
        if let existingIndex = productHistory.firstIndex(of: prodcutData) {
            if existingIndex != productHistory.count - 1 {
                productHistory.remove(at: existingIndex)
                productHistory.append(prodcutData)
            }
            trackingIdx = productHistory.count - 1
        } else {
            productHistory.append(prodcutData)
            trackingIdx = productHistory.count - 1
        }
        notifyChangeData(data: prodcutData)
    }

    static func removeProductHistory(productData: ProductData) {
 
        if let index = productHistory.firstIndex(of: productData) {
            productHistory.remove(at: index)

            if trackingIdx >= productHistory.count {
                trackingIdx = max(0, productHistory.count - 1)
            }
    
            if !productHistory.isEmpty {
                notifyChangeData(data:  productHistory[trackingIdx])

            } else {
         
                let emptyProduct = ProductData(id: "", name: "", subName: "", manufacturer: "", description: "", isHybrid: false, infoUrl: "", imageName: "")
                notifyChangeData(data: emptyProduct)

            }
        }
    }
    
    static func currentProdcutHistory() -> ProductData {
        if (productHistory.isEmpty) {
            return ProductData(id: "", name: "", subName: "", manufacturer: "", description: "", isHybrid: false, infoUrl: "", imageName: "")
        }
        return productHistory[trackingIdx]
    }
    static func prevProdcutHistory() {
      
        trackingIdx -= 1
        if (trackingIdx < 0) {
            trackingIdx = 0
        }
        notifyChangeData(data: productHistory[trackingIdx])
    }

    static func nextProdcutHistory() {
        trackingIdx += 1
        if (trackingIdx > size() - 1) {
            trackingIdx = size() - 1
        }
        notifyChangeData(data: productHistory[trackingIdx])
    }
    
    static func size() -> Int {
        return productHistory.count
    }
    
    static func isCanPlay() -> Bool {
        return size() != 0
    }
    
    static func isCanPrev() -> Bool {
        print("appLog isCanPrev size: \(size())  trackingIdx:\(trackingIdx)")
        if (size() <= 1) {
            return false
        }
        
        if (0 >= trackingIdx) {
            trackingIdx = 0
            return false
        }
        print("appLog isCanPrev size: \(size()) trackingIdx:\(trackingIdx) return true" )
        return true
    }
    
    static func isCanNext() -> Bool {
        print("appLog isCanNext size: \(size())  trackingIdx:\(trackingIdx)")
        if (size() < 2) {
            return false
        }
        if (size() - 1 <= trackingIdx) {
            trackingIdx = size() - 1
            return false
        }
        print("appLog isCanNext size: \(size()) trackingIdx:\(trackingIdx) return true" )
        return true
    }

}


