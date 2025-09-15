//: [Previous](@previous)

import Cocoa

//Step1
let FirstName: String = "Akerke"
let LastName: String = "Amirtay"
let Age: Int = 20
let BirthYear: Int = 2005
let IsStudent: Bool = true
let Height: Double = 1.65
let GPA: Double = 3.24

//Bonus task1
let CurrentYear = 2025
let CurrentAge = CurrentYear - BirthYear

//Step2
let Hobby: String = "watching serials"
let NumberOfHobbies: Int = 2
let FavoriteNumber: Int = 09
let IsHobbyCreative: Bool = false
let SecondHobby: String = "volleyball"
let Emoji: String = "🏐"
let FavoriteSerials: String = "Desperate Housewives; 911"

let FavouriteTeacher: String = "Arman Myrzakanurov"

//Step3
var MyLifeStory: String = """
    My name is \(FirstName) \(LastName). I am \(Age) years old, born in \(BirthYear). My height is \(Height)m. I am currently a student: \(IsStudent). My gpa is \(GPA).\nI enjoy \(Hobby), which is creative hobby: \(IsHobbyCreative). I have favorite serials like \(FavoriteSerials). I also like playing \(SecondHobby)\(Emoji). I have \(NumberOfHobbies) in total, and my favorite number is \(FavoriteNumber).
    """
//Step4
print(MyLifeStory)

//Bonus task2
let FutureGoals: String = "In the future, I want to become a professional iOS developer and travel the world 🌍🛩️"

MyLifeStory += "\n\(FutureGoals)"
print(MyLifeStory)

//: [Next](@next)
