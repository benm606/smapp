//
//  MainViewController.swift
//  Smapp
//
//  Created by Ben Mesnik on 1/6/17.
//  Copyright © 2017 Ben Mesnik. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var postsTableView: UITableView!
    var posts = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.postsTableView.delegate = self
        self.postsTableView.dataSource = self
        
        self.navigationController?.navigationBar.alpha = 0    //set top bar coloring
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 150/255, green: 10/255, blue: 10/255, alpha: 1.0)
        
        loadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData(){
        FIRDatabase.database().reference().child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
            if let postsDictionary = snapshot.value as? [String: AnyObject]{
                for post in postsDictionary{
                    self.posts.add(post.value)       //fill table with posts from posts folder-
                }
                self.postsTableView.reloadData()
            }
        })
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.posts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {      //called with reloadData()-
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        
        // Configure the cell...
        let post = self.posts[indexPath.row] as! [String: AnyObject]  //indexPath.row is the post number?-
        cell.titleLabel.text = post["title"] as? String
        cell.contentTextView.text = post["content"] as? String
        if let imageName = post["image"] as? String{
            let imageRef = FIRStorage.storage().reference().child("images/\(imageName)")
            imageRef.data(withMaxSize: 25 * 1024 * 1024, completion:{ (data, error) -> Void in  //max data size 25 mb
                if error == nil{   //successfully took image data from firebase
                    //success
                    let image = UIImage(data: data!)
                    cell.postImageView.image = image

                    cell.titleLabel.alpha = 0                   //slowly fade in post with animation
                    cell.contentTextView.alpha = 0
                    cell.postImageView.alpha = 0
                    UIView.animate(withDuration: 0.4, animations: {
                        cell.titleLabel.alpha = 1
                        cell.contentTextView.alpha = 1
                        cell.postImageView.alpha = 1
                    })

                }else{
                    //error
                    print("Error downloading image: \(error?.localizedDescription)")
                }
            })
        }
        
        return cell
    }
    
    @IBAction func logOutTapped(_ sender: Any) {
        do{
            try FIRAuth.auth()?.signOut()
            //successfully logged out
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
            self.present(vc!, animated: true, completion: nil)
        }catch{
            //if error logging out
            print("Error logging out user.")
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
