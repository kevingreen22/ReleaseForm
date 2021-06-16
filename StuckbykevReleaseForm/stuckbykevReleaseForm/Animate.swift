//
//  Animate.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 3/18/18.
//  Copyright © 2018 Kevin Green. All rights reserved.
//

import Foundation
import UIKit

public enum AnimationCurve: String {
    case EaseIn = "easeIn"
    case EaseOut = "easeOut"
    case EaseInOut = "easeInOut"
    case Linear = "linear"
    case Spring = "spring"
    case EaseInSine = "easeInSine"
    case EaseOutSine = "easeOutSine"
    case EaseInOutSine = "easeInOutSine"
    case EaseInQuad = "easeInQuad"
    case EaseOutQuad = "easeOutQuad"
    case EaseInOutQuad = "easeInOutQuad"
    case EaseInCubic = "easeInCubic"
    case EaseOutCubic = "easeOutCubic"
    case EaseInOutCubic = "easeInOutCubic"
    case EaseInQuart = "easeInQuart"
    case EaseOutQuart = "easeOutQuart"
    case EaseInOutQuart = "easeInOutQuart"
    case EaseInQuint = "easeInQuint"
    case EaseOutQuint = "easeOutQuint"
    case EaseInOutQuint = "easeInOutQuint"
    case EaseInExpo = "easeInExpo"
    case EaseOutExpo = "easeOutExpo"
    case EaseInOutExpo = "easeInOutExpo"
    case EaseInCirc = "easeInCirc"
    case EaseOutCirc = "easeOutCirc"
    case EaseInOutCirc = "easeInOutCirc"
    case EaseInBack = "easeInBack"
    case EaseOutBack = "easeOutBack"
    case EaseInOutBack = "easeInOutBack"
}



class Animate {
    
    /// Animates the settings gear barButtonItem. Automatically dispatches the main queue.
    ///
    /// - Parameter settingsButton: The UIButton to animate.
    static func animateSettingsButton(settingsButton: SpringButton) {
        settingsButton.animation = "flipY"
        settingsButton.curve = AnimationCurve.EaseIn.rawValue
        settingsButton.duration = 1.8
        settingsButton.damping = 0.7
        settingsButton.rotate = 2.1
        settingsButton.force = 1.0
        settingsButton.x = 7.0
        settingsButton.velocity = 0.7
        settingsButton.scaleX = 1.0
        DispatchQueue.main.async {
            settingsButton.animate()
        }
    }
    
    /// Animates the collectionView cell when tapped. Automatically dispatches the main queue.
    ///
    /// - Parameter cell: The UICollectionViewCell to animate.
    static func collectionView(cell: ClientQueueCell) {
        cell.clientIDImage.animation = "pop"
        cell.clientIDImage.curve = AnimationCurve.Linear.rawValue
        cell.clientIDImage.duration = 0.6
        DispatchQueue.main.async {
            cell.clientIDImage.animate()
        }
    }
    
    
    /// Animates the collectionView cells when the edit/done barButtonItem is tapped.
    ///
    /// - Parameters:
    ///   - collectionView: The UICollectionViewCell to animate.
    ///   - delay: The amount of delay time.
    static func startJiggle(collectionView: UICollectionView, with delay: CFTimeInterval) {
        let degrees: CGFloat = 3.0
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        animation.beginTime = CACurrentMediaTime() + delay
        animation.duration = 0.6
        animation.isCumulative = true
        animation.repeatCount = Float.infinity
        animation.values = [0.0,
                            degreesToRadians(degrees: -degrees) * 0.25,
                            0.0,
                            degreesToRadians(degrees: degrees) * 0.25,
                            0.0,
                            degreesToRadians(degrees: -degrees) * 0.25,
                            0.0,
                            degreesToRadians(degrees: degrees) * 0.25,
                            0.0]
        animation.fillMode = CAMediaTimingFillMode.forwards;
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.isRemovedOnCompletion = true
        
        for cell in collectionView.visibleCells {
            cell.layer.add(animation, forKey: "jiggle")
        }
    }
    
