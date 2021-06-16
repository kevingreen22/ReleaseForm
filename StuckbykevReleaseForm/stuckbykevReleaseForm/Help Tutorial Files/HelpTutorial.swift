//
//  HelpTutorial.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 5/19/19.
//  Copyright © 2019 Kevin Green. All rights reserved.
//

import Foundation
import UIKit
import Localize_Swift

public func showHelpTutorial(viewController: UIViewController) {
    switch viewController {
    case is MainViewController:
        playMainVCTutorial(controller: viewController as! MainViewController)
    case is CameraTabVC:
        playCameraTutorial(controller: viewController as! CameraTabVC)
    case is InfoTabVC:
        playInfoTutorial(controller: viewController as! InfoTabVC)
    case is LegalTabVC:
        playLegalTutorial(controller: viewController as! LegalTabVC)
    case is HealthTabVC:
        playHealthTutorial(controller: viewController as! HealthTabVC)
    default:
        break
    }
}



fileprivate var sender: UIView!
fileprivate var origin = CGPoint(x: 0, y: 0)
fileprivate let translationX: CGFloat = 75.0



fileprivate func playMainVCTutorial(controller: MainViewController) {
    let tutorialStrings: [String] = [
        "Tap the start button to begin a new form".localized(),
        "Search for yourself to auto-fill".localized()
    ]
    
    // First view of tutorial
    let helpView1 = HelpView()
    sender = controller.startButton
    origin = CGPoint(x: sender.frame.midX - translationX, y: sender.frame.minY)
    helpView1.frame.origin = origin
    helpView1.label.text = tutorialStrings[0]
    controller.view.bringSubviewToFront(helpView1)
    animateHelpViewIn(helpView: helpView1, controller: controller)
    delay(delay: 3.0) {
        animateHelpViewOut(helpView: helpView1)
        
        // Second view of tutorial
        let helpView2 = HelpView()
        sender = controller.searchBar
        origin = CGPoint(x: sender.frame.minX, y: sender.frame.maxY - 15)
        helpView2.frame.origin = origin
        helpView2.label.text = tutorialStrings[1]
        controller.view.bringSubviewToFront(helpView2)
        animateHelpViewIn(helpView: helpView2, controller: controller)
        delay(delay: 3.0) { animateHelpViewOut(helpView: helpView2) }
    }
    
    
}



fileprivate func playCameraTutorial(controller: CameraTabVC) {
    let tutorialStrings: [String] = [
        "Hold your ID in front of the camera".localized(),
        "Tap here to access the camera".localized(),
        "Double tap on any preview to delete it".localized()
    ]
    
    // First view of tutorial
    let helpView1 = HelpView()
    sender = controller.infoLabel1
    origin = CGPoint(x: sender.frame.midX - helpView1.width / 2 - translationX, y: sender.frame.minY)
    helpView1.frame.origin = origin
    helpView1.label.text = tutorialStrings[0]
    controller.view.bringSubviewToFront(helpView1)
    animateHelpViewIn(helpView: helpView1, controller: controller)
    delay(delay: 3.0) {
        animateHelpViewOut(helpView: helpView1)
        
        // Second view of tutorial
        let helpView2 = HelpView()
        sender = controller.startPhotoSessionButton
        origin = CGPoint(x: sender.frame.minX + 5, y: sender.frame.midY)
        helpView2.frame.origin = origin
        helpView2.label.text = tutorialStrings[1]
        controller.view.bringSubviewToFront(helpView2)
        animateHelpViewIn(helpView: helpView2, controller: controller)
        delay(delay: 3.0) {
            animateHelpViewOut(helpView: helpView2)
            
            // Third view of tutorial
            let helpView3 = HelpView()
            sender = controller.photoPreviewStackView
            origin = CGPoint(x: sender.center.x, y: sender.center.y - translationX)
            helpView3.frame.origin = origin
            helpView3.label.text = tutorialStrings[2]
            controller.view.bringSubviewToFront(helpView3)
            animateHelpViewIn(helpView: helpView3, controller: controller)
            delay(delay: 3.0) {
                animateHelpViewOut(helpView: helpView3)
            }
        }
    }
}


