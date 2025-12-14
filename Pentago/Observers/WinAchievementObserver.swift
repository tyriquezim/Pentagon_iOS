//
//  Win.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 14/12/2025.
//

class WinAchievementObserver: AchievementObserver
{
    var winAchievementsDict: Dictionary<String, Achievement>
    
    init()
    {
        self.winAchievementsDict = Dictionary<String, Achievement>()
    }
    
    func updateAchievements(playerProfile: PlayerProfile) -> Achievement?
    {
        let stringNumWinsKey = String(playerProfile.getNumWins())
        let desiredAchievement = winAchievementsDict[stringNumWinsKey]
        
        if(desiredAchievement != nil)
        {
            desiredAchievement?.earnAchivement()
        }
        
        return desiredAchievement
    }
    
    func addAchievement(key: Int, achievement: Achievement)
    {
        let stringKey = String(key)
        self.winAchievementsDict[stringKey] = achievement
    }
    
    func removeAchievement(key: Int)
    {
        let stringKey = String(key)
        self.winAchievementsDict.removeValue(forKey: stringKey)
    }
    
    func getAchievement(key: Int) -> Achievement?
    {
        let stringKey = String(key)
        let desiredAchievement = self.winAchievementsDict[stringKey]
        
        return desiredAchievement
    }
    
    func getAchievementArray() -> Array<Achievement>
    {
        return Array<Achievement>(winAchievementsDict.values)
    }
}
