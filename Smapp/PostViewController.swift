//
//  PostViewController.swift
//  Smapp
//
//  Created by Ben Mesnik on 1/5/17.
//  Copyright © 2017 Ben Mesnik. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class PostViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var selectImageButton: UIButton!
    
    var imageFileName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //runs when photo selection is cancelled
        picker.dismiss(animated: true, completion: nil)   //close image picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //runs when photo is picked from library
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as?
            UIImage{
            self.previewImageView.image = pickedImage
            self.selectImageButton.isEnabled = false  //hide select image button
            self.selectImageButton.isHidden = true
            uploadImage(image: pickedImage)
            picker.dismiss(animated: true, completion: nil)  //close image picker
        }
    }
    
    @IBAction func postTapped(_ sender: Any) {     //post to firebase databse
        
        if let uid = FIRAuth.auth()?.currentUser?.uid{   ///make sure all fields r filled and create postable object
            if let title = titleTextField.text{
                if let content = contentTextView.text{
                    let postObject: Dictionary<String, Any> = [
                        "uid" : uid,
                        "title" : title,
                        "content" : content,
                        "image" : imageFileName
                    ]
                    
                    FIRDatabase.database().reference().child("posts").childByAutoId().setValue(postObject)
                    
                    let alert = UIAlertController(title: "Success", message: "Post sent", preferredStyle: .alert)  // popup message to say posted
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                    
                    print("posted to Firebase")
                }
            }
        }
     
    }

    @IBAction func selectImageTapped(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func uploadImage(image: UIImage){                           //create random name to save photo under
        let randomName = randomStringWithLength(length: 10)
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        let uploadRef = FIRStorage.storage().reference().child("images/\(randomName).jpg")
        
        let uploadTask = uploadRef.put(imageData!, metadata: nil){
            metadata, error in
            
            if error == nil{
                //success
                print("Successfully uploaded picture")
                self.imageFileName = "\(randomName as String).jpg"
            }else{
                //error
                print("Error uloading image: \(error?.localizedDescription)")
            }
        }
    }
    
    func randomStringWithLength(length: Int) -> NSString{
        let characters: NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: NSMutableString = NSMutableString(capacity: length)
        for i in 0..<length{
            var len = UInt32(characters.length)
            var rand = arc4random_uniform(len)
            randomString.appendFormat("%C", characters.character(at: Int(rand)))
        }
        return randomString
        
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
