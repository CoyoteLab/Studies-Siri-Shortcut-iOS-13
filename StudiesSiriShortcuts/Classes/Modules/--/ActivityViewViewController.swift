//
//
//  HomeViewController.swift
//  SiriShortcutsStudies
//
//  Created by Stephan Yannick on 31/07/2019.
//  Copyright © 2019 Stephan Yannick. All rights reserved.
//

import UIKit
import os.log

// MARK: - ActivityViewController

final class ActivityViewController: UIViewController {

    // MARK: @IBOutlet

    @IBOutlet fileprivate weak var cityStartTextField: UITextField!
    @IBOutlet fileprivate weak var cityEndTextField: UITextField!
    @IBOutlet fileprivate weak var citySwitch: UISwitch!

    // MARK: Public properties

    var viewModel: ActivityViewModelable?

    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.cityEndTextField.alpha =  0
        cityStartTextField.delegate = self
        cityEndTextField.delegate = self
        viewModel?.didRestoreActivityValue = { [weak self] (enums) in
            guard let self = self else { return }
            for value in enums {
                switch value {
                 case  .start(let text):
                     self.cityStartTextField.text = text
                 case .end(let text):
                     self.citySwitch.isOn = true
                     self.cityEndTextField.alpha = 1
                     self.cityEndTextField.text = text
                 }
            }

        }
        viewModel?.didChangeActivity = { [weak self] activity in
            guard let self = self else { return }
            self.userActivity = activity
            self.userActivity?.becomeCurrent()
        }
        viewModel?.viewDidLoad()
    }

    // MARK: @IBAction

    @IBAction func actionDidSwitch(_ sender: UISwitch) {
        UIView.animate(withDuration: 0.3) {
            self.cityEndTextField.alpha = sender.isOn ? 1 : 0
        }
    }

}

extension ActivityViewController: UITextFieldDelegate {

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case cityStartTextField:
            viewModel?.didEndEdting(type: .start(textField.text))
        case cityEndTextField:
            viewModel?.didEndEdting(type: .end(textField.text))
        default:
            break
        }


        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(false)
        return true
    }
}
