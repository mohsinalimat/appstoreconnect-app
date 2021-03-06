//
//  BetaTestersViewController.swift
//  AppStoreConnect
//
//  Created by Antoine van der Lee on 01/12/2018.
//  Copyright © 2018 SwiftLee. All rights reserved.
//

import Cocoa

final class BetaTestersViewController: NSViewController {

    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var searchTextField: NSSearchField!
    @IBOutlet weak var addNewUserButton: NSButton!

    let viewModel: BetaTestersViewModel

    required init(viewModel: BetaTestersViewModel) {
        self.viewModel = viewModel

        super.init(nibName: "BetaTestersViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    private func updateViews() {
        titleLabel.stringValue = viewModel.title
        addNewUserButton.isHidden = !viewModel.canAddNewUser
        tableView.reloadData()
    }

    @IBAction func addNewUser(_ sender: NSButton) {
        guard let betaGroup = viewModel.betaGroup else { return }
        let addUserViewController = AddTestFlightUserViewController(betaGroup: betaGroup)
        present(addUserViewController, asPopoverRelativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxY, behavior: NSPopover.Behavior.semitransient)
    }
}

extension BetaTestersViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return viewModel.totalNumberOfTesters
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let betaTester = viewModel.betaTester(for: row), let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "BetaTesterCell"), owner: nil) as? NSTableCellView else { return nil }

        if tableColumn == tableView.tableColumns[0] {
            cell.textField?.stringValue = betaTester.attributes?.email ?? ""
        } else if tableColumn == tableView.tableColumns[1] {
            let firstName = betaTester.attributes?.firstName ?? ""
            let lastName = betaTester.attributes?.lastName ?? ""
            cell.textField?.stringValue = [firstName, lastName].joined(separator: " ")
        }

        return cell
    }
}

extension BetaTestersViewController: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        viewModel.applyFilter(with: searchTextField.stringValue) {
            tableView.reloadData()
        }
    }
}
