// Sourced from
// https://blog.codemagic.io/google-sign-in-firebase-authentication-using-swift/
import Firebase
import GoogleSignIn

// Necessary for Google sign in
class GoogleSignInModel: ObservableObject {

  // Sign in states
  enum SignInState {
    case signedIn
    case signedOut
  }

  @Published var state: SignInState = .signedOut
        
    func signIn() {
      if GIDSignIn.sharedInstance.hasPreviousSignIn() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
            authenticateUser(for: user, with: error)
            print("Successfully resigned through Google")
            guard let GIDUser = user else {
                return
            }
            DataManager.sharedInstance.retrieveUser(GIDUser)
            DataManager.sharedInstance.getUserBirthdays()
            
        }
      } else {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let configuration = GIDConfiguration(clientID: clientID)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
        GIDSignIn.sharedInstance.signIn(with: configuration, presenting: rootViewController) { [unowned self] user, error in
          authenticateUser(for: user, with: error)
            print("Successfully signed in through Google")
            guard let GIDUser = user else {
                return
            }
            DataManager.sharedInstance.createUser(GIDUser)
            DataManager.sharedInstance.getUserBirthdays()
        }
      }
    }
    
    
    func signOut() {
      GIDSignIn.sharedInstance.signOut()
      
      do {
        try Auth.auth().signOut()
        state = .signedOut
      } catch {
        print(error.localizedDescription)
      }
    }
    
    
    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
      if let error = error {
        print(error.localizedDescription)
        return
      }
      
      guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
      let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
      Auth.auth().signIn(with: credential) { [unowned self] (_, error) in
        if let error = error {
          print(error.localizedDescription)
        } else {
          self.state = .signedIn
        }
      }
    }
}