    /// Stops the animation of the collectionView cells when the edit/done barButtonItem is tapped.
    ///
    /// - Parameter collectionView: The UICollectionView that is currently animating.
    static func stopJiggling(collectionView: UICollectionView) {
        for cell in collectionView.visibleCells {
            cell.layer.removeAnimation(forKey: "jiggle")
            cell.layer.removeAllAnimations()
            cell.transform = CGAffineTransform.identity
            cell.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        }
    }
    
    
    /// Animates the language chooser button. Automatically dispatches the main queue.
    ///
    /// - Parameter button: The UIButton to animate
    static func languageButton(for button: SpringButton) {
        button.animation = "flipY"
        button.curve = AnimationCurve.Linear.rawValue
        button.duration = 1.0
        button.rotate = 2.0
        DispatchQueue.main.async {
            button.animate()
        }
    }
    
    
    /// A heart beat animation that repeats.
    ///
    /// - Parameter anyView:  Any view that conforms to Animatable.
    static func heartBeat(for anyView: Any, duration: Double = 3.0, delay: Double = 3.0, force: Double = 2, curveString: String = AnimationCurve.Linear.rawValue) {
        switch anyView {
        case is SpringButton:
            guard let button = anyView as? UIButton else { return }
            UIView.animate(withDuration: duration, delay: delay, options: [.curveEaseIn, .repeat], animations: {
                button.transform = CGAffineTransform(scaleX: 1.7, y: 1.7)
                button.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                button.transform = CGAffineTransform.identity
            })
            
        case is CAShapeLayer:
            guard let shapeLayer = anyView as? CAShapeLayer else { return }
            UIView.animate(withDuration: duration, delay: delay, animations: {
                let animation = CAKeyframeAnimation()
                animation.keyPath = "transform.scale"
                animation.values = [0, 0.2*force, -0.2*force, 0.2*force, 0]
                animation.keyTimes = [0, 0.2, 0.3, 0.4, 0.5, 1]
                animation.timingFunction = getTimingFunction(curve: curveString, force: force)
                animation.duration = CFTimeInterval(duration)
                animation.isAdditive = true
                animation.repeatCount = .infinity
                animation.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
                shapeLayer.add(animation, forKey: "pop")
            })
            
        default:
            break
        }
    }
    
    
    
    
    
    // MARK: - Generic Animations
    
    /// A basic pop animation for a button
    ///
    /// - Parameter button: The UIButton to animate.
    static func pop(for button: SpringButton, duration: CGFloat = 0.3, loop: Bool, completion: @escaping () -> ()) {
        button.animation = "pop"
        button.curve = AnimationCurve.EaseOut.rawValue
        button.duration = duration
        loop ? (button.repeatCount = Float.infinity) : (button.repeatCount = 1.0)
        DispatchQueue.main.async {
            button.animateToNext {
                completion()
            }
        }
    }
    
    /// A basic flash animation for a button.
    ///
    /// - Parameter button: The UIButton to animate.
    static func flash(for button: SpringButton, duration: CGFloat = 0.3, loop: Bool, completion: @escaping () -> ()) {
        button.animation = "flash"
        button.curve = AnimationCurve.Linear.rawValue
        button.duration = duration
        loop ? (button.repeatCount = Float.infinity) : (button.repeatCount = 1.0)
        DispatchQueue.main.async {
            button.animateToNext() {
                completion()
            }
        }
    }
    
    
    static func glareStar(for button: UIButton) {
        UIView.animate(withDuration: 0.5) {
            let imageLayer = CALayer()
            imageLayer.backgroundColor = UIColor.clear.cgColor
            let centerPoint = CGPoint(x: button.bounds.width / 2, y: button.bounds.height / 2)
            imageLayer.bounds = CGRect(x: centerPoint.x, y: centerPoint.y , width: 30, height: 30)
            imageLayer.position = CGPoint(x: centerPoint.x + 12 ,y: centerPoint.y - 12)
            imageLayer.contents = UIImage(named: "glareStar.png")?.cgImage
            button.layer.addSublayer(imageLayer)
                        
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotationAnimation.toValue = 2*CGFloat.pi
            rotationAnimation.duration = 4
            rotationAnimation.repeatCount = .infinity
            rotationAnimation.fillMode = CAMediaTimingFillMode.forwards
            rotationAnimation.isRemovedOnCompletion = false
            imageLayer.add(rotationAnimation, forKey: nil)
        }
    }
    
    
    
    
    
    
    
