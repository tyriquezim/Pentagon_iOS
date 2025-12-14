//
//  MovesMadeAchievementObserver.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 14/12/2025.
//

class MovesMadeAchievementObserver: AchievementObserver
{
    var movesMadeAchievementDict: Dictionary<String, Achievement>
    
    init()
    {
        self.movesMadeAchievementDict = Dictionary<String, Achievement>()
    }
    
    func updateAchievements(playerProfile: PlayerProfile) -> Achievement?
    {
        let stringMovesMadeKey = String(playerProfile.getTotalMovesMade())
        let desiredAchievement = movesMadeAchievementDict[stringMovesMadeKey]
        
        if(desiredAchievement != nil)
        {
            desiredAchievement?.earnAchivement()
        }
        
        return desiredAchievement
    }
    
    func addAchievement(key: Int, achievement: Achievement)
    {
        let stringKey = String(key)
        self.movesMadeAchievementDict[stringKey] = achievement
    }
    
    func removeAchievement(key: Int)
    {
        let stringKey = String(key)
        self.movesMadeAchievementDict.removeValue(forKey: stringKey)
    }
    
    func getAchievement(key: Int) -> Achievement?
    {
        let stringKey = String(key)
        let desiredAchievement = self.movesMadeAchievementDict[stringKey]
        
        return desiredAchievement
    }
    
    func getAchievementArray() -> Array<Achievement>
    {
        return Array<Achievement>(movesMadeAchievementDict.values)
    }
}
