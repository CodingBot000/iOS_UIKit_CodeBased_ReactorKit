//
//  Car.swift
//  MyApp
//
//  Created by switchMac on 8/20/24.
//



struct ProductData: Codable, Identifiable, Equatable {
    var id: String
    var name: String
    var subName: String
    var manufacturer: String
    var description: String
    var isHybrid: Bool
    var infoUrl: String
    var imageName: String
}
