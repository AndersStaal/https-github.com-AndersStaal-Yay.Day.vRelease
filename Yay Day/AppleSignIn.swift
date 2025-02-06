import AuthenticationServices
import SwiftUI



class SignInWithAppleManager: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    var onSuccess: (() -> Void)? // A closure to notify successful login

    func signIn() {
        print("Sign In with Apple triggered")
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self // Set self as the presentationContextProvider
        controller.performRequests()
    }

    // Implement the required method for presentationContextProvider
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        print("Providing presentation anchor")
        return UIApplication.shared.windows.first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }

    // Handle the authorization completion
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        print("Authorization completed")
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            print("User Identifier: \(appleIDCredential.user)")
            print("Full Name: \(appleIDCredential.fullName?.givenName ?? "")")
            print("Email: \(appleIDCredential.email ?? "")")
            
            // Notify success (this triggers the closure you set earlier)
            onSuccess?()
        }
    }

    // Handle authorization errors
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Authorization failed: \(error.localizedDescription)")
    }
}
