//
//  InteractorInput.swift
//  Fracker
//
//  Created by Yesset Murat on 4/24/22.
//

import Base
import Network11

protocol InteractorInput {

    func handleFailure(response: NetworkResponse, view: BaseViewInput) -> Bool
}

extension InteractorInput {

    func handleFailure(response: NetworkResponse, view: BaseViewInput) -> Bool {
        guard !response.success else { return false }

        let errorDescription = ErrorDescriptor.convert(response).text
        view.showAlert(message: errorDescription)

        return true
    }

    func show(error: DisplayedError, view: BaseViewInput) {
        if let title = error.title {
            view.showAlert(title: title, message: error.text)
        } else {
            view.showAlert(message: error.text)
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
