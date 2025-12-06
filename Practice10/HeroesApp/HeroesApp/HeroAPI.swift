//
//  HeroAPI.swift
//  HeroesApp
//
//  Created by Ақерке Амиртай on 04.12.2025.
//

import Foundation
import Alamofire

struct HeroAPI {
    
    func getHero(id: Int) async throws -> HeroModel {
        let endpoint = "https://akabab.github.io/superhero-api/api/id/\(id).json"
        
        let request = AF.request(endpoint)
            .validate(statusCode: 200..<300)
            .serializingDecodable(HeroModel.self)
        
        do {
            return try await request.value
        } catch {
            print("API error:", error)
            throw error
        }
    }
}
