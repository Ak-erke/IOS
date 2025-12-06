//
//  Untitled.swift
//  HeroesApp
//
//  Created by Akerke Amirtay on 04.12.2025.
//

struct HeroModel: Codable {
    let name: String
    let images: HeroImages
    let powerstats: PowerStats
    let appearance: Appearance
    
    struct HeroImages: Codable {
        let md: String
        let lg: String
    }
    
    struct PowerStats: Codable {
        let intelligence: Int
        let strength: Int
        let speed: Int
        let durability: Int
        let power: Int
        let combat: Int
    }
    
    struct Appearance: Codable {
        let gender: String
        let height: [String]
        let weight: [String]
    }
}

