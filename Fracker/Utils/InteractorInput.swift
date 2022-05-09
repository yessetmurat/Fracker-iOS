//
//  InteractorInput.swift
//  Fracker
//
//  Created by Yesset Murat on 4/24/22.
//

import BaseKit
import NetworkKit

protocol InteractorInput {

    func handleFailure(response: NetworkResponse, view: BaseViewInput) -> Bool
}

extension InteractorInput {

    func handleFailure(response: NetworkResponse, view: BaseViewInput) -> Bool {
        guard !response.success else { return false }

        let errorDescription = ErrorDescriptor.convert(response).text
        view.showAlert(
            title: "Common.attention".localized,
            message: errorDescription,
            image: BaseImage.alertCircle.uiImage
        )

        return true
    }

    func show(error: DisplayedError, view: BaseViewInput) {
        if let title = error.title {
            view.showAlert(title: title, message: error.text, image: BaseImage.alertCircle.uiImage)
        } else {
            view.showAlert(message: error.text, image: BaseImage.alertCircle.uiImage)
        }
    }

    func show(networkError: NetworkError, view: BaseViewInput) {
        let error = ErrorDescriptor.convert(networkError: networkError)
        show(error: error, view: view)
    }

    func show(localError: LocalError, view: BaseViewInput) {
        let error = ErrorDescriptor.convert(localError: localError)
        show(error: error, view: view)
    }
}
