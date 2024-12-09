//
//  EditorViewController.swift
//  NBC_PhoneBook
//
//  Created by t2023-m0072 on 12/8/24.
//

import UIKit

import Alamofire
import SnapKit

/// 전화번호 생성 화면 ViewController
final class PhoneBookViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        configureNavigationController()
    }

}


//MARK: - Navigation Controller
extension PhoneBookViewController {
    
    private func configureNavigationController() {
        guard let navigationController = self.navigationController else { return }
        
        let titleFont = UIFont.systemFont(ofSize: 25, weight: .bold)
        let itemFont = UIFont.systemFont(ofSize: 21, weight: .semibold)
        
        navigationController.navigationBar.titleTextAttributes = [.font: titleFont]
        
        self.navigationItem.title = "연락처 추가"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "적용",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(applyButtonTapped))
        
        navigationItem.backBarButtonItem?.setTitleTextAttributes([.font: itemFont],
                                                                 for: .normal)
        
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([.font: itemFont],
                                                                 for: .normal)
  
    }
    
    @objc private func applyButtonTapped() {
        self.dismiss(animated: false, completion: saveData)
    }
    
    private func saveData() {
        
    }
    
}


extension PhoneBookViewController {
    
    private func fetchData<T: Decodable>(url: URL, completion: @escaping (Result<T, AFError>) -> Void) {
        AF.request(url).responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
    
}
