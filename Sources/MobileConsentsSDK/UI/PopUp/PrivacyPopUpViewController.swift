import UIKit

final class PrivacyPopUpViewController: UIViewController {
    private lazy var navigationBar: UINavigationBar = {
        let bar = UINavigationBar()
        bar.prefersLargeTitles = true
        bar.isTranslucent = false
        bar.delegate = self.viewModel
        bar.backgroundColor = .navigationBarbackground
        bar.items = [self.barItem]
        return bar
    }()
    
    private lazy var barItem: UINavigationItem = {
        let item = UINavigationItem()
        item.leftBarButtonItem = UIBarButtonItem(title: "Accept selected", style: .plain, target: self, action: #selector(acceptSelected))
        item.rightBarButtonItem = UIBarButtonItem(title: "Accept all", style: .plain, target: self, action: #selector(acceptAll))
        
        item.leftBarButtonItem?.tintColor = accentColor
        item.rightBarButtonItem?.tintColor = accentColor
        
        return item
    }()
    
    private lazy var readModeButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Read more", for: .normal)
        btn.tintColor = accentColor
        btn.setTitleColor(accentColor, for: .normal)
        btn.addTarget(self, action: #selector(openProvacyPolicy), for: .touchUpInside)
        btn.titleLabel?.font = fontSet.bold
        return btn
    }()
    
    private lazy var privacyDescription: UILabel = {
        let label = UILabel()
        label.font = fontSet.bold
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var poweredByLabel: UILabel = {
        let label = UILabel()
        let powered = NSAttributedString(string: "Powered by ",
                                         attributes: [.font: UIFont.systemFont(ofSize: 10, weight: .regular),
                                                      .foregroundColor: UIColor.lightGray])
        
        let cookie = NSAttributedString(string: "Cookie Information",
                                        attributes: [.font: UIFont.systemFont(ofSize: 10, weight: .bold),
                                                     .foregroundColor: UIColor.lightGray])
        let combined = NSMutableAttributedString(attributedString: powered)
        combined.append(cookie)
        label.attributedText = combined
        
        return label
    }()
    
    private var privacyPolicyLongtext = ""
    private let tableView = UITableView()
    private lazy var buttonsView = { PopUpButtonsView(accentColor: accentColor) }()
    private let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    private let accentColor: UIColor
    private let viewModel: PrivacyPopUpViewModelProtocol
    private var sections = [Section]()
    private let fontSet: FontSet
    init(viewModel: PrivacyPopUpViewModelProtocol, accentColor: UIColor, fontSet: FontSet) {
        self.viewModel = viewModel
        self.accentColor = accentColor
        self.fontSet = fontSet
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        setupViewModel()
        setupLayout()
        
        self.view.accessibilityElements = [navigationBar,tableView]
    }
        
    private func setupLayout() {
        view.backgroundColor = .popUpBackground
        
        activityIndicator.color = .activityIndicator
        
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        view.addSubview(navigationBar)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(privacyDescription)
        view.addSubview(readModeButton)
        view.addSubview(poweredByLabel)
        
        readModeButton.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        privacyDescription.translatesAutoresizingMaskIntoConstraints = false
        poweredByLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            privacyDescription.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 15),
            privacyDescription.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            privacyDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            readModeButton.topAnchor.constraint(equalTo: privacyDescription.bottomAnchor, constant: 15),
            readModeButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            readModeButton.heightAnchor.constraint(equalToConstant: readModeButton.titleLabel?.font.pointSize ?? 14),
            
            tableView.topAnchor.constraint(equalTo: readModeButton.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: poweredByLabel.topAnchor, constant: -2),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            poweredByLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -8),
            poweredByLabel.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -8)
        ])
        
        ([
            PopUpConsentsSection.self
        ] as [Section.Type]).forEach { $0.registerCells(in: tableView) }
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupViewModel() {
        viewModel.onDataLoaded = { [weak self] data in
            guard let self = self else { return }
            self.sections = data.sections
            self.tableView.reloadData()
            self.barItem.title = data.title
            self.navigationBar.largeTitleTextAttributes = [.font: self.fontSet.largeTitle]
            self.barItem.leftBarButtonItem?.title = data.saveSelectionButtonTitle
            self.barItem.rightBarButtonItem?.title = data.acceptAllButtonTitle
            self.privacyDescription.text = data.privacyDescription
            self.privacyPolicyLongtext = data.privacyPolicyLongtext
            self.readModeButton.setTitle("\(data.readMoreButton) ", for: .normal)
            let chevron = UIImage(named: "chevron", in: .module, compatibleWith: nil)
            self.readModeButton.setImage(chevron, for: .normal)
            self.readModeButton
            self.readModeButton.semanticContentAttribute = .forceRightToLeft
        }
        
        viewModel.onLoadingChange = { [weak self, activityIndicator] isLoading in
            isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
            self?.setInteractionEnabled(!isLoading)
        }
        
        viewModel.onError = { [weak self] alert in
            self?.showErrorAlert(alert)
        }
        
        viewModel.viewDidLoad()
    }
}

extension PrivacyPopUpViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        sections[indexPath.section].cell(for: indexPath, in: tableView)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
        return section == 0 ? "Required" : "Optional"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = .navigationBarbackground
    }
}

extension PrivacyPopUpViewController {
    @objc func acceptAll() {
        viewModel.acceptAll()
    }
    
    @objc func acceptSelected() {
        viewModel.acceptSelected()
    }
    
    @objc func openProvacyPolicy() {
        let detailView = PrivacyPolicyDetail(text: privacyPolicyLongtext, accentColor: accentColor)
               
        present(detailView, animated: true)

        
    }
}

extension String {
    init(key: String) {
        self = NSLocalizedString(key, bundle: Bundle(for: PrivacyPopUpViewController.self), comment: "")
    }
}

