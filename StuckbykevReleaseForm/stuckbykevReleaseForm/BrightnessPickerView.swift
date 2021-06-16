//
//  BrightnessPickerView.swift
//
//  Created by Kevin Green on 6/30/17.
//
//

import UIKit

fileprivate enum BrightnessPickerViewConstant {
    static let brightnessPickerSliderHeightMin: CGFloat = 2.0
    static let uiSliderHeightDefault: CGFloat = 31.0
}

public typealias ColorChangeBlock = (_ color: UIColor?) -> Void

@available(iOS 9.0, *)
open class BrightnessPickerView: UIView {
    
    //***************************************************************
    //MARK:- Open constant
    //***************************************************************
   
    /// User can use this value to change the slider height.
    open var brightnessPickerSliderHeight: CGFloat = 6.0 //Min value
    
    
    
    //***************************************************************
    //MARK:- Instance Variables
    //***************************************************************
    
    fileprivate var currentBrightnessValue : CGFloat = 0.0
    fileprivate var currentSliderColor = UIColor.clear
    fileprivate var brightnessImage: UIImage!
    fileprivate var slider: UISlider!
    
    open var didChangeColor: ColorChangeBlock?
    
    
    
    //***************************************************************
    //MARK:- Override Functions
    //***************************************************************
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor.clear
        update()
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        if slider == nil {
            let sliderRect = CGRect(x: rect.origin.x, y:  (rect.size.height - BrightnessPickerViewConstant.uiSliderHeightDefault) * 0.5,
                                    width: rect.width, height: BrightnessPickerViewConstant.uiSliderHeightDefault)
            slider = UISlider(frame: sliderRect)
            slider.setValue(0, animated: false)
            slider.addTarget(self, action: #selector(onSliderValueChange), for: UIControl.Event.valueChanged)
            slider.minimumTrackTintColor = UIColor.clear
            slider.maximumTrackTintColor = UIColor.clear
            
            addSubview(slider)
            
            slider.translatesAutoresizingMaskIntoConstraints = false
            slider.leadingAnchor.constraint(equalTo: slider.superview!.leadingAnchor, constant: 0).isActive = true
            slider.topAnchor.constraint(equalTo: slider.superview!.topAnchor, constant: 0).isActive = true
            slider.trailingAnchor.constraint(equalTo: slider.superview!.trailingAnchor, constant: 0).isActive = true
            slider.bottomAnchor.constraint(equalTo: slider.superview!.bottomAnchor, constant: 0).isActive = true
            
            
        }
        
        let heigthForSliderImage = max(brightnessPickerSliderHeight, BrightnessPickerViewConstant.brightnessPickerSliderHeightMin)
        let sliderImageRect = CGRect(x: rect.origin.x, y: (rect.size.height - heigthForSliderImage) * 0.5,
                                     width: rect.width, height: heigthForSliderImage)
        if brightnessImage != nil {
            brightnessImage.draw(in: sliderImageRect)
        }
        
    }
    
    
    
    //***************************************************************
    //MARK:- Internal Functions
    //***************************************************************
    
    @objc func onSliderValueChange(slider: UISlider) {
        currentBrightnessValue = CGFloat(slider.value)
        currentSliderColor = UIColor(hue: 1, saturation: 0, brightness: currentBrightnessValue, alpha: 1)
        self.didChangeColor?(currentSliderColor)
        print("Slider moved") // debugging
    }
}



@available(iOS 9.0, *)
fileprivate extension BrightnessPickerView {
    func update() {
        if brightnessImage == nil {
            let heigthForSliderImage = max(brightnessPickerSliderHeight, BrightnessPickerViewConstant.brightnessPickerSliderHeightMin)
            let size: CGSize = CGSize(width: frame.width, height: heigthForSliderImage)
            brightnessImage = generateBRIGHTNESSImage(size)
        }
    }
    
    func generateBRIGHTNESSImage(_ size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let heigthForSliderImage = max(brightnessPickerSliderHeight, BrightnessPickerViewConstant.brightnessPickerSliderHeightMin)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIBezierPath(roundedRect: rect, cornerRadius: heigthForSliderImage * 0.5).addClip()
        
        for x: Int in 0 ..< Int(size.width) {
            UIColor(white: CGFloat(CGFloat(x) / size.width), alpha: 1.0).set()
            let temp = CGRect(x: CGFloat(x), y: 0, width: 1, height: size.height)
            UIRectFill(temp)
        }
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    
}