    private static func getTimingFunction(curve: String, force: Double = 1) -> CAMediaTimingFunction {
        if let curve = AnimationCurve(rawValue: curve) {
            switch curve {
            case .EaseIn: return CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
            case .EaseOut: return CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            case .EaseInOut: return CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            case .Linear: return CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            case .Spring: return CAMediaTimingFunction(controlPoints: 0.5, 1.1+Float(force/3), 1, 1)
            case .EaseInSine: return CAMediaTimingFunction(controlPoints: 0.47, 0, 0.745, 0.715)
            case .EaseOutSine: return CAMediaTimingFunction(controlPoints: 0.39, 0.575, 0.565, 1)
            case .EaseInOutSine: return CAMediaTimingFunction(controlPoints: 0.445, 0.05, 0.55, 0.95)
            case .EaseInQuad: return CAMediaTimingFunction(controlPoints: 0.55, 0.085, 0.68, 0.53)
            case .EaseOutQuad: return CAMediaTimingFunction(controlPoints: 0.25, 0.46, 0.45, 0.94)
            case .EaseInOutQuad: return CAMediaTimingFunction(controlPoints: 0.455, 0.03, 0.515, 0.955)
            case .EaseInCubic: return CAMediaTimingFunction(controlPoints: 0.55, 0.055, 0.675, 0.19)
            case .EaseOutCubic: return CAMediaTimingFunction(controlPoints: 0.215, 0.61, 0.355, 1)
            case .EaseInOutCubic: return CAMediaTimingFunction(controlPoints: 0.645, 0.045, 0.355, 1)
            case .EaseInQuart: return CAMediaTimingFunction(controlPoints: 0.895, 0.03, 0.685, 0.22)
            case .EaseOutQuart: return CAMediaTimingFunction(controlPoints: 0.165, 0.84, 0.44, 1)
            case .EaseInOutQuart: return CAMediaTimingFunction(controlPoints: 0.77, 0, 0.175, 1)
            case .EaseInQuint: return CAMediaTimingFunction(controlPoints: 0.755, 0.05, 0.855, 0.06)
            case .EaseOutQuint: return CAMediaTimingFunction(controlPoints: 0.23, 1, 0.32, 1)
            case .EaseInOutQuint: return CAMediaTimingFunction(controlPoints: 0.86, 0, 0.07, 1)
            case .EaseInExpo: return CAMediaTimingFunction(controlPoints: 0.95, 0.05, 0.795, 0.035)
            case .EaseOutExpo: return CAMediaTimingFunction(controlPoints: 0.19, 1, 0.22, 1)
            case .EaseInOutExpo: return CAMediaTimingFunction(controlPoints: 1, 0, 0, 1)
            case .EaseInCirc: return CAMediaTimingFunction(controlPoints: 0.6, 0.04, 0.98, 0.335)
            case .EaseOutCirc: return CAMediaTimingFunction(controlPoints: 0.075, 0.82, 0.165, 1)
            case .EaseInOutCirc: return CAMediaTimingFunction(controlPoints: 0.785, 0.135, 0.15, 0.86)
            case .EaseInBack: return CAMediaTimingFunction(controlPoints: 0.6, -0.28, 0.735, 0.045)
            case .EaseOutBack: return CAMediaTimingFunction(controlPoints: 0.175, 0.885, 0.32, 1.275)
            case .EaseInOutBack: return CAMediaTimingFunction(controlPoints: 0.68, -0.55, 0.265, 1.55)
            }
        }
        return CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
    }
    
}

