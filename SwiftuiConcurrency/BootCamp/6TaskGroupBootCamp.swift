//
//  TaskGroupBootCamp.swift
//  SwiftuiConcurrency
//
//  Created by hb on 16/12/24.
//

import SwiftUI

class TaskGroupImageManager {
    
    func fetchImagesWithAsyncLet() async throws -> [UIImage] {
        
        async let fetchImage1 = self.fetchImage(urlString: "https://picsum.photos/200")
        async let fetchImage2 = self.fetchImage(urlString: "https://picsum.photos/200")
        async let fetchImage3 = self.fetchImage(urlString: "https://picsum.photos/200")
        async let fetchImage4 = self.fetchImage(urlString: "https://picsum.photos/200")
        
        do {
            let (image1, image2, Image3, image4) = await(try fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4)
            return [image1, image2, Image3, image4]
        } catch {
            throw error
        }
    }
    
    
    func fetchImagesUsingAsyncTaskGroup() async throws -> [UIImage] {
        
        let urlStrings = [
            "https://picsum.photos/200",
            "https://picsum.photos/200",
            "https://picsum.photos/200",
            "https://picsum.photos/200",
            "https://picsum.photos/200",
            "https://picsum.photos/200",
        ]
        
        /**
         - There are 2 types of task groups
            1- Task group that throw errors
            2- Task group that doesn't thorw errors
         */
        
        return try await withThrowingTaskGroup(of: UIImage?.self) { group in
            
            var images = [UIImage]()
            // performance update by adding the maximum capacity
            images.reserveCapacity(urlStrings.count)
            
            for urlString in urlStrings {
                
                // Always try to use an optional try? instead of try because if one try fails then the whole task will be failed and throw an error
                group.addTask {
                    try? await self.fetchImage(urlString: urlString)
                }
            }
            
            
            for try await image in group {
                if let image = image {
                    debugPrint("Returned Image:: \(image)")
                    images.append(image)
                }
            }
            
            return images
        }
    }
    
    
    
    private func fetchImage(urlString: String) async throws  -> UIImage {
        
        guard let url = URL(string: urlString) else {
            throw(URLError(.badURL))
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw(URLError(.badURL))
            }
        } catch {
            throw(error)
        }
    }
}


class TaskGroupViewModel: ObservableObject {
    @Published var images: [UIImage] = []
    private let manager = TaskGroupImageManager()
    
    func getImages() async {
        if let images = try? await manager.fetchImagesUsingAsyncTaskGroup() {
            self.images.append(contentsOf: images)
        }
    }
}


struct TaskGroupBootCamp: View {
    
    // MARK: - Constants
    private let url = URL(string: "https://picsum.photos/200")!
    private let columns: [GridItem] = [
        .init(.flexible()),
        .init(.flexible())
    ]
    
    // MARK: - Variables
    @StateObject private var vm = TaskGroupViewModel()
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(vm.images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .clipShape(.rect(cornerRadius: 10))
                            .frame(height: 200)
                            .shadow(radius: 10)
                    }
                }
                .padding()
            }
            .navigationTitle("Task group")
        }
        .task {
            await vm.getImages()
        }
    }
}

#Preview {
    TaskGroupBootCamp()
}
