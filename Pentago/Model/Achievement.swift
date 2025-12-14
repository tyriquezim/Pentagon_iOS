//
//  Achievement.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 12/12/2025.
//

import Foundation

class Achievement: Comparable
{
    var achievementTitle: String
    var achievementDescription: String
    private(set) var hasBeenEarned: Bool //Private to prevent it from being changed to false once it has been changed to true
    private(set) var dateEarned: Date? //Private setter so that it can't be altered
    var hasBeenDisplayed: Bool
    
    init(achievementTitle: String, achievementDescription: String)
    {
        self.achievementTitle = achievementTitle
        self.achievementDescription = achievementDescription
        self.hasBeenEarned = false
        self.dateEarned = nil
        self.hasBeenDisplayed = false
    }
    
    func earnAchivement()
    {
        dateEarned = Date()
        hasBeenEarned = true
    }
    
    //To conform to comparable
    static func < (lhs: Achievement, rhs: Achievement) -> Bool
    {
        return lhs.achievementTitle < rhs.achievementTitle
    }
    
    static func == (lhs: Achievement, rhs: Achievement) -> Bool
    {
        return lhs.achievementTitle == rhs.achievementTitle
    }
}
