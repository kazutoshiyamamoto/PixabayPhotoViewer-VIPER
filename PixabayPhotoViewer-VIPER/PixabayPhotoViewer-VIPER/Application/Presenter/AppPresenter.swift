//
//  AppPresenter.swift
//  PixabayPhotoViewer-VIPER
//
//

import Foundation

protocol AppPresenterProtocol: AnyObject {
    func didFinishLaunch()
}

final class AppPresenter {
    private let router: AppWireframeProtocol
    
    init(router: AppWireframeProtocol) {
        self.router = router
    }
}

extension AppPresenter: AppPresenterProtocol {
    func didFinishLaunch() {
        router.showSearchImageView()
    }
}

