//
//  ViewController.swift
//  Firebase_Authentication
//
//  Created by Mac 02 on 02/10/18.
//  Copyright © 2018 Mac 02. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import TwitterKit
import SafariServices
import QuartzCore

class ViewController: UIViewController,GIDSignInUIDelegate,GIDSignInDelegate {
   
    
    //MARK:Variable declaration
    @IBOutlet weak var txtEmail:UITextField!
    @IBOutlet weak var txtPassword:UITextField!
    @IBOutlet weak var btnSignup:UIButton!
    @IBOutlet weak var btnSignIn:UIButton!
    @IBOutlet weak var btnLogOut:UIButton!
    @IBOutlet weak var mainView:UIView!
    @IBOutlet weak var stackView:UIStackView!
     let loginManager:FBSDKLoginManager = FBSDKLoginManager()
    //@IBOutlet weak var googleSignInButton: GIDSignInButton!
    
//    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
  
     var dict : [String : AnyObject]!
    
    var index : Int!
    //MARK:View Hierarchy
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSignIn.layer.borderWidth = 1
        btnSignup.layer.borderWidth = 1
        btnLogOut.layer.borderWidth = 1
        btnSignIn.layer.cornerRadius = btnSignIn.frame.size.height/2
        btnSignup.layer.cornerRadius = btnSignup.frame.size.height/2
        btnLogOut.layer.cornerRadius = btnLogOut.frame.size.height/2
        btnSignIn.clipsToBounds = true
        btnSignup.clipsToBounds = true
        btnLogOut.clipsToBounds = true
        
//        mainView.layer.borderWidth = 5
//        mainView.layer.borderColor = UIColor.white.cgColor
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
       btnLogOut.isHidden = true
        
      

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    //MARK:Click Event
    @IBAction func btnSignupClicked(_ sender:UIButton)
    {
       
       
        txtEmail.text = txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        txtPassword.text = txtPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
      
        //for signup new user
        if((txtEmail.text?.isEmpty)! || (txtPassword.text?.isEmpty)!)
        {
           
            self.showAlert(message: "All fields are mandatory!")
            return
        }
        else
        {
          Auth.auth().createUser(withEmail: txtEmail.text!, password: txtPassword.text!) { (authResult, error) in
            // ...
           
            if((error == nil))
            {
                self.index = 4
                self.btnLogOut.isHidden = false
                self.showAlert(message: "SignUp Successfully!")
            }
            else
            {
               
               self.showAlert(message: (error?.localizedDescription)!)
            }
          }
        }
        
    }
    @IBAction func btnSignInClicked(_ sender:UIButton)
    {
        
       
        Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPassword.text!) { (user, error) in
            // ...
            
            if(error == nil )
            {
                self.index = 1
                self.btnLogOut.isHidden = false
                if let user = user {
                    
                    _ = user.user.displayName
                    let user_email = user.user.email
                    print(user_email!)
                    
            }
                self.showAlert(message: "SignIn Successfully!")
            }
            else{
                
                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                    
                    switch errorCode {
                        
                    case.wrongPassword:
                        self.showAlert(message: "You entered an invalid password please try again!")
                        break
                    case.userNotFound:
                      //  self.btnLogOut.isHidden = false
                        self.showAlert(message: "User not found")
//                        Auth.auth().createUser(withEmail: self.txtEmail.text!, password: self.txtPassword.text!, completion: { (user, error) in
//                            if error == nil {
//                                 self.index = 4
//                                self.btnLogOut.isHidden = false
//                                if let user = user {
//
//                                    _ = user.user.displayName
//                                    let user_email = user.user.email
//                                    print(user_email!)
//                                    self.showAlert(message: "SignUp Successfully!")
//                                } else {
//                                    if let errorCode = AuthErrorCode(rawValue: error!._code) {
//
//                                        switch errorCode {
//
//                                        case .invalidEmail:
//                                            self.showAlert(message: "You entered an invalid email!")
//
//                                        case .userNotFound:
//                                            self.showAlert(message: "User not found")
//
//                                        default:
//                                            print("Creating user error 2 \(error.debugDescription)!")
//                                            self.showAlert(message: "Unexpected error \(errorCode.rawValue) please try again!")
//                                        }
//                                    }
//                                }
//
//                                self.dismiss(animated: true, completion: nil)
//                            }
                       // })
                        
                    default:
                        self.showAlert(message: "Unexpected error \(errorCode.rawValue) please try again!")
                        print("Creating user error \(error.debugDescription)!")
                    }
                }
                
            }
        }
        
    }
    func showAlert(message:String)
    {
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
//    @IBAction func btnLogOutClicked(_ sender:UIButton)
//    {
//        let firebaseAuth = Auth.auth()
//        do {
//            let alert = UIAlertController(title: "SignOut Successfully!", message:"" , preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            self.present(alert, animated: true)
//            try firebaseAuth.signOut()
//            
//        } catch let signOutError as NSError {
//            print ("Error signing out: %@", signOutError)
//            
//            let alert = UIAlertController(title: "", message: signOutError.localizedDescription, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//             self.present(alert, animated: true)
//            
//        }
//    }
   
    //MARK: Google Sign-In Authentication
    //MARK:
    @IBAction func googleSignIn(_ sender: AnyObject) {
        index = 2
        GIDSignIn.sharedInstance().signIn()
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if(error != nil)
        {
            print(error.localizedDescription)
            
        }
        else
        {
            self.btnLogOut.isHidden = false
            self.showAlert(message: "SignIn Successfully!")
            let userId = user.userID                  // For client-side use only!
            print("User id is \(String(describing: userId))")
            
            let idToken = user.authentication.idToken // Safe to send to the server
            print("Authentication idToken is \(String(describing: idToken))")
            let fullName = user.profile.name
            print("User full name is \(String(describing: fullName))")
            let givenName = user.profile.givenName
            print("User given profile name is \(String(describing: givenName))")
            let familyName = user.profile.familyName
            print("User family name is \(String(describing: familyName))")
            let email = user.profile.email
            print("User email address is \(String(describing: email))")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        print(error.localizedDescription)
        
    }
//    @IBAction func googleSignOutButtonClicked(_ sender:UIButton)
//    {
//        //        GIDSignIn.sharedInstance().signOut()
//        let firebaseAuth = Auth.auth()
//        do {
//            try firebaseAuth.signOut()
//        } catch let signOutError as NSError {
//            print ("Error signing out: %@", signOutError)
//        }
//
//    }
//    //MARK: Google Sign-In-UI Authentication Delegates
//    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
//
//        guard error == nil else {
//
//            print("Error while trying to redirect : \(error)")
//            return
//        }
//
//        print("Successful Redirection")
//    }

//    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
//        self.present(self, animated: true, completion: nil)
//    }
//    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
//        self.dismiss(animated: true, completion: nil)
//    }
    
    //MARK: ButtonEvents
//    @IBAction func googleSignInButtonClicked(_ sender: GIDSignInButton) {
////        var credential:AuthCredential!
////        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
////            if let error = error {
////                // ...
////                print(error)
////                return
////            }
////            else
////            {
////                print("User is LoggedIn")
////            }
////            // User is signed in
////            // ...
////        }
//
//    }
    
     //MARK: Facebook Sign-In-UI Authentication
    
    @IBAction func btnFBSignInButtonClicked(_ sender: AnyObject) {
        
        
       
        loginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if (error == nil)
            {
                self.index = 3
                
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.btnLogOut.isHidden = false
                        self.showAlert(message: "SignIn Successfully!")
                        self.getFBUserData()
                        
                    }
                    else
                    {
                        print(error?.localizedDescription)
                    }
                }
            }
        }
    }

    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    
                    print(result!)
                    print(self.dict)
                }
            })
        }
    }
    
    
