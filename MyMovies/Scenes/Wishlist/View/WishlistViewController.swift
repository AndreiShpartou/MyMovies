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

        addShortLivedObservers()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        removeShortLivedObservers()
    }
}

// MARK: - Setup
extension WishlistViewController {
    private func setupViewController() {
        wishlistView.delegate = self
    }
}

// MARK: - ActionMethods
extension WishlistViewController {
    @objc
    private func didTapActiveTabBarItem() {
        // Handle active tab bar item
        wishlistView.setNilValueForScrollOffset()
    }
}

// MARK: - Helpers
extension WishlistViewController {
    private func addShortLivedObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didTapActiveTabBarItem),
            name: .activeTabBarItemRootVCTapped,
            object: nil
        )
    }

    private func removeShortLivedObservers() {
        NotificationCenter.default.removeObserver(
            self,
            name: .activeTabBarItemRootVCTapped,
            object: nil
        )
    }
}

// MARK: - WishlistViewDelegate
extension WishlistViewController: WishlistViewDelegate {
    func didSelectMovie(movieID: Int) {
        presenter.didSelectMovie(movieID: movieID)
    }
}

extension WishlistViewController: WishlistCollectionViewCellDelegate {
    func didTapRemoveButton(for movieID: Int) {
        presenter.didTapRemoveButton(for: movieID)
    }
}
