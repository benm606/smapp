//
//  ViewController.swift
//  Smapp
//
//  Created by Ben Mesnik on 1/4/17.
//  Copyright © 2017 Ben Mesnik. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class ViewController: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.usernameTextField.tag = 0
        self.passwordTextField.tag = 1
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if FIRAuth.auth()?.currentUser != nil{             //checks if user already signed in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC")//loggedin so set mainvc(posts) as vc
            self.present(vc!, animated: false, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func signInTapped(_ sender: Any) {        //sign in button
        
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        FIRAuth.auth()?.signIn(withEmail: username!, password: password!, completion: { (user, error) in
            if error != nil {
                //error logging in
                let alert = UIAlertController(title: "Error", message: "Incorrect Username/Password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                //success
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC")  //go to posts viewcontroller
                self.present(vc!, animated: true, completion: nil)
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
            signInTapped(self)
        }
        // Do not add a line break
        return false
    }
    /*override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
        usernameTextField.resignFirstResponder()
    }*/
    
    
    
}

