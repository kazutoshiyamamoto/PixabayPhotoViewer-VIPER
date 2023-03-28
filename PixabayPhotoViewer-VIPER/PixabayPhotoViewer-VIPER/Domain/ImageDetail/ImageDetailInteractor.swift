//
//  ImageDetailModel.swift
//  PixabayPhotoViewer-VIPER
//
//  Created by home on 2021/11/06.
//

import Foundation

protocol ImageDetailUseCaseProtocol {
    var image: Image { get }
    func startFetch(url: URL, completion: @escaping (Result<Data, Error>) -> ())
}

final class ImageDetailInteractor: ImageDetailUseCaseProtocol {
    private let imageDetailGateway: ImageDetailGatewayProtocol
    
    private(set) var image: Image
    
    private(set) var isFetching = false
    
    init(imageDetailGateway: ImageDetailGatewayProtocol, image: Image) {
        self.image = image
        self.imageDetailGateway = imageDetailGateway
    }
    
    func startFetch(url: URL, completion: @escaping (Result<Data, Error>) -> ()) {
        
        if isFetching { return }
        
        self.isFetching = true
        
        imageDetailGateway.fetchImage(url: url) { [weak self] result in
            switch result {
            case .success(let response):
                self?.isFetching = false
                completion(.success(response))
            case .failure(let error):
                self?.isFetching = false
                completion(.failure(error))
            }
        }
    }
}
