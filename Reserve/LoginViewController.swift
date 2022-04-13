//
//  LoginViewController.swift
//  Reserve
//
//  Created by Eric Chavez on 4/12/22.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSignIn(_ sender: Any) {
        let username = usernameField.text!
        let password = passwordField.text!
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            if(user != nil) {
                print("Log In success")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                
            } else {
                print("Error: \(error?.localizedDescription)")
                
                let alertDisapperTimeInSeconds = 1.5
                let alert = UIAlertController(title: nil, message: "Sign In Error", preferredStyle: .actionSheet)
                self.present(alert, animated: true)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + alertDisapperTimeInSeconds) {
                  alert.dismiss(animated: true)
                }
                
            }
        }
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        let user = PFUser()
        user.username = usernameField.text
        user.password = passwordField.text
        
        user.signUpInBackground { (success, error) in
            if success {
                print("Sign Up success")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
               
            } else {
                print("Error: \(error?.localizedDescription)")
                let alertDisapperTimeInSeconds = 1.5
                let alert = UIAlertController(title: nil, message: "Sign Up Error!", preferredStyle: .actionSheet)
                self.present(alert, animated: true)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + alertDisapperTimeInSeconds) {
                  alert.dismiss(animated: true)
                }
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
