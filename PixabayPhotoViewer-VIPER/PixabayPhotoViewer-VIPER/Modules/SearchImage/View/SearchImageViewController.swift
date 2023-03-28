//
//  SearchImageViewController.swift
//  PixabayPhotoViewer-VIPER
//
//  Created by home on 2021/10/19.
//

import UIKit

protocol SearchImageViewProtocol: Transitioner {
    func reloadCollectionView()
    func showError(title: String, message: String)
}

class SearchImageViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var presenter: SearchImagePresenterProtocol!
    func inject(presenter: SearchImagePresenterProtocol) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        collectionView.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
        
        let flowLayout = UICollectionViewFlowLayout()
        let margin: CGFloat = 5.0
        flowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width - 20) / 3, height: (UIScreen.main.bounds.size.width - 20) / 3)
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        flowLayout.sectionInset = UIEdgeInsets(top: margin,
                                               left: margin,
                                               bottom: margin,
                                               right: margin)
        collectionView.collectionViewLayout = flowLayout
    }
}

extension SearchImageViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.clearImages()
        presenter.searchImages(query: searchBar.text, page: 1)
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
}

extension SearchImageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        presenter.didSelectItem(at: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentSize.height > 0 &&
            (scrollView.contentSize.height - scrollView.bounds.size.height) <= scrollView.contentOffset.y {
            presenter.searchImages(query: presenter.query, page: presenter.page)
        }
    }
}

extension SearchImageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfImages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        
        if let image = presenter.image(forItem: indexPath.row) {
            cell.configure(image: image)
        }
        
        return cell
    }
}

extension SearchImageViewController: SearchImageViewProtocol {
    func reloadCollectionView() {
        collectionView.reloadData()
    }
    
    func showError(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle:  UIAlertController.Style.alert)
        alert.addAction(.init(title: "OK", style: .default, handler: nil))
        present(viewController: alert, animated: true)
    }
}

