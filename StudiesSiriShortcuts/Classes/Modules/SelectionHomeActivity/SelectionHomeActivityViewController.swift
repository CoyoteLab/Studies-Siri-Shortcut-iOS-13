//
//  ActivitySelectionViewController.swift
//  StudiesSiriShortcuts
//
//  Created by Stephan Yannick on 09/08/2019.
//  Copyright © 2019 Coyote Lab. All rights reserved.
//

import UIKit
import GooglePlaces
import IntentsSiriKit

// MARK: - SelectionHomeActivityViewController

final class SelectionHomeActivityViewController: UIViewController {
    
    // MARK: @IBOutlet properties
    
    @IBOutlet private weak var adressHomeLabel: UILabel!
    
    // MARK: Public properties
    
    private var viewModel: SelectionHomeActivityViewModelable = SelectionHomeActivityViewModel()
    
    // MARK: Private properties
    
    private enum SegueType: String {
        case mapView = "segueNavigationMapBoxViewController"
    }
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.didChangeActivity = { [weak self] activity in
            guard let self = self, let activity = activity else { return }
            self.userActivity = activity
            activity.becomeCurrent()
            
        }
        viewModel.didChangeAdress = { [weak self] address in
            guard let self = self else { return }
            guard let address = address else {
                self.adressHomeLabel.text = "Aucune adresse n'est enregistrée"
                return
            }
            self.adressHomeLabel.text = "Votre adresse est enregistrée pour \(address)"
        }
        viewModel.loadData()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier, let segueType = SegueType(rawValue: identifier) else {
            return
        }
        switch (segueType, segue.destination, userActivity) {
        case let (.mapView, vs as NavigationMapBoxViewController, .some(activity)):
            vs.restoreUserActivityState(activity)
        default:
            break
        }
    }

    // MARK: @IBAction
    
    @IBAction private func actionTapNavigateToGMSAutocomplete(_ sender: UIButton) {
        navigateToGMSAutocomplete()
    }
    
    @IBAction private func actionTapCleanBackup(_ sender: UIButton) {
        viewModel.cleanBackup()
    }

    // MARK: Private methods
    
    private func navigateToGMSAutocomplete() {
        let autocompleteViewController = GMSAutocompleteViewController()
        autocompleteViewController.tableCellBackgroundColor = UIColor.darkGray
        autocompleteViewController.delegate = self
        navigationController?.pushViewController(autocompleteViewController, animated: true)
    }
}

// MARK: - GMSAutocompleteViewControllerDelegate Implementation

extension SelectionHomeActivityViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        guard let name = place.name else {
            return
        }
        viewModel.changeAdress(name: name, location: place.coordinate)
        navigationController?.popViewController(animated: true)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        navigationController?.popViewController(animated: true)
    }
}


