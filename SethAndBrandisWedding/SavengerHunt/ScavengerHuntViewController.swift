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
        //guard ScavengerTask.tasks.count == 0 else { return }
        ScavengerTask.tasks = [
            ScavengerTask(title: "Laughter", subtitle: "Get the best picture of a smile of the night.", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "Bride & Groom Kissing", subtitle: "Where there's one, there may be many. Where there's many, there may be one picture.", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "Dancing Feet", subtitle: "Who stepped on my blue suede shoes?", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "A Selfie", subtitle: "Can you capture yourself better than anyone else?", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "The Best Man", subtitle: "Get a picture of someone laughing at the best man or the best man laughing.", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "The Inlaws", subtitle: "Take a picture of yourself with someone that has the same relationship (co-worker counts) to the Bride/Groom as you do to the other one of the two.", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "A Toast", subtitle: "Does one toast rule them all?", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "Your Table", subtitle: "Each table has a story to tell.", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "The Wedding Party", subtitle: "An opportune time comes but once. Watch and wait for the right moment when your hand is steady and lens is full.", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "An Oak Tree", subtitle: "The tree stands taller when people linger.", imageUrl: "", isCompleted: false),
            ScavengerTask(
                title: "Opposites Attract",
                subtitle: "Take a picture with someone of the opposite sex that has different color hair and eyes than you.",
                imageUrl: "",
                isCompleted: false
            ),
            ScavengerTask(title: "A Tasty Bite", subtitle: "Get a picture of cake going into a mouth.", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "Worst Dancer", subtitle: "Is it me? Is it you? Two left feet are somewhere and I think you know who.", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "The Parents", subtitle: "Get a picture of the bride or groom with their parents.", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "Publix meets Vimvest", subtitle: "Meet someone new that Seth or Brandi works with and grab a selfie.", imageUrl: "", isCompleted: false),
            ScavengerTask(title: "Quality Over Quanitity", subtitle: "Is there a better photo to be found? Give me the nights best photo... or else!", imageUrl: "", isCompleted: false)
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

}

extension ScavengerHuntViewController: ASTableDataSource {

    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return ScavengerTask.tasks.count
    }

    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            let task = ScavengerTask.tasks[indexPath.row]
            return ScavengerHuntCellNode(task: task, delegate: self)
        }
    }

}

extension ScavengerHuntViewController: ScavengerHuntCellNodeDelegate {

    func cellWasTapped(with task: ScavengerTask) {
        let indexPath = IndexPath(row: ScavengerTask.tasks.index(where: { $0.title == task.title }) ?? 0, section: 0)
        let vc = ScavengerHuntDescriptionViewController(task: task) { [weak self] newTask in
            self?.dismiss(animated: true) {
                ScavengerTask.tasks[indexPath.row] = newTask
                self?.tableNode.reloadRows(at: [indexPath], with: .automatic)
                ScavengerTask.updateTaskInformation()
                ScavengerTask.save()
            }
        }
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = TransitionDelegate.shared
        self.present(vc, animated: true)
    }

}
