//
//  EditorViewController.swift
//  NBC_PhoneBook
//
//  Created by t2023-m0072 on 12/8/24.
//

import UIKit

//import Alamofire
import SnapKit

/// 전화번호 생성 화면 ViewController
final class PhoneBookViewController: UIViewController {
    
    private let pokeImageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.contentMode = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private let pokeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 100
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.image = UIImage(systemName: "pencil.circle")
        imageView.clipsToBounds = true
        imageView.backgroundColor = .white
        
        return imageView
    }()
    
    private let pokeRandomButton: UIButton = {
        let button = UIButton()
        button.setTitle("랜덤 이미지 생성", for: .normal)
        button.backgroundColor = .systemGray5
        button.setTitleColor(.black, for: .normal)
        
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    private let textViewStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.contentMode = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        return stackView
    }()
    
    private let nameTextView: UITextView = {
        let textView = UITextView()
        textView.textContentType = .name
        textView.font = .systemFont(ofSize: 17, weight: .regular)
        textView.textColor = .black
        textView.text = "이름"
        
        textView.layer.cornerRadius = 8
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 2
        
        textView.isScrollEnabled = false
        textView.isEditable = true
        
        return textView
    }()
    
    private let phoneNumberTextView: UITextView = {
        let textView = UITextView()
        textView.textContentType = .telephoneNumber
        textView.font = .systemFont(ofSize: 17, weight: .regular)
        textView.textColor = .black
        textView.text = "전화번호"
        
        textView.layer.cornerRadius = 8
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 2
        
        textView.isScrollEnabled = false
        textView.isEditable = true
        
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        configureUI()
        configureNavigationController()
        
        startImage()
        self.pokeRandomButton.addTarget(self,
                                        action: #selector(randomButtonTapped),
                                        for: .touchUpInside)
    }
    
}

//MARK: - Configure UI
extension PhoneBookViewController {
    
    private func configureUI() {
                
        [
            pokeImageStackView,
            textViewStackView
        ].forEach { view.addSubview($0) }
        
        [
            pokeImageView,
            pokeRandomButton
        ].forEach { pokeImageStackView.addArrangedSubview($0) }
        
        [
            nameTextView,
            phoneNumberTextView
        ].forEach { textViewStackView.addArrangedSubview($0) }
        
        pokeImageStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(250)
            $0.width.equalTo(200)
            $0.centerX.equalToSuperview()
        }
        
        pokeImageView.snp.makeConstraints {
            $0.width.height.equalTo(200)
        }
        
        pokeRandomButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        textViewStackView.snp.makeConstraints {
            $0.top.equalTo(pokeImageStackView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(80)
        }
        
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

//TODO: URLSession or Alamofire 로 API 통신
extension PhoneBookViewController {
    
    //처음은 메타몽
    private func startImage() {
        guard let pngURL = PokeData(from: 132).pngURL,
              let data = try? Data(contentsOf: pngURL),
              let image = UIImage(data: data) else { return }
        
        DispatchQueue.main.async {
            self.pokeImageView.image = image
        }
    }
    
    
    //TODO: URLSession or Alamofire 로 API 통신
    @objc private func randomButtonTapped() {
        guard let pngURL = PokeData().pngURL,
              let data = try? Data(contentsOf: pngURL),
              let image = UIImage(data: data) else { return }
        
        DispatchQueue.main.async {
            self.pokeImageView.image = image
        }
    }
    
}

#Preview {
    PhoneBookViewController()
}
