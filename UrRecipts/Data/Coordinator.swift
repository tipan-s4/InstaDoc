//
//  Coordinator.swift
//  UrRecipts
//
//  Created by Carlos Tipán on 26/5/24.
//

import Foundation
import SwiftUI


class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: AccessCameraView

    init(picker: AccessCameraView) {
        self.picker = picker
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            self.picker.selectedImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            self.picker.selectedImage = originalImage
        }

        self.picker.isPresented.wrappedValue.dismiss()

        // Aquí establecemos el estado para navegar a la siguiente vista
        DispatchQueue.main.async {
            self.picker.navigateToCheckReceiptDataView = true
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.picker.isPresented.wrappedValue.dismiss()
    }
}
