//
//  GameBoardController.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 13/12/2025.
//

class GameBoardController
{
    var gameBoard: GameBoard
    
    init(gameBoard: GameBoard)
    {
        self.gameBoard = gameBoard
    }
    
    private func updateTurns()
    {
        if(self.gameBoard.currentTurnPlayerProfile === self.gameBoard.player1Profile)
        {
            self.gameBoard.currentTurnPlayerProfile = self.gameBoard.player2Profile
        }
        else
        {
            if(self.gameBoard.currentTurnPlayerProfile === self.gameBoard.player2Profile)
            {
                self.gameBoard.currentTurnPlayerProfile = self.gameBoard.player1Profile
            }
        }
    }
    
    func placeMarble(rowIndex: Int, columnIndex: Int) throws
    {
        let newMarble =  Marble(marbleOwner: self.gameBoard.currentTurnPlayerProfile, marbleColour: self.gameBoard.currentTurnPlayerProfile.marbleColour)
        let gridMaximumCapacity = gameBoard.gridSideLength * gameBoard.gridSideLength
        
        if(rowIndex < 0 || rowIndex > 5)
        {
            throw GeneralException.IllegalArgument(message: "Illegal move! A marble can only be placed in a row with an index between 0 and 5 inclusive. Passed position -> Row Index: \(rowIndex), Column Index: \(columnIndex)")
        }
        if(columnIndex < 0 || columnIndex > 5)
        {
            throw GeneralException.IllegalArgument(message: "Illegal move! A marble can only be placed in a column with an index between 0 and 5 inclusive. Passed position -> Row Index: \(rowIndex), Column Index: \(columnIndex)")
        }
        
        if(gameBoard.numMarbles == gridMaximumCapacity)
        {
            throw GameBoardException.GameGridFull(message: "Cannot place marble. The grid is full.")
        }
        
        if(gameBoard.gameGrid[rowIndex][columnIndex] != nil)
        {
            throw GameBoardException.CellOccupied(message: "Cannot place marble in position \(rowIndex), \(columnIndex). There is already a marble in that position.")
        }
        else
        {
            gameBoard.gameGrid[rowIndex][columnIndex] = newMarble
        }
        gameBoard.numMarbles += 1
    }
    
    func rotateSubgrid(subgrid: GameBoard.Subgrid, rotationDirection: GameBoard.RotationDirection)
    {
        if(subgrid == .upperLeft)
        {
            rotateUpperLeftSubgrid(rotationDirection: rotationDirection)
        }
        else
        {
            if(subgrid == .upperRight)
            {
                rotateUpperRightSubgrid(rotationDirection: rotationDirection)
            }
            else
            {
                if(subgrid == .lowerLeft)
                {
                    rotateLowerLeftSubgrid(rotationDirection: rotationDirection)
                }
                else
                {
                    if(subgrid == .lowerRight)
                    {
                        rotateLowerRightSubgrid(rotationDirection: rotationDirection)
                    }
                }
            }
        }
        updateTurns()
    }
    
    private func rotateUpperLeftSubgrid(rotationDirection: GameBoard.RotationDirection)
    {
        let subgridSideLength = gameBoard.gridSideLength / 2
        var upperLeftSubgrid: Array<Array<Marble?>> = Array(repeating: Array(repeating: nil, count: subgridSideLength), count: subgridSideLength) //3x3 empty array
        
        //Copy contents of the upper left subgrid to this array
        for i in 0...2
        {
            for j in 0...2
            {
                upperLeftSubgrid[i][j] = gameBoard.gameGrid[i][j]
            }
        }
        
        if(rotationDirection == .clockwise)
        {
            //Top Row
            gameBoard.gameGrid[0][0] = upperLeftSubgrid[2][0]
            gameBoard.gameGrid[0][1] = upperLeftSubgrid[1][0]
            gameBoard.gameGrid[0][2] = upperLeftSubgrid[0][0]
            
            //Middle Row
            gameBoard.gameGrid[1][0] = upperLeftSubgrid[2][1]
            gameBoard.gameGrid[1][1] = upperLeftSubgrid[1][1]
            gameBoard.gameGrid[1][2] = upperLeftSubgrid[0][1]
            
            //Bottom Row
            gameBoard.gameGrid[2][0] = upperLeftSubgrid[2][2]
            gameBoard.gameGrid[2][1] = upperLeftSubgrid[1][2]
            gameBoard.gameGrid[2][2] = upperLeftSubgrid[0][2]
        }
        else
        {
            if(rotationDirection == .anticlockwise)
            {
                //Bottom Row
                gameBoard.gameGrid[2][2] = upperLeftSubgrid[2][0]
                gameBoard.gameGrid[2][1] = upperLeftSubgrid[1][0]
                gameBoard.gameGrid[2][0] = upperLeftSubgrid[0][0]
                
                //Middle Row
                gameBoard.gameGrid[1][2] = upperLeftSubgrid[2][1]
                gameBoard.gameGrid[1][1] = upperLeftSubgrid[1][1]
                gameBoard.gameGrid[1][0] = upperLeftSubgrid[0][1]
                
                //Top Row
                gameBoard.gameGrid[0][2] = upperLeftSubgrid[2][2]
                gameBoard.gameGrid[0][1] = upperLeftSubgrid[1][2]
                gameBoard.gameGrid[0][0] = upperLeftSubgrid[0][2]
            }
        }
    }
    
