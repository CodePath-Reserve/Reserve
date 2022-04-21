//
//  CatalogViewController.swift
//  Reserve
//
//  Created by Edward Cluster on 4/12/22.
//

//        PFUser.current()!.removeObjects(in: [books[indexPath.row]], forKey: "checkedOut")
//        PFUser.current()!.saveInBackground { (success, error) in
//            if success {
//                print("Comment saved")
//            } else {
//                print("Error saving comment")
//            }
//        }

import UIKit
import Parse
import AlamofireImage
import MessageInputBar

// Edward's changes
class SearchResult: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// Edwars's Changes
class CatalogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BookPostCellDelegate, MessageInputBarDelegate, UISearchResultsUpdating {
    func buttonTapped(cell: BookPostCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        let book = books[indexPath.section]
        
        if (book["status"] as! Bool == true) {
            book["status"] = false
            
            PFUser.current()!.add(book, forKey: "checkedOut")
            PFUser.current()!.saveInBackground { (success, error) in
                if success {
                    print("Book is checked out")
                    let alertDisapperTimeInSeconds = 1.5
                    let alert = UIAlertController(title: nil, message: "Checkout success", preferredStyle: .actionSheet)
                    self.present(alert, animated: true)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + alertDisapperTimeInSeconds) {
                      alert.dismiss(animated: true)
                    }
                } else {
                    print("Error checking out book")
                    let alertDisapperTimeInSeconds = 1.5
                    let alert = UIAlertController(title: nil, message: "Checkout failure", preferredStyle: .actionSheet)
                    self.present(alert, animated: true)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + alertDisapperTimeInSeconds) {
                      alert.dismiss(animated: true)
                    }
                }
            }
        } else {
            print("Book is already checked out")
            let alertDisapperTimeInSeconds = 1.5
            let alert = UIAlertController(title: nil, message: "Book is already checked out", preferredStyle: .actionSheet)
            self.present(alert, animated: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + alertDisapperTimeInSeconds) {
              alert.dismiss(animated: true)
            }
        }

    }
    
    func favoriteTapped(cell: BookPostCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        
        let book = books[indexPath.section]
        let favorites = PFUser.current()!["favorited"] as! [PFObject]
        
        for f in favorites {
            if book.objectId == f.objectId {
                print("Book is already favorited")
                let alertDisapperTimeInSeconds = 1.5
                let alert = UIAlertController(title: nil, message: "Book is already favorited", preferredStyle: .actionSheet)
                self.present(alert, animated: true)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + alertDisapperTimeInSeconds) {
                  alert.dismiss(animated: true)
                }
                return
            }
        }
        
        PFUser.current()!.add(book, forKey: "favorited")
        PFUser.current()!.saveInBackground { (success, error) in
            if success {
                print("Book is favorited")
                let alertDisapperTimeInSeconds = 1.5
                let alert = UIAlertController(title: nil, message: "Favorite success", preferredStyle: .actionSheet)
                self.present(alert, animated: true)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + alertDisapperTimeInSeconds) {
                  alert.dismiss(animated: true)
                }
            } else {
                print("Error checking out book")
                let alertDisapperTimeInSeconds = 1.5
                let alert = UIAlertController(title: nil, message: "Favorite failure", preferredStyle: .actionSheet)
                self.present(alert, animated: true)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + alertDisapperTimeInSeconds) {
                  alert.dismiss(animated: true)
                }
            }
        }
    }

    
    var books = [PFObject]()
    
    @IBOutlet weak var tableView: UITableView!
    let commentBar = MessageInputBar()
    var showsCommentBar = false
    
    var selectedBook: PFObject!
    
    // Edward's Changes
    let searchController = UISearchController(searchResultsController: SearchResult())
    var filteredData: [String]!
    @IBOutlet weak var searchTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Edward's changes
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        commentBar.inputTextView.placeholder = "Add a comment..."
        commentBar.sendButton.title = "Book"
        commentBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.keyboardDismissMode = .interactive
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    // Edward's changes
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        let vc = searchController.searchResultsController as? SearchResult
        vc?.view.backgroundColor = .systemCyan

        print("\nSearching for: "+text)
        print("\tBooks below:\n")

        for bookObj in books {
            let strTitle = bookObj["title"] as! String
            if strTitle.replacingOccurrences(of: " ", with: "").lowercased().contains(text.replacingOccurrences(of: " ", with: "").lowercased()){
                print("\t"+strTitle)
            }
        }
        
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        // create the comment
        let comment = PFObject(className: "Comments")
        comment["text"] = text
        comment["book"] = selectedBook
        comment["author"] = PFUser.current()!

        selectedBook.add(comment, forKey: "comments")

        selectedBook.saveInBackground { (success, error) in
            if success {
                print("Comment saved")
            } else {
                print("Error saving comment")
            }

        }
        
        tableView.reloadData()
        
        // clear and dismiss the input bar
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
    
    @objc func keyboardWillBeHidden(note: Notification) {
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
    }
    
    override var inputAccessoryView: UIView? {
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return showsCommentBar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let query = PFQuery(className: "Book")
        query.includeKeys(["author", "comments", "comments.author"])

        query.findObjectsInBackground { (books, error) in
            if books != nil {
                self.books = books!
                self.tableView.reloadData()
            } else {
                print("There are no books")
            }
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let book = books[section]
        let comments = (book["comments"] as? [PFObject]) ?? []
        
        return comments.count + 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let book = books[indexPath.section]
        let comments = (book["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookPostCell") as! BookPostCell
            cell.delegate = self
            cell.titleLabel.text = book["title"] as! String
            cell.authorLabel.text = book["author"] as! String
            
            let imageFile = book["cover"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            cell.photoView.af.setImage(withURL: url)
            return cell
        } else if indexPath.row <= comments.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            let comment = comments[indexPath.row - 1]
            cell.commentLabel.text = comment["text"] as? String
           
            let user = comment["author"] as! PFUser
            cell.nameLabel.text = user.username
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = books[indexPath.section]
        let comment = PFObject(className: "Comments")
        let comments = (book["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == comments.count + 1 {
            showsCommentBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
            
            selectedBook = book
        }
        
//        comment["text"] = "This is a random comment"
//        comment["book"] = book
//        comment["author"] = PFUser.current()!
//
//        book.add(comment, forKey: "comments")
//
//        book.saveInBackground { (success, error) in
//            if success {
//                print("Comment saved")
//            } else {
//                print("Error saving comment")
//            }
//
//        }
        
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        PFUser.logOut()
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else { return }
        
        delegate.window?.rootViewController = loginViewController
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
