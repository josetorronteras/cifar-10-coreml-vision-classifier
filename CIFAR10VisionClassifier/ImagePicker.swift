//
//  ImagePicker.swift
//  CIFAR10VisionClassifier
//
//  Created by Jose Torronteras on 1/5/23.
//
//  Article: https://designcode.io/swiftui-advanced-handbook-imagepicker
//

import SwiftUI

// MARK: - ImagePicker
struct ImagePicker: UIViewControllerRepresentable {
    
    // MARK: - Properties
    @Binding var image: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    
    // MARK: - Variables
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    // MARK: - Methods
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.image = image
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