    private func rotateUpperRightSubgrid(rotationDirection: GameBoard.RotationDirection)
    {
        let subgridSideLength: Int = gameBoard.gridSideLength / 2
        let indexOffset: Int = subgridSideLength
        var upperRightSubgrid: Array<Array<Marble?>> = Array(repeating: Array(repeating: nil, count: subgridSideLength), count: subgridSideLength) //3x3 empty array
        
        //Copy contents of the upper left subgrid to this array
        for i in 0...2
        {
            for j in 0...2
            {
                upperRightSubgrid[i][j] = gameBoard.gameGrid[i][indexOffset + j]
            }
        }
        
        if(rotationDirection == .clockwise)
        {
            //Top Row
            gameBoard.gameGrid[0][3] = upperRightSubgrid[2][0]
            gameBoard.gameGrid[0][4] = upperRightSubgrid[1][0]
            gameBoard.gameGrid[0][5] = upperRightSubgrid[0][0]
            
            //Middle Row
            gameBoard.gameGrid[1][3] = upperRightSubgrid[2][1]
            gameBoard.gameGrid[1][4] = upperRightSubgrid[1][1]
            gameBoard.gameGrid[1][5] = upperRightSubgrid[0][1]
            
            //Bottom Row
            gameBoard.gameGrid[2][3] = upperRightSubgrid[2][2]
            gameBoard.gameGrid[2][4] = upperRightSubgrid[1][2]
            gameBoard.gameGrid[2][5] = upperRightSubgrid[0][2]
        }
        else
        {
            if(rotationDirection == .anticlockwise)
            {
                //Bottom Row
                gameBoard.gameGrid[2][5] = upperRightSubgrid[2][0]
                gameBoard.gameGrid[2][4] = upperRightSubgrid[1][0]
                gameBoard.gameGrid[2][3] = upperRightSubgrid[0][0]
                
                //Middle Row
                gameBoard.gameGrid[1][5] = upperRightSubgrid[2][1]
                gameBoard.gameGrid[1][4] = upperRightSubgrid[1][1]
                gameBoard.gameGrid[1][3] = upperRightSubgrid[0][1]
                
                //Top Row
                gameBoard.gameGrid[0][5] = upperRightSubgrid[2][2]
                gameBoard.gameGrid[0][4] = upperRightSubgrid[1][2]
                gameBoard.gameGrid[0][3] = upperRightSubgrid[0][2]
            }
        }
    }
    
