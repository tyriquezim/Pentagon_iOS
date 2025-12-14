//
//  PlayerProfile.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 12/12/2025.
//
import Foundation

class PlayerProfile
{
    let playerID: UUID
    var userName: String
    var profilePicture: ProfilePicture
    var marbleColour: Marble.MarbleColour
    private var playerStats: PlayerStatistics
    
    init(userName: String, profilePicture: ProfilePicture, marbleColour: Marble.MarbleColour)
    {
        self.playerID = UUID()
        self.userName = userName
        self.profilePicture = profilePicture
        self.marbleColour = marbleColour
        self.playerStats = PlayerStatistics()
        self.playerStats.owner = self
    }
    
    //Player Statistics Wrappers
    func getNumWins() -> Int
    {
        return playerStats.numWins
    }
    
    func getNumLosses() -> Int
    {
        return playerStats.numLosses
    }
    
    func getNumDraws() -> Int
    {
        return playerStats.numDraws
    }
    
    func getNumGamesPlayed() -> Int
    {
        return playerStats.numGamesPlayed
    }
    
    func getTotalMovesMade() -> Int
    {
        return playerStats.totalMovesMade
    }
    
    func getNumAchievementsEarned() -> Int
    {
        return playerStats.getNumAchievementsEarned()
    }
    
    func getNumAchievements() -> Int
    {
        return playerStats.getNumAchievements()
    }
    
    func getWinPercentage() -> Double
    {
        return playerStats.getWinPercentage()
    }
    
    private struct PlayerStatistics
    {
        weak var owner: PlayerProfile? //Weak so that it can get garbage collected if other references to it disappear
        var numGamesPlayed: Int
        var numWins: Int
        var numLosses: Int
        var numDraws: Int
        var totalMovesMade: Int
        var achievementObserverArray: Array<AchievementObserver>
        
        init()
        {
            self.numGamesPlayed = 0
            self.numWins = 0
            self.numLosses = 0
            self.numDraws = 0
            self.totalMovesMade = 0
            self.achievementObserverArray = Array<AchievementObserver>()
        }
        
        mutating func updateWins() -> Array<Achievement>
        {
            self.numGamesPlayed += 1
            self.numWins += 1
            
            let earnedAchievementArray = notifyAchievementObservers()
            
            return earnedAchievementArray
        }
        
        mutating func updateLosses() -> Array<Achievement>
        {
            self.numGamesPlayed += 1
            self.numLosses += 1
            
            var earnedAchievementArray = notifyAchievementObservers()
            
            return earnedAchievementArray
        }
        
        mutating func updateDraws() -> Array<Achievement>
        {
            self.numGamesPlayed += 1
            self.numDraws += 1
            
            var earnedAchievementArray = notifyAchievementObservers()
            
            return earnedAchievementArray
        }
        
        mutating func updateTotalMovesMade() -> Array<Achievement>
        {
            self.totalMovesMade += 1
            
            var earnedAchievementArray = notifyAchievementObservers()
            
            return earnedAchievementArray
        }
        
        func getWinPercentage() -> Double
        {
            return Double(numWins) / Double(numGamesPlayed)
        }
        
        func getNumAchievementsEarned() -> Int
        {
            let achievements = self.getAllAchievements()
            var count = 0
            
            for achievement in achievements
            {
                if(achievement.hasBeenEarned)
                {
                    count += 1
                }
            }
            
            return count
        }
        
        func getNumAchievements() -> Int
        {
            return self.getAllAchievements().count
        }
        
        mutating func addAchievementObservers(achievementObserver: AchievementObserver)
        {
            self.achievementObserverArray.append(achievementObserver)
        }
        
        mutating func removeAchievementObserver(index: Int)
        {
            self.achievementObserverArray.remove(at: index)
        }
        
        func getAchievementObserver(index: Int) -> AchievementObserver
        {
            return self.achievementObserverArray[index]
        }
        
        func notifyAchievementObservers() -> Array<Achievement>
        {
            
            guard let checkedOwner = owner else //Unwraps the owner
            {
                fatalError("The owner for this PlayerStatistic struct has not been set")
            }
            
            var earnedAchievementArray = Array<Achievement>()
            
            for observer in self.achievementObserverArray
            {
                if let earnedAchievement = observer.updateAchievements(playerProfile: checkedOwner)
                {
                    earnedAchievementArray.append(earnedAchievement)
                }
            }
            
            return earnedAchievementArray
        }
        
        func getAllAchievements() -> Array<Achievement>
        {
            var achievementsArray = Array<Achievement>()
            
            for observer in self.achievementObserverArray
            {
                achievementsArray.append(contentsOf: observer.getAchievementArray().sorted()) //Should have achievements sorted alphabetically on their respective types
            }
            
            return achievementsArray
        }
    }
    
    enum ProfilePicture
    {
        case beach
        case cpuRobot
        case defaultIcon
        case desert
        case giraffe
        case lion
        case mountain
        case ostrich
        case puppy
        case tiger
        case tree
        case zebra
    }
}
