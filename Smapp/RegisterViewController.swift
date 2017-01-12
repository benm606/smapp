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

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                    let object1 = ["score" : 0]
                    userRef.child("score").setValue(object1)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC")  //go to posts viewcontroller
                    self.present(vc!, animated: true, completion: nil)
                    
                    
                    let catObject: Dictionary<String, Any> = [
                        "cat1" : "",
                        "cat2" : "",
                        "cat3" : "",
                        "cat4" : ""
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