    private func rotateLowerLeftSubgrid(rotationDirection: GameBoard.RotationDirection)
    {
        let subgridSideLength: Int = gameBoard.gridSideLength / 2
        let indexOffset: Int = subgridSideLength
        var lowerLeftSubgrid: Array<Array<Marble?>> = Array(repeating: Array(repeating: nil, count: subgridSideLength), count: subgridSideLength) //3x3 empty array
        
        //Copy contents of the upper left subgrid to this array
        for i in 0...2
        {
            for j in 0...2
            {
                lowerLeftSubgrid[i][j] = gameBoard.gameGrid[indexOffset + i][j]
            }
        }
        
        if(rotationDirection == .clockwise)
        {
            //Top Row
            gameBoard.gameGrid[3][0] = lowerLeftSubgrid[2][0]
            gameBoard.gameGrid[3][1] = lowerLeftSubgrid[1][0]
            gameBoard.gameGrid[3][2] = lowerLeftSubgrid[0][0]
            
            //Middle Row
            gameBoard.gameGrid[4][0] = lowerLeftSubgrid[2][1]
            gameBoard.gameGrid[4][1] = lowerLeftSubgrid[1][1]
            gameBoard.gameGrid[4][2] = lowerLeftSubgrid[0][1]
            
            //Bottom Row
            gameBoard.gameGrid[5][0] = lowerLeftSubgrid[2][2]
            gameBoard.gameGrid[5][1] = lowerLeftSubgrid[1][2]
            gameBoard.gameGrid[5][2] = lowerLeftSubgrid[0][2]
        }
        else
        {
            if(rotationDirection == .anticlockwise)
            {
                //Bottom Row
                gameBoard.gameGrid[5][2] = lowerLeftSubgrid[2][0]
                gameBoard.gameGrid[5][1] = lowerLeftSubgrid[1][0]
                gameBoard.gameGrid[5][0] = lowerLeftSubgrid[0][0]
                
                //Middle Row
                gameBoard.gameGrid[4][2] = lowerLeftSubgrid[2][1]
                gameBoard.gameGrid[4][1] = lowerLeftSubgrid[1][1]
                gameBoard.gameGrid[4][0] = lowerLeftSubgrid[0][1]
                
                //Top Row
                gameBoard.gameGrid[3][2] = lowerLeftSubgrid[2][2]
                gameBoard.gameGrid[3][1] = lowerLeftSubgrid[1][2]
                gameBoard.gameGrid[3][0] = lowerLeftSubgrid[0][2]
            }
        }
    }
    
    private func rotateLowerRightSubgrid(rotationDirection: GameBoard.RotationDirection)
    {
        let subgridSideLength: Int = gameBoard.gridSideLength / 2
        let indexOffset: Int = subgridSideLength
        var lowerRightSubgrid: Array<Array<Marble?>> = Array(repeating: Array(repeating: nil, count: subgridSideLength), count: subgridSideLength) //3x3 empty array
        
        //Copy contents of the upper left subgrid to this array
        for i in 0...2
        {
            for j in 0...2
            {
                lowerRightSubgrid[i][j] = gameBoard.gameGrid[indexOffset + i][indexOffset + j]
            }
        }
        
        if(rotationDirection == .clockwise)
        {
            //Top Row
            gameBoard.gameGrid[3][3] = lowerRightSubgrid[2][0]
            gameBoard.gameGrid[3][4] = lowerRightSubgrid[1][0]
            gameBoard.gameGrid[3][5] = lowerRightSubgrid[0][0]
            
            //Middle Row
            gameBoard.gameGrid[4][3] = lowerRightSubgrid[2][1]
            gameBoard.gameGrid[4][4] = lowerRightSubgrid[1][1]
            gameBoard.gameGrid[4][5] = lowerRightSubgrid[0][1]
            
            //Bottom Row
            gameBoard.gameGrid[5][3] = lowerRightSubgrid[2][2]
            gameBoard.gameGrid[5][4] = lowerRightSubgrid[1][2]
            gameBoard.gameGrid[5][5] = lowerRightSubgrid[0][2]
        }
        else
        {
            if(rotationDirection == .anticlockwise)
            {
                //Bottom Row
                gameBoard.gameGrid[5][5] = lowerRightSubgrid[2][0]
                gameBoard.gameGrid[5][4] = lowerRightSubgrid[1][0]
                gameBoard.gameGrid[5][3] = lowerRightSubgrid[0][0]
                
                //Middle Row
                gameBoard.gameGrid[4][5] = lowerRightSubgrid[2][1]
                gameBoard.gameGrid[4][4] = lowerRightSubgrid[1][1]
                gameBoard.gameGrid[4][3] = lowerRightSubgrid[0][1]
                
                //Top Row
                gameBoard.gameGrid[3][5] = lowerRightSubgrid[2][2]
                gameBoard.gameGrid[3][4] = lowerRightSubgrid[1][2]
                gameBoard.gameGrid[3][3] = lowerRightSubgrid[0][2]
            }
        }
    }
    
