//
//  ImageAssetFactory.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 1/1/2026.
//
import UIKit

struct ImageAssetFactory
{
    static func getProfilePictureUIImage(profilePicture: PlayerProfile.ProfilePicture) -> UIImage
    {
        var imageResource: UIImage
        
        switch profilePicture
        {
            case .beach:
                imageResource = UIImage(named: "beach")!
            case .cpuRobot:
                imageResource = UIImage(named: "cpu")!
            case .defaultIcon:
                imageResource = UIImage(named: "default")!
            case .desert:
                imageResource = UIImage(named: "desert")!
            case .giraffe:
                imageResource = UIImage(named: "giraffe")!
            case .lion:
                imageResource = UIImage(named: "lion")!
            case .mountain:
                imageResource = UIImage(named: "mountain")!
            case .ostrich:
                imageResource = UIImage(named: "ostrich")!
            case .puppy:
                imageResource = UIImage(named: "puppy")!
            case .tiger:
                imageResource = UIImage(named: "tiger")!
            case .tree:
                imageResource = UIImage(named: "tree")!
            case .zebra:
                imageResource = UIImage(named: "zebra")!
            default:
                fatalError("Unaccounted for profile picture image asset in getProfilePictureUIImage")
        }
        
        return imageResource
    }
    
    static func getAddProfileUIImage() -> UIImage
    {
        return UIImage(named: "add_profile")!
    }
    
    static func getAppLogoUIImage() -> UIImage
    {
        return UIImage(named: "pentago_logo")!
    }
    
    static func getRuleUIImage(ruleTitle: GameRulesInfoStore.RuleTitle) -> UIImage
    {
        var ruleImage: UIImage
        
        switch ruleTitle
        {
            case .orderOfActions:
                ruleImage = UIImage(named: "rotate")!
            case .howToWin:
                ruleImage = UIImage(named: "diagonal_win")!
            case .exceptionToRotating:
                ruleImage = UIImage(named: "no_rotate_win")!
            case .fullBoardDraw:
                ruleImage = UIImage(named: "draw")!
            case .doubleWinDraw:
                ruleImage = UIImage(named: "double_win_draw")!
            default:
            fatalError("Unnaccounted for RuleTitle in getRuleUIImage. Case: \(ruleTitle)")
        }
        
        return ruleImage
    }
    
    static func getStatUIImage(gameDisplayStat: GameDisplayStatisticStore) -> UIImage
    {
        var statImage: UIImage
        
        switch gameDisplayStat
        {
            case .achievementsEarned:
                statImage = UIImage(named: "achievements_earned_stat")!
            case .draw:
                statImage = UIImage(named: "draw_stat")!
            case .gamesPlayed:
                statImage = UIImage(named: "games_played_stat")!
            case .lose:
                statImage = UIImage(named: "lose_stat")!
            case .movesMade:
                statImage = UIImage(named: "moves_made_stat")!
            case .win:
                statImage = UIImage(named: "win_percentage_stat")!
            case .winPercentage:
                statImage = UIImage(named: "win_stat")!
            default:
            fatalError("Unnaccounted for gameDisplayStat in getStatUIImage. Case: \(gameDisplayStat)")
        }
        
        return statImage
    }
    
    static func getAchievementEarnStatusUIImage(hasBeenEarned: Bool) -> UIImage
    {
        var statusImage: UIImage
        
        if(hasBeenEarned)
        {
            statusImage = UIImage(named: "earned")!
        }
        else
        {
            statusImage = UIImage(named: "not_earned")!
        }
        
        return statusImage
    }
    
