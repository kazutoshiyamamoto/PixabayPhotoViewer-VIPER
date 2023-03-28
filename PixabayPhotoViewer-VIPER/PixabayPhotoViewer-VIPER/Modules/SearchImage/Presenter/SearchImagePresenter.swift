//
//  SearchImagePresenter.swift
//  PixabayPhotoViewer-VIPER
//
//  Created by home on 2021/10/22.
//

import Foundation

protocol SearchImagePresenterProtocol {
    var query: String? { get }
    var page: Int? { get }
    var numberOfImages: Int { get }
    func image(forItem item: Int) -> Image?
    func didSelectItem(at indexPath: IndexPath)
    func searchImages(query: String?, page: Int?)
    func clearImages()
}

final class SearchImagePresenter: SearchImagePresenterProtocol {
    private weak var view: SearchImageViewProtocol!
    private let router: SearchImageWireframeProtocol
    private let interactor: SearchImageUseCaseProtocol!
    
    init(view: SearchImageViewProtocol,
         router: SearchImageWireframeProtocol,
         interactor: SearchImageUseCaseProtocol) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    
    var query: String? {
        return interactor.query
    }
    
    var page: Int? {
        return interactor.pagination?.next
    }
    
    var numberOfImages: Int {
        return interactor.images.count
    }
    
    func image(forItem item: Int) -> Image? {
        guard item < numberOfImages else { return nil }
        return interactor.images[item]
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        guard let image = image(forItem: indexPath.row) else { return }
        router.transitionToImageDetail(image: image)
    }
    
    func searchImages(query: String?, page: Int?) {
        interactor.startFetch(query: query, page: page) { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.view?.reloadCollectionView()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.view?.showError(title: "エラー", message: error.localizedDescription)
                }
            }
        }
    }
    
    func clearImages() {
        interactor.clearImages()
        DispatchQueue.main.async {
            self.view?.reloadCollectionView()
        }
    }
}