    func aiPlaceMarble() throws -> (rowIndex: Int?, columnIndex: Int?)
    {
        var rowIndex: Int = Int.random(in: 0...5)
        var columnIndex: Int = Int.random(in: 0...5)
        var hasCellBeenFound: Bool = false
        var isBoardFull: Bool = false
        var marbleLocation: (rowIndex: Int?, columnIndex: Int?) = (nil, nil)
        
        if(!gameBoard.isAgainstAiOpponent)
        {
            throw GeneralException.IllegalState(message: "Cannot use function aiPlaceMarble. The gameBoard isAgainstAiOpponent property has been set to false.")
        }
        
        while(!hasCellBeenFound && !isBoardFull)
        {
            do
            {
                try placeMarble(rowIndex: rowIndex, columnIndex: columnIndex)
                marbleLocation.rowIndex = rowIndex
                marbleLocation.columnIndex = columnIndex
                hasCellBeenFound = true
            }
            catch GameBoardException.GameGridFull
            {
                isBoardFull = true
            }
            catch GameBoardException.CellOccupied
            {
                rowIndex = Int.random(in: 0...5)
                columnIndex = Int.random(in: 0...5)
            }
            catch
            {
                fatalError("Unaccounted for error thrown by placeMarble function")
            }
        }
        return marbleLocation
    }
    
    func aiRotateSubgrid() -> (subgrid: GameBoard.Subgrid, rotationDirection: GameBoard.RotationDirection)
    {
        var selectedSubgrid: GameBoard.Subgrid = .random()
        var selectedRotationDirection: GameBoard.RotationDirection = .random()
        var subgridRotationInfo: (subgrid: GameBoard.Subgrid, rotationDirection: GameBoard.RotationDirection) = (selectedSubgrid, selectedRotationDirection)
        
        rotateSubgrid(subgrid: selectedSubgrid, rotationDirection: selectedRotationDirection)
        
        return subgridRotationInfo
    }
    
    func checkWinCondition(rowIndex: Int, columnIndex: Int) -> PlayerProfile?
    {
        var winner: PlayerProfile? = nil
        
        winner = checkHorizontal(rowIndex: rowIndex, columnIndex: columnIndex)
        
        if(winner == nil)
        {
            winner = checkVertical(rowIndex: rowIndex, columnIndex: columnIndex)
            
            if(winner == nil)
            {
                winner = checkLeadingDiagonal(rowIndex: rowIndex, columnIndex: columnIndex)
                
                if(winner == nil)
                {
                    winner = checkAntiDiagonal(rowIndex: rowIndex, columnIndex: columnIndex)
                }
            }
        }
        
        return winner
    }
    private func checkHorizontal(rowIndex: Int, columnIndex: Int) -> PlayerProfile?
    {
        //Checks for a win horizontally. Performs the check left to right
        let currentMarble = gameBoard.gameGrid[rowIndex][columnIndex] //The most recently placed marble
        var currentHorizontalMarble: Marble? = nil
        var winner: PlayerProfile? = nil
        var count: Int = 1
        var checkRowIndex = rowIndex
        var checkColumnIndex = columnIndex
        var rightDeadEnd = false
        var foundLeftmostMarble = false
        var nextLeftHorizontalMarble: Marble? = nil
        
        while(!foundLeftmostMarble)
        {
            if(checkColumnIndex != 0) //If the current marble's column number is not at the very left already. Prevents checking an index that is out of the grid's bounds
            {
                nextLeftHorizontalMarble = gameBoard.gameGrid[checkRowIndex][checkColumnIndex - 1]
                
                if(nextLeftHorizontalMarble != nil && nextLeftHorizontalMarble?.marbleOwner === currentMarble?.marbleOwner) //If the next cell is not empty and if it belongs to the current player
                {
                    checkColumnIndex -= 1
                }
                else
                {
                    foundLeftmostMarble = true
                }
            }
            else
            {
                foundLeftmostMarble = true
            }
        }
        
        //Counts the marbles from the leftmost marble in the chain belonging to the current player
        while(count < 5 && !rightDeadEnd)
        {
            if(checkColumnIndex != 5) //If it is not at the very right already
            {
                checkColumnIndex += 1
                currentHorizontalMarble = gameBoard.gameGrid[checkRowIndex][checkColumnIndex] //next marble to the right
                
                if(currentHorizontalMarble != nil && currentHorizontalMarble?.marbleOwner === currentMarble?.marbleOwner)
                {
                    count += 1
                }
                else
                {
                    rightDeadEnd = true
                }
            }
            else
            {
                rightDeadEnd = true
            }
        }
        if(count == 5)
        {
            winner = currentMarble?.marbleOwner
        }
        
        return winner
    }
    
