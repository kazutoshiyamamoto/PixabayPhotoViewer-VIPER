//
//  ImageDetailGateway.swift
//  PixabayPhotoViewer-VIPER
//
//

import Foundation

protocol ImageDetailGatewayProtocol {
    func fetchImage(url: URL, completion: @escaping (Result<Data, Error>) -> ())
}

class ImageDetailGateway: ImageDetailGatewayProtocol {
    private let webClient: ImageDetailProtocol
    init(webClient: ImageDetailProtocol) {
        self.webClient = webClient
    }
    
    func fetchImage(url: URL, completion: @escaping (Result<Data, Error>) -> ()) {
        webClient.fetchImage(url: url) { [weak self] result in
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

