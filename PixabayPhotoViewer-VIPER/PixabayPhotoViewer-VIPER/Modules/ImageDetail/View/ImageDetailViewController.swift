//
//  ImageDetailViewController.swift
//  PixabayPhotoViewer-VIPER
//
//  Created by home on 2021/11/06.
//

import UIKit

protocol ImageDetailViewProtocol: Transitioner {
    func updateView(userName: String,
                    datailImage: Data,
                    tags: String,
                    views: Int,
                    downloads: Int)
    
    func showError(title: String, message: String)
}

class ImageDetailViewController: UIViewController {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var imageDetail: UIImageView!
    @IBOutlet weak var tags: UILabel!
    @IBOutlet weak var views: UILabel!
    @IBOutlet weak var downloads: UILabel!
    
    private var presenter: ImageDetailPresenterProtocol!
    func inject(presenter: ImageDetailPresenterProtocol) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.startFetch()
    }
}

extension ImageDetailViewController: ImageDetailViewProtocol {
    func updateView(userName: String,
                    datailImage: Data,
                    tags: String,
                    views: Int,
                    downloads: Int) {
        DispatchQueue.global().async { [weak self] in
            guard let image = UIImage(data: datailImage) else {
                return
            }
            
            DispatchQueue.main.async {
                self?.imageDetail?.image = image
                self?.userName.text = userName
                self?.tags.text = tags
                self?.views.text = String(views)
                self?.downloads.text = String(downloads)
            }
        }
    }
    
    func showError(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle:  UIAlertController.Style.alert)
        alert.addAction(.init(title: "OK", style: .default, handler: { [weak self] _ in
            self?.presenter.popViewController()
        }))
        present(viewController: alert, animated: true)
    }
}