    private func checkVertical(rowIndex: Int, columnIndex: Int) -> PlayerProfile?
    {
        //This function checks for a win vertically. It performs the check from Top to bottom
        let currentMarble = gameBoard.gameGrid[rowIndex][columnIndex]
        var currentVerticalMarble: Marble? = nil
        var winner: PlayerProfile? = nil
        var count: Int = 1
        var checkRowIndex = rowIndex
        var checkColumnIndex = columnIndex
        var bottomDeadEnd = false
        var foundTopmostMarble = false
        var nextTopVerticalMarble: Marble? = nil
        
        //Finds the topmost marble belonging to the current player
        while(!foundTopmostMarble)
        {
            if(checkRowIndex != 0) //If the current marbles column number is not at the very top already. Prevents checking an out of bounds index
            {
                nextTopVerticalMarble = gameBoard.gameGrid[checkRowIndex - 1][checkColumnIndex]
                
                if(nextTopVerticalMarble != nil && nextTopVerticalMarble?.marbleOwner === currentMarble?.marbleOwner)
                {
                    checkRowIndex -= 1
                }
                else
                {
                    foundTopmostMarble = true
                }
            }
            else
            {
                foundTopmostMarble = true
            }
        }
        
        //Counts the marbles from the topmost marble in the chain belonging to the current player
        while(count < 5 && !bottomDeadEnd)
        {
            if(checkRowIndex != 5) //If it is not at the very bottom already
            {
                checkRowIndex += 1
                currentVerticalMarble = gameBoard.gameGrid[checkRowIndex][checkColumnIndex] //the next marble one step down
                if(currentVerticalMarble != nil && currentVerticalMarble?.marbleOwner === currentMarble?.marbleOwner)
                {
                    count += 1 //Found a marble belonging to the current player next to it so count is incremented
                }
                else
                {
                    bottomDeadEnd = true
                }
            }
            else
            {
                bottomDeadEnd = true
            }
        }
        if(count == 5)
        {
            winner = currentMarble?.marbleOwner
        }
        
        return winner
    }
    
    private func checkLeadingDiagonal(rowIndex: Int, columnIndex: Int) ->PlayerProfile?
    {
        //This function checks for a win condition diagonally from the top left corner to the bottom right corner.
        let currentMarble = gameBoard.gameGrid[rowIndex][columnIndex]
        var currentDiagonalMarble: Marble? = nil
        var winner: PlayerProfile? = nil
        var count: Int = 1
        var checkRowIndex = rowIndex
        var checkColumnIndex = columnIndex
        var bottomRightDiagonalDeadEnd = false
        var foundTopLeftmostMarble = false
        var nextTopLeftDiagonalMarble: Marble? = nil
        
        //Finds the topleftmost marble belonging to the current player
        while(!foundTopLeftmostMarble)
        {
            if(checkRowIndex != 0 && checkColumnIndex != 0) //If the current marbles column number is not at the top left already (prevent IndexOutOfBounds)
            {
                nextTopLeftDiagonalMarble = gameBoard.gameGrid[checkRowIndex - 1][checkColumnIndex - 1]
                
                if(nextTopLeftDiagonalMarble != nil && nextTopLeftDiagonalMarble?.marbleOwner === currentMarble?.marbleOwner)
                {
                    checkRowIndex -= 1
                    checkColumnIndex -= 1
                }
                else
                {
                    foundTopLeftmostMarble = true
                }
            }
            else
            {
                foundTopLeftmostMarble = true
            }
        }
        
        //Counts the marbles from the topleftmost marble in the chain belonging to the current player
        while(count < 5 && !bottomRightDiagonalDeadEnd)
        {
            if(checkRowIndex != 5 && checkColumnIndex != 5) //If it is not at the top left already
            {
                checkRowIndex += 1
                checkColumnIndex += 1
                currentDiagonalMarble = gameBoard.gameGrid[checkRowIndex][checkColumnIndex] //the next marble to the bottom right
                if(currentDiagonalMarble != nil && currentDiagonalMarble?.marbleOwner === currentMarble?.marbleOwner)
                {
                    count += 1//Found a marble belonging to the current player next to it so count is incremented
                }
                else
                {
                    bottomRightDiagonalDeadEnd = true
                }
            }
            else
            {
                bottomRightDiagonalDeadEnd = true
            }
        }
        if(count == 5)
        {
            winner = currentMarble?.marbleOwner
        }
        
        return winner
    }
    
