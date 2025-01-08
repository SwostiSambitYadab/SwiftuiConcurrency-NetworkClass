//
//  AsyncLetBootCamp.swift
//  SwiftuiConcurrency
//
//  Created by hb on 16/12/24.
//

import SwiftUI

struct AsyncLetBootCamp: View {
    
    // MARK: - Constants
    private let url = URL(string: "https://picsum.photos/200")!
    private let columns: [GridItem] = [
        .init(.flexible()),
        .init(.flexible())
    ]
    
    // MARK: - Variables
    @State private var images: [UIImage] = []
    
    // MARK: - Main View
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(images, id: \.self) { image in
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
            .navigationTitle("Async Let")
        }
        .onAppear {
            
            /**
                - When using a single Task and multiple await methods the await methods will execute one by one serially, so in order to make them execute simultaneously we can use `multiple Tasks` or `async let`
             
                - `Async let`s can be used for different functions irrespective of their return types
                    - These can be used when you open a screen and need to call 2 - 3 Apis to load data and show them in the screen at the same time .
             */
            
            Task {
                // Multiple async let calls with different return types
                /*
                do {
                    
                    async let fetchImage1 = fetchImage()
                    async let fetchTitle1 = fetchTitle()
                    
                    let (image1, title1) = await(try fetchImage1, fetchTitle1)
                    images.append(image1)
                    debugPrint("NEW TITLE :: \(title1)")
                    
                } catch {
                    debugPrint("Error :: \(error.localizedDescription)")
                }
                */
                
                // Multiple async let calls with same return types
                
                do {
                    async let fetchImage1 = fetchImage()
                    async let fetchImage2 = fetchImage()
                    async let fetchImage3 = fetchImage()
                    async let fetchImage4 = fetchImage()
                    
                    let (image1, image2, image3, image4) = await (try fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4)
                    
                    images.append(contentsOf: [
                        image1, image2, image3, image4
                    ])
                } catch {
                    debugPrint("Error:: \(error.localizedDescription)")
                }
            }
            
            // using traditional image fetch requests using try await
            Task {
                do {
                    let image1 = try await fetchImage()
                    let image2 = try await fetchImage()
                    let image3 = try await fetchImage()
                    let image4 = try await fetchImage()
                    
                    images.append(contentsOf: [
                        image1, image2, image3, image4
                    ])
                } catch {
                    debugPrint("Error:: \(error.localizedDescription)")
                }
            }
        }
    }
}

#Preview {
    AsyncLetBootCamp()
}

extension AsyncLetBootCamp {
    
    private func fetchImage() async throws -> UIImage {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badURL)
            }
        } catch {
            throw error
        }
    }
    
    func fetchTitle() async -> String {
        return "New Title"
    }
}
