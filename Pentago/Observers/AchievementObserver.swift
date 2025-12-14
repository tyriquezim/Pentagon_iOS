//
//  AchievementObserver.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 13/12/2025.
//

protocol AchievementObserver
{
    func updateAchievements(playerProfile: PlayerProfile) -> Achievement?
    
    func addAchievement(key: Int, achievement: Achievement)
    
    func removeAchievement(key: Int)
    
    func getAchievement(key: Int) -> Achievement?
    
    func getAchievementArray() -> Array<Achievement>
}
