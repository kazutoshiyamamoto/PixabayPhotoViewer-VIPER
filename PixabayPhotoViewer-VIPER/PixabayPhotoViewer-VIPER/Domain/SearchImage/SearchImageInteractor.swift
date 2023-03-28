//
//  SearchImageUseCase.swift
//  PixabayPhotoViewer-VIPER
//
//

import Foundation

protocol SearchImageUseCaseProtocol: AnyObject {
    var images: [Image] { get }
    var query: String? { get }
    var pagination: Pagination? { get }
    func startFetch(query: String?,
                    page: Int?,
                    completion: @escaping (Result<(), Error>) -> ())
    func clearImages()
}

final class SearchImageInteractor: SearchImageUseCaseProtocol {
    private let searchImageGateway: SearchImageGatewayProtocol
    init(searchImageGateway: SearchImageGatewayProtocol) {
        self.searchImageGateway = searchImageGateway
    }
    
    private(set) var images: [Image] = []
    private(set) var query: String?
    private(set) var pagination: Pagination?
    private(set) var isFetching = false

    func startFetch(query: String?,
                    page: Int?,
                    completion: @escaping (Result<(), Error>) -> ()) {
        guard let query = query, let page = page else { return }
        guard !query.isEmpty else { return }
        
        if isFetching { return }
        
        self.isFetching = true
        
        searchImageGateway.fetchImage(query: query, page: page) { [weak self] result in
            switch result {
            case .success(let response):
                self?.images.append(contentsOf: response.0)
                self?.query = query
                self?.pagination = response.1
                self?.isFetching = false
                completion(.success(()))
            case .failure(let error):
                self?.isFetching = false
                completion(.failure(error))
            }
        }
    }
    
    func clearImages() {
        images = []
    }
}