    static func getGameBoardCellUIImage(cellType: GameBoardCollectionViewCell.CellType, colour: Marble.MarbleColour?) -> UIImage?
    {
        var cellImage: UIImage! = nil
        
        if(cellType == .topMiddleCell || cellType == .middleLeftCell || cellType == .middleMiddleCell || cellType == .middleRightCell || cellType == .bottomMiddleCell)
        {
            switch colour
            {
                case .black:
                    cellImage = UIImage(named: "black_general")
                case .blue:
                    cellImage = UIImage(named: "blue_general")
                case .green:
                    cellImage = UIImage(named: "green_general")
                case .grey:
                    cellImage = UIImage(named: "grey_general")
                case .orange:
                    cellImage = UIImage(named: "orange_general")
                case .pink:
                    cellImage = UIImage(named: "pink_general")
                case .purple:
                    cellImage = UIImage(named: "purple_general")
                case .red:
                    cellImage = UIImage(named: "red_general")
                case .yellow:
                    cellImage = UIImage(named: "yellow_general")
                case nil:
                    cellImage = UIImage(named: "empty_general")
                default:
                    fatalError("Unexpected colour in getGameBoardCellUIImage.")
            }
        }
        else
        {
            if(cellType == .topLeftCell)
            {
                switch colour
                {
                    case .black:
                        cellImage = UIImage(named: "black_upper_left")
                    case .blue:
                        cellImage = UIImage(named: "blue_upper_left")
                    case .green:
                        cellImage = UIImage(named: "green_upper_left")
                    case .grey:
                        cellImage = UIImage(named: "grey_upper_left")
                    case .orange:
                        cellImage = UIImage(named: "orange_upper_left")
                    case .pink:
                        cellImage = UIImage(named: "pink_upper_left")
                    case .purple:
                        cellImage = UIImage(named: "purple_upper_left")
                    case .red:
                        cellImage = UIImage(named: "red_upper_left")
                    case .yellow:
                        cellImage = UIImage(named: "yellow_upper_left")
                    case nil:
                        cellImage = UIImage(named: "empty_upper_left")
                    default:
                        fatalError("Unexpected colour in getGameBoardCellUIImage")
                }
            }
            else
            {
                if(cellType == .topRightCell)
                {
                    switch colour
                    {
                        case .black:
                            cellImage = UIImage(named: "black_upper_right")
                        case .blue:
                            cellImage = UIImage(named: "blue_upper_right")
                        case .green:
                            cellImage = UIImage(named: "green_upper_right")
                        case .grey:
                            cellImage = UIImage(named: "grey_upper_right")
                        case .orange:
                            cellImage = UIImage(named: "orange_upper_right")
                        case .pink:
                            cellImage = UIImage(named: "pink_upper_right")
                        case .purple:
                            cellImage = UIImage(named: "purple_upper_right")
                        case .red:
                            cellImage = UIImage(named: "red_upper_right")
                        case .yellow:
                            cellImage = UIImage(named: "yellow_upper_right")
                        case nil:
                            cellImage = UIImage(named: "empty_upper_right")
                        default:
                            fatalError("Unexpected colour in getGameBoardCellUIImage")
                    }
                }
                else
                {
                    if(cellType == .bottomLeftCell)
                    {
                        switch colour
                        {
                            case .black:
                                cellImage = UIImage(named: "black_lower_left")
                            case .blue:
                                cellImage = UIImage(named: "blue_lower_left")
                            case .green:
                                cellImage = UIImage(named: "green_lower_left")
                            case .grey:
                                cellImage = UIImage(named: "grey_lower_left")
                            case .orange:
                                cellImage = UIImage(named: "orange_lower_left")
                            case .pink:
                                cellImage = UIImage(named: "pink_lower_left")
                            case .purple:
                                cellImage = UIImage(named: "purple_lower_left")
                            case .red:
                                cellImage = UIImage(named: "red_lower_left")
                            case .yellow:
                                cellImage = UIImage(named: "yellow_lower_left")
                            case nil:
                                cellImage = UIImage(named: "empty_lower_left")
                            default:
                                fatalError("Unexpected colour in getGameBoardCellUIImage")
                        }
                    }
                    else
                    {
                        if(cellType == .bottomRightCell)
                        {
                            switch colour
                            {
                                case .black:
                                    cellImage = UIImage(named: "black_lower_right")
                                case .blue:
                                    cellImage = UIImage(named: "blue_lower_right")
                                case .green:
                                    cellImage = UIImage(named: "green_lower_right")
                                case .grey:
                                    cellImage = UIImage(named: "grey_lower_right")
                                case .orange:
                                    cellImage = UIImage(named: "orange_lower_right")
                                case .pink:
                                    cellImage = UIImage(named: "pink_lower_right")
                                case .purple:
                                    cellImage = UIImage(named: "purple_lower_right")
                                case .red:
                                    cellImage = UIImage(named: "red_lower_right")
                                case .yellow:
                                    cellImage = UIImage(named: "yellow_lower_right")
                                case nil:
                                    cellImage = UIImage(named: "empty_lower_right")
                                default:
                                    fatalError("Unexpected colour in getGameBoardCellUIImage")
                            }
                        }
                    }
                }
            }
        }
        
        return cellImage
    }
    
    static func getMarbleColourUIImage(colour: Marble.MarbleColour) -> UIImage
    {
        var colourImage: UIImage
        
        switch colour
        {
            case .black:
                colourImage = UIImage(named: "marble_black")!
            case .blue:
                colourImage = UIImage(named: "marble_blue")!
            case .green:
                colourImage = UIImage(named: "marble_green")!
            case .grey:
                colourImage = UIImage(named: "marble_grey")!
            case .orange:
                colourImage = UIImage(named: "marble_orange")!
            case .pink:
                colourImage = UIImage(named: "marble_pink")!
            case .purple:
                colourImage = UIImage(named: "marble_purple")!
            case .red:
                colourImage = UIImage(named: "marble_red")!
            case .yellow:
                colourImage = UIImage(named: "marble_yellow")!
            default:
                fatalError("Unexpected colour in getMarbleColourUIImage")
        }
        
        return colourImage
    }
}
