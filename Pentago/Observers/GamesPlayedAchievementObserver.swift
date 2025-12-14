//
//  GamesPlayedAchievementObserver.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 14/12/2025.
//

class GamesPlayedAchievementObserver: AchievementObserver
{
    var gamesPlayedAchievementDict: Dictionary<String, Achievement>
    
    init()
    {
        self.gamesPlayedAchievementDict = Dictionary<String, Achievement>()
    }
    
    func updateAchievements(playerProfile: PlayerProfile) -> Achievement?
    {
        let stringGamesPlayedKey = String(playerProfile.getNumGamesPlayed())
        let desiredAchievement = gamesPlayedAchievementDict[stringGamesPlayedKey]
        
        if(desiredAchievement != nil)
        {
            desiredAchievement?.earnAchivement()
        }
        
        return desiredAchievement
    }
    
    func addAchievement(key: Int, achievement: Achievement)
    {
        let stringKey = String(key)
        self.gamesPlayedAchievementDict[stringKey] = achievement
    }
    
    func removeAchievement(key: Int)
    {
        let stringKey = String(key)
        self.gamesPlayedAchievementDict.removeValue(forKey: stringKey)
    }
    
    func getAchievement(key: Int) -> Achievement?
    {
        let stringKey = String(key)
        let desiredAchievement = self.gamesPlayedAchievementDict[stringKey]
        
        return desiredAchievement
    }
    
    func getAchievementArray() -> Array<Achievement>
    {
        return Array<Achievement>(gamesPlayedAchievementDict.values)
    }
}
