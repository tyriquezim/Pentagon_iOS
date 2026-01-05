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
    {
        get
        {
            return self._userName
        }
        set(newValue) //Will not set the value if the PlayerProfileManager already has a PlayerProfile with that userName
        {
            if let checkedManager = manager
            {
                var isUserNameUnique = true
            
                for profile in checkedManager.getPlayerProfileArray()
                {
                    if(profile.userName == newValue)
                    {
                        isUserNameUnique = false
                    }
                }
                
                if(isUserNameUnique) //If it isnt unique, the username does not change
                {
                    self._userName = newValue
                }
            }
            else
            {
                self._userName = newValue // set as normal if there is no manager
            }
        }
    }
    var profilePicture: ProfilePicture
    var marbleColour: Marble.MarbleColour
    var isLocalPlayer1: Bool
    {
        get
        {
            return self._isLocalPlayer1
        }
        
        set(newValue)
        {
            if let checkedManager = self.manager, newValue //If the the PlayerProfile has a manager AND is being having this property set to true
            {
                for profile in checkedManager.getPlayerProfileArray()
                {
                    if(profile !== self)
                    {
                        profile._isLocalPlayer1 = false //set all other profiles to false
                    }
                }
                self._isLocalPlayer1 = true
            }
            else
            {
                self._isLocalPlayer1 = newValue
            }
        }
    }
    var isLocalPlayer2: Bool
    {
        get
        {
            return self._isLocalPlayer2
        }
        
        set(newValue)
        {
            if let checkedManager = self.manager, newValue
            {
                for profile in checkedManager.getPlayerProfileArray()
                {
                    if(profile !== self)
                    {
                        profile._isLocalPlayer2 = false
                    }
                }
                self._isLocalPlayer2 = true
            }
            else
            {
                self._isLocalPlayer2 = newValue
            }
        }
    }
    private var playerStats: PlayerStatistics
    var numWins: Int {return playerStats.numWins}
    var numLosses: Int {return playerStats.numLosses}
    var numDraws: Int{return playerStats.numDraws}
    var numGamesPlayed: Int {return playerStats.numGamesPlayed}
    var totalMovesMade: Int {return playerStats.totalMovesMade}
    var numAchievementsEarned: Int {return playerStats.numAchievementsEarned}
    var numAchievements: Int {return playerStats.numAchievements}
    var achievements: Array<Achievement> {return playerStats.achievements}
    var winPercentage: Double {return playerStats.winPercentage}
    weak var manager: PlayerProfileManager?
    
    //Backing stores
    private var _userName: String
    private var _isLocalPlayer1: Bool
    private var _isLocalPlayer2: Bool
    
    init(userName: String, profilePicture: ProfilePicture, marbleColour: Marble.MarbleColour)
    {
        self.playerID = UUID()
        self._userName = userName
        self.profilePicture = profilePicture
        self.marbleColour = marbleColour
        self._isLocalPlayer1 = false
        self._isLocalPlayer2 = false
        self.playerStats = PlayerStatistics()
        self.playerStats.owner = self
        self.manager = nil
    }
    
    init(userName: String, profilePicture: ProfilePicture, marbleColour: Marble.MarbleColour, manager: PlayerProfileManager)
    {
        self.playerID = UUID()
        self._userName = userName
        self.profilePicture = profilePicture
        self.marbleColour = marbleColour
        self._isLocalPlayer1 = false
        self._isLocalPlayer2 = false
        self.playerStats = PlayerStatistics()
        self.playerStats.owner = self
        self.manager = manager
    }
    
    //Player Statistics Wrappers
    func updateWins() -> Array<Achievement>
    {
        return self.playerStats.updateWins()
    }
    func updateLosses() -> Array<Achievement>
    {
        return self.playerStats.updateLosses()
    }
    func updateDraws() -> Array<Achievement>
    {
        return self.playerStats.updateDraws()
    }
    func updateTotalMovesMade() -> Array<Achievement>
    {
        return self.playerStats.updateTotalMovesMade()
    }
    func addAchievementObservers(achievementObservers: Array<AchievementObserver>)
    {
        self.playerStats.addAchievementObservers(achievementObservers: achievementObservers)
    }
    
    func addAchievementObserver(achievementObserver: AchievementObserver)
    {
        self.playerStats.addAchievementObserver(achievementObserver: achievementObserver)
    }
    
    func removeAchievementObserver(index: Int)
    {
        self.playerStats.removeAchievementObserver(index: index)
    }
    
    private struct PlayerStatistics
    {
        weak var owner: PlayerProfile? //Weak so that it can get garbage collected if other references to it disappear
        var numGamesPlayed: Int
        var numWins: Int
        var numLosses: Int
        var numDraws: Int
        var totalMovesMade: Int
        var numAchievements: Int {return self.achievements.count}
        var numAchievementsEarned: Int
        {
            let achievements = self.achievements
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
        var achievements: Array<Achievement>
        {
            var achievementsArray = Array<Achievement>()
            
            for observer in self.achievementObserverArray
            {
                achievementsArray.append(contentsOf: observer.getAchievementArray().sorted()) //Should have achievements sorted alphabetically on their respective types
            }
            
            return achievementsArray
        }
        var winPercentage: Double
        {
            var perc: Double
            
            if(self.numGamesPlayed == 0)
            {
                perc = 0
            }
            else
            {
                perc = Double(self.numWins) / Double(self.numGamesPlayed)
            }
            
            return perc
        }
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
        
        mutating func addAchievementObservers(achievementObservers: Array<AchievementObserver>)
        {
            self.achievementObserverArray.append(contentsOf: achievementObservers)
        }
        
        mutating func addAchievementObserver(achievementObserver: AchievementObserver)
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
