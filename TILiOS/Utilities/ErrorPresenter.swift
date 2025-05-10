//
//  ErrorPresenter.swift
//  TILiOS
//
//  Created by Rychillie Umpierre de Oliveira on 09/05/25.
//

import UIKit

enum ErrorPresenter {
    static func showError(message: String, on viewController: UIViewController?, dismissAction: ((UIAlertAction) -> Void)? = nil) {
        weak var weakViewController = viewController
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: dismissAction))
            weakViewController?.present(alertController, animated: true)
        }
    }
}
