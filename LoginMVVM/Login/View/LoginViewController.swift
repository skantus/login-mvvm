//
//  LoginViewController.swift
//  LoginMVVM
//
//  Created by Alejo Castaño on 07/11/2020.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    private let logoView: UIImageView = UIImageView()
    private let usernameTextField: UITextField = UITextField()
    private let passwordTextField: UITextField = UITextField()
    private let loginErrorDescriptionLabel: UILabel = UILabel()
    private let loginButton: UIButton = UIButton()
    
    var loginViewModel: LoginViewModel!
    
    private let didTapSignIn: PublishSubject = PublishSubject<Void>()
    private let bag = DisposeBag()
    
    //MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupViews()
        bindData()
        log.debug("LoginViewController mounted")
    }
}

//MARK: - Binding
extension LoginViewController {
    
    func bindData() {
        loginViewModel.credentialsInputErrorMessage.bind {
            self.loginErrorDescriptionLabel.isHidden = false
            self.loginErrorDescriptionLabel.text = $0
        }
        
        loginViewModel.isUsernameTextFieldHighLighted.bind {
            if $0 {
                self.highlightTextField(self.usernameTextField)
            }
        }
        
        loginViewModel.isPasswordTextFieldHighLighted.bind {
            if $0 {
                self.highlightTextField(self.passwordTextField)
            }
        }
        
        loginButton.rx.tap.subscribe(didTapSignIn).disposed(by: bag)
        
        didTapSignIn.subscribe { _ in
            self.loginButtonPressed()
        }.disposed(by: bag)
    }
}

//MARK: Actions
extension LoginViewController {
    
    func loginButtonPressed() {
        loginViewModel.updateCredentials(username: usernameTextField.text!, password: passwordTextField.text!)
        
        switch loginViewModel.credentialsInput() {
        case .Correct:
            login()
        case .Incorrect:
            return
        }
    }
    
    func login() {
        
        navigationController?.pushViewController(ViewController(), animated: true)
        
        loginViewModel.login { error in
            print("res: \(String(describing: error))")
        }
    }
    
    func highlightTextField(_ textField: UITextField) {
        textField.resignFirstResponder()
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.cornerRadius = 3
    }
}

//MARK: - SetupUI
extension LoginViewController {
    
    private func setupViews() {
        setupUI()
        addSubviews()
        setupAutoLayout()
    }
    
    private func setupUI() {
        logoView.contentMode = .scaleAspectFit
        logoView.clipsToBounds = true
        logoView.image = UIImage(named: "logo")
        
        usernameTextField.placeholder = "Email"
        usernameTextField.autocapitalizationType = .none
        usernameTextField.font = UIFont.systemFont(ofSize: 17)
        usernameTextField.borderStyle = UITextField.BorderStyle.roundedRect
        usernameTextField.autocorrectionType = UITextAutocorrectionType.no
        usernameTextField.keyboardType = UIKeyboardType.emailAddress
        usernameTextField.returnKeyType = UIReturnKeyType.next
        usernameTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        usernameTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        usernameTextField.delegate = self
        
        passwordTextField.placeholder = "Password"
        passwordTextField.font = UIFont.systemFont(ofSize: 17)
        passwordTextField.borderStyle = UITextField.BorderStyle.roundedRect
        passwordTextField.autocorrectionType = UITextAutocorrectionType.no
        passwordTextField.keyboardType = UIKeyboardType.default
        passwordTextField.returnKeyType = UIReturnKeyType.send
        passwordTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        passwordTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
        
        loginErrorDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        loginErrorDescriptionLabel.textAlignment = .center
        loginErrorDescriptionLabel.textColor = .systemRed
        loginErrorDescriptionLabel.font = UIFont(name: "Avenir Book", size: 13)
        loginErrorDescriptionLabel.text = "Error login"
        loginErrorDescriptionLabel.isHidden = false
        
        loginButton.backgroundColor = .red
        loginButton.titleLabel?.font = UIFont(name: "Arial", size: 15)
        loginButton.setTitle("Login In", for: .normal)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.layer.cornerRadius = 3
        // loginButton.addTarget(self, action: #selector(loginButtonPressed(_:)), for: .touchUpInside)
    }
    
    private func addSubviews() {
        view.addSubview(logoView)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginErrorDescriptionLabel)
        view.addSubview(loginButton)
    }
}

//MARK: - Setup AutoLayout
extension LoginViewController {
    
    private func setupAutoLayout() {
        
        logoView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(Layout.LogoView.marginTop)
            $0.height.equalTo(Layout.LogoView.height)
        }
        
        usernameTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logoView.snp.bottom).offset(Layout.UsernameTextField.marginTop)
            $0.height.equalTo(Layout.UsernameTextField.height)
            $0.width.equalToSuperview().inset(Layout.UsernameTextField.width)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(usernameTextField.snp.bottom).offset(Layout.PasswordTextField.marginTop)
            $0.height.equalTo(usernameTextField.snp.height)
            $0.width.equalTo(usernameTextField.snp.width)
        }
        
        loginErrorDescriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(passwordTextField.snp.bottom).offset(Layout.LoginErrorDescriptionLabel.marginTop)
            $0.height.equalTo(Layout.LoginErrorDescriptionLabel.height)
        }
        
        loginButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(loginErrorDescriptionLabel.snp.bottom).offset(Layout.LoginButton.marginTop)
            $0.height.equalTo(Layout.LoginButton.height)
            $0.width.equalToSuperview().inset(Layout.LoginButton.width)
        }
    }
}

//MARK: - UITextfield Delegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        loginErrorDescriptionLabel.isHidden = true
        usernameTextField.layer.borderWidth = 0
        passwordTextField.layer.borderWidth = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - Layouts
extension LoginViewController {
    struct Layout {
        struct LogoView {
            static let marginTop = 100
            static let height = 80
        }
        
        struct UsernameTextField {
            static let marginTop = 50
            static let height = 50
            static let width = 40
        }
        
        struct PasswordTextField {
            static let marginTop = 20
        }
        
        struct LoginErrorDescriptionLabel {
            static let marginTop = 10
            static let height = 20
        }
        
        struct LoginButton {
            static let marginTop = 10
            static let height = 50
            static let width = 40
        }
    }
}