//    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
//       // print("User Logged In")
//        let alert = UIAlertController(title: "Login Successfully!", message:"" , preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        self.present(alert, animated: true)
//        if ((error) != nil)
//        {
//            // Process error
//            print(error.localizedDescription)
//        }
//        else if result.isCancelled {
//            // Handle cancellations
//            print("cancel")
//        }
//        else {
//            // If you ask for multiple permissions at once, you
//            // should check if specific permissions missing
//            if result.grantedPermissions.contains("public_profile")
//            {
//
//                let dict = result
//                print(result!)
//                print(dict)
//                // Do work
//            }
//        }
//    }
//    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
//
//        print("loginButton tapped")
//        let alert = UIAlertController(title: "LogOut Successfully!", message:"" , preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        self.present(alert, animated: true)
//
//    }
//    /There is no user record corresponding to this identifier. The user may have been deleted in swift 3
    //MARK:Twitter Login Authentication
    @IBAction func btnTwitterLoginClicked(_ sender: AnyObject)
    {
//        if(UIApplication.shared.canOpenURL(URL(string:"twitter://")!)) {
//            if(TWTRTwitter.sharedInstance().sessionStore.hasLoggedInUsers()){
//               print("Already Logged In")
//            }
//            else
//            {
      
//        let store = TWTRTwitter.sharedInstance().sessionStore
//        let lastSession = store.session()
//        let sessions = store.existingUserSessions()
        guard let _:TWTRSession = TWTRSession.init(authToken: "755345671-7H3xjgxnqLhS40UuCr4IMHmGxtXyERYAynGl2V2N", authTokenSecret: "uDZbQPb62v2O1BoQuN4iAzmsXQ8cyemKmVLSiHJbipmbR", userName: "diosdeveloper", userID: "755345671") else {return}
        
            
        
        TWTRTwitter.sharedInstance().logIn { (session, error) in
            if session != nil {
                let token = session?.authToken
                let auth_secret = session?.authTokenSecret
                let userID = session?.userID
                let username = session?.userName
            
            }
            else {
                print(error?.localizedDescription)
            }
        }
//                TWTRTwitter.sharedInstance().logIn(with: self,completion: {(_ session: TWTRSession?, _ error: Error?) -> Void in
//                    if session != nil {
//                        let token = session?.authToken
//                        let auth_secret = session?.authTokenSecret
//                        let userID = session?.userID
//                        let username = session?.userName
//
//                    }
//                    else {
//                        print(error?.localizedDescription)
//                    }
//                })
           // }
            
        }
