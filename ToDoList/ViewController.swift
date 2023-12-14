import UIKit

private let reuseIdentifier = "Cell"
private let userDefaultsKey = "items"

class ViewController: UIViewController {
    private let tableView = UITableView()
    
    private var items = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "To Do List"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        items = UserDefaults.standard.stringArray(forKey: userDefaultsKey) ?? []
        
        view.addSubview(tableView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(didTapAdd))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = self.view.bounds
    }
    
    // MARK: - Helpers
    
    @objc func didTapAdd() {
        let alert = UIAlertController(title: "New item", message: "Enter new to do list item", preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = "Enter item..."
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self](_) in
            if let field = alert.textFields?.first {
                if let text = field.text, !text.isEmpty {
                    DispatchQueue.main.async {
                        var currentItems = UserDefaults.standard.stringArray(forKey: userDefaultsKey) ?? []
                        currentItems.append(text)
                        UserDefaults.standard.setValue(currentItems, forKey: userDefaultsKey)
                        self?.items.append(text)
                        self?.tableView.reloadData()
                    }
                }
            }
        }))
        present(alert, animated: true)
    }


}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete item?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self](_) in
            DispatchQueue.main.async {
                var currentItems = UserDefaults.standard.stringArray(forKey: userDefaultsKey) ?? []
                currentItems.remove(at: indexPath.row)
                UserDefaults.standard.setValue(currentItems, forKey: userDefaultsKey)
                self?.items.remove(at: indexPath.row)
                self?.tableView.reloadData()
            }
        }))
        present(alert, animated: true)
    }
}

