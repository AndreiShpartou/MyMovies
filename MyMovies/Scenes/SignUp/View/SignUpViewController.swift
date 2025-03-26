//
//  SignUpViewController.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 26/03/2025.
//

import UIKit

protocol SignUpViewControllerProtocol: UIViewController {
    var presenter: SignUpPresenterProtocol { get set }
}

final class SignUpViewController: UIViewController, SignUpViewControllerProtocol {
    var presenter: SignUpPresenterProtocol
    private let signUpView: SignUpViewProtocol

    // MARK: - Init
    init(presenter: SignUpPresenterProtocol, signUpView: SignUpViewProtocol) {
        self.presenter = presenter
        self.signUpView = signUpView

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func loadView() {
        view = signUpView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewController()
        presenter.viewDidLoad()
    }
}

// MARK: - Setup
extension SignUpViewController {
    func setupViewController() {
        signUpView.delegate = self
    }
}

// MARK: - SignUpViewDelegate
extension SignUpViewController: SignUpViewDelegate {
    func didTapSignUpButton() {
        presenter.didTapSignUpButton()
    }
}

import SwiftUI

extension SignUpViewController {
    struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController

        func makeUIViewController(context: Context) -> some UIViewController {
            viewController
        }

        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    }

    func preview() -> some View {
        Preview(viewController: self).edgesIgnoringSafeArea(.all)
    }
}

struct ViewControllerProvider: PreviewProvider {
    static var previews: some View {
        Group {
            // change to your vc
            let signUpRouter = SignUpRouter()
            let signUpInteractor = SignUpInteractor()
            let signUpPresenter = SignUpPresenter(interactor: signUpInteractor, router: signUpRouter)
            let signUpView = SignUpView(frame: .zero)
            let signUpVC = SignUpViewController(presenter: signUpPresenter, signUpView: signUpView)
            signUpVC.preview()
        }
    }
}
