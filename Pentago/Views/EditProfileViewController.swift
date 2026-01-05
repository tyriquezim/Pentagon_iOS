//
//  EditProfileViewController.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 2/1/2026.
//

import UIKit

class EditProfileViewController: UIViewController
{
    @IBOutlet var profilePictureImageView: UIImageView!
    @IBOutlet var marbleColourImageView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var colourLabel: UILabel!
    @IBOutlet var playerIDLabel: UILabel!
    @IBOutlet var profileEditTableView: UITableView!
    
    var sourceProfile: PlayerProfile!
    
    override func viewDidLoad()
    {
        self.profilePictureImageView.image = ImageAssetFactory.getProfilePictureUIImage(profilePicture: sourceProfile.profilePicture)
        self.usernameLabel.text = self.sourceProfile.userName
        self.playerIDLabel.text = "ID: " + self.sourceProfile.playerID.uuidString
        self.colourLabel.text = self.sourceProfile.marbleColour.rawValue
    }
}
