//
//  CatalogViewController.swift
//  shop
//
//  Created by Ke4a on 10.11.2022.
//

import UIKit

/// Delegate controller input.
protocol CatalogViewControllerInput {
    /// Reload data collection view.
    func reloadCollectionView()

    /// Add product to basket.
    /// - Parameters:
    ///   - index: Index product.
    ///   - qt: Product Quantity.
    func addProductToCart(_ index: Int, qt: Int)

    /// Enable/disable loading animation.
    /// - Parameter isEnable: Loading is enable.
    func loadingAnimation(_ isEnable: Bool)
}

/// Delegate controller output.
protocol CatalogViewControllerOutput {
    /// Maximum page.
    var maxPage: Int { get }
    /// Current page.
    var currentPage: Int { get }
    /// Data catalogs.
    var data: [ResponseProductModel] { get }
    
    /// View call a request for data.
    /// - Parameters:
    ///   - page: Page.
    ///   - category: Category product.
    func viewFetchData(page: Int, category: Int?)

    /// View calls to add an item to the cart.
    /// - Parameters:
    ///   - index: Index product.
    ///   - qt: Product Quantity.
    func viewAddProductToCart(_ index: Int, qt: Int)

    /// View call a request for basket data.
    func viewFetchBasket()

    /// Get the quantity of the item in the cart.
    /// - Parameter index: Index product.
    /// - Returns: Product Quantity.
    func getQtToBasket(_ index: Int) -> Int
}

class CatalogViewController: UIViewController {
    // MARK: - Visual Components

    /// Screen view.
    private var catalogView: CatalogView {
        guard let view = self.view as? CatalogView else {
            let vc = CatalogView(self)
            self.view = vc
            return vc
        }

        return view
    }

    /// Presenter with screen control.
    private var presenter: CatalogViewControllerOutput?

    // MARK: - Initialization

    /// Presenter with screen control.
    /// - Parameter presenter: Presenter with screen control protocol
    init(presenter: CatalogViewControllerOutput) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()
        self.view = CatalogView(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        catalogView.setupUI()
        setupNavController()
        presenter?.viewFetchData(page: 1, category: nil)
        presenter?.viewFetchBasket()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
    }

    // MARK: - Setting UI Methods

    /// Settings navbar controller.
    private func setupNavController() {
        navigationItem.title = AppDataScreen.catalog.tittleNav

        navigationController?.navigationBar.tintColor = AppStyles.color.complete
        navigationController?.navigationBar.backgroundColor = AppStyles.color.background

        // Changes the color of the navbar title
        let textAttributes = [NSAttributedString.Key.foregroundColor: AppStyles.color.complete]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }

}

// MARK: - CatalogViewControllerInput

extension CatalogViewController: CatalogViewControllerInput {
    func loadingAnimation(_ isEnable: Bool) {
        DispatchQueue.main.async {
            self.catalogView.loadingAnimation(isEnable)
        }
    }

    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.catalogView.reloadCollectionView()
        }
    }
}

// MARK: - CatalogViewOutput

extension CatalogViewController: CatalogViewOutput {
    func getQtItem(_ index: Int) -> Int {
        presenter?.getQtToBasket(index) ?? 0
    }

    func addProductToCart(_ index: Int, qt: Int) {
        presenter?.viewAddProductToCart(index, qt: qt)
    }

    var data: [ResponseProductModel] {
        presenter?.data ?? []
    }
}