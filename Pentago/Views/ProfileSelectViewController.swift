//
//  ProfileSelectViewController.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 1/1/2026.
//
import UIKit

class ProfileSelectViewController: UIViewController
{
    @IBOutlet var profileSelectCollectionView: UICollectionView!
    
    var profileManager: PlayerProfileManager!
    var nextScreen: MainMenuViewController.ProfileSelectScreenDestination!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Setting the ViewController as the DataSource and delegate of the collectionview
        profileSelectCollectionView.dataSource = self
        profileSelectCollectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.profileSelectCollectionView.reloadData() //Updates any changes from the edit screen
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
    }
}

extension ProfileSelectViewController: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt index: IndexPath) -> Bool
    {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt index: IndexPath)
    {
        if(nextScreen == .editProfileScreen && index.item == self.profileManager.getPlayerProfileArray().count)
        {
            let newProfile = PlayerProfile(userName: "NewPlayer", profilePicture: PlayerProfile.ProfilePicture.defaultIcon, marbleColour: Marble.MarbleColour.random())
            do
            {
                try self.profileManager.addPlayerProfile(newProfile: newProfile)
                
                let editProfileVC = storyboard!.instantiateViewController(withIdentifier: "StoryBoardEditProfileViewController") as! EditProfileViewController
                editProfileVC.sourceProfile = newProfile
                
                self.navigationController!.pushViewController(editProfileVC, animated: true)
            }
            catch let GeneralException.IllegalArgument(message)
            {
                fatalError(message)
            }
            catch
            {
                fatalError("Unaccounted for exception was thrown")
            }
            
        }
        else
        {
            if(nextScreen == .editProfileScreen && index.item != self.profileManager.getPlayerProfileArray().count)
            {
                let designatedProfile = self.profileManager.getPlayerProfile(index: index.item)
                let editProfileVC = storyboard!.instantiateViewController(withIdentifier: "StoryBoardEditProfileViewController") as! EditProfileViewController
                editProfileVC.sourceProfile = designatedProfile
            
                self.navigationController!.pushViewController(editProfileVC, animated: true)
            }
            else
            {
                if(nextScreen == .gameplayStatsScreen)
                {
                    let designatedProfile = self.profileManager.getPlayerProfile(index: index.item)
                    let gameplayStatsTVC = storyboard!.instantiateViewController(withIdentifier: "StoryBoardGameplayStatisticsTableViewController") as! GameplayStatisticsTableViewController //Fixes error that was being caused by instantiating my own TVC
                    gameplayStatsTVC.sourceProfile = designatedProfile
                    
                    self.navigationController!.pushViewController(gameplayStatsTVC, animated: true)
                }
                else
                {
                    if(nextScreen == .achievementScreen)
                    {
                        let designatedProfile = self.profileManager.getPlayerProfile(index: index.item)
                        let achievementTVC = storyboard!.instantiateViewController(withIdentifier: "StoryBoardAchievementTableViewController") as! AchievementTableViewController
                        
                        achievementTVC.sourceProfile = designatedProfile
                        
                        self.navigationController!.pushViewController(achievementTVC, animated: true)
                    }
                }
            }
        }
    }
}

extension ProfileSelectViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        var numCells: Int
        
        if(nextScreen != .editProfileScreen)
        {
            numCells = self.profileManager.getPlayerProfileArray().count
        }
        else
        {
            numCells = self.profileManager.getPlayerProfileArray().count + 1 //Extra cell to add player profiles
        }
        return numCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileSelectCollectionViewCell", for: indexPath) as! ProfileSelectCollectionViewCell
        
        if(nextScreen == .editProfileScreen && indexPath.item == self.profileManager.getPlayerProfileArray().count) //If we are selecting a profile for profile settings and we are on the last cell item, make at the add profile button
        {
            cell.profilePictureImageView.image = ImageAssetFactory.getAddProfileUIImage()
            cell.usernameLabel.text = "Add Profile"
        }
        else
        {
            let designatedProfile = self.profileManager.getPlayerProfile(index: indexPath.item)
            cell.profilePictureImageView.image = ImageAssetFactory.getProfilePictureUIImage(profilePicture: designatedProfile.profilePicture)
            cell.usernameLabel.text = designatedProfile.userName
        }
        
        return cell
    }
}
