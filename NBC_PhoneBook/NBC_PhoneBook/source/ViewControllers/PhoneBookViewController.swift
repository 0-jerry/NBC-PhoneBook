//
//  EditorViewController.swift
//  NBC_PhoneBook
//
//  Created by t2023-m0072 on 12/8/24.
//

import UIKit

import SnapKit

let imageData = UIImage(systemName: "square.and.pencil.circle")!.pngData()!

/// 전화번호 생성 화면 ViewController
final class PhoneBookViewController: UIViewController {
    
    private weak var phoneBookManager = PhoneBookManager.shared
    
    private var data: PhoneNumber?
    
    var onPop: (() -> Void)?
    
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
        imageView.clipsToBounds = true
        
        imageView.backgroundColor = .white
        
        return imageView
    }()
    
    private let pokeRandomButton: UIButton = {
        let button = UIButton()
        button.setTitle("랜덤 이미지 생성", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.backgroundColor = .systemGray5
        button.contentMode = .center
        
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
        
        if pokeImageView.image == nil {
            defaultImage()
        }
        
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
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.height.equalTo(250)
            $0.width.equalTo(200)
            $0.centerX.equalToSuperview()
        }
        
        pokeImageView.snp.makeConstraints {
            $0.width.height.equalTo(200)
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
        
        let titleFont = UIFont.systemFont(ofSize: 23, weight: .bold)
        let itemFont = UIFont.systemFont(ofSize: 21, weight: .semibold)
        
        navigationController.navigationBar.titleTextAttributes = [.font: titleFont]
        
        let titleLabel = UILabel()
        titleLabel.text = "연락처 추가"
        titleLabel.font = titleFont
        
        self.navigationItem.titleView = titleLabel
        
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
        saveData()
        guard let navigationController else { return }
        onPop?()
        let _ = navigationController.popViewController(animated: false)
    }
    
    private func saveData() {
        guard let image = self.pokeImageView.image?.pngData(),
              let name = nameTextView.text,
              let number = phoneNumberTextView.text,
              let phoneBookManager else { return }
        
        let id = data?.id ?? UUID()
        
        let phoneNumber = PhoneNumber(id: id,
                                      pokeImage: image,
                                      name: name,
                                      number: number)
        
        if data == nil {
            phoneBookManager.creat(phoneNumber)
            self.data = phoneNumber
        } else {
            phoneBookManager.update(phoneNumber)
        }
    }
    
    func setData(_ phoneNumber: PhoneNumber) {
        self.data = phoneNumber
        if let image = UIImage(data: phoneNumber.pokeImage) {
            self.pokeImageView.image = image
        }
        
        self.nameTextView.text = phoneNumber.name
        self.phoneNumberTextView.text = phoneNumber.phoneNumber
    }
    
}

//TODO: URLSession or Alamofire 로 API 통신
extension PhoneBookViewController {
    
    //처음은 메타몽
    private func defaultImage() {
        fetchPokeImage(PokeData(from: 132))
    }
    
    
    //TODO: URLSession or Alamofire 로 API 통신
    @objc private func randomButtonTapped() {
        fetchPokeImage(PokeData())
    }
    
    private func fetchPokeImage(_ pokeData: PokeData) {
        guard let pngURL = pokeData.pngURL else { return }
        let urlRequest = URLRequest(url: pngURL)
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil,
                  let data,
                  let image = UIImage(data: data),
                  let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode) else { return }
            
            DispatchQueue.main.async {
                self.pokeImageView.image = image
            }
        }.resume()
    }
    
}

#Preview {
    PhoneBookViewController()
}
