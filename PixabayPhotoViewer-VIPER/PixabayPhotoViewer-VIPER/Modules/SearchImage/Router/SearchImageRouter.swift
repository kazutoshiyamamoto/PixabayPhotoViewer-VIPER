//
//  SearchImageRouter.swift
//  PixabayPhotoViewer-VIPER
//
//

import UIKit

protocol SearchImageWireframeProtocol: AnyObject {
    static func assembleModules() -> UIViewController
    func transitionToImageDetail(image: Image)
}

class SearchImageRouter {
    private(set) weak var view: SearchImageViewProtocol!
    
    init(view: SearchImageViewProtocol) {
        self.view = view
    }
}

extension SearchImageRouter: SearchImageWireframeProtocol {
    static func assembleModules() -> UIViewController {
        let view = UIStoryboard(name: "SearchImage", bundle: nil).instantiateInitialViewController() as! SearchImageViewController
        
        let router = SearchImageRouter(view: view)
        
        let webClient = SearchImage()
        let searchImageGateway = SearchImageGateway(webClient: webClient)
        let interactor = SearchImageInteractor(searchImageGateway: searchImageGateway)
        
        let presenter = SearchImagePresenter(view: view,
                                             router: router,
                                             interactor: interactor)
        
        view.inject(presenter: presenter)
        
        return view
    }
    
    func transitionToImageDetail(image: Image) {
        let detailView = ImageDetailRouter.assembleModules(image: image)
        view.navigationController?.pushViewController(detailView, animated: true)
    }
}
