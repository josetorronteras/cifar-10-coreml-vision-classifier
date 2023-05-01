//
//  ContentView.swift
//  CIFAR10VisionClassifier
//
//  Created by Jose Torronteras on 28/4/23.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - States
    @State private var showingImagePicker = false
    @State private var sourceType = UIImagePickerController.SourceType.photoLibrary
    @State private var image: UIImage?
    
    // MARK: - Observed Objects
    /// CIFAR10 Image classifier
    @ObservedObject var classification = ImageClassifier()
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .bottom) {
            
            // Image in background. Ignore safe area
            if let image = self.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Image(uiImage: UIImage())
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.all)
            }
            
            VStack {
                Text(classification.classificationLabel)
                    .padding(20)
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.black)
                    )
                
                // Menu: Photo library or Select camera
                Menu {
                    Button(action: {
                        showingImagePicker.toggle()
                        sourceType = .camera
                    }, label: {
                        Text("Take Photo")
                    })
                    
                    Button(action: {
                        showingImagePicker.toggle()
                        sourceType = .photoLibrary
                    }, label: {
                        Text("Choose Photo")
                    })
                } label: {
                    Image(systemName: "camera")
                        .padding()
                        .background(.black)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                .sheet(isPresented: $showingImagePicker, onDismiss: {
                    if let image = self.image {
                        classification.updateClassifications(for: image)
                    }
                }, content: {
                    ImagePicker(image: $image, sourceType: self.sourceType)
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
