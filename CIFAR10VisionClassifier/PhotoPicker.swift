//
//  PhotoPicker.swift
//  CIFAR10VisionClassifier
//
//  Created by Jose Torronteras on 1/5/23.
//

import SwiftUI
import PhotosUI

// MARK: - PhotoPicker
struct PhotoPicker: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = PHPickerViewController
    
    // MARK: - Properties
    @Binding var image: UIImage?
    
    // MARK: - Methods
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .any(of: [.images])
        configuration.selectionLimit = 0
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(image: self.$image)
    }
}

// MARK: - Coordinator
extension PhotoPicker {
    
    final class Coordinator: NSObject, PHPickerViewControllerDelegate {
        
        @Binding var image: UIImage?
        
        init(image: Binding<UIImage?>) {
            self._image = image
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            if let itemProvider = results.first?.itemProvider,
               itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    DispatchQueue.main.async {
                        guard let uiimage = image as? UIImage else { return }
                        self?.image = uiimage
                    }
                }
            }
        }
    }
}
