//
//  WishlistViewController.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 27/07/2024.
//

import UIKit

protocol WishlistViewControllerProtocol: UIViewController {
    var presenter: WishlistPresenterProtocol { get set }
}

final class WishlistViewController: UIViewController {
    var presenter: WishlistPresenterProtocol

    private let wishlistView: WishlistViewProtocol

    // MARK: - Init
    init(wishlistView: WishlistViewProtocol, presenter: WishlistPresenterProtocol) {
        self.presenter = presenter
        self.wishlistView = wishlistView

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func loadView() {
        view = wishlistView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewController()
        // The initial data loading
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.isNavigationBarHidden = true
    }
}

// MARK: - Setup
extension WishlistViewController {
    private func setupViewController() {
        wishlistView.delegate = self
    }
}

// MARK: - WishlistViewDelegate
extension WishlistViewController: WishlistViewDelegate {
    func didSelectMovie(movieID: Int) {
        presenter.didSelectMovie(movieID: movieID)
    }

    func removeMovie(movieID: Int) {
        presenter.removeMovie(movieID: movieID)
    }
}
