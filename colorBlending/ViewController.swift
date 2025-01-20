//
//  ViewController.swift
//  colorBlending
//
//  Created by Anna Melekhina on 11.09.2024.
//

import UIKit

var firstColorButton = UIButton()
var secondColorButton = UIButton()
private var selectedButton: UIButton?
private var color1: UIColor?

private var color2: UIColor?
private var colorResult: UIColor?

var resultView: UIView = {
    let resultView = UIButton()
    resultView.backgroundColor = .white
    resultView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        resultView.widthAnchor.constraint(equalToConstant: 90),
        resultView.heightAnchor.constraint(equalToConstant: 90),
    ])
    resultView.layer.borderColor = UIColor.black.cgColor
    resultView.layer.borderWidth = 0.5
    
    return resultView
}()

final class ViewController: UIViewController, UIColorPickerViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupUI()
        
        firstColorButton.addTarget(self, action: #selector(didTapSelectColor(_:)), for: .touchUpInside)
        secondColorButton.addTarget(self, action: #selector(didTapSelectColor(_:)), for: .touchUpInside)
        
    }
    
    func setupUI() {
        
        firstColorButton = setupColorButton()
        secondColorButton = setupColorButton()
        
        view.addSubview(firstColorButton)
        view.addSubview(secondColorButton)
        view.addSubview(resultView)
        
        NSLayoutConstraint.activate([
            firstColorButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstColorButton.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 300),
            secondColorButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondColorButton.centerYAnchor.constraint(equalTo: firstColorButton.bottomAnchor, constant: 150),
            
            resultView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultView.centerYAnchor.constraint(equalTo: secondColorButton.bottomAnchor, constant: 150),
            
        ])
        
    }
    
    @objc private func didTapSelectColor(_ sender: UIButton) {
        let colorPickerVC = UIColorPickerViewController()
        colorPickerVC.delegate = self
        colorPickerVC.supportsAlpha = false
        selectedButton = sender
        present(colorPickerVC, animated: true)
    }
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let _ = viewController.selectedColor
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        var color = viewController.selectedColor
        selectedButton?.backgroundColor = color
        
        if selectedButton === firstColorButton {
            color1 = color
        } else if selectedButton === secondColorButton {
            color2 = color
        }
        
        resultView.backgroundColor = mixColors()

        dismiss(animated: true)
        
    }
    
    private func getColors(color: UIColor?) -> (red: Int, green: Int, blue: Int)? {
        guard let color = color else { return nil }
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
        
            if color.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
                let redValue = Int(red * 255)
                let greenValue = Int(green * 255)
                let blueValue = Int(blue * 255)
                return (redValue, greenValue, blueValue)
            } else {
                print("error with colors")
                return nil
            }
        
    }
    
    private func mixColors() -> UIColor? {
        guard let color1Components = getColors(color: color1),
              let color2Components = getColors(color: color2) else {
            print("no colors")
            return nil
        }
        
        let red = (color1Components.red + color2Components.red) / 2
        let green = (color1Components.green + color2Components.green) / 2
        let blue = (color1Components.blue + color2Components.blue) / 2
        
        return UIColor(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: 1
        )
    }
    
    private func setupColorButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 90),
            button.heightAnchor.constraint(equalToConstant: 90),
        ])
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 0.5
        return button
    }
}


#Preview { ViewController() }

