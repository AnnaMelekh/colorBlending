//
//  ViewController.swift
//  colorBlending
//
//  Created by Anna Melekhina on 11.09.2024.
//

import UIKit

final class ViewController: UIViewController, UIColorPickerViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton (frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        view.addSubview(button)
        button.backgroundColor = .systemGreen
        button.setTitle("Select color", for: .normal)
        button.center = view.center
        button.addTarget(self, action: #selector(didTapSelectColor), for: .touchUpInside)
    }
    @objc private func didTapSelectColor() {
        let colorPickerVC = UIColorPickerViewController()
        colorPickerVC.delegate = self
        colorPickerVC.supportsAlpha = false
        present(colorPickerVC, animated: true)
    }
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let _ = viewController.selectedColor
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        view.backgroundColor = color
    }
}