//        else
//        {
//            let alertController = UIAlertController(title: "Twitter application is not found.", message: "Do you want to install Twitter ? ", preferredStyle: .alert)
//
//            let cancelAction = UIAlertAction(title: "Cancel",
//                                             style: .cancel, handler: nil)
//            let yesAction = UIAlertAction(title: "YES", style: .default) { (action:UIAlertAction) in
//
//                let twitter_url = URL.init(string: "https://itunes.apple.com/us/app/twitter/id333903271?mt=8")
//                // let url:String  = (twitter_url?.absoluteString)!
//
//                UIApplication.shared.openURL(twitter_url!)
//
//            }
//            alertController.addAction(cancelAction)
//            alertController.addAction(yesAction)
//            self.present(alertController, animated: true, completion: nil)
//        }
//
      
        
//        TWTRTwitter.sharedInstance().logIn { (session, error) in
//            if (session != nil) {
//                print("signed in as \(String(describing: session?.userName))");
//                self.showAlert(message: "SignIn Successfully!")
//            } else {
//                print("error: \(String(describing: error?.localizedDescription))");
//            }
//        }
   // }
    
   // let alert = UIAlertController(title: "SignOut Successfully!", message:"" , preferredStyle: .alert)
    //                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    //                        self.present(alert, animated: true)
    @IBAction func  btnLogoutClicked(_ sender: AnyObject)
    {
      print(index)
        if(index == 1 || index == 4)
        {
            //Email
            let firebaseAuth = Auth.auth()
                    do {
                        try firebaseAuth.signOut()
                        self.btnLogOut.isHidden = true
                        self.showAlert(message: "SignOut Successfully!")
                        
            
                    } catch let signOutError as NSError {
                        print ("Error signing out: %@", signOutError)
                       self.showAlert(message: signOutError.localizedDescription)

                    }
        }
        else if(index == 2)
        {
            //Google
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                 self.btnLogOut.isHidden = true
                  self.showAlert(message: "SignOut Successfully!")
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
        }
        
        else if(index == 3)
        {
           //Facebook
            if FBSDKAccessToken.current != nil {
                //let logout = FBSDKLoginManager()
                //logout.logOut()
               loginManager.logOut()
            }
            self.btnLogOut.isHidden = true
             self.showAlert(message: "SignOut Successfully!")
           
        }
        
        else
        {
            
        }
    }
    override func didReceiveMemoryWarning() {
    
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


