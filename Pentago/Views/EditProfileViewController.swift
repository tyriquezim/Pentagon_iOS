//
//  EditProfileViewController.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 2/1/2026.
//

import UIKit
import CoreData

class EditProfileViewController: UIViewController
{
    @IBOutlet var profilePictureImageView: UIImageView!
    @IBOutlet var marbleColourImageView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var colourLabel: UILabel!
    @IBOutlet var playerIDLabel: UILabel!
    @IBOutlet var deleteProfileButton: UIButton!
    @IBOutlet var profileEditTableView: UITableView!
    var activeTextField: UITextField? //Stores the textField instance currently being used by the user
    
    var sourceProfile: PlayerProfile!
    var existingUsernames: Array<String>!
    var defaultUsername: String!
    
    override func viewDidLoad()
    {
        self.profilePictureImageView.image = ImageAssetFactory.getProfilePictureUIImage(profilePicture: sourceProfile.profilePicture)
        self.usernameLabel.text = self.sourceProfile.userName
        self.playerIDLabel.text = "ID: " + self.sourceProfile.playerID.uuidString
        self.colourLabel.text = self.sourceProfile.marbleColour.rawValue
        self.marbleColourImageView.image = ImageAssetFactory.getMarbleColourUIImage(colour: self.sourceProfile.marbleColour)
        
        self.profileEditTableView.dataSource = self
        self.profileEditTableView.delegate = self
        self.profileEditTableView.isScrollEnabled = false
        
        self.activeTextField = nil
        
        let dismissKeyboardTapRecog = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(dismissKeyboardTapRecog)
        
        self.navigationItem.backAction = UIAction
        {_ in
            self.onBackButtonTap()
        }
    }
    
