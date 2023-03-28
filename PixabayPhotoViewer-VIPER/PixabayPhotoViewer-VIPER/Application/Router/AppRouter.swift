//
//  AppRouter.swift
//  PixabayPhotoViewer-VIPER
//
//

import UIKit

protocol AppWireframeProtocol: AnyObject {
    func showSearchImageView()
}

final class AppRouter {
    private var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    static func assembleModules(window: UIWindow) -> AppPresenterProtocol {
        let router = AppRouter(window: window)
        let presenter = AppPresenter(router: router)
        
        return presenter
    }
}

extension AppRouter: AppWireframeProtocol {
    func showSearchImageView() {
        let searchImageView = SearchImageRouter.assembleModules()
        let navigationController = UINavigationController(rootViewController: searchImageView)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
