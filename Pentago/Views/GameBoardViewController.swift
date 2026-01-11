//
//  StoryBoardGameBoardViewController.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 2/1/2026.
//

import UIKit

class GameBoardViewController: UIViewController
{
    @IBOutlet var player1ImageView: UIImageView!
    @IBOutlet var player2ImageView: UIImageView!
    @IBOutlet var player1UsernameLabel: UILabel!
    @IBOutlet var player2UsernameLabel: UILabel!
    @IBOutlet var playerTurnLabel: UILabel!
    @IBOutlet var gameStatusLabel: UILabel!
    @IBOutlet var rotationStackView: UIStackView!
    @IBOutlet var clockwiseImageView: UIImageView!
    @IBOutlet var anticlockwiseImageView: UIImageView!
    @IBOutlet var upperLeftSubgrid: UICollectionView!
    @IBOutlet var upperRightSubgrid: UICollectionView!
    @IBOutlet var lowerLeftSubgrid: UICollectionView!
    @IBOutlet var lowerRightSubgrid: UICollectionView!
    
    var gameController: GameBoardController!
    var gamePhase: GamePhase!
    var selectedSubgridCollectionView: UICollectionView? //The grid that is to be rotated
    
    //These are to store the rotations since the property animations only apply them to the subgrids original position
    var upperLeftSubgridRotationMultiplier: CGFloat!
    var upperRightSubgridRotationMultiplier: CGFloat!
    var lowerLeftSubgridRotationMultiplier: CGFloat!
    var lowerRightSubgridRotationMultiplier: CGFloat!
    
    var snackbarFrame: CGRect!
    var snackbarVerticalTranslation: Double!
    var snackbarQueue: Array<SnackbarView>!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.upperLeftSubgrid.dataSource = self
        self.upperRightSubgrid.dataSource = self
        self.lowerLeftSubgrid.dataSource = self
        self.lowerRightSubgrid.dataSource = self
        
        self.upperLeftSubgrid.delegate = self
        self.upperRightSubgrid.delegate = self
        self.lowerLeftSubgrid.delegate = self
        self.lowerRightSubgrid.delegate = self
        
        self.upperLeftSubgridRotationMultiplier = CGFloat.zero
        self.upperRightSubgridRotationMultiplier = CGFloat.zero
        self.lowerLeftSubgridRotationMultiplier = CGFloat.zero
        self.lowerRightSubgridRotationMultiplier = CGFloat.zero
        
        self.upperLeftSubgrid.isScrollEnabled = true
        self.upperRightSubgrid.isScrollEnabled = false
        self.lowerLeftSubgrid.isScrollEnabled = false
        self.lowerRightSubgrid.isScrollEnabled = false
        
        self.selectedSubgridCollectionView = nil
        
        self.gamePhase = .placeMarble
        self.rotationStackView.isHidden = true
        self.gameStatusLabel.text = GameStateInfoStore.placeMarbleInstruction.rawValue
        self.playerTurnLabel.text = self.gameController.gameBoard.currentTurnPlayerProfile.userName + GameStateInfoStore.playerTurnTrailing.rawValue
        
        self.player1ImageView.image = ImageAssetFactory.getProfilePictureUIImage(profilePicture: self.gameController.gameBoard.player1Profile.profilePicture)
        self.player2ImageView.image = ImageAssetFactory.getProfilePictureUIImage(profilePicture: self.gameController.gameBoard.player2Profile.profilePicture)
        self.player1UsernameLabel.text = self.gameController.gameBoard.player1Profile.userName
        self.player2UsernameLabel.text = self.gameController.gameBoard.player2Profile.userName
        
        anticlockwiseImageView.transform = CGAffineTransform(scaleX: -1, y: 1) //Mirrors the image view so the arrow is pointing in the other direction
        self.anticlockwiseImageView.isUserInteractionEnabled = true
        self.clockwiseImageView.isUserInteractionEnabled = true
        