    @IBAction func onDeleteButtonTap(deleteButton: UIButton)
    {
        let alert = UIAlertController(title: "Delete Profile", message: "Are you sure you want to delete this profile? This action cannot be undone.", preferredStyle: .alert)
        let deleteConfirmAction = UIAlertAction(title: "Yes", style: .destructive)
        {_ in
            self.sourceProfile.manager = nil //This manager will remove it automatically
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let request: NSFetchRequest<PlayerEntity> = PlayerEntity.fetchRequest()
            request.predicate = NSPredicate(format: "playerID == %@", self.sourceProfile.playerID as CVarArg)
            
            do
            {
                var player = try context.fetch(request)
                context.delete(player[0])//Confident there is only one item in the list
            }
            catch
            {
                fatalError("Failed to delete PlayerEntity")
            }
            
            self.navigationController!.popViewController(animated: true)
            self.sourceProfile.manager = nil
        }
        let deleteDenyAction = UIAlertAction(title: "No", style: .default)
        
        alert.addAction(deleteConfirmAction)
        alert.addAction(deleteDenyAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func onBackButtonTap()
    {
        if(self.sourceProfile.userName == self.defaultUsername)
        {
            let alert = UIAlertController(title: "Change Username", message: "The username cannot be \"\(String(describing: self.defaultUsername!))\".", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            if(self.existingUsernames.contains(self.sourceProfile.userName))
            {
                let alert = UIAlertController(title: "Change Username", message: "The username, \"\(self.sourceProfile.userName)\" is already in use.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
               self.navigationController!.popViewController(animated: true)
            }
        }
    }
}

extension EditProfileViewController: UITableViewDelegate
{
    
}

extension EditProfileViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell: UITableViewCell? = nil
        
        if(indexPath.row == 0)
        {
            var textFieldCell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell") as! TextFieldTableViewCell
            
            textFieldCell.fieldTitleLabel.text = "Username"
            textFieldCell.textField.delegate = self
            textFieldCell.textField.text = self.sourceProfile.userName
            
            cell = textFieldCell
        }
        else
        {
            if(indexPath.row == 1)
            {
                var menuButtonCell = tableView.dequeueReusableCell(withIdentifier: "MenuButtonTableViewCell") as! MenuButtonTableViewCell
                
                var activePlayer1Option: UIAction
                var inactivePlayer1Option: UIAction
                
                if(self.sourceProfile.isLocalPlayer1)
                {
                    activePlayer1Option = UIAction(title: "Active", image: UIImage(systemName: ""), state: .on)
                    { action in
                        self.sourceProfile.isLocalPlayer1 = true
                        self.profileEditTableView.reloadData()
                    }
                    inactivePlayer1Option = UIAction(title: "Inactive", image: UIImage(systemName: ""), state: .off)
                    { action in
                        self.sourceProfile.isLocalPlayer1 = false
                        self.profileEditTableView.reloadData()
                    }
                }
                else
                {
                    activePlayer1Option = UIAction(title: "Active", image: UIImage(systemName: ""), state: .off)
                    { action in
                        self.sourceProfile.isLocalPlayer1 = true
                        self.profileEditTableView.reloadData()
                    }
                    inactivePlayer1Option = UIAction(title: "Inactive", image: UIImage(systemName: ""), state: .on)
                    { action in
                        self.sourceProfile.isLocalPlayer1 = false
                        self.profileEditTableView.reloadData()
                    }
                }
                
                let menuOptions = UIMenu(title: "Status", children: [activePlayer1Option, inactivePlayer1Option])
                
                menuButtonCell.menuTitleLabel.text = "Player 1"
                menuButtonCell.menuButton.menu = menuOptions
                menuButtonCell.menuButton.showsMenuAsPrimaryAction = true
                
                cell = menuButtonCell
            }
            else
            {
                if(indexPath.row == 2)
                {
                    var menuButtonCell = tableView.dequeueReusableCell(withIdentifier: "MenuButtonTableViewCell") as! MenuButtonTableViewCell
                    
                    var activePlayer2Option: UIAction
                    var inactivePlayer2Option: UIAction
                    
                    if(self.sourceProfile.isLocalPlayer2)
                    {
                        activePlayer2Option = UIAction(title: "Active", state: .on)
                        { action in
                            self.sourceProfile.isLocalPlayer2 = true
                            self.profileEditTableView.reloadData()
                        }
                        inactivePlayer2Option = UIAction(title: "Inactive", state: .off)
                        { action in
                            self.sourceProfile.isLocalPlayer2 = false
                            self.profileEditTableView.reloadData()
                        }
                    }
                    else
                    {
                        activePlayer2Option = UIAction(title: "Active", image: UIImage(systemName: ""), state: .off)
                        { action in
                            self.sourceProfile.isLocalPlayer2 = true
                            self.profileEditTableView.reloadData()
                        }
                        inactivePlayer2Option = UIAction(title: "Inactive", state: .on)
                        { action in
                            self.sourceProfile.isLocalPlayer2 = false
                            self.profileEditTableView.reloadData()
                        }
                    }
                    
                    let menuOptions = UIMenu(title: "Status", children: [activePlayer2Option, inactivePlayer2Option])
                    
                    menuButtonCell.menuTitleLabel.text = "Player 2"
                    menuButtonCell.menuButton.menu = menuOptions
                    menuButtonCell.menuButton.showsMenuAsPrimaryAction = true
                    
                    cell = menuButtonCell
                }
                else
                {
                    if(indexPath.row == 3)
                    {
                        var menuButtonCell = tableView.dequeueReusableCell(withIdentifier: "MenuButtonTableViewCell") as! MenuButtonTableViewCell
                        
                        var beachOption = UIAction(title: PlayerProfile.ProfilePicture.beach.rawValue, state: .off)
                        {_ in
                            self.sourceProfile.profilePicture = .beach
                            self.profilePictureImageView.image = ImageAssetFactory.getProfilePictureUIImage(profilePicture: self.sourceProfile.profilePicture)
                        }
                        var defaultOption = UIAction(title: PlayerProfile.ProfilePicture.defaultIcon.rawValue, state: .off)
                        {_ in
                            self.sourceProfile.profilePicture = .defaultIcon
                            self.profilePictureImageView.image = ImageAssetFactory.getProfilePictureUIImage(profilePicture: self.sourceProfile.profilePicture)
                        }
                        var desertOption = UIAction(title: PlayerProfile.ProfilePicture.desert.rawValue, state: .off)
                        {_ in
                            self.sourceProfile.profilePicture = .desert
                            self.profilePictureImageView.image = ImageAssetFactory.getProfilePictureUIImage(profilePicture: self.sourceProfile.profilePicture)
                        }
                        var giraffeOption = UIAction(title: PlayerProfile.ProfilePicture.giraffe.rawValue, state: .off)
                        {_ in
                            self.sourceProfile.profilePicture = .giraffe
                            self.profilePictureImageView.image = ImageAssetFactory.getProfilePictureUIImage(profilePicture: self.sourceProfile.profilePicture)
                        }
                        var lionOption  = UIAction(title: PlayerProfile.ProfilePicture.lion.rawValue, state: .off)
                        {_ in
                            self.sourceProfile.profilePicture = .lion
                            self.profilePictureImageView.image = ImageAssetFactory.getProfilePictureUIImage(profilePicture: self.sourceProfile.profilePicture)
                        }
                        var mountainOption = UIAction(title: PlayerProfile.ProfilePicture.mountain.rawValue, state: .off)
                        {_ in
                            self.sourceProfile.profilePicture = .mountain
                            self.profilePictureImageView.image = ImageAssetFactory.getProfilePictureUIImage(profilePicture: self.sourceProfile.profilePicture)
                        }
                        var ostrichOption = UIAction(title: PlayerProfile.ProfilePicture.ostrich.rawValue, state: .off)
                        {_ in
                            self.sourceProfile.profilePicture = .ostrich
                            self.profilePictureImageView.image = ImageAssetFactory.getProfilePictureUIImage(profilePicture: self.sourceProfile.profilePicture)
                        }
                        var puppyOption = UIAction(title: PlayerProfile.ProfilePicture.puppy.rawValue, state: .off)
                        {_ in
                            self.sourceProfile.profilePicture = .puppy
                            self.profilePictureImageView.image = ImageAssetFactory.getProfilePictureUIImage(profilePicture: self.sourceProfile.profilePicture)
                        }
                        var tigerOption = UIAction(title: PlayerProfile.ProfilePicture.tiger.rawValue, state: .off)
                        {_ in
                            self.sourceProfile.profilePicture = .tiger
                            self.profilePictureImageView.image = ImageAssetFactory.getProfilePictureUIImage(profilePicture: self.sourceProfile.profilePicture)
                        }
                        var treeOption = UIAction(title: PlayerProfile.ProfilePicture.tree.rawValue, state: .off)
                        {_ in
                            self.sourceProfile.profilePicture = .tree
                            self.profilePictureImageView.image = ImageAssetFactory.getProfilePictureUIImage(profilePicture: self.sourceProfile.profilePicture)
                        }
                        var zebraOption = UIAction(title: PlayerProfile.ProfilePicture.zebra.rawValue, state: .off)
                        {_ in
                            self.sourceProfile.profilePicture = .zebra
                            self.profilePictureImageView.image = ImageAssetFactory.getProfilePictureUIImage(profilePicture: self.sourceProfile.profilePicture)
                        }
                            
                        //CPU robot is exclusively for the AI so its not included here
                        switch self.sourceProfile.profilePicture
                        {
                            case .beach:
                                beachOption.state = .on
                            case .defaultIcon:
                                defaultOption.state = .on
                            case .desert:
                                desertOption.state = .on
                            case .giraffe:
                                giraffeOption.state = .on
                            case .lion:
                                lionOption.state = .on
                            case .mountain:
                                mountainOption.state = .on
                            case .ostrich:
                                ostrichOption.state = .on
                            case .puppy:
                                puppyOption.state = .on
                            case .tiger:
                                tigerOption.state = .on
                            case .tree:
                                treeOption.state = .on
                            case .zebra:
                                zebraOption.state = .on
                            default:
                                fatalError("Unnaccounted for profile picture was found in the source profile")
                        }
                            
                        let menuOptions = UIMenu(title: "Picture", children: [beachOption, defaultOption, defaultOption, desertOption, giraffeOption, lionOption, mountainOption, ostrichOption, puppyOption, tigerOption, treeOption, zebraOption])
                        
                        menuButtonCell.menuTitleLabel.text = "Profile Picture"
                        menuButtonCell.menuButton.menu = menuOptions
                        menuButtonCell.menuButton.showsMenuAsPrimaryAction = true
                        
                        cell = menuButtonCell
                    }
                    else
                    {
                        if(indexPath.row == 4)
                        {
                            var menuButtonCell = tableView.dequeueReusableCell(withIdentifier: "MenuButtonTableViewCell") as! MenuButtonTableViewCell
                            
                            var blackOption = UIAction(title: Marble.MarbleColour.black.rawValue, state: .off)
                            {_ in
                                self.sourceProfile.marbleColour = .black
                                self.marbleColourImageView.image = ImageAssetFactory.getMarbleColourUIImage(colour: self.sourceProfile.marbleColour)
                                self.colourLabel.text = self.sourceProfile.marbleColour.rawValue
                            }
                            var blueOption  = UIAction(title: Marble.MarbleColour.blue.rawValue, state: .off)
                            {_ in
                                self.sourceProfile.marbleColour = .blue
                                self.marbleColourImageView.image = ImageAssetFactory.getMarbleColourUIImage(colour: self.sourceProfile.marbleColour)
                                self.colourLabel.text = self.sourceProfile.marbleColour.rawValue
                            }
                            var greenOption = UIAction(title: Marble.MarbleColour.green.rawValue, state: .off)
                            {_ in
                                self.sourceProfile.marbleColour = .green
                                self.marbleColourImageView.image = ImageAssetFactory.getMarbleColourUIImage(colour: self.sourceProfile.marbleColour)
                                self.colourLabel.text = self.sourceProfile.marbleColour.rawValue
                            }
                            var orangeOption = UIAction(title: Marble.MarbleColour.orange.rawValue, state: .off)
                            {_ in
                                self.sourceProfile.marbleColour = .orange
                                self.marbleColourImageView.image = ImageAssetFactory.getMarbleColourUIImage(colour: self.sourceProfile.marbleColour)
                                self.colourLabel.text = self.sourceProfile.marbleColour.rawValue
                            }
                            var pinkOption = UIAction(title: Marble.MarbleColour.pink.rawValue, state: .off)
                            {_ in
                                self.sourceProfile.marbleColour = .pink
                                self.marbleColourImageView.image = ImageAssetFactory.getMarbleColourUIImage(colour: self.sourceProfile.marbleColour)
                                self.colourLabel.text = self.sourceProfile.marbleColour.rawValue
                            }
                            var purpleOption = UIAction(title: Marble.MarbleColour.purple.rawValue, state: .off)
                            {_ in
                                self.sourceProfile.marbleColour = .purple
                                self.marbleColourImageView.image = ImageAssetFactory.getMarbleColourUIImage(colour: self.sourceProfile.marbleColour)
                                self.colourLabel.text = self.sourceProfile.marbleColour.rawValue
                            }
                            var redOption = UIAction(title: Marble.MarbleColour.red.rawValue, state: .off)
                            {_ in
                                self.sourceProfile.marbleColour = .red
                                self.marbleColourImageView.image = ImageAssetFactory.getMarbleColourUIImage(colour: self.sourceProfile.marbleColour)
                                self.colourLabel.text = self.sourceProfile.marbleColour.rawValue
                            }
                            var yellowOption = UIAction(title: Marble.MarbleColour.yellow.rawValue, state: .off)
                            {_ in
                                self.sourceProfile.marbleColour = .yellow
                                self.marbleColourImageView.image = ImageAssetFactory.getMarbleColourUIImage(colour: self.sourceProfile.marbleColour)
                                self.colourLabel.text = self.sourceProfile.marbleColour.rawValue
                            }
    
                            //Grey isnt an option because its reserved for the ai
                            switch self.sourceProfile.marbleColour
                            {
                                case .black:
                                    blackOption.state = .on
                                case .blue:
                                    blueOption.state = .on
                                case .green:
                                    greenOption.state = .on
                                case .orange:
                                    orangeOption.state = .on
                                case .pink:
                                    pinkOption.state = .on
                                case .purple:
                                    purpleOption.state = .on
                                case .red:
                                    redOption.state = .on
                                case .yellow:
                                    yellowOption.state = .on
                                default:
                                    fatalError("Unnaccounted for colour was found")
                            }
                            let menuOptions = UIMenu(title: "Colour", children: [blackOption, blueOption, greenOption, orangeOption, pinkOption, purpleOption, redOption, yellowOption])
                            menuButtonCell.menuTitleLabel.text = "Marble Colour"
                            menuButtonCell.menuButton.menu = menuOptions
                            menuButtonCell.menuButton.showsMenuAsPrimaryAction = true
                            
                            cell = menuButtonCell
                        }
                    }
                }
            }
        }
            
        return cell!
    }
}
    
extension EditProfileViewController: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        self.activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        self.sourceProfile.userName = textField.text ?? ""
        self.usernameLabel.text = textField.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder() //Removes the keyboard
        
        return true
    }
    
    @objc func dismissKeyboard()
    {
        if let checkedTextField = activeTextField
        {
            checkedTextField.resignFirstResponder()
        }
    }
}
