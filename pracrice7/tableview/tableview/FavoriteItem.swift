//
//  FavoriteItem.swift
//  tableview
//
//  Created by Ақерке Амиртай on 15.11.2025.
//
import UIKit

struct FavoriteItem {
    let image: UIImage?
    let title: String
    let subtitle: String
    let review: String
}

enum SectionType: Int, CaseIterable {
    case movies, music, books, courses
    
    var title: String {
        switch self {
        case .movies: return "Favorite Movies"
        case .music: return "Favorite Music"
        case .books: return "Favorite Books"
        case .courses: return "Favorite University Courses"
        }
    }
    
    var emoji: String {
        switch self {
        case .movies: return "🎬"
        case .music: return "🎧"
        case .books: return "📚"
        case .courses: return "🎓"
        }
    }
}