    private func checkAntiDiagonal(rowIndex: Int, columnIndex: Int) -> PlayerProfile?
    {
        //This function checks for a win condition diagonally from the top right corner to the bottom left corner.
        let currentMarble = gameBoard.gameGrid[rowIndex][columnIndex] //There SHOULD be a marble here because this function requires arguments of the recently placed marble
        var currentDiagonalMarble: Marble? = nil
        var winner: PlayerProfile? = nil
        var count: Int = 1
        var checkRowIndex = rowIndex
        var checkColumnIndex = columnIndex
        var bottomLeftDiagonalDeadEnd = false
        var foundTopRightmostMarble = false
        var nextTopRightDiagonalMarble: Marble? = nil
        
        //Finds the toprightmost marble belonging to the current player
        while(!foundTopRightmostMarble)
        {
            if(checkRowIndex != 0 && checkColumnIndex != 5) //If the current marbles column number is not at the top right already (prevent IndexOutOfBounds)
            {
                nextTopRightDiagonalMarble = gameBoard.gameGrid[checkRowIndex - 1][checkColumnIndex + 1]
                
                if(nextTopRightDiagonalMarble != nil && nextTopRightDiagonalMarble?.marbleOwner === currentMarble?.marbleOwner)
                {
                    checkRowIndex -= 1
                    checkColumnIndex += 1
                }
                else
                {
                    foundTopRightmostMarble = true
                }
            }
            else
            {
                foundTopRightmostMarble = true
            }
        }
        
        //Counts the marbles from the toprightmost marble in the chain belonging to the current player
        while(count < 5 && !bottomLeftDiagonalDeadEnd)
        {
            if(checkRowIndex != 5 && checkColumnIndex != 0) //If it is not at the bottom left already
            {
                checkRowIndex += 1
                checkColumnIndex -= 1
                currentDiagonalMarble = gameBoard.gameGrid[checkRowIndex][checkColumnIndex] //the next marble to the bottom right
                if(currentDiagonalMarble != nil && currentDiagonalMarble?.marbleOwner === currentMarble?.marbleOwner)
                {
                    count += 1 //Found a marble belonging to the current player next to it so count is incremented
                }
                else
                {
                    bottomLeftDiagonalDeadEnd = true
                }
            }
            else
            {
                bottomLeftDiagonalDeadEnd = true
            }
        }
        if(count == 5)
        {
            winner = currentMarble?.marbleOwner
        }
        
        return winner
    }
    
    func checkWinConditionPostRotation() -> PlayerProfile?
    {
        var winner: PlayerProfile? = nil
        var i = 0
        var j = 0
        
        while(i <= 5 && winner == nil)
        {
            while(j <= 5 && winner == nil)
            {
                if(gameBoard.gameGrid[i][j] != nil)
                {
                    winner = checkWinCondition(rowIndex: i, columnIndex: j)
                }
                j += 1
            }
            i += 1
            j = 0
        }
        
        return winner
    }
    
    func didDrawHappen() -> Bool
    {
        var draw = false
        var winner: PlayerProfile? = nil
        var winnerCount = 0
        var i = 0
        var j = 0
        var hasPlayer1Won = false
        var hasPlayer2Won = false
        let maximumCapacity = gameBoard.gridSideLength * gameBoard.gridSideLength
        
        while(i <= 5 && winnerCount < 2)
        {
            while(j <= 5 && winnerCount < 2)
            {
                if(gameBoard.gameGrid[i][j] != nil)
                {
                    winner = checkWinCondition(rowIndex: i, columnIndex: j)
                    
                    if(winner === gameBoard.player1Profile && !hasPlayer1Won)
                    {
                        hasPlayer1Won = true
                        winnerCount += 1
                    }
                    if(winner === gameBoard.player2Profile && !hasPlayer2Won)
                    {
                        hasPlayer2Won = true
                        winnerCount += 1
                    }
                }
                j += 1
            }
            i += 1
            j = 0
        }
        
        if(gameBoard.numMarbles == maximumCapacity && !hasPlayer1Won && !hasPlayer2Won)
        {
            draw = true
        }
        if(winnerCount > 1)
        {
            draw = true
        }
        
        return draw
    }
}
