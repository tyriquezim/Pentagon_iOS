//
//  Marble.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 12/12/2025.
//

import Foundation

struct Marble
{
    let marbleOwner: PlayerProfile
    let marbleColour: MarbleColour
    
    init(marbleOwner: PlayerProfile, marbleColour: MarbleColour)
    {
        self.marbleOwner = marbleOwner
        self.marbleColour = marbleColour
    }
    
    enum MarbleColour: String, CaseIterable
    {
        case black = "Black"
        case blue = "Blue"
        case green = "Green"
        case orange = "Orange"
        case pink = "Pink"
        case purple = "Purple"
        case red = "Red"
        case yellow = "Yellow"
        case grey = "Grey"
        
        static func random() -> MarbleColour
        {
            let randomIndex = Int.random(in: 0..<allCases.count)
            
            return allCases[randomIndex]
        }
        
        static func random(caseArray: Array<MarbleColour>) -> MarbleColour
        {
            let randomIndex = Int.random(in: 0..<caseArray.count)
            
            return caseArray[randomIndex]
        }
    }
}
