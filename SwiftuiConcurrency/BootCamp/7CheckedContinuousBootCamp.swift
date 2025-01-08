//
//  CheckedContinuousBootCamp.swift
//  SwiftuiConcurrency
//
//  Created by hb on 16/12/24.
//

import SwiftUI

/**
 - We use the `checkedContinuation` method to convert a `non-async` function to an `async` function
 
    - We need to be careful that we need to `resume the continuation exactly once` otherwise the application might `crash` or `store large number of memory` if we are unable to resume the continuation properly .
 
 */

class CheckedContinuousNetworkManager {
    
    func getData(url: URL) async throws -> Data {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            throw error
        }
    }
    
    
    func getData2(url: URL) async throws -> Data {
        
        return try await withCheckedThrowingContinuation { contiunation in
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    contiunation.resume(returning: data)
                } else if let error = error {
                    contiunation.resume(throwing: error)
                } else {
                    contiunation.resume(throwing: URLError(.badURL))
                }
            }
            .resume()
        }
    }
    
    
    private func getHeartImageFromDBUsingClosure(completion: @escaping(_ image: UIImage) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            if let image = UIImage(systemName: "heart.fill") {
                completion(image)
            } else {
                debugPrint("Check your eyes")
            }
        }
    }
    
    func getHeartImageFromDB() async -> UIImage {
        let heartImage = await withCheckedContinuation { continuation in
            getHeartImageFromDBUsingClosure { image in
                continuation.resume(returning: image)
            }
        }
        return heartImage
    }
}


class CheckedContinuousViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    private let manager = CheckedContinuousNetworkManager()
        
    func getImage() async {
        guard let url = URL(string: "https://picsum.photos/200") else { return }
        do {
            let data = try await manager.getData2(url: url)
            if let image = UIImage(data: data) {
                await MainActor.run {
                    self.image = image
                }
            }
        } catch {
            debugPrint("Error : \(error.localizedDescription)")
        }
    }
    
    func getHeartImage() async {
        let heartImage = await manager.getHeartImageFromDB()
        self.image = heartImage
    }
}


struct CheckedContinuousBootCamp: View {
    
    @StateObject private var vm = CheckedContinuousViewModel()
    
    var body: some View {
        VStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .clipShape(.rect(cornerRadius: 10))
                    .shadow(radius: 10)
            }
        }
        .task {
            // await vm.getImage()
            await vm.getHeartImage()
        }
    }
}

#Preview {
    CheckedContinuousBootCamp()
}
