//
//  ViewController.swift
//  LogoViewer
//
//  Created by Ambroise COLLON on 24/04/2018.
//  Copyright © 2018 OpenClassrooms. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBAction func didTapSearchButton() {
        searchLogo()
    }

    // Fonction recherche de logo et l'affiche.
    func searchLogo() {
        guard let domain = textField.text else { return }

        toggleActivityIndicator(shown: true)
        LogoService.shared.getLogo(domain: domain) { (success, data) in
            self.toggleActivityIndicator(shown: false)
            if success, let data = data {
                self.updateImage(with: data)
            } else {
                self.presentAlert()
            }
        }
    }
    // Fonction avec para Bool qui montre ou pas le bouton "activityIndicator" et le bouton "searchButton"
    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
        searchButton.isHidden = shown
    }
    // Fonction qui met à jour "imageView.image" à chaque nouvelle recherche.
    private func updateImage(with data: Data) {
        self.imageView.image = UIImage(data: data)
    }

    // Fonction "Alert" qui permet d'envoyer un message à l'utilisateur.
    private func presentAlert() {
        let alertVC = UIAlertController(title: "Error", message: "Could not find a logo.", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}

    // Extension qui permet...
    extension ViewController: UITextFieldDelegate {
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchLogo()
        return true
    }

    // Fonction qui permet de faire disparaitre le clavier.
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
}
