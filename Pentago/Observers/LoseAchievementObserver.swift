//
//  LoseAchievementObserver.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 14/12/2025.
//

class LoseAchievementObserver: AchievementObserver
{
    var loseAchievementsDict: Dictionary<String, Achievement>
    
    init()
    {
        self.loseAchievementsDict = Dictionary<String, Achievement>()
    }
    
    func updateAchievements(playerProfile: PlayerProfile) -> Achievement?
    {
        let stringLossKey = String(playerProfile.getNumLosses())
        let desiredAchievement = loseAchievementsDict[stringLossKey]
        
        if(desiredAchievement != nil)
        {
            desiredAchievement?.earnAchivement()
        }
        
        return desiredAchievement
    }
    
    func addAchievement(key: Int, achievement: Achievement)
    {
        let stringKey = String(key)
        self.loseAchievementsDict[stringKey] = achievement
    }
    
    func removeAchievement(key: Int)
    {
        let stringKey = String(key)
        self.loseAchievementsDict.removeValue(forKey: stringKey)
    }
    
    func getAchievement(key: Int) -> Achievement?
    {
        let stringKey = String(key)
        let desiredAchievement = self.loseAchievementsDict[stringKey]
        
        return desiredAchievement
    }
    
    func getAchievementArray() -> Array<Achievement>
    {
        return Array<Achievement>(loseAchievementsDict.values)
    }
}
