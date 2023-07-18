import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var todoItems = [TodoItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        let todoItem = todoItems[indexPath.row]
        cell.textLabel?.text = todoItem.title
        cell.accessoryType = todoItem.isChecked ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let todoItem = todoItems[indexPath.row]
        todoItem.isChecked = !todoItem.isChecked
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    @IBAction func addTodoItem(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Title"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { action in
            if let title = alert.textFields?.first?.text, !title.isEmpty {
                let todoItem = TodoItem(title: title)
                self.todoItems.append(todoItem)
                self.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}

class TodoItem: NSObject {
    var title: String
    var isChecked: Bool
    
    init(title: String) {
        self.title = title
        self.isChecked = false
    }
}
