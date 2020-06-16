//
//  VCUitilityExtension.swift
//  VirtualTourist
//
//  Created by Agnidhra Gangopadhyay on 6/13/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func saveCurrentContext() {        
        do {
            try CoreDataStackDetails.getSharedInstance().saveCurrentContext()
        } catch {
            showAlert(withTitle: "Error", message : "Encountered Some Issue While Saving Pin Location: \(error). Please Try Again")
        }
    }
    
    func showAlert(withTitle: String = "Information", message: String, action: (() -> Void)? = nil) {
        updateUIOnMainThread {
            let alert = UIAlertController(title: withTitle, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(alertAction) in
                action?()
            }))
            self.present(alert, animated: true)
        }
    }
    
    func updateUIOnMainThread(_ updateTheUI: @escaping () -> Void) {
        DispatchQueue.main.async {
            updateTheUI()
        }
    }
}

