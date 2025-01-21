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
private var colorResLabel = UILabel()
private var color1Label = UILabel()
private var color2Label = UILabel()
private var resetButton = UIButton()

private var color2: UIColor?
private var colorResult: UIColor?
let networkService = NetworkService()

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
        resetButton.addTarget(self, action: #selector(resetAll), for: .touchUpInside)
        
    }
    
    func setupUI() {
        
        firstColorButton = setupColorButton()
        secondColorButton = setupColorButton()
        colorResLabel.text = "color name"
        colorResLabel.translatesAutoresizingMaskIntoConstraints = false
        color1Label.translatesAutoresizingMaskIntoConstraints = false
        color1Label.text = "color name"
        color2Label.translatesAutoresizingMaskIntoConstraints = false
        color2Label.text = "color name"
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.setTitle("Reset", for: .normal)
        resetButton.backgroundColor = .systemBlue

        view.addSubview(firstColorButton)
        view.addSubview(secondColorButton)
        view.addSubview(resultView)
        view.addSubview(colorResLabel)
        view.addSubview(color1Label)
        view.addSubview(color2Label)
        view.addSubview(resetButton)

        NSLayoutConstraint.activate([
            firstColorButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstColorButton.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            secondColorButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondColorButton.centerYAnchor.constraint(equalTo: firstColorButton.bottomAnchor, constant: 150),
            
            resultView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultView.centerYAnchor.constraint(equalTo: secondColorButton.bottomAnchor, constant: 150),
            colorResLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colorResLabel.bottomAnchor.constraint(equalTo: resultView.topAnchor, constant: -10),
            
            color1Label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            color1Label.bottomAnchor.constraint(equalTo: firstColorButton.topAnchor, constant: -10),
            
            color2Label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            color2Label.bottomAnchor.constraint(equalTo: secondColorButton.topAnchor, constant: -10),
            
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetButton.bottomAnchor.constraint(equalTo: resultView.bottomAnchor, constant: 100),
            resetButton.widthAnchor.constraint(equalToConstant: 70),
            resetButton.heightAnchor.constraint(equalToConstant: 40)
            
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
        let color = viewController.selectedColor
        selectedButton?.backgroundColor = color
        
        if selectedButton === firstColorButton {
            color1 = color
            getColorsName(color: color1, label: color1Label)

        } else if selectedButton === secondColorButton {
            color2 = color
            getColorsName(color: color2, label: color2Label)
        }
        
        resultView.backgroundColor = mixColors()
        getColorsName(color: resultView.backgroundColor, label: colorResLabel)
        
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
    
    private func getColorsName(color: UIColor?, label: UILabel) {
        
        if let colorComponents = getColors(color: color) {
            print(colorComponents)
            networkService.fetchData(red: colorComponents.red, green: colorComponents.green, blue: colorComponents.blue) { colorName in
                if let colorName = colorName {
                    DispatchQueue.main.async {
                        label.text = colorName
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        label.text = "no color"
                    }
                }
            }
        }
    }
    
    @objc private func resetAll() {
        firstColorButton.backgroundColor = .white
        secondColorButton.backgroundColor = .white
        resultView.backgroundColor = .white
        colorResLabel.text = "color name"
        color1Label.text = "color name"
        color2Label.text = "color name"
        color1 = nil
        color2 = nil

    }
}

#Preview { ViewController() }

