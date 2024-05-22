//
//  MainViewController.swift
//  Cellular-Filling
//
//  Created by Дывак Максим on 21.05.2024.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    private var cells: [CellModel] = []
    private var liveCellInSeries = 0
    private var deadCellInSeries = 0
    
    private var worldTableView: UITableView!
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Клеточное наполнение"
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private lazy var createCellButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("СОТВОРИТЬ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 90/255, green: 52/255, blue: 114/255, alpha: 1.0)
        button.addTarget(self, action: #selector(didTapCreateCell), for: .touchUpInside)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        button.addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside])
        button.layer.cornerRadius = 6
        return button
    }()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewConfigure()
        createTable()
        setupLayouts()
    }
    
    //MARK: - Private methods
    private func viewConfigure() {
        let gradiendBackground = CAGradientLayer()
        gradiendBackground.colors = [UIColor(red: 49/255, green: 0, blue: 80/255, alpha: 100).cgColor, UIColor.black.cgColor]
        gradiendBackground.startPoint = CGPoint(x: view.bounds.midX, y: 0.0)
        gradiendBackground.endPoint = CGPoint(x: view.bounds.midX, y: 1.0)
        gradiendBackground.frame = view.bounds
        view.layer.addSublayer(gradiendBackground)
    }
    
    private func createTable() {
        worldTableView = UITableView(frame: .zero)
        worldTableView.translatesAutoresizingMaskIntoConstraints = false
        worldTableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "WorldCell")
        worldTableView.delegate = self
        worldTableView.dataSource = self
        worldTableView.backgroundColor = .clear
        worldTableView.rowHeight = 72
        worldTableView.separatorStyle = .none
    }
    
    private func setupLayouts() {
        view.addSubview(headerLabel)
        view.addSubview(createCellButton)
        view.addSubview(worldTableView)
        
        NSLayoutConstraint.activate([
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            createCellButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            createCellButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createCellButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createCellButton.heightAnchor.constraint(equalToConstant: 36),
            
            worldTableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 22),
            worldTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            worldTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            worldTableView.bottomAnchor.constraint(equalTo: createCellButton.topAnchor, constant: -30)
        ])
    }
    
    private func scrollToBottom() {
        let lastIndex = IndexPath(row: 0, section: cells.count-1)
        worldTableView.scrollToRow(at: lastIndex, at: .bottom, animated: true)
    }
    
    private func showTemporaryMessage(message: String, duration: TimeInterval = 2.0, bgColor: UIColor) {
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.backgroundColor = bgColor
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        messageLabel.text = message
        messageLabel.alpha = 0.0
        messageLabel.layer.cornerRadius = 8
        messageLabel.clipsToBounds = true

        view.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: worldTableView.topAnchor, constant: 50),
            messageLabel.widthAnchor.constraint(equalToConstant: 160),
            messageLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        UIView.animate(withDuration: 0.5, animations: {
            messageLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: duration, options: [], animations: {
                messageLabel.alpha = 0.0
            }) { _ in
                messageLabel.removeFromSuperview()
            }
        }
    }

    
    //MARK: - Button methods
    @objc private func buttonPressed() {
        createCellButton.backgroundColor = UIColor(red: 90/255, green: 52/255, blue: 114/255, alpha: 0.7)
    }
    
    @objc private func buttonReleased() {
        createCellButton.backgroundColor = UIColor(red: 90/255, green: 52/255, blue: 114/255, alpha: 1.0)
    }
    
    @objc private func didTapCreateCell() {
        let isAlive = Int.random(in: 0...1) == 1
        let cellType = isAlive ? CellType.alive : CellType.dead
        
        var cell: CellModel
        
        if cellType == .alive {
            liveCellInSeries += 1
            deadCellInSeries = 0
            cell = CellModel(title: "Живая", type: .alive, description: "и шевелится!", image: UIImage(named: "alive") ?? UIImage())
        } else {
            liveCellInSeries = 0
            deadCellInSeries += 1
            cell = CellModel(title: "Мёртвая", type: .alive, description: "или прикидывается", image: UIImage(named: "dead") ?? UIImage())
        }
        
        cells.append(cell)
        
        if liveCellInSeries == 3 {
            liveCellInSeries = 0
            cells.append(CellModel(title: "Жизнь", type: .specialLive, description: "Ку-ку!", image: UIImage(named: "live") ?? UIImage()))
            
            showTemporaryMessage(message: "Плюс жизнь :)", bgColor: .systemGreen)
        } else if deadCellInSeries == 3 {
            if let lastAliveIndex = cells.lastIndex(where: { $0.type == .specialLive }) {
                deadCellInSeries = 0
                cells.remove(at: lastAliveIndex)
                
                showTemporaryMessage(message: "Минус жизнь :(", bgColor: .systemRed)
            }
        }
        
        worldTableView.reloadData()
        scrollToBottom()
    }

}

//MARK: - TableView methods
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorldCell", for: indexPath) as! CustomTableViewCell
        cell.configure(with: cells[indexPath.section].title, description: cells[indexPath.section].description, image: cells[indexPath.section].image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

}


