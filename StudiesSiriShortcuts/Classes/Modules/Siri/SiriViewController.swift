//
//  SiriViewController.swift
//  StudiesSiriShortcuts
//
//  Created by Stephan Yannick on 12/08/2019.
//  Copyright © 2019 Stephan Yannick. All rights reserved.
//

import UIKit
import Intents
import IntentsUI
import IntentsSiriKit


// MARK: - SelectionHomeActivityViewController

final class SiriViewController: UIViewController {

    @IBOutlet private weak var stackView: UIStackView!

    // MARK: Private properties
    
    private enum SegueType: String {
        case mapView = "segueNavigationMapBoxViewController"
    }
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSiriButtons(to:self.view)
    }

    // MARK: Private methods

    private func addSiriButtons(to view: UIView) {

        let directionIntent = GoToFavoriteIntent()
        directionIntent.suggestedInvocationPhrase = "Va vers un lieu favori avec coyote"

        let alertDeclarationIntent = RequestAlertIntent()
        alertDeclarationIntent.suggestedInvocationPhrase = "Déclare une alerte"

        let intents = [
            "Aller ou éditer un favori": directionIntent,
            "Déclarer une alerte": alertDeclarationIntent
        ]

        for intent in intents.enumerated() {

            guard let intentShortcut = INShortcut(intent: intent.element.value) else {
                return
            }

            let label = UILabel()
            label.text = intent.element.key

            let siriButton = INUIAddVoiceShortcutButton(style: .white)
            siriButton.translatesAutoresizingMaskIntoConstraints = false
            siriButton.shortcut = intentShortcut
            siriButton.delegate = self

            stackView.addArrangedSubview(label)
            stackView.addArrangedSubview(siriButton)
        }
    }
}

// MARK: - INUIAddVoiceShortcutButtonDelegate implementation

extension SiriViewController: INUIAddVoiceShortcutButtonDelegate {
    
    func present(_ addVoiceShortcutViewController: INUIAddVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        addVoiceShortcutViewController.delegate = self
        present(addVoiceShortcutViewController, animated: true, completion: nil)
    }
    
    func present(_ editVoiceShortcutViewController: INUIEditVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        editVoiceShortcutViewController.delegate = self
        present(editVoiceShortcutViewController, animated: true, completion: nil)
    }
}

// MARK: - INUIAddVoiceShortcutViewControllerDelegate implementation

extension SiriViewController: INUIAddVoiceShortcutViewControllerDelegate {
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        if let error = error as NSError? {
            print(error)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - INUIEditVoiceShortcutViewControllerDelegate implementation

extension SiriViewController: INUIEditVoiceShortcutViewControllerDelegate {
    
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController,
                                         didUpdate voiceShortcut: INVoiceShortcut?,
                                         error: Error?) {
        if let error = error as NSError? {
            print(error)
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController,
                                         didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

