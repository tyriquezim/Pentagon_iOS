//
//  GameStateInfoStore.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 2/1/2026.
//

import UIKit

enum GameStateInfoStore: String, CaseIterable
{
    case playerTurnTrailing = "'s Turn"
    case playerWinTrailing = " Wins!!!"
    case gameOver = "Game Over"
    case draw = "Draw"
    case placeMarbleInstruction = "Tap an empty cell to place your marble"
    case subgridSelectInstruction = "Tap the subgrid you would like to rotate"
    case rotationInstruction = "Tap one of the arrows to rotate the grid clockwise or anti-clockwise"
    case aiMoveIndicator = "Thinking..."
}
