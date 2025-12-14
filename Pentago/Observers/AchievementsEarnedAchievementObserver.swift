//
//  AchievementsEarnedAchievementObserver.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 14/12/2025.
//

class AchievementsEarnedAchievementObserver: AchievementObserver
{
    var achievementsEarnedDict: Dictionary<String, Achievement>
    
    init()
    {
        self.achievementsEarnedDict = Dictionary<String, Achievement>()
    }
    
    func updateAchievements(playerProfile: PlayerProfile) -> Achievement?
    {
        let stringAchievementsEarnedKey = String(playerProfile.getNumAchievementsEarned())
        let desiredAchievement = self.achievementsEarnedDict[stringAchievementsEarnedKey]
        
        if(desiredAchievement != nil)
        {
            desiredAchievement?.earnAchivement()
        }
        
        return desiredAchievement
    }
    
    func addAchievement(key: Int, achievement: Achievement)
    {
        let stringKey = String(key)
        self.achievementsEarnedDict[stringKey] = achievement
    }
    
    func removeAchievement(key: Int)
    {
        let stringKey = String(key)
        self.achievementsEarnedDict.removeValue(forKey: stringKey)
    }
    
    func getAchievement(key: Int) -> Achievement?
    {
        let stringKey = String(key)
        let desiredAchievement = self.achievementsEarnedDict[stringKey]
        
        return desiredAchievement
    }
    
    func getAchievementArray() -> Array<Achievement>
    {
        return Array<Achievement>(achievementsEarnedDict.values)
    }
}
