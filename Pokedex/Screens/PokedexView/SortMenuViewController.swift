//
//  SortMenuViewController.swift
//  Pokedex
//
//  Created by Beyza Nur Tekerek on 14.10.2025.
//

import UIKit

protocol SortMenuDelegate: AnyObject {
    func didSelectSortOption(_ option: SortOption)
}

final class SortMenuViewController: UIViewController {
    
    // MARK: - Constants
    private enum UI {
        static let preferredWidth: CGFloat = 250
        static let rowHeight: CGFloat = 44
        static let headerHeight: CGFloat = 44
        static let cornerRadius: CGFloat = 8
        static let iconSize: CGFloat = 20
        static let checkSize: CGFloat = 20
        static let horizontalPadding: CGFloat = 16
        static let labelSpacing: CGFloat = 12
        static let selectionAlpha: CGFloat = 0.3
        
        static let headerTitle = "Sort by"
        static let headerIconSystemName = "arrow.up.and.down.text.horizontal"
        static let cellReuseID = "SortCell"
    }
    
    // MARK: - Properties
    weak var delegate: SortMenuDelegate?
    
    private var currentOption: SortOption {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = UI.cornerRadius
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UI.cellReuseID)
        return tableView
    }()
    
    private lazy var headerView: UIView = makeHeaderView()
    
    // MARK: - Init
    init(currentOption: SortOption) {
        self.currentOption = currentOption
        super.init(nibName: nil, bundle: nil)
        setupPopupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sizeHeaderToFit()
    }
    
    // MARK: - Setup
    private func setupPopupStyle() {
        modalPresentationStyle = .popover
        preferredContentSize = CGSize(
            width: UI.preferredWidth,
            height: UI.headerHeight + (UI.rowHeight * CGFloat(SortOption.allCases.count))
        )
    }
    
    private func setupUI() {
        view.backgroundColor = .clear
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Header View
    private func makeHeaderView() -> UIView {
        let container = UIView()
        container.backgroundColor = .clear
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: UI.headerIconSystemName)
        iconImageView.tintColor = .lightGray
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.setContentHuggingPriority(.required, for: .horizontal)
        iconImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        let titleLabel = UILabel()
        titleLabel.text = UI.headerTitle
        titleLabel.textColor = .lightGray
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(iconImageView)
        container.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: UI.headerHeight),
            
            iconImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: UI.horizontalPadding),
            iconImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: UI.iconSize),
            iconImageView.heightAnchor.constraint(equalToConstant: UI.iconSize),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: UI.labelSpacing),
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -UI.horizontalPadding)
        ])
        
        return container
    }
    
    private func sizeHeaderToFit() {
        guard let header = tableView.tableHeaderView else { return }
        header.setNeedsLayout()
        header.layoutIfNeeded()
        let targetSize = CGSize(width: tableView.bounds.width, height: UIView.layoutFittingCompressedSize.height)
        let height = header.systemLayoutSizeFitting(targetSize).height
        if header.frame.height != height {
            var frame = header.frame
            frame.size.height = height
            header.frame = frame
            tableView.tableHeaderView = header
        }
    }
    
    // MARK: - Cell Building
    private func configureCell(_ cell: UITableViewCell, with option: SortOption) {
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.selectionStyle = .default
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: option.iconName)
        iconImageView.tintColor = option == currentOption ? .systemBlue : .white
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.setContentHuggingPriority(.required, for: .horizontal)
        iconImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        let titleLabel = UILabel()
        titleLabel.text = option.rawValue
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let checkmarkImageView = UIImageView()
        checkmarkImageView.image = option == currentOption ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
        checkmarkImageView.tintColor = option == currentOption ? .systemBlue : .lightGray
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        checkmarkImageView.setContentHuggingPriority(.required, for: .horizontal)
        checkmarkImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        cell.contentView.addSubview(iconImageView)
        cell.contentView.addSubview(titleLabel)
        cell.contentView.addSubview(checkmarkImageView)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: UI.horizontalPadding),
            iconImageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: UI.iconSize),
            iconImageView.heightAnchor.constraint(equalToConstant: UI.iconSize),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: UI.labelSpacing),
            titleLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            
            checkmarkImageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -UI.horizontalPadding),
            checkmarkImageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: UI.checkSize),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: UI.checkSize),
            
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: checkmarkImageView.leadingAnchor, constant: -UI.labelSpacing)
        ])
        
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = UIColor.lightGray.withAlphaComponent(UI.selectionAlpha)
        cell.selectedBackgroundView = selectedBackgroundView
        
        // Accessibility
        cell.isAccessibilityElement = true
        cell.accessibilityLabel = option.rawValue
        cell.accessibilityTraits = option == currentOption ? [.button, .selected] : [.button]
    }
}

// MARK: - UITableViewDataSource
extension SortMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SortOption.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let option = SortOption.allCases[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: UI.cellReuseID, for: indexPath)
        configureCell(cell, with: option)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SortMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }
        let selectedOption = SortOption.allCases[indexPath.row]
        currentOption = selectedOption
        delegate?.didSelectSortOption(selectedOption)
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UI.rowHeight
    }
}
