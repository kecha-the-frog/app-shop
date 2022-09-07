//
//  ProductService.swift
//  shop
//
//  Created by Ke4a on 07.09.2022.
//

import Foundation

/// Product Service.
class ProductService<Parser: ResponseParserProtocol> {
    // MARK: - Public Properties

    let productId: Int
    var data: Parser.Model?

    // MARK: - Private Properties

    private let network: NetworkProtocol
    private let decoder: Parser

    // MARK: - Initialization
    
    init(_ network: NetworkProtocol, _ decoder: Parser) {
        self.network = network
        self.decoder = decoder

        self.productId = 123
    }

    // MARK: - Public Methods

    /// Fetch async data.
    /// The decoded models are written to the date property.
    func fetchAsync() {
        DispatchQueue.global(qos: .background).async {
            self.network.fetch(.product(123)) {
                // Отключил пока вызывается в appDelegate, так как там не сохраняется
                // [weak self]
                result in

                // guard let self = self else { return }

                switch result {
                case .success(let data):
                    guard let response = try? self.decoder.decode(data: data) else { return }
                    self.data = response
                    print(self.data)
                case .failure:
                    break
                }
            }
        }
    }
}