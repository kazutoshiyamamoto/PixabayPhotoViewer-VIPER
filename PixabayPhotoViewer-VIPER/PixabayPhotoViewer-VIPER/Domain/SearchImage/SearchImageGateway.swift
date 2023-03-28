//
//  SearchImageGateway.swift
//  PixabayPhotoViewer-VIPER
//
//

import Foundation

protocol SearchImageGatewayProtocol {
    func fetchImage(query: String,
                    page: Int,
                    completion: @escaping (Result<([Image], Pagination), Error>) -> ())
}

class SearchImageGateway: SearchImageGatewayProtocol {
    private let webClient: SearchImageProtocol
    init(webClient: SearchImageProtocol) {
        self.webClient = webClient
    }
    
    func fetchImage(query: String,
                    page: Int,
                    completion: @escaping (Result<([Image], Pagination), Error>) -> ()) {
        webClient.fetchImage(query: query, page: page) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
