//
//  CatalogViewController.swift
//  Reserve
//
//  Created by Edward Cluster on 4/12/22.
//

import UIKit
import Parse
import AlamofireImage
import MessageInputBar

class CatalogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var books = [PFObject]()
//    var selectedBooks: PFObject!
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let query = PFQuery(className: "Book")
        query.includeKey("title")
        query.includeKey("author")
//        query.includeKey("cover")
        query.limit = books.count

        query.findObjectsInBackground { (books, error) in
            if books != nil {
                self.books = books!
                self.tableView.reloadData()
            }
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TO DO: return the number of all books
//        return 5
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookPostCell") as! BookPostCell
        
        let book = books[indexPath.row]
        print(book["title"] as Any)

        cell.titleLabel.text = book["title"] as! String
        cell.authorLabel.text = book["author"] as! String
//        cell.titleLabel.text = "titles"
//        cell.authorLabel.text = "authors"
//        cell.genreLabel.text = "Some genre"
        return cell
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
