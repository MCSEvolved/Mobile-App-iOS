//
//  Created by Josian van Efferen on 03/07/2023.
//

import Foundation

enum ApiError: Error {
    case urlIsNil
    case unauthorized
    case forbidden
    case notFound
    case badRequest
    case serverError
}
