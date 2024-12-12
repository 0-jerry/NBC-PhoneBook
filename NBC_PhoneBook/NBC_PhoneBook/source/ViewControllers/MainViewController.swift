//
//  ViewController.swift
//  NBC_PhoneBook
//
//  Created by t2023-m0072 on 12/8/24.
//

import UIKit

import CoreData
import SnapKit

/// 메인 화면 ViewController
final class MainViewController: UIViewController, ErrorAlertPresentable {
        
    
    private let pokeContactManager = PokeContactManager.shared
    
    // 연락처 데이터
    private var datas: [PokeContact] = []
    
    // 헤더뷰
    private let headerView = UIView()
    
    // 전화번호부 테이블 뷰
    private lazy var phoneBookTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        
        tableView.register(PokeContactTableViewCell.self,
                                forCellReuseIdentifier: PokeContactTableViewCell.id)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    //뷰를 메모리에 불러온 뒤 실행
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        setupHeaderView()
        setUpPhoneBookTableView()
    }
    
    //뷰가 화면에 나타날 때 실행
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        loadDatas()
    }
    
    //데이터 설정 메서드
    private func loadDatas() {
        do {
            let datas = try pokeContactManager.read()
            self.datas = datas
            self.phoneBookTableView.reloadData()
        } catch {
            presentErrorAlert("read failed")
        }
    }
    
}

//MARK: - NavigationController

extension MainViewController {
    
    // 헤더뷰 설정 메서드
    private func setupHeaderView() {
        let titleLabel = UILabel()
        titleLabel.text = "친구 목록"
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        
        let addButton = UIButton()
        addButton.setTitle("추가", for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        addButton.setTitleColor(.systemBlue, for: .normal)
        addButton.addTarget(self, action: #selector(pushPhoneBookViewController), for: .touchUpInside)
        
        view.addSubview(headerView)
        
        [
         titleLabel,
         addButton
        ].forEach { headerView.addSubview($0) }
        
        headerView.snp.makeConstraints {
            $0.height.equalTo(80)
            $0.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.height.equalToSuperview()
        }
        
        addButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(50)
            $0.width.equalTo(70)
        }
        
    }
    
    // PhoneBookViewController 푸쉬 액션
    @objc private func pushPhoneBookViewController() {
        guard let navigationController = self.navigationController else { return }
        let phoneBookViewController = makePhoneBookViewController(nil)
        navigationController.pushViewController(phoneBookViewController, animated: true)
    }
    
    // PhoneBookViewController 설정 및 반환
    private func makePhoneBookViewController(_ data: PokeContact?) -> PhoneBookViewController {
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
            $0.top.equalTo(headerView.snp.bottom).offset(20)
        }
    }
    
    // 셀 수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    // 테이블 뷰에 셀 반환
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let pokeContactCell = tableView.dequeueReusableCell(withIdentifier: PokeContactTableViewCell.id,
                                                                  for: indexPath) as? PokeContactTableViewCell else {
            return UITableViewCell()
        }
        
        let pokeContact = datas[indexPath.row]
        pokeContactCell.configureData(pokeContact)
        
        return pokeContactCell
    }
    
    // 셀 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    // 셀 선택시 실행
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let pokeContactCell = tableView.cellForRow(at: indexPath) as? PokeContactTableViewCell,
              let data = pokeContactCell.data,
              let navigationController = self.navigationController else { return }
        
        let phoneBookViewController = makePhoneBookViewController(data)
        
        navigationController.pushViewController(phoneBookViewController, animated: true)
    }
    
    // 셀 수정 (삭제)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let data = datas[indexPath.row]
            do {
                try pokeContactManager.delete(data)
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
