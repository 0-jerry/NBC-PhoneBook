//
//  ViewController.swift
//  NBC_PhoneBook
//
//  Created by t2023-m0072 on 12/8/24.
//

import UIKit

import SnapKit

/// 메인 화면 ViewController
final class MainViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        configureNavigationController()
    }
    
}

//MARK: - NavigationController
extension MainViewController {
    
    //네비게이션 컨트롤러 설정 메서드
    private func configureNavigationController() {
        self.navigationItem.title = "친구 목록"
        self.navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 20, weight: .bold)]
        
        let addButton = UIBarButtonItem(title: "추가",
                                        style: .plain,
                                        target: self,
                                        action: #selector(pushEditerView))
        
        self.navigationItem.setRightBarButton(addButton, animated: false)
    }
    
    @objc private func pushEditerView() {
        guard let navigationController = self.navigationController else { return }
        navigationController.pushViewController(EditorViewController(), animated: false)
    }
    
}

//#Preview {
//    MainViewController()
//}
