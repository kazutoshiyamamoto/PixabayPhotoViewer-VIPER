//
//  ImageDetail.swift
//  PixabayPhotoViewer-VIPER
//
//

import Foundation

protocol ImageDetailProtocol {
    func fetchImage(url: URL, completion: @escaping (Result<Data, Error>) -> ())
}

final class ImageDetail: ImageDetailProtocol {
    private var task: URLSessionTask?
    
    func fetchImage(url: URL, completion: @escaping (Result<Data, Error>) -> ()) {
        task = {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let imageData = data else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(imageData))
            }
            task.resume()
            return task
        }()
    }
}
