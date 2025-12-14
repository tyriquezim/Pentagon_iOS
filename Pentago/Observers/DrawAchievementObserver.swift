//
//  DrawAchievementObserver.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 14/12/2025.
//

class DrawAchievementObserver: AchievementObserver
{
    var drawAchievementsDict: Dictionary<String, Achievement>
    
    init()
    {
        self.drawAchievementsDict = Dictionary<String, Achievement>()
    }
    
    func updateAchievements(playerProfile: PlayerProfile) -> Achievement?
    {
        let stringDrawKey = String(playerProfile.getNumDraws())
        let desiredAchievement =  self.drawAchievementsDict[stringDrawKey]
        
        if(desiredAchievement != nil)
        {
            desiredAchievement?.earnAchivement()
        }
        
        return desiredAchievement
    }
    
    func addAchievement(key: Int, achievement: Achievement)
    {
        let stringKey = String(key)
        self.drawAchievementsDict[stringKey] = achievement
    }
    
    func removeAchievement(key: Int)
    {
        let stringKey = String(key)
        self.drawAchievementsDict.removeValue(forKey: stringKey)
    }
    
    func getAchievement(key: Int) -> Achievement?
    {
        let stringKey = String(key)
        let desiredAchievement = drawAchievementsDict[stringKey]
        
        return desiredAchievement
    }
    
    func getAchievementArray() -> Array<Achievement>
    {
        return Array<Achievement>(drawAchievementsDict.values)
    }
}
