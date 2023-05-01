//
//  ImageClassifier.swift
//  CIFAR10VisionClassifier
//
//  Created by Jose Torronteras on 28/4/23.
//

import SwiftUI
import CoreML
import Vision

class ImageClassifier: ObservableObject {
    
    // MARK: - Properties
    @Published var classificationLabel: String = "Add a photo."
    
    // MARK: - Variables
    lazy var model: VNCoreMLModel = {
        do {
            let configuration = MLModelConfiguration()
            let imageClassifierWrapper = try CIFAR10(configuration: configuration)
            // Get the underlying model instance.
            let imageClassifierModel = imageClassifierWrapper.model
            let imageClassifierVisionModel = try VNCoreMLModel(for: imageClassifierModel)
            return imageClassifierVisionModel
        } catch {
            fatalError(error.localizedDescription)
        }
    }()
    
    lazy var classificationRequest: VNCoreMLRequest = {
        let imageClassificationRequest = VNCoreMLRequest(model: self.model, completionHandler: { request, error in
            self.processClassifications(for: request, error: error)
        })

        imageClassificationRequest.imageCropAndScaleOption = .centerCrop
        return imageClassificationRequest
    }()
    
    // MARK: - Methods
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                self.classificationLabel = "Unable to classify image.\n\(error!.localizedDescription)"
                return
            }
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as! [VNClassificationObservation]
        
            if classifications.isEmpty {
                self.classificationLabel = "Nothing recognized."
            } else {
                // Display top classifications ranked by confidence in the UI.
                let topClassifications = classifications.prefix(2)
                let descriptions = topClassifications.map { classification in
                    // Formats the classification for display; e.g. "(0.37) cliff, drop, drop-off".
                   return String(format: "(%.2f) %@", classification.confidence, classification.identifier)
                }
                self.classificationLabel = "Classification:\n" + descriptions.joined(separator: "\n")
            }
        }
    }
    
    func updateClassifications(for image: UIImage) {
        classificationLabel = "Classifying..."
        
        guard let orientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue)),
              let ciImage = CIImage(image: image) else {
            fatalError("Unable to create \(CIImage.self) from \(image).")
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                /*
                 This handler catches general image processing errors. The `classificationRequest`'s
                 completion handler `processClassifications(_:error:)` catches errors specific
                 to processing that request.
                 */
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
}
