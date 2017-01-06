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


class ViewController: UIViewController{
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostVC")  //go to posts viewcontroller
                self.present(vc!, animated: true, completion: nil)
            }
            
            
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {   //when touched close keyboard
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    /*override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
        usernameTextField.resignFirstResponder()
    }*/
    
    
    
}

