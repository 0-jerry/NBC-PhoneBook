//
//  ViewController.swift
//  NBC_PhoneBook
//
//  Created by t2023-m0072 on 12/8/24.
//

import UIKit

import CoreData

/// 메인 화면 ViewController
final class MainViewController: UIViewController, ErrorAlertPresentable {
        
    private let phoneBookManager = PhoneBookManager.shared
    
    private var datas: [PhoneNumber] = []

    private lazy var phoneBookTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        
        tableView.register(PhoneNumberTableViewCell.self,
                                forCellReuseIdentifier: PhoneNumberTableViewCell.id)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    //뷰를 메모리에 불러온 뒤 실행
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        setUpNavigationController()
        setUpPhoneBookTableView()
//        configurePhoneBookTableView()
    }
    
    //뷰가 화면에 나타날 때 실행
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDatas()
    }
    
    //데이터 설정 메서드
    private func loadDatas() {
        do {
            let datas = try phoneBookManager.read()
            self.datas = datas
            self.phoneBookTableView.reloadData()
        } catch {
            presentErrorAlert("read failed")
        }
    }
    
}

//MARK: - NavigationController

extension MainViewController {
    
    // 네비게이션 컨트롤러 설정 메서드
    private func setUpNavigationController() {
        
        let titleFont = UIFont.systemFont(ofSize: 23, weight: .bold)
        let itemFont = UIFont.systemFont(ofSize: 21, weight: .semibold)
        
        let titleLabel = UILabel()
        titleLabel.text = "친구 목록"
        titleLabel.font = titleFont
        
        let addButton = UIBarButtonItem(title: "추가",
                                        style: .plain,
                                        target: self,
                                        action: #selector(pushPhoneBookViewController))
        
        addButton.setTitleTextAttributes([.font: itemFont], for: .normal)
        
        self.navigationItem.titleView = titleLabel
        self.navigationItem.setRightBarButton(addButton, animated: false)
    }
    
    // PhoneBookViewController 푸쉬 액션
    @objc private func pushPhoneBookViewController() {
        guard let navigationController = self.navigationController else { return }
        let phoneBookViewController = makePhoneBookViewController(nil)
        navigationController.pushViewController(phoneBookViewController, animated: false)
    }
    
    // PhoneBookViewController 설정 및 반환
    private func makePhoneBookViewController(_ data: PhoneNumber?) -> PhoneBookViewController {
        let phoneBookViewController = PhoneBookViewController()
        if let data { phoneBookViewController.setData(data) }
    
        return phoneBookViewController
    }
}


//MARK: - TableViewController

extension MainViewController: UITableViewDataSource, UITableViewDelegate  {
    
    // TableView 레이아웃 설정
    private func setUpPhoneBookTableView() {
        self.view.addSubview(phoneBookTableView)

        phoneBookTableView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(30)
        }
    }
    
    // 셀 수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    // 테이블 뷰에 셀 반환
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let phoneNumberCell = tableView.dequeueReusableCell(withIdentifier: PhoneNumberTableViewCell.id,
                                                                  for: indexPath) as? PhoneNumberTableViewCell else {
            return UITableViewCell()
        }
        
        let phoneNumber = datas[indexPath.row]
        phoneNumberCell.configureData(phoneNumber)
        
        return phoneNumberCell
    }
    
    // 셀 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    // 셀 선택시 실행
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let phoneNumberCell = tableView.cellForRow(at: indexPath) as? PhoneNumberTableViewCell,
              let data = phoneNumberCell.data,
              let navigationController = self.navigationController else { return }
        
        let phoneBookViewController = makePhoneBookViewController(data)
        
        navigationController.pushViewController(phoneBookViewController, animated: false)
    }
    
    // 셀 수정 (삭제)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let data = datas[indexPath.row]
            do {
                try phoneBookManager.delete(data)
            } catch {
                presentErrorAlert("delete failed")
            }
            loadDatas()
        }
    }
    
}

#Preview {
    MainViewController()
}
