    // MARK: Properties
    
    // MARK: Initializers
    
    
    // MARK: Methods
    

// MARK: - UITableViewDelegate, UITableViewDataSource
    
    
    
    

// MARK: - Layout Constraints
private extension ResultView {
    
    func layoutInitialView() {
        backgroundColor = .systemBackground
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
