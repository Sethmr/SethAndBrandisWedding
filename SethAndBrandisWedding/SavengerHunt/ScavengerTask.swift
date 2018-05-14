//
//  ScavengerTask.swift
//  SethAndBrandisWedding
//
//  Created by Seth Rininger on 5/12/18.
//  Copyright © 2018 Seth Rininger. All rights reserved.
//

import Foundation

struct ScavengerTask: Codable {
    var title: String
    var subtitle: String
    var imageUrl: String
    var isCompleted: Bool
}

extension ScavengerTask {

    static var storageName: String = "ScavengerTasks.json"
    static var tasks: [ScavengerTask] = []
    static var completedCount: Int {
        return tasks.filter({ $0.isCompleted }).count
    }

    static func updateTaskInformation() {
        NotificationCenter.default.post(
            name: NSNotification.Name("tasksUpdated"),
            object: nil
        )
    }

    static func save() {
        guard tasks.count > 0 else { return }
        Storage.store(tasks, to: .documents, as: storageName)
    }

    static func retrieve() {
        if tasks.count == 0, Storage.fileExists(storageName, in: .documents) {
            tasks = Storage.retrieve(storageName, from: .documents, as: [ScavengerTask].self)
        }
    }

}
