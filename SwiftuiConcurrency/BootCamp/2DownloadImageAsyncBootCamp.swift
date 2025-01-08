//
//  DownloadImageAsyncBootCamp.swift
//  SwiftuiConcurrency
//
//  Created by hb on 12/12/24.
//

import SwiftUI
import Combine

// MARK: - Image Loader
class DownloadImageAsyncImageLoader {
    
    private let url: URL = URL(string: "https://picsum.photos/200")!
    
    /// - Download image using old escaping closures
    func downloadWithEscaping(completion: @escaping(_ image: UIImage?, _ error: Error?) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let data = data,
                let image = UIImage(data: data),
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else { return }
            completion(image, error)
        }
        .resume()
    }
    
    
    /// - Download images using combine and subscribers
    func downloadWithCombine() -> AnyPublisher<UIImage?, Error> {
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(handleResponse)
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    
    
    /// - Download images using async await
    func downloadWithAsyncAwait() async throws -> UIImage? {
        do {
            let (data, response) = try await  URLSession.shared.data(from: url)
            return handleResponse(data: data, response: response)
        } catch {
            throw(error)
        }
    }
    
    
    /// - Common mapping methods
    private func handleResponse(data: Data, response: URLResponse) -> UIImage? {
        guard let image = UIImage(data: data),
              let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300
        else { return nil }
        return image
    }
}


// MARK: - View Model
class DownloadImageAsyncViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    private let loader = DownloadImageAsyncImageLoader()
    private var cancellables = Set<AnyCancellable>()
    
    
    func fetchImage() async {
        
        /// - using escaping closure
        /*
        loader.downloadWithEscaping { [weak self] image, error in
            // back to main thread
            DispatchQueue.main.async {
                self?.image = image
            }
        }
         */
        
        
        /// - using combine
        /*
        loader.downloadWithCombine()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] image in
                self?.image = image
            }
            .store(in: &cancellables)
        */
        
        
        /// - using async await
        let image = try? await loader.downloadWithAsyncAwait()
        await MainActor.run {
            self.image = image
        }
    }
}


// MARK: - View
struct DownloadImageAsyncBootCamp: View {
    @StateObject private var vm = DownloadImageAsyncViewModel()
    
    var body: some View {
        demoImage
            .onAppear {
                Task {
                    await vm.fetchImage()
                }
            }
    }
}

#Preview {
    DownloadImageAsyncBootCamp()
}

extension DownloadImageAsyncBootCamp {
    @ViewBuilder
    private var demoImage: some View {
        VStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 250, height: 250)
                    .clipShape(.rect(cornerRadius: 10))
                    .shadow(radius: 10)
                    .onAppear {
                        debugPrint(image)
                    }
            }
        }
    }
}
