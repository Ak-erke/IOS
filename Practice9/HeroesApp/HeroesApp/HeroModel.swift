//
//  Untitled.swift
//  HeroesApp
//
//  Created by Akerke Amirtay on 28.11.2025.
//

import Foundation

struct Hero: Codable {
    let id: Int
    let name: String
    let powerstats: Powerstats
    let images: HeroImages
}

struct Powerstats: Codable {
    let intelligence: Int?
    let strength: Int?
    let speed: Int?
    let power: Int?
    let combat: Int?
}

struct HeroImages: Codable {
    let sm: String?
    let md: String?
    let lg: String?
}