        let clockwiseTapRecog = UITapGestureRecognizer(target: self, action: #selector(clockwiseRotationAnimation))
        let anticlockiwiseTapRecog = UITapGestureRecognizer(target: self, action: #selector(anticlockwiseRotationAnimation))
        
        self.clockwiseImageView.addGestureRecognizer(clockwiseTapRecog)
        self.anticlockwiseImageView.addGestureRecognizer(anticlockiwiseTapRecog)
        
        let snackbarWidth = (view.frame.width / 1.5) //centre
        let snackbarHeight = CGFloat(60)
        let snackbarX = (view.frame.width - snackbarWidth) / 2
        let snackbarY = view.frame.height
        
        self.snackbarFrame = CGRect(x: snackbarX, y: snackbarY, width: snackbarWidth, height: snackbarHeight)
        
        self.snackbarVerticalTranslation = 100
        
        snackbarQueue = Array()
    }
    
    //Passing nil means it will rotate the selected one
    @objc func clockwiseRotationAnimation()
    {
        self.rotationStackView.isHidden = true //Prevents more rotations being initiated
        
        //Removes the highlighting
        self.selectedSubgridCollectionView!.layer.borderWidth = 0
        self.selectedSubgridCollectionView!.layer.borderColor = nil
        self.selectedSubgridCollectionView!.layer.cornerRadius = 0
        self.selectedSubgridCollectionView!.clipsToBounds = false
        
        //Makes it so they cant be selected mid animation
        self.upperLeftSubgrid.allowsSelection = false
        self.upperRightSubgrid.allowsSelection = false
        self.lowerLeftSubgrid.allowsSelection = false
        self.lowerRightSubgrid.allowsSelection = false
        
        let rotationAnimator: UIViewPropertyAnimator = createRotationAnimator(rotationDirection: .clockwise)
        
        rotationAnimator.addCompletion()
        {_ in
            self.onSubgridRotate()
            //Updates the indices that get passed to the GameController.placeMarble function after rotation
            
            if(self.gamePhase != .gameOver)
            {
                for cell in self.selectedSubgridCollectionView!.visibleCells
                {
                    let castCell = cell as! GameBoardCollectionViewCell
                    
                    castCell.updateGameBoardIndices(rotationDirection: .clockwise)
                }
                self.selectedSubgridCollectionView = nil
                
                if(self.gameController.gameBoard.isAgainstAiOpponent)
                {
                    self.gamePhase = .aiTurn
                    self.gameStatusLabel.text = GameStateInfoStore.aiMoveIndicator.rawValue
                    self.playerTurnLabel.text = self.gameController.gameBoard.currentTurnPlayerProfile.userName + GameStateInfoStore.playerTurnTrailing.rawValue
                    DispatchQueue.main.asyncAfter(deadline: .now() + Duration.placeMarbleWait.rawValue)
                    {
                        self.handleAITurn()
                    }
                    
                }
                else
                {
                    self.gamePhase = .placeMarble
                    
                    //Makes the cells interactable again
                    self.upperLeftSubgrid.allowsSelection = true
                    self.upperRightSubgrid.allowsSelection = true
                    self.lowerLeftSubgrid.allowsSelection = true
                    self.lowerRightSubgrid.allowsSelection = true
                    
                    self.gameStatusLabel.text = GameStateInfoStore.placeMarbleInstruction.rawValue
                    self.playerTurnLabel.text = self.gameController.gameBoard.currentTurnPlayerProfile.userName + GameStateInfoStore.playerTurnTrailing.rawValue
                }
            }
        }
        self.gamePhase = .animationOccuring
        rotationAnimator.startAnimation()
    }
    
    @objc func anticlockwiseRotationAnimation()
    {
        self.rotationStackView.isHidden = true //Prevents more rotations being initiated
        
        //Removes the highlighting
        self.selectedSubgridCollectionView!.layer.borderWidth = 0
        self.selectedSubgridCollectionView!.layer.borderColor = nil
        self.selectedSubgridCollectionView!.layer.cornerRadius = 0
        self.selectedSubgridCollectionView!.clipsToBounds = false
        
        //Makes it so they cant be selected mid animation
        self.upperLeftSubgrid.allowsSelection = false
        self.upperRightSubgrid.allowsSelection = false
        self.lowerLeftSubgrid.allowsSelection = false
        self.lowerRightSubgrid.allowsSelection = false
        
        
        let rotationAnimator: UIViewPropertyAnimator = createRotationAnimator(rotationDirection: .anticlockwise) //Returns an animator that rotates the selected subgrid
        
        rotationAnimator.addCompletion()
        {_ in
            self.onSubgridRotate()
            
            if(self.gamePhase != .gameOver)
            {
                //Updates the indices that get passed to the GameController.placeMarble function after rotation
                for cell in self.selectedSubgridCollectionView!.visibleCells
                {
                    let castCell = cell as! GameBoardCollectionViewCell
                    
                    castCell.updateGameBoardIndices(rotationDirection: .anticlockwise)
                }
                self.selectedSubgridCollectionView = nil
                
                if(self.gameController.gameBoard.isAgainstAiOpponent)
                {
                    self.gamePhase = .aiTurn
                    self.gameStatusLabel.text = GameStateInfoStore.aiMoveIndicator.rawValue
                    self.playerTurnLabel.text = self.gameController.gameBoard.currentTurnPlayerProfile.userName + GameStateInfoStore.playerTurnTrailing.rawValue
                    DispatchQueue.main.asyncAfter(deadline: .now() + Duration.placeMarbleWait.rawValue)
                    {
                        self.handleAITurn()
                    }
                }
                else
                {
                    self.gamePhase = .placeMarble
                    
                    self.upperLeftSubgrid.allowsSelection = true
                    self.upperRightSubgrid.allowsSelection = true
                    self.lowerLeftSubgrid.allowsSelection = true
                    self.lowerRightSubgrid.allowsSelection = true
                    
                    self.gameStatusLabel.text = GameStateInfoStore.placeMarbleInstruction.rawValue
                    self.playerTurnLabel.text = self.gameController.gameBoard.currentTurnPlayerProfile.userName + GameStateInfoStore.playerTurnTrailing.rawValue
                }
            }
        }
        self.gamePhase = .animationOccuring
        rotationAnimator.startAnimation()
    }
    
    func createRotationAnimator(rotationDirection: GameBoard.RotationDirection) -> UIViewPropertyAnimator
    {
        var rotationAnimator: UIViewPropertyAnimator? = nil
        
        if(rotationDirection == .clockwise)
        {
            if(self.selectedSubgridCollectionView === self.upperLeftSubgrid)
            {
                self.gameController.rotateSubgrid(subgrid: .upperLeft, rotationDirection: .clockwise)
                self.upperLeftSubgridRotationMultiplier += CGFloat.pi / 2
                
                rotationAnimator = UIViewPropertyAnimator(duration: Duration.gridRotationDuration.rawValue, curve: .easeInOut)
                {
                    self.selectedSubgridCollectionView!.transform = CGAffineTransform(rotationAngle: self.upperLeftSubgridRotationMultiplier)
                }
            }
            else
            {
                if(self.selectedSubgridCollectionView === self.upperRightSubgrid)
                {
                    self.gameController.rotateSubgrid(subgrid: .upperRight, rotationDirection: .clockwise)
                    self.upperRightSubgridRotationMultiplier += CGFloat.pi / 2
                    
                    rotationAnimator = UIViewPropertyAnimator(duration: Duration.gridRotationDuration.rawValue, curve: .easeInOut)
                    {
                        self.selectedSubgridCollectionView!.transform = CGAffineTransform(rotationAngle: self.upperRightSubgridRotationMultiplier)
                    }
                }
                else
                {
                    if(self.selectedSubgridCollectionView === self.lowerLeftSubgrid)
                    {
                        self.gameController.rotateSubgrid(subgrid: .lowerLeft, rotationDirection: .clockwise)
                        self.lowerLeftSubgridRotationMultiplier += CGFloat.pi / 2
                        
                        rotationAnimator = UIViewPropertyAnimator(duration: Duration.gridRotationDuration.rawValue, curve: .easeInOut)
                        {
                            self.selectedSubgridCollectionView!.transform = CGAffineTransform(rotationAngle: self.lowerLeftSubgridRotationMultiplier)
                        }
                    }
                    else
                    {
                        if(self.selectedSubgridCollectionView === self.lowerRightSubgrid)
                        {
                            self.gameController.rotateSubgrid(subgrid: .lowerRight, rotationDirection: .clockwise)
                            self.lowerRightSubgridRotationMultiplier += CGFloat.pi / 2
                            
                            rotationAnimator = UIViewPropertyAnimator(duration: Duration.gridRotationDuration.rawValue, curve: .easeInOut)
                            {
                                self.selectedSubgridCollectionView!.transform = CGAffineTransform(rotationAngle: self.lowerRightSubgridRotationMultiplier)
                            }
                        }
                    }
                }
            }
        }
        else
        {
            if(rotationDirection == .anticlockwise)
            {
                if(self.selectedSubgridCollectionView === self.upperLeftSubgrid)
                {
                    self.gameController.rotateSubgrid(subgrid: .upperLeft, rotationDirection: .anticlockwise)
                    self.upperLeftSubgridRotationMultiplier -= CGFloat.pi / 2
                    
                    rotationAnimator = UIViewPropertyAnimator(duration: Duration.gridRotationDuration.rawValue, curve: .easeInOut)
                    {
                        self.selectedSubgridCollectionView!.transform = CGAffineTransform(rotationAngle: self.upperLeftSubgridRotationMultiplier)
                    }
                }
                else
                {
                    if(self.selectedSubgridCollectionView === self.upperRightSubgrid)
                    {
                        self.gameController.rotateSubgrid(subgrid: .upperRight, rotationDirection: .anticlockwise)
                        self.upperRightSubgridRotationMultiplier -= CGFloat.pi / 2
                        
                        rotationAnimator = UIViewPropertyAnimator(duration: Duration.gridRotationDuration.rawValue, curve: .easeInOut)
                        {
                            self.selectedSubgridCollectionView!.transform = CGAffineTransform(rotationAngle: self.upperRightSubgridRotationMultiplier)
                        }
                    }
                    else
                    {
                        if(self.selectedSubgridCollectionView === self.lowerLeftSubgrid)
                        {
                            self.gameController.rotateSubgrid(subgrid: .lowerLeft, rotationDirection: .anticlockwise)
                            self.lowerLeftSubgridRotationMultiplier -= CGFloat.pi / 2
                            
                            rotationAnimator = UIViewPropertyAnimator(duration: Duration.gridRotationDuration.rawValue, curve: .easeInOut)
                            {
                                self.selectedSubgridCollectionView!.transform = CGAffineTransform(rotationAngle: self.lowerLeftSubgridRotationMultiplier)
                            }
                        }
                        else
                        {
                            if(self.selectedSubgridCollectionView === self.lowerRightSubgrid)
                            {
                                self.gameController.rotateSubgrid(subgrid: .lowerRight, rotationDirection: .anticlockwise)
                                self.lowerRightSubgridRotationMultiplier -= CGFloat.pi / 2
                                
                                rotationAnimator = UIViewPropertyAnimator(duration: Duration.gridRotationDuration.rawValue, curve: .easeInOut)
                                {
                                    self.selectedSubgridCollectionView!.transform = CGAffineTransform(rotationAngle: self.lowerRightSubgridRotationMultiplier)
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return rotationAnimator!
    }
    
    func createAIRotationAnimator(subgrid: GameBoard.Subgrid, rotationDirection: GameBoard.RotationDirection) -> UIViewPropertyAnimator
    {
        var rotationAnimator: UIViewPropertyAnimator? = nil
        
        if(rotationDirection == .clockwise)
        {
            if(subgrid == .upperLeft)
            {
                self.upperLeftSubgridRotationMultiplier += CGFloat.pi / 2
                
                rotationAnimator = UIViewPropertyAnimator(duration: Duration.gridRotationDuration.rawValue, curve: .easeInOut)
                {
                    self.upperLeftSubgrid.transform = CGAffineTransform(rotationAngle: self.upperLeftSubgridRotationMultiplier)
                }
            }
            else
            {
                if(subgrid == .upperRight)
                {
                    self.upperRightSubgridRotationMultiplier += CGFloat.pi / 2
                    
                    rotationAnimator = UIViewPropertyAnimator(duration: Duration.gridRotationDuration.rawValue, curve: .easeInOut)
                    {
                        self.upperRightSubgrid.transform = CGAffineTransform(rotationAngle: self.upperRightSubgridRotationMultiplier)
                    }
                }
                else
                {
                    if(subgrid == .lowerLeft)
                    {
                        self.lowerLeftSubgridRotationMultiplier += CGFloat.pi / 2
                        
                        rotationAnimator = UIViewPropertyAnimator(duration: Duration.gridRotationDuration.rawValue, curve: .easeInOut)
                        {
                            self.lowerLeftSubgrid.transform = CGAffineTransform(rotationAngle: self.lowerLeftSubgridRotationMultiplier)
                        }
                    }
                    else
                    {
                        if(subgrid == .lowerRight)
                        {
                            self.lowerRightSubgridRotationMultiplier += CGFloat.pi / 2
                            
                            rotationAnimator = UIViewPropertyAnimator(duration: Duration.gridRotationDuration.rawValue, curve: .easeInOut)
                            {
                                self.lowerRightSubgrid.transform = CGAffineTransform(rotationAngle: self.lowerRightSubgridRotationMultiplier)
                            }
                        }
                    }
                }
            }
        }
        else
        {
            if(rotationDirection == .anticlockwise)
            {
                if(subgrid == .upperLeft)
                {
                    self.upperLeftSubgridRotationMultiplier -= CGFloat.pi / 2
                    
                    rotationAnimator = UIViewPropertyAnimator(duration: Duration.gridRotationDuration.rawValue, curve: .easeInOut)
                    {
                        self.upperLeftSubgrid.transform = CGAffineTransform(rotationAngle: self.upperLeftSubgridRotationMultiplier)
                    }
                }
                else
                {
                    if(subgrid == .upperRight)
                    {
                        self.upperRightSubgridRotationMultiplier -= CGFloat.pi / 2
                        
                        rotationAnimator = UIViewPropertyAnimator(duration: Duration.gridRotationDuration.rawValue, curve: .easeInOut)
                        {
                            self.upperRightSubgrid.transform = CGAffineTransform(rotationAngle: self.upperRightSubgridRotationMultiplier)
                        }
                    }
                    else
                    {
                        if(subgrid == .lowerLeft)
                        {
                            self.lowerLeftSubgridRotationMultiplier -= CGFloat.pi / 2
                            
                            rotationAnimator = UIViewPropertyAnimator(duration: Duration.gridRotationDuration.rawValue, curve: .easeInOut)
                            {
                                self.lowerLeftSubgrid.transform = CGAffineTransform(rotationAngle: self.lowerLeftSubgridRotationMultiplier)
                            }
                        }
                        else
                        {
                            if(subgrid == .lowerRight)
                            {
                                self.lowerRightSubgridRotationMultiplier -= CGFloat.pi / 2
                                
                                rotationAnimator = UIViewPropertyAnimator(duration: Duration.gridRotationDuration.rawValue, curve: .easeInOut)
                                {
                                    self.lowerRightSubgrid.transform = CGAffineTransform(rotationAngle: self.lowerRightSubgridRotationMultiplier)
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return rotationAnimator!
    }
    
    func handleAITurn()
    {
        var aiRotationAnimator: UIViewPropertyAnimator? = nil
        var aiMoveInfo: (rowIndex: Int?, columnIndex: Int?)
        var aiRotateInfo: (subgrid: GameBoard.Subgrid?, rotationDirection: GameBoard.RotationDirection?) = (nil, nil)
        
        do
        {
            aiMoveInfo = try self.gameController.aiPlaceMarble()
            
            guard aiMoveInfo.rowIndex != nil, aiMoveInfo.columnIndex != nil else
            {
                return
            }
            
            if(aiMoveInfo.rowIndex! <= 2 && aiMoveInfo.columnIndex! <= 2) //upper left
            {
                for cell in self.upperLeftSubgrid.visibleCells
                {
                    let castedCell = cell as! GameBoardCollectionViewCell
                    
                    if(castedCell.gameBoardRowIndex == aiMoveInfo.rowIndex && castedCell.gameBoardColumnIndex == aiMoveInfo.columnIndex)
                    {
                        castedCell.cellImageView.image = ImageAssetFactory.getGameBoardCellUIImage(cellType: castedCell.initialCellType, colour: self.gameController.gameBoard.currentTurnPlayerProfile.marbleColour)
                    }
                }
            }
            else
            {
                if(aiMoveInfo.rowIndex! <= 2 && aiMoveInfo.columnIndex! <= 5) //upper right
                {
                    for cell in self.upperRightSubgrid.visibleCells
                    {
                        let castedCell = cell as! GameBoardCollectionViewCell
                        
                        if(castedCell.gameBoardRowIndex == aiMoveInfo.rowIndex && castedCell.gameBoardColumnIndex == aiMoveInfo.columnIndex)
                        {
                            castedCell.cellImageView.image = ImageAssetFactory.getGameBoardCellUIImage(cellType: castedCell.initialCellType, colour: self.gameController.gameBoard.currentTurnPlayerProfile.marbleColour)
                        }
                    }
                }
                else
                {
                    if(aiMoveInfo.rowIndex! <= 5 && aiMoveInfo.columnIndex! <= 2) //lower left
                    {
                        for cell in self.lowerLeftSubgrid.visibleCells
                        {
                            let castedCell = cell as! GameBoardCollectionViewCell
                            
                            if(castedCell.gameBoardRowIndex == aiMoveInfo.rowIndex && castedCell.gameBoardColumnIndex == aiMoveInfo.columnIndex)
                            {
                                castedCell.cellImageView.image = ImageAssetFactory.getGameBoardCellUIImage(cellType: castedCell.initialCellType, colour: self.gameController.gameBoard.currentTurnPlayerProfile.marbleColour)
                            }
                        }
                    }
                    else
                    {
                        if(aiMoveInfo.rowIndex! <= 5 && aiMoveInfo.columnIndex! <= 5)//Falls to the lower right
                        {
                            for cell in self.lowerRightSubgrid.visibleCells
                            {
                                let castedCell = cell as! GameBoardCollectionViewCell
                                
                                if(castedCell.gameBoardRowIndex == aiMoveInfo.rowIndex && castedCell.gameBoardColumnIndex == aiMoveInfo.columnIndex)
                                {
                                    castedCell.cellImageView.image = ImageAssetFactory.getGameBoardCellUIImage(cellType: castedCell.initialCellType, colour: self.gameController.gameBoard.currentTurnPlayerProfile.marbleColour)
                                }
                            }
                        }
                    }
                }
            }
            onMarblePlace(rowIndex:aiMoveInfo.rowIndex!, columnIndex: aiMoveInfo.columnIndex!)
            
            aiRotateInfo = self.gameController.aiRotateSubgrid()
            aiRotationAnimator = self.createAIRotationAnimator(subgrid: aiRotateInfo.subgrid!, rotationDirection: aiRotateInfo.rotationDirection!)
            aiRotationAnimator!.addCompletion()
            {_ in
                self.onSubgridRotate()
                
                if(self.gamePhase != .gameOver)
                {
                    self.gamePhase = .placeMarble
                    
                    self.upperLeftSubgrid.allowsSelection = true
                    self.upperRightSubgrid.allowsSelection = true
                    self.lowerLeftSubgrid.allowsSelection = true
                    self.lowerRightSubgrid.allowsSelection = true
                    
                    self.gameStatusLabel.text = GameStateInfoStore.placeMarbleInstruction.rawValue
                    self.playerTurnLabel.text = self.gameController.gameBoard.currentTurnPlayerProfile.userName + GameStateInfoStore.playerTurnTrailing.rawValue
                    
                    switch aiRotateInfo.subgrid
                    {
                    case .upperLeft:
                        for cell in self.upperLeftSubgrid.visibleCells
                        {
                            let castCell = cell as! GameBoardCollectionViewCell
                            
                            castCell.updateGameBoardIndices(rotationDirection: aiRotateInfo.rotationDirection!)
                        }
                    case .upperRight:
                        for cell in self.upperRightSubgrid.visibleCells
                        {
                            let castCell = cell as! GameBoardCollectionViewCell
                            
                            castCell.updateGameBoardIndices(rotationDirection: aiRotateInfo.rotationDirection!)
                        }
                    case .lowerLeft:
                        for cell in self.lowerLeftSubgrid.visibleCells
                        {
                            let castCell = cell as! GameBoardCollectionViewCell
                            
                            castCell.updateGameBoardIndices(rotationDirection: aiRotateInfo.rotationDirection!)
                        }
                    case .lowerRight:
                        for cell in self.lowerRightSubgrid.visibleCells
                        {
                            let castCell = cell as! GameBoardCollectionViewCell
                            
                            castCell.updateGameBoardIndices(rotationDirection: aiRotateInfo.rotationDirection!)
                        }
                    default:
                        fatalError("Unnaccounted for case")
                    }
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Duration.rotateSubgridWait.rawValue)
            {
                self.gamePhase = .animationOccuring
                aiRotationAnimator!.startAnimation()
            }
            
        }
        catch let GeneralException.IllegalArgument(message)
        {
            fatalError(message)
        }
        catch let GameBoardException.CellOccupied(message)
        {
            fatalError(message)
        }
        catch let GameBoardException.GameGridFull(message)
        {
            fatalError(message)
        }
        catch
        {
            fatalError("An unaccounted for error was thrown by the placeMarble function")
        }
    }
    
    //Call after the rotation animation completes
    func onSubgridRotate()
    {
        let winner: PlayerProfile? = self.gameController.checkWinConditionPostRotation()
        
        if(winner != nil)
        {
            self.playerTurnLabel.text = winner!.userName + GameStateInfoStore.playerWinTrailing.rawValue
            self.gameStatusLabel.text = GameStateInfoStore.gameOver.rawValue
            self.upperLeftSubgrid.isUserInteractionEnabled = false
            self.upperRightSubgrid.isUserInteractionEnabled = false
            self.lowerLeftSubgrid.isUserInteractionEnabled = false
            self.lowerRightSubgrid.isUserInteractionEnabled = false
            self.rotationStackView.isHidden = true
            self.gamePhase = .gameOver
            
            let achievements = winner!.updateWins()
            
            if(!achievements.isEmpty)
            {
                onAchievementEarned(playerProfile: winner!, achievementsEarned: achievements)
            }
            
            if(winner === self.gameController.gameBoard.player1Profile)
            {
                let achievements = self.gameController.gameBoard.player2Profile.updateLosses()
                
                if(!achievements.isEmpty && !self.gameController.gameBoard.isAgainstAiOpponent)
                {
                    onAchievementEarned(playerProfile: self.gameController.gameBoard.player2Profile, achievementsEarned: achievements)
                }
                
            }
            else
            {
                if(winner === self.gameController.gameBoard.player2Profile)
                {
                    let achievements = self.gameController.gameBoard.player1Profile.updateLosses()
                    
                    if(!achievements.isEmpty)
                    {
                        onAchievementEarned(playerProfile: self.gameController.gameBoard.player1Profile, achievementsEarned: achievements)
                    }
                }
            }
        }
        else
        {
            if(self.gameController.didDrawHappen())
            {
                onDraw()
            }
        }
        if(self.gameController.gameBoard.currentTurnPlayerProfile === self.gameController.gameBoard.player1Profile)
        {
            onPlayerMove(playerProfile: self.gameController.gameBoard.player2Profile) //We pass player 2 instead of 1 because after the rotation has been done, the current player isnt the one who just completed the move (it changes automitcally have the rotateFunction has been called).
        }
        else
        {
            onPlayerMove(playerProfile: self.gameController.gameBoard.player1Profile)
        }
        displaySnackbars()
    }
    
    func onMarblePlace(rowIndex: Int, columnIndex: Int)
    {
        let winner: PlayerProfile? = self.gameController.checkWinCondition(rowIndex: rowIndex, columnIndex: columnIndex)
        
        if(winner != nil)
        {
            self.playerTurnLabel.text = winner!.userName + GameStateInfoStore.playerWinTrailing.rawValue
            self.gameStatusLabel.text = GameStateInfoStore.gameOver.rawValue
            self.upperLeftSubgrid.isUserInteractionEnabled = false
            self.upperRightSubgrid.isUserInteractionEnabled = false
            self.lowerLeftSubgrid.isUserInteractionEnabled = false
            self.lowerRightSubgrid.isUserInteractionEnabled = false
            self.rotationStackView.isHidden = true
            self.gamePhase = .gameOver
            
            let achievements = winner!.updateWins()
            
            if(!achievements.isEmpty)
            {
                onAchievementEarned(playerProfile: winner!, achievementsEarned: achievements)
            }
            
            if(winner === self.gameController.gameBoard.player1Profile)
            {
                let achievements = self.gameController.gameBoard.player2Profile.updateLosses()
                
                if(!achievements.isEmpty && !self.gameController.gameBoard.isAgainstAiOpponent)
                {
                    onAchievementEarned(playerProfile: self.gameController.gameBoard.player2Profile, achievementsEarned: achievements)
                }
                onPlayerMove(playerProfile: self.gameController.gameBoard.player1Profile) //Only counts placing a marble as a move on its own without rotation if it resulted in a win
            }
            else
            {
                if(winner === self.gameController.gameBoard.player2Profile)
                {
                    let achievements = self.gameController.gameBoard.player1Profile.updateLosses()
                    
                    if(!achievements.isEmpty)
                    {
                        onAchievementEarned(playerProfile: self.gameController.gameBoard.player1Profile, achievementsEarned: achievements)
                    }
                    onPlayerMove(playerProfile: self.gameController.gameBoard.player2Profile) //Only counts placing a marble as a move on its own without rotation if it resulted in a win
                }
            }
        }
        else
        {
            if(self.gameController.didDrawHappen())
            {
                onDraw()
            }
        }
        displaySnackbars()
    }
    
    func onDraw()
    {
        self.playerTurnLabel.text = GameStateInfoStore.draw.rawValue
        self.gameStatusLabel.text = GameStateInfoStore.gameOver.rawValue
        self.upperLeftSubgrid.isUserInteractionEnabled = false
        self.upperRightSubgrid.isUserInteractionEnabled = false
        self.lowerLeftSubgrid.isUserInteractionEnabled = false
        self.lowerRightSubgrid.isUserInteractionEnabled = false
        self.rotationStackView.isHidden = true
        self.gamePhase = .gameOver
        
        let player1Achievements = self.gameController.gameBoard.player1Profile.updateDraws()
        let player2Achievements = self.gameController.gameBoard.player2Profile.updateDraws()
        
        if(!player1Achievements.isEmpty)
        {
            onAchievementEarned(playerProfile: self.gameController.gameBoard.player1Profile, achievementsEarned: player1Achievements)
        }
        if(!player2Achievements.isEmpty && !self.gameController.gameBoard.isAgainstAiOpponent)
        {
            onAchievementEarned(playerProfile: self.gameController.gameBoard.player2Profile, achievementsEarned: player2Achievements)
        }
    }
    
    func onAchievementEarned(playerProfile: PlayerProfile, achievementsEarned: Array<Achievement>)
    {
        for achievement in achievementsEarned
        {
            if(!achievement.hasBeenDisplayed)
            {
                let snackbarMessage = playerProfile.userName + " earned " + achievement.achievementTitle
                let snackbarViewModel = SnackbarViewModel(type: .info, text: snackbarMessage, image: .init(systemName: "trophy.circle.fill"))
                let snackbar = SnackbarView(viewModel: snackbarViewModel, frame: self.snackbarFrame, verticalTranslation: self.snackbarVerticalTranslation, backgroundColour: .systemGreen, imageColour: .yellow, duration: Duration.snackbarDuration.rawValue)
                self.snackbarQueue.append(snackbar)
                
                achievement.hasBeenDisplayed = true
            }
        }
    }
    
    func onPlayerMove(playerProfile: PlayerProfile)
    {
        let achievements = playerProfile.updateTotalMovesMade()
        
        if(!achievements.isEmpty)
        {
            if(!(self.gameController.gameBoard.isAgainstAiOpponent && playerProfile === self.gameController.gameBoard.player2Profile)) //checks to see if this is the as the AI cant earn achievements
            {
                onAchievementEarned(playerProfile: playerProfile, achievementsEarned: achievements)
            }
        }
    }
    
    func displaySnackbars()
    {
        if(!self.snackbarQueue.isEmpty)
        {
            var currentOffset: Double = 0
            let copyQueue = self.snackbarQueue!
            for snackbar in copyQueue
            {
                DispatchQueue.main.asyncAfter(deadline: .now() + currentOffset)
                {
                    snackbar.showSnackbar(view: self.view.window!)
                    self.snackbarQueue.removeAll(where: {$0 === snackbar})
                }
                currentOffset += Duration.snackbarDuration.rawValue //The snack bar will show up one after the other
            }
        }
    }
    
    enum GamePhase
    {
        case placeMarble
        case rotateSubgid
        case animationOccuring
        case aiTurn
        case gameOver
    }
    
    enum Duration: Double
    {
        case gridRotationDuration = 1.5 //Seconds
        case placeMarbleWait = 0.75 //Seconds
        case rotateSubgridWait = 1
        case snackbarDuration = 2.5
    }
}

extension GameBoardViewController: UICollectionViewDelegate
{
    func collectionView(
        _ collectionView: UICollectionView,
        shouldSelectItemAt indexPath: IndexPath
    ) -> Bool
    {
        var shouldBeSelected: Bool = true
        
        if(gamePhase == .animationOccuring || gamePhase == .aiTurn) //Stops the user making moves while an animation is occuring or when it is the AI's turn
        {
            shouldBeSelected = false
        }
        
        return shouldBeSelected
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt index: IndexPath)
    {
        let cell = collectionView.cellForItem(at: index) as! GameBoardCollectionViewCell
        
        if(gamePhase == .placeMarble)
        {
            do
            {
                try self.gameController.placeMarble(rowIndex: cell.gameBoardRowIndex, columnIndex: cell.gameBoardColumnIndex)
                cell.cellImageView.image = ImageAssetFactory.getGameBoardCellUIImage(cellType: cell.initialCellType, colour: self.gameController.gameBoard.currentTurnPlayerProfile.marbleColour)
                onMarblePlace(rowIndex: cell.gameBoardRowIndex, columnIndex: cell.gameBoardColumnIndex)
                
                if(self.gamePhase != .gameOver)
                {
                    self.gamePhase = .rotateSubgid
                    self.gameStatusLabel.text = GameStateInfoStore.subgridSelectInstruction.rawValue
                }
            }
            catch let GeneralException.IllegalArgument(message)
            {
                fatalError(message)
            }
            catch(GameBoardException.CellOccupied)
            {
                //Notify the user
                let snackbarMessage = "This Cell already has a Marble in it!"
                let snackbarViewModel = SnackbarViewModel(type: .info, text: snackbarMessage, image: .init(systemName: "exclamationmark.circle.fill"))
                let snackbar = SnackbarView(viewModel: snackbarViewModel, frame: self.snackbarFrame, verticalTranslation: self.snackbarVerticalTranslation, backgroundColour: .systemGray2, imageColour: .systemPurple, duration: Duration.snackbarDuration.rawValue)
                
                //Wont be added to the queue because t should appear immediately
                snackbar.showSnackbar(view: self.view.window!)
            }
            catch(GameBoardException.GameGridFull)
            {
                //This shouldnt really ever appear with the way the code is structured
                let snackbarMessage = "The Gameboard is Full!"
                let snackbarViewModel = SnackbarViewModel(type: .info, text: snackbarMessage, image: .init(systemName: "exclamationmark.circle.fill"))
                let snackbar = SnackbarView(viewModel: snackbarViewModel, frame: self.snackbarFrame, verticalTranslation: self.snackbarVerticalTranslation, backgroundColour: .systemGray2, imageColour: .systemPurple, duration: Duration.snackbarDuration.rawValue)
                
                //Wont be added to the queue because t should appear immediately
                snackbar.showSnackbar(view: self.view.window!)
            }
            catch
            {
                fatalError("An unaccounted for error was thrown by the placeMarble function")
            }
        }
        else
        {
            if(gamePhase == .rotateSubgid)
            {
                let subgrids = [self.upperLeftSubgrid!, self.upperRightSubgrid!, self.lowerLeftSubgrid!, self.lowerRightSubgrid!]
                
                for subgrid in subgrids //Unhighlights any highlighted colletion views
                {
                    if(subgrid.clipsToBounds)
                    {
                        subgrid.layer.borderWidth = 0
                        subgrid.layer.borderColor = nil
                        subgrid.layer.cornerRadius = 0
                        subgrid.clipsToBounds = false
                    }
                }
                
                collectionView.layer.borderWidth = 4
                collectionView.layer.borderColor = UIColor.systemYellow.cgColor
                collectionView.layer.cornerRadius = 10
                collectionView.clipsToBounds = true
                
                self.selectedSubgridCollectionView = collectionView
                self.rotationStackView.isHidden = false
                
                self.gameStatusLabel.text = GameStateInfoStore.rotationInstruction.rawValue
            }
        }
    }
}

extension GameBoardViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 9 //HAS TO BE 9 with the way storyboard is configured to make it look
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameBoardCollectionViewCell", for: indexPath) as! GameBoardCollectionViewCell
        
        var rowIndex: Int? = nil
        var columnIndex: Int? = nil
        var rowIndexOffset: Int? = nil
        var columnIndexOffset: Int? = nil
        
        switch indexPath.item
        {
        case 0:
            cell.initialCellType = .topLeftCell
            cell.currentCellType = .topLeftCell
            rowIndex = 0
            columnIndex = 0
        case 1:
            cell.initialCellType = .topMiddleCell
            cell.currentCellType = .topMiddleCell
            rowIndex = 0
            columnIndex = 1
        case 2:
            cell.initialCellType = .topRightCell
            cell.currentCellType = .topRightCell
            rowIndex = 0
            columnIndex = 2
        case 3:
            cell.initialCellType = .middleLeftCell
            cell.currentCellType = .middleLeftCell
            rowIndex = 1
            columnIndex = 0
        case 4:
            cell.initialCellType = .middleMiddleCell
            cell.currentCellType = .middleMiddleCell
            rowIndex = 1
            columnIndex = 1
        case 5:
            cell.initialCellType = .middleRightCell
            cell.currentCellType = .middleRightCell
            rowIndex = 1
            columnIndex = 2
        case 6:
            cell.initialCellType = .bottomLeftCell
            cell.currentCellType = .bottomLeftCell
            rowIndex = 2
            columnIndex = 0
        case 7:
            cell.initialCellType = .bottomMiddleCell
            cell.currentCellType = .bottomMiddleCell
            rowIndex = 2
            columnIndex = 1
        case 8:
            cell.initialCellType = .bottomRightCell
            cell.currentCellType = .bottomRightCell
            rowIndex = 2
            columnIndex = 2
        default:
            fatalError("There should only be 9 items in the collection view")
        }
        
        if(collectionView === upperLeftSubgrid)
        {
            rowIndexOffset = 0
            columnIndexOffset = 0
        }
        else
        {
            if(collectionView === upperRightSubgrid)
            {
                rowIndexOffset = 0
                columnIndexOffset = 3
            }
            else
            {
                if(collectionView === lowerLeftSubgrid)
                {
                    rowIndexOffset = 3
                    columnIndexOffset = 0
                }
                else
                {
                    if(collectionView === lowerRightSubgrid)
                    {
                        rowIndexOffset = 3
                        columnIndexOffset = 3
                    }
                }
            }
        }
        
        cell.gameBoardRowIndex = rowIndex! + rowIndexOffset! //Should be non-nil at this point
        cell.gameBoardColumnIndex = columnIndex! + columnIndexOffset!
        
        cell.cellImageView.image = ImageAssetFactory.getGameBoardCellUIImage(cellType: cell.initialCellType, colour: nil)
        
        guard cell.cellImageView.image != nil else
        {
            fatalError("Could not get a cell image for cell with rowIndex: \(String(cell.gameBoardRowIndex)) and columnIndex: \(String(cell.gameBoardColumnIndex))")
        }
        
        return cell
    }
}
