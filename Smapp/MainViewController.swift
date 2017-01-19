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
    @IBOutlet var fullPostView: UIView!
    @IBOutlet weak var selectionLikeImageView: UIImageView!
    
    @IBOutlet weak var selectionCenterImageView: UIImageView!
    @IBOutlet weak var popularCategoryButton: UIButton!
    @IBOutlet weak var recentCategoryButton: UIButton!
    @IBOutlet weak var categoryMenuButton: UIButton!
    @IBOutlet weak var grayBackgroundCoat: UIImageView!
    
    @IBOutlet weak var selectionNextImageView: UIImageView!
    @IBOutlet weak var selectionBackImageView: UIImageView!
    @IBOutlet weak var selectionSaveImageView: UIImageView!
    @IBOutlet weak var cat1Button: UIButton!
    @IBOutlet weak var cat2Button: UIButton!
    @IBOutlet weak var cat3Button: UIButton!
    @IBOutlet weak var cat4Button: UIButton!
    @IBOutlet weak var cat5Button: UIButton!
    @IBOutlet weak var cat6Button: UIButton!
    @IBOutlet weak var cat7Button: UIButton!
    @IBOutlet weak var cat8Button: UIButton!
    @IBOutlet weak var cat9Button: UIButton!
    @IBOutlet weak var cat10Button: UIButton!
    @IBOutlet weak var centerInfoText: UITextView!
    
    
    var posts = NSMutableArray()
    var touchPressedX = CGFloat()
    var touchReleasedX = CGFloat()
    var touchPressedY = CGFloat()
    var touchReleasedY = CGFloat()
    var touchDown = false
    var selectionLikeHighlighted = false
    var selectionSaveHighlighted = false
    var selectionBackHighlighted = false
    var selectionNextHighlighted = false
    var postID: String!
    var categoryMenuOpen = false
    var likesRank = NSMutableArray()
    var likesRankIndexPathsRows = NSMutableArray()
    var likesRankRow = Int()
    var likesRankIndexPath = IndexPath()
    var sortByLikes = true
    var sortByTime = false
    var recentRank = NSMutableArray()
    var recentRankIndexPathsRows = NSMutableArray()
    var recentRankRow = Int()
    var recentRankIndexPath = IndexPath()
    var cat1Available = false
    var cat2Available = false
    var cat3Available = false
    var cat4Available = false
    var cat5Available = false
    var cat6Available = false
    var cat7Available = false
    var cat8Available = false
    var cat9Available = false
    var cat10Available = false
    var cat1: String!
    var cat2: String!
    var cat3: String!
    var cat4: String!
    var cat5: String!
    var cat6: String!
    var cat7: String!
    var cat8: String!
    var cat9: String!
    var cat10: String!
    var sortByCat1 = false
    var sortByCat2 = false
    var sortByCat3 = false
    var sortByCat4 = false
    var sortByCat5 = false
    var sortByCat6 = false
    var sortByCat7 = false
    var sortByCat8 = false
    var sortByCat9 = false
    var sortByCat10 = false
    var stopSearching = false
    var goBackToRow = Int()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.postsTableView.delegate = self
        self.postsTableView.dataSource = self
        
        self.selectionCenterImageView.alpha = 0
        self.selectionLikeImageView.alpha = 0
        self.selectionSaveImageView.alpha = 0
        self.selectionNextImageView.alpha = 0
        self.selectionBackImageView.alpha = 0
        self.grayBackgroundCoat.alpha = 0
        
        self.likesRankIndexPath = IndexPath(row: 0, section: 0)
        self.likesRankRow = 0
        self.recentRankIndexPath = IndexPath(row: 0, section: 0)
        self.recentRankRow = 0
        
        //hide buttons
        self.popularCategoryButton.frame.origin = CGPoint(x: (self.categoryMenuButton.frame.origin.x + 10), y: self.categoryMenuButton.frame.origin.y)
        self.recentCategoryButton.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
        self.cat1Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
        self.cat2Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
        self.cat3Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
        self.cat4Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
        self.cat5Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
        self.cat6Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
        self.cat7Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
        self.cat8Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
        self.cat9Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
        self.cat10Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
        
        self.cat1Button.alpha = 0
        self.cat2Button.alpha = 0
        self.cat3Button.alpha = 0
        self.cat4Button.alpha = 0
        self.cat5Button.alpha = 0
        self.cat6Button.alpha = 0
        self.cat7Button.alpha = 0
        self.cat8Button.alpha = 0
        self.cat9Button.alpha = 0
        self.cat10Button.alpha = 0
        self.popularCategoryButton.alpha = 0
        self.recentCategoryButton.alpha = 0
        
        self.navigationController?.navigationBar.alpha = 0    //set top bar coloring
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 150/255, green: 10/255, blue: 10/255, alpha: 1.0)
        
        self.popularCategoryButton.backgroundColor = UIColor(red: 150/255, green: 10/255, blue: 10/255, alpha: 1.0)
        self.recentCategoryButton.backgroundColor = UIColor(red: 150/255, green: 10/255, blue: 10/255, alpha: 1.0)
        self.cat1Button.backgroundColor = UIColor(red: 150/255, green: 10/255, blue: 10/255, alpha: 1.0)
        self.cat2Button.backgroundColor = UIColor(red: 150/255, green: 10/255, blue: 10/255, alpha: 1.0)
        self.cat3Button.backgroundColor = UIColor(red: 150/255, green: 10/255, blue: 10/255, alpha: 1.0)
        self.cat4Button.backgroundColor = UIColor(red: 150/255, green: 10/255, blue: 10/255, alpha: 1.0)
        self.cat5Button.backgroundColor = UIColor(red: 150/255, green: 10/255, blue: 10/255, alpha: 1.0)
        self.cat6Button.backgroundColor = UIColor(red: 150/255, green: 10/255, blue: 10/255, alpha: 1.0)
        self.cat7Button.backgroundColor = UIColor(red: 150/255, green: 10/255, blue: 10/255, alpha: 1.0)
        self.cat8Button.backgroundColor = UIColor(red: 150/255, green: 10/255, blue: 10/255, alpha: 1.0)
        self.cat9Button.backgroundColor = UIColor(red: 150/255, green: 10/255, blue: 10/255, alpha: 1.0)
        self.cat10Button.backgroundColor = UIColor(red: 150/255, green: 10/255, blue: 10/255, alpha: 1.0)
        
        self.goBackToRow = 0
        
        self.centerInfoText.alpha = 0
        
        //setup buttons
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        FIRDatabase.database().reference().child("users").child(uid!).child("categories").observeSingleEvent(of: .value, with: { (snapshot) in
            if let post = snapshot.value as? [String: AnyObject]{
                self.cat1 = post["cat1"] as? String
                self.cat2 = post["cat2"] as? String
                self.cat3 = post["cat3"] as? String
                self.cat4 = post["cat4"] as? String
                self.cat5 = post["cat5"] as? String
                self.cat6 = post["cat6"] as? String
                self.cat7 = post["cat7"] as? String
                self.cat8 = post["cat8"] as? String
                self.cat9 = post["cat9"] as? String
                self.cat10 = post["cat10"] as? String
            }
            if(self.cat1 != ""){
                self.cat1Available = true
                self.cat1Button.setTitle(self.cat1, for: .normal)
            }
            if(self.cat2 != ""){
                self.cat2Available = true
                self.cat2Button.setTitle(self.cat2, for: .normal)
            }
            if(self.cat3 != ""){
                self.cat3Available = true
                self.cat3Button.setTitle(self.cat3, for: .normal)
            }
            if(self.cat4 != ""){
                self.cat4Available = true
                self.cat4Button.setTitle(self.cat4, for: .normal)
            }
            if(self.cat5 != ""){
                self.cat5Available = true
                self.cat5Button.setTitle(self.cat5, for: .normal)
            }
            if(self.cat6 != ""){
                self.cat6Available = true
                self.cat6Button.setTitle(self.cat6, for: .normal)
            }
            if(self.cat7 != ""){
                self.cat7Available = true
                self.cat7Button.setTitle(self.cat7, for: .normal)
            }
            if(self.cat8 != ""){
                self.cat8Available = true
                self.cat8Button.setTitle(self.cat8, for: .normal)
            }
            if(self.cat9 != ""){
                self.cat9Available = true
                self.cat9Button.setTitle(self.cat9, for: .normal)
            }
            if(self.cat10 != ""){
                self.cat10Available = true
                self.cat10Button.setTitle(self.cat10, for: .normal)
            }
        })
        
        
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
                    
                    var skipPost = false
                    
                    let post1 = post.value as! [String: AnyObject]  //indexPath.row is the post number?-
                    
                    let t = post1["time"] as! TimeInterval              //this and next few lines, get date of post and current post
                    let postTime = Date(timeIntervalSince1970: t/1000)
                    
                    let date = NSDate()
                    let calendar = Calendar.current
                    
                    let dayCurrent = calendar.component(.day, from: date as Date)
                    let hourCurrent = calendar.component(.hour, from: date as Date)
                    let minutesCurrent = calendar.component(.minute, from: date as Date)
                    let timeCurrent = (dayCurrent * 1440) + (hourCurrent * 60) + (minutesCurrent)
                    
                    let dayPost = calendar.component(.day, from: postTime as Date)
                    let hourPost = calendar.component(.hour, from: postTime as Date)
                    let minutesPost = calendar.component(.minute, from: postTime as Date)
                    let timePost = (dayPost * 1440) + (hourPost * 60) + (minutesPost)
                    
                    if(timeCurrent - timePost > 1440){          //check if post is older than 24 hours(1440 mins)
                        print("post old")           //delete post
                        let postID = post1["postID"] as! String
                        
                        if let imageName1 = post1["image"] as? String{
                            print("\(imageName1)")
                            FIRStorage.storage().reference().child("images/\(imageName1)").delete(completion: { (error) in //delete image in storage
                                //print(error)
                            })
                        }
                        skipPost = true
                        FIRDatabase.database().reference().child("posts").child(postID).removeValue()       //delete post
                    }else{
                        print("keep post")
                    }
                    
                    
                    if(!skipPost){
                        /*                  sort by likes                         */
                        
                        let currentPostLikes = post1["likes"] as! Int
                        self.likesRank.add(currentPostLikes)
                        self.likesRankIndexPathsRows.add(self.likesRankRow)
                        self.likesRankRow = self.likesRankRow + 1
                        
                        
                        if(self.likesRank.count > 1){
                            for (index, element) in self.likesRank.enumerated() {
                                if(self.likesRank[(self.likesRank.count - 1)] as! Int > element as! Int){
                                    self.likesRank.exchangeObject(at: index, withObjectAt: (self.likesRank.count - 1))
                                    self.likesRankIndexPathsRows.exchangeObject(at: index, withObjectAt: (self.likesRankIndexPathsRows.count - 1))
                                }
                            }
                            
                        }
                        /*          ^^             ^^     */
                        
                        /*              sort by time               */
                        
                        // if(FIRAuth.auth()?.currentUser?.uid == ("j1Bj5gGjH1eoJtP4CcgFbDJYxNt2")){  //only my account can do(for later deleting old posts)
                        if let t = post1["time"] as? TimeInterval{
                            let time = Date(timeIntervalSince1970: t/1000)
                            
                            self.recentRank.add(time)
                            self.recentRankIndexPathsRows.add(self.recentRankRow)
                            self.recentRankRow = self.recentRankRow + 1
                            
                            
                            if(self.recentRank.count > 1){
                                for (index, element) in self.recentRank.enumerated() {
                                    let date1 = self.recentRank[(self.recentRank.count - 1)] as! Date
                                    let date2 = element as! Date
                                    if(date1.compare(date2 as Date) == ComparisonResult.orderedDescending){
                                        self.recentRank.exchangeObject(at: index, withObjectAt: (self.recentRank.count - 1))
                                        self.recentRankIndexPathsRows.exchangeObject(at: index, withObjectAt: (self.recentRankIndexPathsRows.count - 1))
                                    }
                                }
                                
                            }
                            
                        }
                        //  }
                        
                        /*       ^^             ^^              */
                        
                        
                        
                        self.posts.add(post.value)       //fill table with posts from posts folder-
                    }
                }
                self.likesRankRow = 0    //set as second index value since first image index already used
                
                
                self.postsTableView.reloadData()
                
                self.likesRankIndexPath.row = self.likesRankIndexPathsRows[0] as! Int   //set next row as next row in array
                self.likesRankIndexPath.section = 0
                self.postsTableView.scrollToRow(at: self.likesRankIndexPath, at: UITableViewScrollPosition.top, animated: false)//go to first/ top liked post
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
        //cell.likeCountLabel.text = post["likes"] as? String
        cell.likeCountLabel.text = "\(post["likes"] as! Int)"
        cell.contentTextView.text = post["content"] as? String
        cell.usernameLabel.text = post["username"] as? String
        
        cell.likeCountLabel.alpha = 0                   //slowly fade in post with animation
        cell.usernameLabel.alpha = 0
        cell.contentTextView.alpha = 0
        cell.postImageView.alpha = 0
        if let imageName = post["image"] as? String{
            let imageRef = FIRStorage.storage().reference().child("images/\(imageName)")
            imageRef.data(withMaxSize: 25 * 1024 * 1024, completion:{ (data, error) -> Void in  //max data size 25 mb
                if error == nil{   //successfully took image data from firebase
                    //success
                    let image = UIImage(data: data!)
                    cell.postImageView.image = image
                    
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        cell.likeCountLabel.alpha = 1
                        cell.usernameLabel.alpha = 1
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
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let touchPoint = touch.location(in: self.selectionCenterImageView)
            if(self.selectionCenterImageView.bounds.contains(touchPoint)){     //if center of wheel touced
                UIView.animate(withDuration: 0.2, animations: {     //highlight selection wheel spokes
                    self.selectionCenterImageView.alpha = 0.8
                    self.selectionLikeImageView.alpha = 0.6
                    self.selectionSaveImageView.alpha = 0.6
                    self.selectionNextImageView.alpha = 0.6
                    self.selectionBackImageView.alpha = 0.6
                    self.grayBackgroundCoat.alpha = 0.5
                })
                selectionLikeHighlighted = false     //set which spoke highlighted for end action
                selectionSaveHighlighted = false
                selectionBackHighlighted = false
                selectionNextHighlighted = false
            }
        }
        //if touches.first?.view == selectionCenterImageView
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            var touchPoint = touch.location(in: self.selectionLikeImageView)
            if(self.selectionLikeImageView.bounds.contains(touchPoint)){
                UIView.animate(withDuration: 0.1, animations: {     //highlight selection wheel spokes
                    self.selectionCenterImageView.alpha = 0.6
                    self.selectionLikeImageView.alpha = 0.8
                    self.selectionSaveImageView.alpha = 0.6
                    self.selectionNextImageView.alpha = 0.6
                    self.selectionBackImageView.alpha = 0.6
                })
                selectionLikeHighlighted = true
                selectionSaveHighlighted = false
                selectionBackHighlighted = false
                selectionNextHighlighted = false
            }
            touchPoint = touch.location(in: self.selectionSaveImageView)
            if(self.selectionSaveImageView.bounds.contains(touchPoint)){
                UIView.animate(withDuration: 0.1, animations: {     //highlight selection wheel spokes
                    self.selectionCenterImageView.alpha = 0.6
                    self.selectionLikeImageView.alpha = 0.6
                    self.selectionSaveImageView.alpha = 0.8
                    self.selectionNextImageView.alpha = 0.6
                    self.selectionBackImageView.alpha = 0.6
                })
                selectionLikeHighlighted = false
                selectionSaveHighlighted = true
                selectionBackHighlighted = false
                selectionNextHighlighted = false
            }
            touchPoint = touch.location(in: self.selectionBackImageView)
            if(self.selectionBackImageView.bounds.contains(touchPoint)){
                UIView.animate(withDuration: 0.1, animations: {     //highlight selection wheel spokes
                    self.selectionCenterImageView.alpha = 0.6
                    self.selectionLikeImageView.alpha = 0.6
                    self.selectionSaveImageView.alpha = 0.6
                    self.selectionNextImageView.alpha = 0.6
                    self.selectionBackImageView.alpha = 0.8
                })
                selectionLikeHighlighted = false
                selectionSaveHighlighted = false
                selectionBackHighlighted = true
                selectionNextHighlighted = false
            }
            touchPoint = touch.location(in: self.selectionNextImageView)
            if(self.selectionNextImageView.bounds.contains(touchPoint)){
                UIView.animate(withDuration: 0.1, animations: {     //highlight selection wheel spokes
                    self.selectionCenterImageView.alpha = 0.6
                    self.selectionLikeImageView.alpha = 0.6
                    self.selectionSaveImageView.alpha = 0.6
                    self.selectionNextImageView.alpha = 0.8
                    self.selectionBackImageView.alpha = 0.6
                })
                selectionLikeHighlighted = false
                selectionSaveHighlighted = false
                selectionBackHighlighted = false
                selectionNextHighlighted = true
            }
            touchPoint = touch.location(in: self.selectionCenterImageView)
            if(self.selectionCenterImageView.bounds.contains(touchPoint)){
                UIView.animate(withDuration: 0.1, animations: {     //highlight selection wheel spokes
                    self.selectionCenterImageView.alpha = 0.8
                    self.selectionLikeImageView.alpha = 0.6
                    self.selectionSaveImageView.alpha = 0.6
                    self.selectionNextImageView.alpha = 0.6
                    self.selectionBackImageView.alpha = 0.6
                })
                selectionLikeHighlighted = false
                selectionSaveHighlighted = false
                selectionBackHighlighted = false
                selectionNextHighlighted = false
            }
            
            touchPoint = touch.location(in: self.selectionLikeImageView)
            if(self.selectionLikeImageView.bounds.contains(touchPoint) == false){
                touchPoint = touch.location(in: self.selectionSaveImageView)
                if(self.selectionSaveImageView.bounds.contains(touchPoint) == false){
                    touchPoint = touch.location(in: self.selectionCenterImageView)
                    if(self.selectionCenterImageView.bounds.contains(touchPoint) == false){
                        touchPoint = touch.location(in: self.selectionBackImageView)
                        if(self.selectionBackImageView.bounds.contains(touchPoint) == false){
                            touchPoint = touch.location(in: self.selectionNextImageView)
                            if(self.selectionNextImageView.bounds.contains(touchPoint) == false){
                                
                                UIView.animate(withDuration: 0.2, animations: {     //unhighlight selection wheel spokes
                                    self.selectionCenterImageView.alpha = 0.6
                                    self.selectionLikeImageView.alpha = 0.6
                                    self.selectionSaveImageView.alpha = 0.6
                                    self.selectionNextImageView.alpha = 0.6
                                    self.selectionBackImageView.alpha = 0.6
                                })
                                selectionLikeHighlighted = false
                                selectionSaveHighlighted = false
                                selectionBackHighlighted = false
                                selectionNextHighlighted = false
                            }
                        }
                        
                    }
                }
            }
        }
        
        if let touchX = touches.first?.preciseLocation(in: fullPostView).x{
            if let touchY = touches.first?.preciseLocation(in: fullPostView).y{
                if(touchDown == false){           //set the first touch x and y once
                    touchPressedX = touchX
                    touchPressedY = touchY
                    touchDown = true
                }
                touchReleasedX = touchX
                touchReleasedY = touchY
            }
        }
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(touchDown){  //make sure there was a drag
            touchDown = false
            if(selectionLikeHighlighted){     //like image selected
                
                likePost(likesRankIndexPath)
                stopSearching = false
                nextPost()
                //print("Like image")
                
            }
            if(selectionSaveHighlighted){
                savePost(likesRankIndexPath)
                stopSearching = false
                nextPost()
                
                // print("Save image")
            }
            if(selectionBackHighlighted){
                stopSearching = false
                goBackPost()
                //print("Go Back an image")
                
            }
            if(selectionNextHighlighted){
                stopSearching = false
                nextPost()
                // print("Next image")
            }
            //let horizontalChange:CGFloat = touchReleasedX - touchPressedX   // x and y change of drag
            //let verticalChange: CGFloat = touchPressedY - touchReleasedY
            
            //print(horizontalChange)
            //print(verticalChange)
        }
        
        UIView.animate(withDuration: 0.2, animations: {     //hide selection wheel
            self.selectionCenterImageView.alpha = 0
            self.selectionLikeImageView.alpha = 0
            self.selectionSaveImageView.alpha = 0
            self.selectionNextImageView.alpha = 0
            self.selectionBackImageView.alpha = 0
            self.grayBackgroundCoat.alpha = 0
            
            if(self.categoryMenuOpen){
                self.categoryMenuOpen = false
                self.popularCategoryButton.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
                self.recentCategoryButton.frame.origin = CGPoint(x: (self.recentCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
                self.cat1Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
                self.cat2Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
                self.cat3Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
                self.cat4Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
                self.cat5Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
                self.cat6Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
                self.cat7Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
                self.cat8Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
                self.cat9Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
                self.cat10Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
                
                self.cat1Button.alpha = 0
                self.cat2Button.alpha = 0
                self.cat3Button.alpha = 0
                self.cat4Button.alpha = 0
                self.cat5Button.alpha = 0
                self.cat6Button.alpha = 0
                self.cat7Button.alpha = 0
                self.cat8Button.alpha = 0
                self.cat9Button.alpha = 0
                self.cat10Button.alpha = 0
                self.popularCategoryButton.alpha = 0
                self.recentCategoryButton.alpha = 0
                self.grayBackgroundCoat.alpha = 0
            }
            
        })
        
        super.touchesEnded(touches, with: event)
    }
    
    
    func likePost(_ indexPath1: IndexPath){
        let post = self.posts[(indexPath1.row)] as! [String: AnyObject]  //get likes int from firebase
        let ref = post["postID"] as! String
        
        let base = FIRDatabase.database().reference()
        let uid = (FIRAuth.auth()?.currentUser?.uid)!
        
        let b = post["userWhoLikedID"] as? [String: Any]
        if let c = b?["\(uid)"] as? String{
            //user already liked post
            
        }else{
            //user hasent liked post yet
            var a = post["likes"] as? Int
            a = a! + 1
            base.child("posts").child(ref).child("likes").setValue(a)
            base.child("posts").child(ref).child("userWhoLikedID").child("\(uid)").setValue("a")  //increase post score
            
            let postUserID = post["uid"] as? String
            FIRDatabase.database().reference().child("users").child(postUserID!).child("score").observeSingleEvent(of: .value, with: { (snapshot) in
                if let score = snapshot.value as? [String: AnyObject]{    //get users score
                    var b = score["score"] as? Int
                    b = b! + 1
                    let scoreObject = ["score" : b!]
                    base.child("users").child(postUserID!).child("score").setValue(scoreObject)  //change score by +1
                }
            })
        }
        
        
        
    }
    //SAVE = Dislike //
    //SAVE = Dislike //
    
    func savePost(_ indexPath1: IndexPath){              //SAVE = Dislike //
        let post = self.posts[(indexPath1.row)] as! [String: AnyObject]  //get likes int from firebase
        let ref = post["postID"] as! String
        
        let base = FIRDatabase.database().reference()
        let uid = (FIRAuth.auth()?.currentUser?.uid)!
        
        let b = post["userWhoDislikedID"] as? [String: Any]
        if let c = b?["\(uid)"] as? String{
            //user already disliked post
            
        }else{
            //user hasent disliked post yet
            var a = post["likes"] as? Int
            a = a! - 1
            base.child("posts").child(ref).child("likes").setValue(a)
            base.child("posts").child(ref).child("userWhoDislikedID").child("\(uid)").setValue("a")
            if(a! < -4){
                base.child("posts").child(ref).removeValue()  //if -5 likes, delete post
            }
            
            
            let postUserID = post["uid"] as? String
            FIRDatabase.database().reference().child("users").child(postUserID!).child("score").observeSingleEvent(of: .value, with: { (snapshot) in
                if let score = snapshot.value as? [String: AnyObject]{    //get users score
                    var b = score["score"] as? Int
                    b = b! - 1
                    let scoreObject = ["score" : b!]
                    base.child("users").child(postUserID!).child("score").setValue(scoreObject)  //change score by -1
                }
            })
        }
        
    }
    func goBackPost(){
        if(sortByLikes){
            if(0 < likesRankRow){                    //chek if first image in column
                self.likesRankRow = self.likesRankRow - 1           //increment array location counter
                
                self.likesRankIndexPath.row = self.likesRankIndexPathsRows[likesRankRow] as! Int   //set next row as previous row in array
                self.likesRankIndexPath.section = 0
                
                self.postsTableView.scrollToRow(at: likesRankIndexPath, at: UITableViewScrollPosition.top, animated: false)//go to next top liked post
            }else{
                //no more posts to go back to
                stopSearching = true
                self.centerInfoText.text = "No Posts Before"
                UIView.animate(withDuration: 1.2, animations: {   //popup text appear
                    self.centerInfoText.alpha = 0.8
                })
                UIView.animate(withDuration: 1.8, animations: {   //popup text disappear
                    self.centerInfoText.alpha = 0
                })
                if(sortByCat1 || sortByCat2 || sortByCat3 || sortByCat4 || sortByCat5 || sortByCat6 || sortByCat7 || sortByCat8 || sortByCat9 || sortByCat10){
                    likesRankRow = goBackToRow + 1
                    goBackPost()
                }
                print("No post before")
            }
        }else if(sortByTime){
            if(0 < recentRankRow){                    //chek if first image in column
                self.recentRankRow = self.recentRankRow - 1           //increment array location counter
                
                self.recentRankIndexPath.row = self.recentRankIndexPathsRows[recentRankRow] as! Int   //set next row as previous row in array
                self.recentRankIndexPath.section = 0
                
                self.postsTableView.scrollToRow(at: recentRankIndexPath, at: UITableViewScrollPosition.top, animated: false)//go to next tmost recent post
            }else{
                //no more posts to go back to
                self.centerInfoText.text = "No Posts Before"
                UIView.animate(withDuration: 1.2, animations: {   //popup text appear
                    self.centerInfoText.alpha = 0.8
                })
                UIView.animate(withDuration: 1.8, animations: {   //popup text disappear
                    self.centerInfoText.alpha = 0
                })
                print("No post before")
            }
        }
        
        let post = self.posts[self.likesRankIndexPath.row] as! [String: AnyObject]  //get category from firebase
        let postCategory = post["category"] as! String
        
        if(sortByCat1){
            if(cat1.lowercased() != postCategory.lowercased()){
                if(!stopSearching){
                    goBackPost()
                }
            }else{
                goBackToRow = likesRankRow    //save the row of the last image in the category
            }
        }else if(sortByCat2){
            if(cat2.lowercased() != postCategory.lowercased()){
                if(!stopSearching){
                    goBackPost()
                }
            }else{
                goBackToRow = likesRankRow    //save the row of the last image in the category
            }
        }else if(sortByCat3){
            if(cat3.lowercased() != postCategory.lowercased()){
                if(!stopSearching){
                    goBackPost()
                }
            }else{
                goBackToRow = likesRankRow    //save the row of the last image in the category
            }
        }else if(sortByCat4){
            if(cat4.lowercased() != postCategory.lowercased()){
                if(!stopSearching){
                    goBackPost()
                }
            }else{
                goBackToRow = likesRankRow    //save the row of the last image in the category
            }
        }else if(sortByCat5){
            if(cat5.lowercased() != postCategory.lowercased()){
                if(!stopSearching){
                    goBackPost()
                }
            }else{
                goBackToRow = likesRankRow    //save the row of the last image in the category
            }
        }else if(sortByCat6){
            if(cat6.lowercased() != postCategory.lowercased()){
                if(!stopSearching){
                    goBackPost()
                }
            }else{
                goBackToRow = likesRankRow    //save the row of the last image in the category
            }
        }else if(sortByCat7){
            if(cat7.lowercased() != postCategory.lowercased()){
                if(!stopSearching){
                    goBackPost()
                }
            }else{
                goBackToRow = likesRankRow    //save the row of the last image in the category
            }
        }else if(sortByCat8){
            if(cat8.lowercased() != postCategory.lowercased()){
                if(!stopSearching){
                    goBackPost()
                }
            }else{
                goBackToRow = likesRankRow    //save the row of the last image in the category
            }
        }else if(sortByCat9){
            if(cat9.lowercased() != postCategory.lowercased()){
                if(!stopSearching){
                    goBackPost()
                }
            }else{
                goBackToRow = likesRankRow    //save the row of the last image in the category
            }
        }else if(sortByCat10){
            if(cat10.lowercased() != postCategory.lowercased()){
                if(!stopSearching){
                    goBackPost()
                }
            }else{
                goBackToRow = likesRankRow    //save the row of the last image in the category
            }
        }
    }
    
    
    func nextPost(){            //go to next post
        
        
        let numberOfRows = self.postsTableView.numberOfRows(inSection: 0)   //get number oftotal rows
        if(sortByLikes){
            if(numberOfRows > self.likesRankRow + 1){                    //chek if last image in column
                self.likesRankRow = self.likesRankRow + 1           //increment array location counter
                self.likesRankIndexPath.row = self.likesRankIndexPathsRows[self.likesRankRow] as! Int   //set next row as next row in array
                self.likesRankIndexPath.section = 0
                
                self.postsTableView.scrollToRow(at: self.likesRankIndexPath, at: UITableViewScrollPosition.top, animated: false)//go to next top liked post
                
            }else{
                //no more posts to view
                stopSearching = true
                self.centerInfoText.text = "No More Posts"
                UIView.animate(withDuration: 1.2, animations: {   //popup text appear
                    self.centerInfoText.alpha = 0.8
                })
                UIView.animate(withDuration: 1.8, animations: {   //popup text disappear
                    self.centerInfoText.alpha = 0
                })
                if(sortByCat1 || sortByCat2 || sortByCat3 || sortByCat4 || sortByCat5 || sortByCat6 || sortByCat7 || sortByCat8 || sortByCat9 || sortByCat10){
                    self.likesRankRow = self.goBackToRow - 1
                    nextPost()
                }
                print("No more posts")
            }
        }else if(sortByTime){
            if(numberOfRows > recentRankRow + 1){                    //chek if last image in column
                
                self.recentRankRow = self.recentRankRow + 1           //increment array location counter
                self.recentRankIndexPath.row = self.recentRankIndexPathsRows[recentRankRow] as! Int   //set next row as next row in array
                self.recentRankIndexPath.section = 0
                
                self.postsTableView.scrollToRow(at: recentRankIndexPath, at: UITableViewScrollPosition.top, animated: false)//go to next tmost recent post
            }else{
                //no more posts to view
                self.centerInfoText.text = "No More Posts"
                UIView.animate(withDuration: 1.2, animations: {   //popup text appear
                    self.centerInfoText.alpha = 0.8
                })
                UIView.animate(withDuration: 1.8, animations: {   //popup text disappear
                    self.centerInfoText.alpha = 0
                })
                print("No more posts")
            }
        }
        let post = self.posts[self.likesRankIndexPath.row] as! [String: AnyObject]  //get category from firebase
        let postCategory = post["category"] as! String
        print(postCategory)
        print(cat3)
        if(sortByCat1){
            if(cat1.lowercased() != postCategory.lowercased()){
                if(!stopSearching){
                    nextPost()
                }
            }else{
                self.goBackToRow = self.likesRankRow    //save the row of the last image in the category
            }
        }else if(sortByCat2){
            if(cat2.lowercased() != postCategory.lowercased()){
                if(!stopSearching){
                    nextPost()
                }
            }else{
                self.goBackToRow = self.likesRankRow    //save the row of the last image in the category
            }
        }else if(sortByCat3){
            print("a")
            if(cat3.lowercased() != postCategory.lowercased()){
                print("b")
                if(!stopSearching){
                    print("c")
                    nextPost()
                }
            }else{
                print("d")
                self.goBackToRow = self.likesRankRow    //save the row of the last image in the category
            }
        }else if(sortByCat4){
            if(cat4.lowercased() != postCategory.lowercased()){
                if(!stopSearching){
                    nextPost()
                }
            }else{
                self.goBackToRow = self.likesRankRow    //save the row of the last image in the category
            }
        }else if(sortByCat5){
            if(cat5.lowercased() != postCategory.lowercased()){
                if(!stopSearching){
                    nextPost()
                }
            }else{
                self.goBackToRow = self.likesRankRow    //save the row of the last image in the category
            }
        }else if(sortByCat6){
            if(cat6.lowercased() != postCategory.lowercased()){
                if(!stopSearching){
                    nextPost()
                }
            }else{
                self.goBackToRow = self.likesRankRow    //save the row of the last image in the category
            }
        }else if(sortByCat7){
            if(cat7.lowercased() != postCategory.lowercased()){
                if(!stopSearching){
                    nextPost()
                }
            }else{
                self.goBackToRow = self.likesRankRow    //save the row of the last image in the category
            }
        }else if(sortByCat8){
            if(cat8.lowercased() != postCategory.lowercased()){
                if(!stopSearching){
                    nextPost()
                }
            }else{
                self.goBackToRow = self.likesRankRow    //save the row of the last image in the category
            }
        }else if(sortByCat9){
            if(cat9.lowercased() != postCategory.lowercased()){
                if(!stopSearching){
                    nextPost()
                }
            }else{
                self.goBackToRow = self.likesRankRow    //save the row of the last image in the category
            }
        }else if(sortByCat10){
            if(cat10.lowercased() != postCategory.lowercased()){
                if(!stopSearching){
                    nextPost()
                }
            }else{
                self.goBackToRow = self.likesRankRow    //save the row of the last image in the category
            }
        }
        
        
    }
    
    @IBAction func categoryMenuTapped(_ sender: Any) {                  //open category menu, dropdown look
        if(categoryMenuOpen){                           //category menu already open, so close it
            categoryMenuOpen = false
            UIView.animate(withDuration: 0.2, animations: {
                self.popularCategoryButton.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
                self.recentCategoryButton.frame.origin = CGPoint(x: (self.recentCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
                self.cat1Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
                self.cat2Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
                self.cat3Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
                self.cat4Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
                self.cat5Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
                self.cat6Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
                self.cat7Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
                self.cat8Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
                self.cat9Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
                self.cat10Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
                
                self.cat1Button.alpha = 0
                self.cat2Button.alpha = 0
                self.cat3Button.alpha = 0
                self.cat4Button.alpha = 0
                self.cat5Button.alpha = 0
                self.cat6Button.alpha = 0
                self.cat7Button.alpha = 0
                self.cat8Button.alpha = 0
                self.cat9Button.alpha = 0
                self.cat10Button.alpha = 0
                self.popularCategoryButton.alpha = 0
                self.recentCategoryButton.alpha = 0
                self.grayBackgroundCoat.alpha = 0
            })
            
        }else{                                          //category menu closed, so open it
            categoryMenuOpen = true
            UIView.animate(withDuration: 0.2, animations: {
                self.popularCategoryButton.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: (self.categoryMenuButton.frame.origin.y + self.popularCategoryButton.frame.height + 18))
                self.recentCategoryButton.frame.origin = CGPoint(x: (self.recentCategoryButton.frame.origin.x ), y: (self.categoryMenuButton.frame.origin.y + self.popularCategoryButton.frame.height + self.recentCategoryButton.frame.height + 18))
                
                var y = self.recentCategoryButton.frame.origin.y + self.recentCategoryButton.frame.height
                if(self.cat1Available){                                  //add in extra category buttons
                    self.cat1Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: y)
                    y  = self.cat1Button.frame.origin.y + self.cat1Button.frame.height
                    self.cat1Button.alpha = 1
                }
                if(self.cat2Available){
                    self.cat2Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: y)
                    y  = self.cat2Button.frame.origin.y + self.cat2Button.frame.height
                    self.cat2Button.alpha = 1
                }
                if(self.cat3Available){
                    self.cat3Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: y)
                    y  = self.cat3Button.frame.origin.y + self.cat3Button.frame.height
                    self.cat3Button.alpha = 1
                }
                if(self.cat4Available){
                    self.cat4Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: y)
                    y  = self.cat4Button.frame.origin.y + self.cat4Button.frame.height
                    self.cat4Button.alpha = 1
                }
                if(self.cat5Available){
                    self.cat5Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: y)
                    y  = self.cat5Button.frame.origin.y + self.cat5Button.frame.height
                    self.cat5Button.alpha = 1
                }
                if(self.cat6Available){
                    self.cat6Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: y)
                    y  = self.cat6Button.frame.origin.y + self.cat6Button.frame.height
                    self.cat6Button.alpha = 1
                }
                if(self.cat7Available){
                    self.cat7Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: y)
                    y  = self.cat7Button.frame.origin.y + self.cat7Button.frame.height
                    self.cat7Button.alpha = 1
                }
                if(self.cat8Available){
                    self.cat8Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: y)
                    y  = self.cat8Button.frame.origin.y + self.cat8Button.frame.height
                    self.cat8Button.alpha = 1
                }
                if(self.cat9Available){
                    self.cat9Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: y)
                    y  = self.cat9Button.frame.origin.y + self.cat9Button.frame.height
                    self.cat9Button.alpha = 1
                }
                if(self.cat10Available){
                    self.cat10Button.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: y)
                    y  = self.cat10Button.frame.origin.y + self.cat10Button.frame.height
                    self.cat10Button.alpha = 1
                }
                
                self.popularCategoryButton.alpha = 1
                self.recentCategoryButton.alpha = 1
                self.grayBackgroundCoat.alpha = 0.5
            })
        }
    }
    
    @IBAction func recentCategoryTapped(_ sender: Any) {                //recent selected as category
        categoryMenuOpen = false
        sortByTime = true
        sortByLikes = false
        sortByCat1 = false
        sortByCat2 = false
        sortByCat3 = false
        sortByCat4 = false
        sortByCat5 = false
        sortByCat6 = false
        sortByCat7 = false
        sortByCat8 = false
        sortByCat9 = false
        sortByCat10 = false
        stopSearching = false
        recentRankRow = -1
        nextPost()
        self.categoryMenuButton.setTitle("Recent", for: .normal)
        UIView.animate(withDuration: 0.2, animations: {
            self.popularCategoryButton.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.recentCategoryButton.frame.origin = CGPoint(x: (self.recentCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat1Button.frame.origin = CGPoint(x: (self.cat1Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat2Button.frame.origin = CGPoint(x: (self.cat2Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat3Button.frame.origin = CGPoint(x: (self.cat3Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat4Button.frame.origin = CGPoint(x: (self.cat4Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat5Button.frame.origin = CGPoint(x: (self.cat5Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat6Button.frame.origin = CGPoint(x: (self.cat6Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat7Button.frame.origin = CGPoint(x: (self.cat7Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat8Button.frame.origin = CGPoint(x: (self.cat8Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat9Button.frame.origin = CGPoint(x: (self.cat9Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat10Button.frame.origin = CGPoint(x: (self.cat10Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            
            self.cat1Button.alpha = 0
            self.cat2Button.alpha = 0
            self.cat3Button.alpha = 0
            self.cat4Button.alpha = 0
            self.cat5Button.alpha = 0
            self.cat6Button.alpha = 0
            self.cat7Button.alpha = 0
            self.cat8Button.alpha = 0
            self.cat9Button.alpha = 0
            self.cat10Button.alpha = 0
            self.popularCategoryButton.alpha = 0
            self.recentCategoryButton.alpha = 0
            self.grayBackgroundCoat.alpha = 0
        })
    }
    
    @IBAction func popularCategoryTapped(_ sender: Any) {                   //popular selected as category
        categoryMenuOpen = false
        sortByTime = false
        sortByLikes = true
        sortByCat1 = false
        sortByCat2 = false
        sortByCat3 = false
        sortByCat4 = false
        sortByCat5 = false
        sortByCat6 = false
        sortByCat7 = false
        sortByCat8 = false
        sortByCat9 = false
        sortByCat10 = false
        stopSearching = false
        likesRankRow = -1
        nextPost()
        self.categoryMenuButton.setTitle("Popular", for: .normal)
        UIView.animate(withDuration: 0.2, animations: {
            self.popularCategoryButton.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.recentCategoryButton.frame.origin = CGPoint(x: (self.recentCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat1Button.frame.origin = CGPoint(x: (self.cat1Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat2Button.frame.origin = CGPoint(x: (self.cat2Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat3Button.frame.origin = CGPoint(x: (self.cat3Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat4Button.frame.origin = CGPoint(x: (self.cat4Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat5Button.frame.origin = CGPoint(x: (self.cat5Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat6Button.frame.origin = CGPoint(x: (self.cat6Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat7Button.frame.origin = CGPoint(x: (self.cat7Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat8Button.frame.origin = CGPoint(x: (self.cat8Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat9Button.frame.origin = CGPoint(x: (self.cat9Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat10Button.frame.origin = CGPoint(x: (self.cat10Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            
            self.cat1Button.alpha = 0
            self.cat2Button.alpha = 0
            self.cat3Button.alpha = 0
            self.cat4Button.alpha = 0
            self.cat5Button.alpha = 0
            self.cat6Button.alpha = 0
            self.cat7Button.alpha = 0
            self.cat8Button.alpha = 0
            self.cat9Button.alpha = 0
            self.cat10Button.alpha = 0
            self.popularCategoryButton.alpha = 0
            self.recentCategoryButton.alpha = 0
            self.grayBackgroundCoat.alpha = 0
        })
        
    }
    
    @IBAction func cat1ButtonTapped(_ sender: Any) {
        categoryMenuOpen = false
        sortByTime = false
        sortByLikes = true
        sortByCat1 = true
        sortByCat2 = false
        sortByCat3 = false
        sortByCat4 = false
        sortByCat5 = false
        sortByCat6 = false
        sortByCat7 = false
        sortByCat8 = false
        sortByCat9 = false
        sortByCat10 = false
        stopSearching = false
        likesRankRow = -1
        nextPost()
        self.categoryMenuButton.setTitle(cat1, for: .normal)
        UIView.animate(withDuration: 0.2, animations: {
            self.popularCategoryButton.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.recentCategoryButton.frame.origin = CGPoint(x: (self.recentCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat1Button.frame.origin = CGPoint(x: (self.cat1Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat2Button.frame.origin = CGPoint(x: (self.cat2Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat3Button.frame.origin = CGPoint(x: (self.cat3Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat4Button.frame.origin = CGPoint(x: (self.cat4Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat5Button.frame.origin = CGPoint(x: (self.cat5Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat6Button.frame.origin = CGPoint(x: (self.cat6Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat7Button.frame.origin = CGPoint(x: (self.cat7Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat8Button.frame.origin = CGPoint(x: (self.cat8Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat9Button.frame.origin = CGPoint(x: (self.cat9Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat10Button.frame.origin = CGPoint(x: (self.cat10Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            
            self.cat1Button.alpha = 0
            self.cat2Button.alpha = 0
            self.cat3Button.alpha = 0
            self.cat4Button.alpha = 0
            self.cat5Button.alpha = 0
            self.cat6Button.alpha = 0
            self.cat7Button.alpha = 0
            self.cat8Button.alpha = 0
            self.cat9Button.alpha = 0
            self.cat10Button.alpha = 0
            self.popularCategoryButton.alpha = 0
            self.recentCategoryButton.alpha = 0
            self.grayBackgroundCoat.alpha = 0
        })
    }
    @IBAction func cat2ButtonTapped(_ sender: Any) {
        categoryMenuOpen = false
        sortByTime = false
        sortByLikes = true
        sortByCat1 = false
        sortByCat2 = true
        sortByCat3 = false
        sortByCat4 = false
        sortByCat5 = false
        sortByCat6 = false
        sortByCat7 = false
        sortByCat8 = false
        sortByCat9 = false
        sortByCat10 = false
        stopSearching = false
        likesRankRow = -1
        nextPost()
        self.categoryMenuButton.setTitle(cat2, for: .normal)
        UIView.animate(withDuration: 0.2, animations: {
            self.popularCategoryButton.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.recentCategoryButton.frame.origin = CGPoint(x: (self.recentCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat1Button.frame.origin = CGPoint(x: (self.cat1Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat2Button.frame.origin = CGPoint(x: (self.cat2Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat3Button.frame.origin = CGPoint(x: (self.cat3Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat4Button.frame.origin = CGPoint(x: (self.cat4Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat5Button.frame.origin = CGPoint(x: (self.cat5Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat6Button.frame.origin = CGPoint(x: (self.cat6Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat7Button.frame.origin = CGPoint(x: (self.cat7Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat8Button.frame.origin = CGPoint(x: (self.cat8Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat9Button.frame.origin = CGPoint(x: (self.cat9Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat10Button.frame.origin = CGPoint(x: (self.cat10Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            
            self.cat1Button.alpha = 0
            self.cat2Button.alpha = 0
            self.cat3Button.alpha = 0
            self.cat4Button.alpha = 0
            self.cat5Button.alpha = 0
            self.cat6Button.alpha = 0
            self.cat7Button.alpha = 0
            self.cat8Button.alpha = 0
            self.cat9Button.alpha = 0
            self.cat10Button.alpha = 0
            self.popularCategoryButton.alpha = 0
            self.recentCategoryButton.alpha = 0
            self.grayBackgroundCoat.alpha = 0
        })
    }
    @IBAction func cat3ButtonTapped(_ sender: Any) {
        categoryMenuOpen = false
        sortByTime = false
        sortByLikes = true
        sortByCat1 = false
        sortByCat2 = false
        sortByCat3 = true
        sortByCat4 = false
        sortByCat5 = false
        sortByCat6 = false
        sortByCat7 = false
        sortByCat8 = false
        sortByCat9 = false
        sortByCat10 = false
        stopSearching = false
        likesRankRow = -1
        nextPost()
        self.categoryMenuButton.setTitle(cat3, for: .normal)
        UIView.animate(withDuration: 0.2, animations: {
            self.popularCategoryButton.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.recentCategoryButton.frame.origin = CGPoint(x: (self.recentCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat1Button.frame.origin = CGPoint(x: (self.cat1Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat2Button.frame.origin = CGPoint(x: (self.cat2Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat3Button.frame.origin = CGPoint(x: (self.cat3Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat4Button.frame.origin = CGPoint(x: (self.cat4Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat5Button.frame.origin = CGPoint(x: (self.cat5Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat6Button.frame.origin = CGPoint(x: (self.cat6Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat7Button.frame.origin = CGPoint(x: (self.cat7Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat8Button.frame.origin = CGPoint(x: (self.cat8Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat9Button.frame.origin = CGPoint(x: (self.cat9Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat10Button.frame.origin = CGPoint(x: (self.cat10Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            
            self.cat1Button.alpha = 0
            self.cat2Button.alpha = 0
            self.cat3Button.alpha = 0
            self.cat4Button.alpha = 0
            self.cat5Button.alpha = 0
            self.cat6Button.alpha = 0
            self.cat7Button.alpha = 0
            self.cat8Button.alpha = 0
            self.cat9Button.alpha = 0
            self.cat10Button.alpha = 0
            self.popularCategoryButton.alpha = 0
            self.recentCategoryButton.alpha = 0
            self.grayBackgroundCoat.alpha = 0
        })
    }
    @IBAction func cat4ButtonTapped(_ sender: Any) {
        categoryMenuOpen = false
        sortByTime = false
        sortByLikes = true
        sortByCat1 = false
        sortByCat2 = false
        sortByCat3 = false
        sortByCat4 = true
        sortByCat5 = false
        sortByCat6 = false
        sortByCat7 = false
        sortByCat8 = false
        sortByCat9 = false
        sortByCat10 = false
        stopSearching = false
        likesRankRow = -1
        nextPost()
        self.categoryMenuButton.setTitle(cat4, for: .normal)
        UIView.animate(withDuration: 0.2, animations: {
            self.popularCategoryButton.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.recentCategoryButton.frame.origin = CGPoint(x: (self.recentCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat1Button.frame.origin = CGPoint(x: (self.cat1Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat2Button.frame.origin = CGPoint(x: (self.cat2Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat3Button.frame.origin = CGPoint(x: (self.cat3Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat4Button.frame.origin = CGPoint(x: (self.cat4Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat5Button.frame.origin = CGPoint(x: (self.cat5Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat6Button.frame.origin = CGPoint(x: (self.cat6Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat7Button.frame.origin = CGPoint(x: (self.cat7Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat8Button.frame.origin = CGPoint(x: (self.cat8Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat9Button.frame.origin = CGPoint(x: (self.cat9Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat10Button.frame.origin = CGPoint(x: (self.cat10Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            
            self.cat1Button.alpha = 0
            self.cat2Button.alpha = 0
            self.cat3Button.alpha = 0
            self.cat4Button.alpha = 0
            self.cat5Button.alpha = 0
            self.cat6Button.alpha = 0
            self.cat7Button.alpha = 0
            self.cat8Button.alpha = 0
            self.cat9Button.alpha = 0
            self.cat10Button.alpha = 0
            self.popularCategoryButton.alpha = 0
            self.recentCategoryButton.alpha = 0
            self.grayBackgroundCoat.alpha = 0
        })
    }
    @IBAction func cat5ButtonTapped(_ sender: Any) {
        categoryMenuOpen = false
        sortByTime = false
        sortByLikes = true
        sortByCat1 = false
        sortByCat2 = false
        sortByCat3 = false
        sortByCat4 = false
        sortByCat5 = true
        sortByCat6 = false
        sortByCat7 = false
        sortByCat8 = false
        sortByCat9 = false
        sortByCat10 = false
        stopSearching = false
        likesRankRow = -1
        nextPost()
        self.categoryMenuButton.setTitle(cat5, for: .normal)
        UIView.animate(withDuration: 0.2, animations: {
            self.popularCategoryButton.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.recentCategoryButton.frame.origin = CGPoint(x: (self.recentCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat1Button.frame.origin = CGPoint(x: (self.cat1Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat2Button.frame.origin = CGPoint(x: (self.cat2Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat3Button.frame.origin = CGPoint(x: (self.cat3Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat4Button.frame.origin = CGPoint(x: (self.cat4Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat5Button.frame.origin = CGPoint(x: (self.cat5Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat6Button.frame.origin = CGPoint(x: (self.cat6Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat7Button.frame.origin = CGPoint(x: (self.cat7Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat8Button.frame.origin = CGPoint(x: (self.cat8Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat9Button.frame.origin = CGPoint(x: (self.cat9Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat10Button.frame.origin = CGPoint(x: (self.cat10Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            
            self.cat1Button.alpha = 0
            self.cat2Button.alpha = 0
            self.cat3Button.alpha = 0
            self.cat4Button.alpha = 0
            self.cat5Button.alpha = 0
            self.cat6Button.alpha = 0
            self.cat7Button.alpha = 0
            self.cat8Button.alpha = 0
            self.cat9Button.alpha = 0
            self.cat10Button.alpha = 0
            self.popularCategoryButton.alpha = 0
            self.recentCategoryButton.alpha = 0
            self.grayBackgroundCoat.alpha = 0
        })
    }
    @IBAction func cat6ButtonTapped(_ sender: Any) {
        categoryMenuOpen = false
        sortByTime = false
        sortByLikes = true
        sortByCat1 = false
        sortByCat2 = false
        sortByCat3 = false
        sortByCat4 = false
        sortByCat5 = false
        sortByCat6 = true
        sortByCat7 = false
        sortByCat8 = false
        sortByCat9 = false
        sortByCat10 = false
        stopSearching = false
        likesRankRow = -1
        nextPost()
        self.categoryMenuButton.setTitle(cat6, for: .normal)
        UIView.animate(withDuration: 0.2, animations: {
            self.popularCategoryButton.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.recentCategoryButton.frame.origin = CGPoint(x: (self.recentCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat1Button.frame.origin = CGPoint(x: (self.cat1Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat2Button.frame.origin = CGPoint(x: (self.cat2Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat3Button.frame.origin = CGPoint(x: (self.cat3Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat4Button.frame.origin = CGPoint(x: (self.cat4Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat5Button.frame.origin = CGPoint(x: (self.cat5Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat6Button.frame.origin = CGPoint(x: (self.cat6Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat7Button.frame.origin = CGPoint(x: (self.cat7Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat8Button.frame.origin = CGPoint(x: (self.cat8Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat9Button.frame.origin = CGPoint(x: (self.cat9Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat10Button.frame.origin = CGPoint(x: (self.cat10Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            
            self.cat1Button.alpha = 0
            self.cat2Button.alpha = 0
            self.cat3Button.alpha = 0
            self.cat4Button.alpha = 0
            self.cat5Button.alpha = 0
            self.cat6Button.alpha = 0
            self.cat7Button.alpha = 0
            self.cat8Button.alpha = 0
            self.cat9Button.alpha = 0
            self.cat10Button.alpha = 0
            self.popularCategoryButton.alpha = 0
            self.recentCategoryButton.alpha = 0
            self.grayBackgroundCoat.alpha = 0
        })
    }
    @IBAction func cat7ButtonTapped(_ sender: Any) {
        categoryMenuOpen = false
        sortByTime = false
        sortByLikes = true
        sortByCat1 = false
        sortByCat2 = false
        sortByCat3 = false
        sortByCat4 = false
        sortByCat5 = false
        sortByCat6 = false
        sortByCat7 = true
        sortByCat8 = false
        sortByCat9 = false
        sortByCat10 = false
        stopSearching = false
        likesRankRow = -1
        nextPost()
        self.categoryMenuButton.setTitle(cat7, for: .normal)
        UIView.animate(withDuration: 0.2, animations: {
            self.popularCategoryButton.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.recentCategoryButton.frame.origin = CGPoint(x: (self.recentCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat1Button.frame.origin = CGPoint(x: (self.cat1Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat2Button.frame.origin = CGPoint(x: (self.cat2Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat3Button.frame.origin = CGPoint(x: (self.cat3Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat4Button.frame.origin = CGPoint(x: (self.cat4Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat5Button.frame.origin = CGPoint(x: (self.cat5Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat6Button.frame.origin = CGPoint(x: (self.cat6Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat7Button.frame.origin = CGPoint(x: (self.cat7Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat8Button.frame.origin = CGPoint(x: (self.cat8Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat9Button.frame.origin = CGPoint(x: (self.cat9Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat10Button.frame.origin = CGPoint(x: (self.cat10Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            
            self.cat1Button.alpha = 0
            self.cat2Button.alpha = 0
            self.cat3Button.alpha = 0
            self.cat4Button.alpha = 0
            self.cat5Button.alpha = 0
            self.cat6Button.alpha = 0
            self.cat7Button.alpha = 0
            self.cat8Button.alpha = 0
            self.cat9Button.alpha = 0
            self.cat10Button.alpha = 0
            self.popularCategoryButton.alpha = 0
            self.recentCategoryButton.alpha = 0
            self.grayBackgroundCoat.alpha = 0
        })
    }
    @IBAction func cat8ButtonTapped(_ sender: Any) {
        categoryMenuOpen = false
        sortByTime = false
        sortByLikes = true
        sortByCat1 = false
        sortByCat2 = false
        sortByCat3 = false
        sortByCat4 = false
        sortByCat5 = false
        sortByCat6 = false
        sortByCat7 = false
        sortByCat8 = true
        sortByCat9 = false
        sortByCat10 = false
        stopSearching = false
        likesRankRow = -1
        nextPost()
        self.categoryMenuButton.setTitle(cat8, for: .normal)
        UIView.animate(withDuration: 0.2, animations: {
            self.popularCategoryButton.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.recentCategoryButton.frame.origin = CGPoint(x: (self.recentCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat1Button.frame.origin = CGPoint(x: (self.cat1Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat2Button.frame.origin = CGPoint(x: (self.cat2Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat3Button.frame.origin = CGPoint(x: (self.cat3Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat4Button.frame.origin = CGPoint(x: (self.cat4Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat5Button.frame.origin = CGPoint(x: (self.cat5Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat6Button.frame.origin = CGPoint(x: (self.cat6Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat7Button.frame.origin = CGPoint(x: (self.cat7Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat8Button.frame.origin = CGPoint(x: (self.cat8Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat9Button.frame.origin = CGPoint(x: (self.cat9Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat10Button.frame.origin = CGPoint(x: (self.cat10Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            
            self.cat1Button.alpha = 0
            self.cat2Button.alpha = 0
            self.cat3Button.alpha = 0
            self.cat4Button.alpha = 0
            self.cat5Button.alpha = 0
            self.cat6Button.alpha = 0
            self.cat7Button.alpha = 0
            self.cat8Button.alpha = 0
            self.cat9Button.alpha = 0
            self.cat10Button.alpha = 0
            self.popularCategoryButton.alpha = 0
            self.recentCategoryButton.alpha = 0
            self.grayBackgroundCoat.alpha = 0
        })
    }
    @IBAction func cat9ButtonTapped(_ sender: Any) {
        categoryMenuOpen = false
        sortByTime = false
        sortByLikes = true
        sortByCat1 = false
        sortByCat2 = false
        sortByCat3 = false
        sortByCat4 = false
        sortByCat5 = false
        sortByCat6 = false
        sortByCat7 = false
        sortByCat8 = false
        sortByCat9 = true
        sortByCat10 = false
        stopSearching = false
        likesRankRow = -1
        nextPost()
        self.categoryMenuButton.setTitle(cat9, for: .normal)
        UIView.animate(withDuration: 0.2, animations: {
            self.popularCategoryButton.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.recentCategoryButton.frame.origin = CGPoint(x: (self.recentCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat1Button.frame.origin = CGPoint(x: (self.cat1Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat2Button.frame.origin = CGPoint(x: (self.cat2Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat3Button.frame.origin = CGPoint(x: (self.cat3Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat4Button.frame.origin = CGPoint(x: (self.cat4Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat5Button.frame.origin = CGPoint(x: (self.cat5Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat6Button.frame.origin = CGPoint(x: (self.cat6Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat7Button.frame.origin = CGPoint(x: (self.cat7Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat8Button.frame.origin = CGPoint(x: (self.cat8Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat9Button.frame.origin = CGPoint(x: (self.cat9Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat10Button.frame.origin = CGPoint(x: (self.cat10Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            
            self.cat1Button.alpha = 0
            self.cat2Button.alpha = 0
            self.cat3Button.alpha = 0
            self.cat4Button.alpha = 0
            self.cat5Button.alpha = 0
            self.cat6Button.alpha = 0
            self.cat7Button.alpha = 0
            self.cat8Button.alpha = 0
            self.cat9Button.alpha = 0
            self.cat10Button.alpha = 0
            self.popularCategoryButton.alpha = 0
            self.recentCategoryButton.alpha = 0
            self.grayBackgroundCoat.alpha = 0
        })
    }
    @IBAction func cat10ButtonTapped(_ sender: Any) {
        categoryMenuOpen = false
        sortByTime = false
        sortByLikes = true
        sortByCat1 = false
        sortByCat2 = false
        sortByCat3 = false
        sortByCat4 = false
        sortByCat5 = false
        sortByCat6 = false
        sortByCat7 = false
        sortByCat8 = false
        sortByCat9 = false
        sortByCat10 = true
        stopSearching = false
        likesRankRow = -1
        nextPost()
        self.categoryMenuButton.setTitle(cat10, for: .normal)
        UIView.animate(withDuration: 0.2, animations: {
            self.popularCategoryButton.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.recentCategoryButton.frame.origin = CGPoint(x: (self.recentCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat1Button.frame.origin = CGPoint(x: (self.cat1Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat2Button.frame.origin = CGPoint(x: (self.cat2Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat3Button.frame.origin = CGPoint(x: (self.cat3Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat4Button.frame.origin = CGPoint(x: (self.cat4Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat5Button.frame.origin = CGPoint(x: (self.cat5Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat6Button.frame.origin = CGPoint(x: (self.cat6Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat7Button.frame.origin = CGPoint(x: (self.cat7Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat8Button.frame.origin = CGPoint(x: (self.cat8Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat9Button.frame.origin = CGPoint(x: (self.cat9Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.cat10Button.frame.origin = CGPoint(x: (self.cat10Button.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            
            self.cat1Button.alpha = 0
            self.cat2Button.alpha = 0
            self.cat3Button.alpha = 0
            self.cat4Button.alpha = 0
            self.cat5Button.alpha = 0
            self.cat6Button.alpha = 0
            self.cat7Button.alpha = 0
            self.cat8Button.alpha = 0
            self.cat9Button.alpha = 0
            self.cat10Button.alpha = 0
            self.popularCategoryButton.alpha = 0
            self.recentCategoryButton.alpha = 0
            self.grayBackgroundCoat.alpha = 0
        })
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
    
    
    
    /*
     to do
     change time deletion part
     add other cats
     
     
     
     
     
     
     
     
     */
    
}
