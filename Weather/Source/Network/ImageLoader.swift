//
//  ImageLoader.swift
//  Weather
//
//  Created by jonathan saville on 11/09/2023.
//

import Foundation
import UIKit

@globalActor actor ImageLoader {
    
    static let shared = ImageLoader()

    private var images: [URLRequest: LoaderStatus] = [:]
    
    public func fetchIcon(id: String) async throws -> UIImage? {
        guard let url = URL(string: "https://openweathermap.org/img/wn/\(id)@2x.png") else { return nil }
        return try await fetch(url)
    }

    public func fetch(_ url: URL) async throws -> UIImage? {
        let request = URLRequest(url: url)
        return try await fetch(request)
    }

    public func fetch(_ urlRequest: URLRequest) async throws -> UIImage? {
        if let status = images[urlRequest] {
            switch status {
            case .fetched(let image):
                return image
            case .inProgress(let task):
                return try await task.value
            }
        }

        let task: Task<UIImage?, Error> = Task {
            let (imageData, _) = try await URLSession.shared.data(for: urlRequest)
            return UIImage(data: imageData)
        }

        images[urlRequest] = .inProgress(task)
        let image = try await task.value
        if let image = image {
            images[urlRequest] = .fetched(image)
        }
        return image
    }

    private enum LoaderStatus {
        case inProgress(Task<UIImage?, Error>)
        case fetched(UIImage)
    }
}
