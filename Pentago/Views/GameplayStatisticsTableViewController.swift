//
//  GameplayStatisticsTableViewController.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 2/1/2026.
//

import UIKit

class GameplayStatisticsTableViewController: UITableViewController
{
    var sourceProfile: PlayerProfile!
    let percentageFormatter: NumberFormatter =
    {
        let nf = NumberFormatter()
        nf.numberStyle = .percent
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        
        return nf
    }()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return GameDisplayStatisticStore.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let gameStatTVCell = tableView.dequeueReusableCell(withIdentifier: "GameplayStatisticsTableViewCell", for: indexPath) as! GameplayStatisticsTableViewCell
        
        let displayStatCase = GameDisplayStatisticStore.allCases[indexPath.row]
        gameStatTVCell.statImageView.image = ImageAssetFactory.getStatUIImage(gameDisplayStat: displayStatCase)
        gameStatTVCell.statNameLabel.text = displayStatCase.rawValue
    
        switch displayStatCase
        {
            case .achievementsEarned:
                gameStatTVCell.statisticLabel.text = String(sourceProfile.numAchievementsEarned)
            case .draw:
                gameStatTVCell.statisticLabel.text = String(sourceProfile.numDraws)
            case .gamesPlayed:
                gameStatTVCell.statisticLabel.text = String(sourceProfile.numGamesPlayed)
            case .lose:
                gameStatTVCell.statisticLabel.text = String(sourceProfile.numLosses)
            case .movesMade:
                gameStatTVCell.statisticLabel.text = String(sourceProfile.totalMovesMade)
            case .win:
                gameStatTVCell.statisticLabel.text = String(sourceProfile.numWins)
            case .winPercentage:
                gameStatTVCell.statisticLabel.text = percentageFormatter.string(from: NSNumber(value: sourceProfile.winPercentage))
            default:
                fatalError("Unaccounted for case in GameplayStatisticsViewController datasource function.")
        }
        
        return gameStatTVCell
    }
}
