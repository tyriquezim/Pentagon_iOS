//
//  SnackbarViewModel.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 9/1/2026.
//
//This code was taken from the iOS Academy tutorial on Youtube. https://www.youtube.com/watch?v=oTPows48MRs

import UIKit

struct SnackbarViewModel
{
    let type: SnackbarViewType
    let text: String
    let image: UIImage?
}

enum SnackbarViewType
{
    case info
    case action(handler: () -> Void)
}
