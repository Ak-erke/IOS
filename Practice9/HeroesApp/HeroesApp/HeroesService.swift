//
//  HeroesService.swift
//  HeroesApp
//
//  Created by Akerke Amirtay on 28.11.2025.
//

import Foundation

final class HeroService {
    static let shared = HeroService()
    private init() {}

    private let url = URL(string: "https://akabab.github.io/superhero-api/api/all.json")!

    private(set) var heroes: [Hero] = []

    func loadAll(completion: @escaping (Result<[Hero], Error>) -> Void) {
        if !heroes.isEmpty {
            completion(.success(heroes))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "no data", code: -1)))
                return
            }

            do {
                let heroes = try JSONDecoder().decode([Hero].self, from: data)
                self.heroes = heroes
                completion(.success(heroes))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func randomHero() -> Hero? {
        heroes.randomElement()
    }
}



