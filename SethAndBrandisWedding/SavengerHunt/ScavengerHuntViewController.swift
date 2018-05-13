//
//  ScavengerHuntViewController.swift
//  SethAndBrandisWedding
//
//  Created by Seth Rininger on 5/12/18.
//  Copyright © 2018 Seth Rininger. All rights reserved.
//

import AsyncDisplayKit

class ScavengerHuntViewController: ASViewController<ASDisplayNode> {

    let headerReuseId = "ScavengerHuntCell"
    let tableNode: ASTableNode
    var headerNode: ASDisplayNode?

    init() {
        tableNode = ASTableNode()
        super.init(node: ASDisplayNode())
        generateTasks()
        tableNode.backgroundColor = UIColor.mainColor
        tableNode.delegate = self
        tableNode.dataSource = self
        node.automaticallyManagesSubnodes = true
        node.layoutSpecBlock = { [unowned self] _, _ in
            let relativeSpec = ASRelativeLayoutSpec(horizontalPosition: .none, verticalPosition: .start, sizingOption: .minimumHeight, child: self.safeAreaNode)
            return ASOverlayLayoutSpec(child: self.tableNode, overlay: relativeSpec)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboard Not Supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableNode.view.separatorStyle = .singleLine
        tableNode.view.separatorColor = UIColor.mainColor
    }

    lazy var safeAreaNode: ASDisplayNode = {
        let node = ASDisplayNode()
        node.backgroundColor = .mainColor
        node.style.preferredLayoutSize = ASLayoutSize(
            width: ASDimension(unit: .points, value: ViewController.screenWidth),
            height: ASDimension(unit: .points, value: ViewController.safeInsets.top)
        )
        return node
    }()

    func generateTasks() {
        guard ScavengerTask.tasks.count == 0 else { return }
        ScavengerTask.tasks = [
            ScavengerTask(
                title: "Opposites Attract",
                subtitle: "Take a picture with someone of the opposite sex on opposite side of the family with different color hair than you.",
                imageUrl: "",
                isCompleted: false
            ),
            ScavengerTask(title: "", subtitle: "", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "", subtitle: "", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "", subtitle: "", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "", subtitle: "", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "", subtitle: "", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "", subtitle: "", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "", subtitle: "", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "", subtitle: "", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "", subtitle: "", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "", subtitle: "", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "", subtitle: "", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "", subtitle: "", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "", subtitle: "", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "", subtitle: "", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "", subtitle: "", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "", subtitle: "", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "", subtitle: "", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "", subtitle: "", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "", subtitle: "", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "", subtitle: "", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "", subtitle: "", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "", subtitle: "", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "", subtitle: "", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "", subtitle: "", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "", subtitle: "", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "", subtitle: "", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "", subtitle: "", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "", subtitle: "", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "", subtitle: "", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "", subtitle: "", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "", subtitle: "", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "", subtitle: "", imageUrl: "", isCompleted: false)
        ]
    }

}

extension ScavengerHuntViewController: ASTableDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section == 0 else { return 0 }
        return ViewController.safeInsets.top + 140.clasp
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        var view = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerReuseId)
        if view == nil {
            view = UITableViewHeaderFooterView(reuseIdentifier: headerReuseId)
        }
        let node = ScavengerHuntHeaderCellNode()
        view?.contentView.addSubview(node.view)
        self.headerNode?.removeFromSupernode()
        self.headerNode = node
        node.view.frame = view!.bounds
        node.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }

    func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
        let size = CGSize(width: ViewController.screenWidth, height: 100.clasp)
        return ASSizeRange(min: size, max: size)
    }

    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < ScavengerTask.tasks.count else { return }
        let task = ScavengerTask.tasks[indexPath.row]
        let vc = ScavengerHuntDescriptionViewController(task: task) { [weak self] in
            self?.dismiss(animated: true) {
                self?.tableNode.deselectRow(at: indexPath, animated: true)
            }
        }
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = TransitionDelegate.shared
        self.present(vc, animated: true)
    }

}

extension ScavengerHuntViewController: ASTableDataSource {

    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return ScavengerTask.tasks.count
    }

    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            let task = ScavengerTask.tasks[indexPath.row]
            return ScavengerHuntCellNode(task: task)
        }
    }

}
