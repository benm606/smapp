//
//  RegisterViewController.swift
//  Smapp
//
//  Created by Ben Mesnik on 1/4/17.
//  Copyright © 2017 Ben Mesnik. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.emailTextField.delegate = self
        self.usernameTextField.tag = 0
        self.passwordTextField.tag = 2
        self.emailTextField.tag = 1
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkUsername(_ username: String){
        var usernameTaken = false
        
        FIRDatabase.database().reference().child("usernameList").observeSingleEvent(of: .value, with: { (snapshot) in
            if let post = snapshot.value as? [String: AnyObject]{
                let a = post["username"] as? Int
                print("\(a)")
            }
        })
        
        //FIRDatabase.database().reference().child("usernameList")
        
        FIRDatabase.database().reference().child("usernameList").observeSingleEvent(of: .value, with: { (snapshot) in
            usernameTaken = true
            print(snapshot.childrenCount)
        })
        
        FIRDatabase.database().reference().child("usernameList").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let b = snapshot.value as? [String: Any]{
                if let c = b["\(username)"] as? Int{
                    //user already liked post
                    //    print("a")
                    //}
                    //if let c = snapshot.value as? Int{
                    //username already taken
                    print("username already taken")
                    usernameTaken = true
                }else{
                    //username available
                    print("username available")
                }
                
            }
        })
        print(usernameTaken)
        
    }
    
    @IBAction func createAccountTapped(_ sender: Any) {
        
        let username = usernameTextField.text
        let email = emailTextField.text
        let password = passwordTextField.text
        FIRAuth.auth()?.createUser(withEmail: email!, password: password!, completion: { (user, error) in
            if error != nil{            //error creating accnt
                
                let errorMessage = error?.localizedDescription
                
                let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{                      //accnt created
                //success
                
                if let uid = FIRAuth.auth()?.currentUser?.uid{
                    let userRef = FIRDatabase.database().reference().child("users").child(uid)
                    let object = ["username" : username]
                    userRef.child("username").setValue(object)   //save username to userRef location-
                    FIRDatabase.database().reference().child("usernameList").child(username!).setValue(0)
                    let object1 = ["score" : 0]
                    userRef.child("score").setValue(object1)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC")  //go to posts viewcontroller
                    self.present(vc!, animated: true, completion: nil)
                    
                    
                    let catObject: Dictionary<String, Any> = [
                        "cat1" : "",
                        "cat2" : "",
                        "cat3" : "",
                        "cat4" : "",
                        "cat5" : "",
                        "cat6" : "",
                        "cat7" : "",
                        "cat8" : "",
                        "cat9" : "",
                        "cat10" : ""
                    ]
                    
                    userRef.child("categories").setValue(catObject)
                }
            }
            
        })
    
    
}

override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {   //when touched close keyboard
    view.endEditing(true)
    super.touchesBegan(touches, with: event)
}
func textFieldShouldReturn(_ textField: UITextField) -> Bool
{
    // Try to find next responder
    if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
        nextField.becomeFirstResponder()
    } else {
        // Not found, so remove keyboard.
        textField.resignFirstResponder()
        createAccountTapped(self)
    }
    // Do not add a line break
    return false
}
/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */

}
