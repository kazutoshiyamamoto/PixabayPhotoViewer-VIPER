//
//  ImageDetailPresenter.swift
//  PixabayPhotoViewer-VIPER
//
//  Created by home on 2021/11/06.
//

import Foundation

protocol ImageDetailPresenterProtocol {
    func startFetch()
    func popViewController()
}

final class ImageDetailPresenter: ImageDetailPresenterProtocol {
    private weak var view: ImageDetailViewProtocol!
    private let router: ImageDetailWireframeProtocol
    private let interactor: ImageDetailUseCaseProtocol!
    
    init(view: ImageDetailViewProtocol,
         router: ImageDetailWireframeProtocol,
         interactor: ImageDetailUseCaseProtocol) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    
    func startFetch() {
        interactor.startFetch(url: interactor.image.webformatURL) { [weak self] result in
            switch result {
            case .success(let imageData):
                DispatchQueue.main.async {
                    if let user = self?.interactor.image.user,
                       let tags = self?.interactor.image.tags,
                       let views = self?.interactor.image.views,
                       let downloads = self?.interactor.image.downloads {
                        self?.view.updateView(userName: user,
                                              datailImage: imageData,
                                              tags: tags,
                                              views: views,
                                              downloads: downloads)
                    } else {
                        self?.view.showError(title: "エラー",
                                             message: "時間をおいてから再度お試しください")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.view.showError(title: "エラー",
                                         message: error.localizedDescription)
                }
            }
        }
    }
    
    func popViewController() {
        router.popViewController()
    }
}
