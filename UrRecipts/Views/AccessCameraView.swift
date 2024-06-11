//
//  AccessCameraView.swift
//  UrRecipts
//
//  Created by Carlos Tipán on 26/5/24.
//


import Foundation
import SwiftUI
import VisionKit

struct AccessCameraView: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage?
    @Binding var navigateToCheckReceiptDataView: Bool
    @Environment(\.presentationMode) var isPresented
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = context.coordinator
        return documentCameraViewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var parent: AccessCameraView
        
        init(picker: AccessCameraView) {
            self.parent = picker
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            parent.isPresented.wrappedValue.dismiss()

            if scan.pageCount > 0 {
                let image = scan.imageOfPage(at: 0)
                parent.selectedImage = image
                parent.navigateToCheckReceiptDataView = true
            }
        }
        
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            parent.isPresented.wrappedValue.dismiss()
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            parent.isPresented.wrappedValue.dismiss()
            print("Document scanning failed with error: \(error)")
        }
    }
}