fileprivate func playInfoTutorial(controller: InfoTabVC) {
    let tutorialStrings: [String] = [
//        "Fill out your tattoo/piercing info".localized(),
        "Fill out personal info".localized(),
    ]
    
    // First view of tutorial
//    let helpView1 = HelpView()
//    sender = controller.shopInfoView
//    origin = CGPoint(x: sender.center.x - helpView1.width / 2 - translationX, y: sender.center.y)
//    helpView1.frame.origin = origin
//    helpView1.label.text = tutorialStrings[0]
//    controller.view.bringSubviewToFront(helpView1)
//    animateHelpViewIn(helpView: helpView1, controller: controller)
//    delay(delay: 3.0) {
//        animateHelpViewOut(helpView: helpView1)
    
        // Second view of tutorial
        let helpView2 = HelpView()
        sender = controller.bioInfoView
        origin = CGPoint(x: sender.center.x - helpView2.width / 2 - translationX, y: sender.center.y)
        helpView2.frame.origin = origin
        helpView2.label.text = tutorialStrings[1]
        controller.view.bringSubviewToFront(helpView2)
        animateHelpViewIn(helpView: helpView2, controller: controller)
        delay(delay: 3.0) {
            animateHelpViewOut(helpView: helpView2)
        }
    }
//}




fileprivate func playLegalTutorial(controller: LegalTabVC) {
    let tutorialStrings: [String] = [
        "Read and confirm each legal clause".localized(),
        "Scroll down for more clauses".localized()
    ]
    
    //    First view of tutorial
    let helpView1 = HelpView()
    sender = controller.view
    origin = CGPoint(x: sender.center.x - helpView1.width / 2 - translationX, y: sender.center.y)
    helpView1.frame.origin = origin
    helpView1.label.text = tutorialStrings[0]
    controller.view.bringSubviewToFront(helpView1)
    animateHelpViewIn(helpView: helpView1, controller: controller)
    delay(delay: 3.0) {
        animateHelpViewOut(helpView: helpView1)
        
        // Second view of tutorial
        let helpView2 = HelpView()
        sender = controller.view
        origin = CGPoint(x: sender.center.x - helpView2.width / 2 - translationX, y: sender.center.y)
        helpView2.frame.origin = origin
        helpView2.label.text = tutorialStrings[1]
        controller.view.bringSubviewToFront(helpView2)
        animateHelpViewIn(helpView: helpView2, controller: controller)
        delay(delay: 3.0) {
            animateHelpViewOut(helpView: helpView2)
        }
    }
}




fileprivate func playHealthTutorial(controller: HealthTabVC) {
    let tutorialStrings: [String] = [
        "Please select any health conditions that apply to you".localized()
    ]
    
    // First view of tutorial
    let helpView1 = HelpView()
    sender = controller.view
    origin = CGPoint(x: sender.center.x - helpView1.width / 2 - translationX, y: sender.center.y)
    helpView1.frame.origin = origin
    helpView1.label.text = tutorialStrings[0]
    controller.view.bringSubviewToFront(helpView1)
    animateHelpViewIn(helpView: helpView1, controller: controller)
    delay(delay: 3.0) {
        animateHelpViewOut(helpView: helpView1)
    }
}







// MARK: - ANIMATIONS

fileprivate func animateHelpViewIn(helpView: HelpView, controller: UIViewController) {
    helpView.alpha = 0
    controller.view.addSubview(helpView)
    
    UIView.animate(withDuration: 0.4) {
        helpView.transform = CGAffineTransform(translationX: translationX, y: 0)
        helpView.alpha = 1
    }
}

fileprivate func animateHelpViewOut(helpView: HelpView) {
    UIView.animate(withDuration: 0.2, animations: {
        helpView.alpha = 0.0
        helpView.transform = CGAffineTransform.init(translationX: translationX, y: -35)
    }) { (complete) in
        helpView.removeFromSuperview()
    }
}

