//
//  ViewController.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 6/12/2025.
//
import UIKit
import CoreData

class MainMenuViewController: UIViewController
{
    @IBOutlet var playButton: UIButton!
    @IBOutlet var profileSettingsButton: UIButton!
    @IBOutlet var gameplayStatisticsButton: UIButton!
    @IBOutlet var achievementsButton: UIButton!
    
    var profileManager: PlayerProfileManager? //Stores and manages user profiles
    var achievementObserverStore: AchievementObserverStore?
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if(self.profileManager == nil)
        {
            self.profileManager = PlayerProfileManager()
        }
        if(self.achievementObserverStore == nil)
        {
            self.achievementObserverStore = AchievementObserverStore()
        }
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.saveProfiles), name: UIScene.didEnterBackgroundNotification, object: nil) //Save profiles when app enters the background state
        
        if(self.profileManager!.getPlayerProfileArray().isEmpty)
        {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let request: NSFetchRequest<PlayerEntity> = PlayerEntity.fetchRequest()

            do
            {
                var playerEntities = try context.fetch(request)
                
                if(!playerEntities.isEmpty)
                {
                    for playerEntity in playerEntities
                    {
                        let playerProfile = PlayerProfile(playerID: playerEntity.playerID, userName: playerEntity.userName, profilePicture: PlayerProfile.ProfilePicture(rawValue: playerEntity.profilePicture)!, marbleColour: Marble.MarbleColour(rawValue: playerEntity.marbleColour)!, isLocalPlayer1: playerEntity.isLocalPlayer1, isLocalPlayer2: playerEntity.isLocalPlayer2, numWins: Int(playerEntity.numWins), numLosses: Int(playerEntity.numLosses), numDraws: Int(playerEntity.numDraws), totalMovesMade: Int(playerEntity.totalMovesMade))
                        
                        let achievementsRequest: NSFetchRequest<AchievementEntity> = AchievementEntity.fetchRequest()
                        achievementsRequest.predicate = NSPredicate(format: "belongsTo == %@", playerEntity)
                        let achievementEntities = try context.fetch(achievementsRequest)
                        
                        var achievements: Array<Achievement> = Array()
                        
                        for achievementEntity in achievementEntities
                        {
                            let achievement = Achievement(achievementTitle: achievementEntity.achievementTitle, achievementDescription: achievementEntity.achievementDescription, hasBeenEarned: achievementEntity.hasBeenEarned, dateEarned: achievementEntity.dateEarned, hasBeenDisplayed: achievementEntity.hasBeenDisplayed)
                            achievements.append(achievement)
                        }
                            
                        playerProfile.addAchievementObservers(achievementObservers: self.achievementObserverStore!.createInitialisedObserverList(existingAchievements: achievements))
                        try self.profileManager!.addPlayerProfile(newProfile: playerProfile)
                    }
                }
            }
            catch let GeneralException.IllegalArgument(message)
            {
                fatalError(message)
            }
            catch
            {
                fatalError("Failed to extract players")
            }
        }
        if(self.profileManager!.getAIProfileArray().isEmpty)
        {
            let aiProfile = PlayerProfile(userName: "AI", profilePicture: .cpuRobot, marbleColour: .grey)
            
            do
            {
                try self.profileManager!.addAIProfile(newProfile: aiProfile)
                aiProfile.addAchievementObservers(achievementObservers: achievementObserverStore!.createInitialisedObserverList())
            }
            catch let GeneralException.IllegalArgument(message)
            {
                fatalError(message)
            }
            catch
            {
                fatalError("Failed to add AI profile")
            }
        }
    }
    
    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews()
        
        //Fixing bug where the button fonts set in Interface Builder weren't applying to the running program
        let interfaceBuilderFont = UIFont(name: "Futura Bold", size: 19)
        
        playButton.configuration?.attributedTitle?[AttributeScopes.UIKitAttributes.FontAttribute.self] = interfaceBuilderFont
        profileSettingsButton.configuration?.attributedTitle?[AttributeScopes.UIKitAttributes.FontAttribute.self] = interfaceBuilderFont
        gameplayStatisticsButton.configuration?.attributedTitle?[AttributeScopes.UIKitAttributes.FontAttribute.self] = interfaceBuilderFont
        achievementsButton.configuration?.attributedTitle?[AttributeScopes.UIKitAttributes.FontAttribute.self] = interfaceBuilderFont
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier
        {
            case "opponentSelectSegue":
                let opponentSelectViewController = segue.destination as! OpponentSelectViewController
                opponentSelectViewController.profileManager = self.profileManager
                
            case "profileSettingsSelectSegue":
                let profileSelectViewController = segue.destination as! ProfileSelectViewController
                profileSelectViewController.profileManager = self.profileManager
                profileSelectViewController.nextScreen = .editProfileScreen
            
            case "gameStatsSelectSegue":
                let profileSelectViewController = segue.destination as! ProfileSelectViewController
                profileSelectViewController.profileManager = self.profileManager
                profileSelectViewController.nextScreen = .gameplayStatsScreen
            
            
            case "achievementsSelectSegue":
                let profileSelectViewController = segue.destination as! ProfileSelectViewController
                profileSelectViewController.profileManager = self.profileManager
                profileSelectViewController.nextScreen = .achievementScreen
            
            default:
                preconditionFailure("Unexpected segue identifier")
        }
    }
    
    @objc func saveProfiles()
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<PlayerEntity> = PlayerEntity.fetchRequest()
        
        do
        {
            var playerEntities = try context.fetch(request)
            
            for playerEntity in playerEntities
            {
                for playerProfile in self.profileManager!.getPlayerProfileArray()
                {
                    if(playerEntity.playerID == playerProfile.playerID)
                    {
                        playerEntity.savePlayerProfileData(playerProfile: playerProfile)
                    }
                }
            }
        }
        catch
        {
            fatalError("Failed to save PlayerProfiles")
        }
    }
    
    enum ProfileSelectScreenDestination
    {
        case editProfileScreen
        case gameplayStatsScreen
        case achievementScreen
    }
}

