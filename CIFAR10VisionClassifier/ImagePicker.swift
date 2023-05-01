//
//  ImagePicker.swift
//  CIFAR10VisionClassifier
//
//  Created by Jose Torronteras on 1/5/23.
//
//  Article: https://designcode.io/swiftui-advanced-handbook-imagepicker (deprecated)
//

import SwiftUI

// MARK: - ImagePicker
struct ImagePicker: UIViewControllerRepresentable {
    
    typealias UIViewControllerRepresentableType = UIViewControllerRepresentableContext<ImagePicker>
    
    // MARK: - Properties
    @Binding var image: UIImage?
        
    // MARK: - Methods
    func makeUIViewController(context: UIViewControllerRepresentableType) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        imagePicker.cameraCaptureMode = .photo
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableType) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(image: self.$image)
    }
}

// MARK: - Coordinator
extension ImagePicker {
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        @Binding var image: UIImage?
        
        init(image: Binding<UIImage?>) {
            self._image = image
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            picker.dismiss(animated: true)
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.image = image
            }
        }
    }
}
