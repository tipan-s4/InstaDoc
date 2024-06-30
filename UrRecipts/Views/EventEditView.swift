//
//  EventEditView.swift
//  InstaDoc
//
//  Created by Carlos Tipán on 22/6/24.
//

import Foundation
import SwiftUI
import EventKit
import EventKitUI

struct EventEditView: UIViewControllerRepresentable {
    var event: EKEvent
    let eventStore: EKEventStore
    var onComplete: ((Bool) -> Void)?

    class Coordinator: NSObject, EKEventEditViewDelegate {
        var parent: EventEditView

        init(parent: EventEditView) {
            self.parent = parent
        }

        func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            controller.dismiss(animated: true) {
                self.parent.onComplete?(action != .canceled)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> EKEventEditViewController {
        let controller = EKEventEditViewController()
        controller.event = event
        controller.eventStore = eventStore
        controller.editViewDelegate = context.coordinator
        
        return controller
    }

    func updateUIViewController(_ uiViewController: EKEventEditViewController, context: Context) {}
}
