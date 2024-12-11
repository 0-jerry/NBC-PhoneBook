//
//  ErrorAlertPresentable.swift
//  NBC_PhoneBook
//
//  Created by t2023-m0072 on 12/11/24.
//

import UIKit

protocol ErrorAlertPresentable: UIViewController {
    
}

extension ErrorAlertPresentable {
    func presentErrorAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel))
        present(alert, animated: false)
    }
}
