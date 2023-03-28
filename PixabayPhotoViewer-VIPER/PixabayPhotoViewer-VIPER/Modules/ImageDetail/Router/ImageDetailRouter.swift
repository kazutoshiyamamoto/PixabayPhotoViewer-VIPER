//
//  ImageDetailRouter.swift
//  PixabayPhotoViewer-VIPER
//
//

import UIKit

protocol ImageDetailWireframeProtocol: AnyObject {
    static func assembleModules(image: Image) -> UIViewController
    func popViewController()
}

class ImageDetailRouter {
    private(set) weak var view: ImageDetailViewProtocol!
    
    init(view: ImageDetailViewProtocol) {
        self.view = view
    }
}

extension ImageDetailRouter: ImageDetailWireframeProtocol {
    static func assembleModules(image: Image) -> UIViewController {
        let view = UIStoryboard(name: "ImageDetail", bundle: nil)
            .instantiateInitialViewController() as! ImageDetailViewController
        
        let router = ImageDetailRouter(view: view)
        
        let webClient = ImageDetail()
        let imageDetailGateway = ImageDetailGateway(webClient: webClient)
        let interactor = ImageDetailInteractor(imageDetailGateway: imageDetailGateway, image: image)
        
        let presenter = ImageDetailPresenter(view: view,
                                             router: router,
                                             interactor: interactor)
        
        view.inject(presenter: presenter)
        
        return view
    }
    
    func popViewController() {
        view.popViewController(animated: true)
    }
}
