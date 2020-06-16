//
//  PlaceSelectionVCUIViewControllerDelegateMethods.swift
//  VirtualTourist
//
//  Created by Agnidhra Gangopadhyay on 6/15/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import Foundation

extension PlaceSelectionVC {
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        toastMessage.isHidden = !editing
    }
}
