//
//  AppDelegate.swift
//  SethAndBrandisWedding
//
//  Created by Seth Rininger on 5/12/18.
//  Copyright © 2018 Seth Rininger. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var storageName: String = "ScavengerTasks.json"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if ScavengerTask.tasks.count == 0, Storage.fileExists(storageName, in: .documents) {
            let tasks = Storage.retrieve(storageName, from: .documents, as: [ScavengerTask].self)
            ScavengerTask.tasks = tasks
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        if ScavengerTask.tasks.count > 0 {
            Storage.store(ScavengerTask.tasks, to: .documents, as: storageName)
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        if ScavengerTask.tasks.count > 0 {
            Storage.store(ScavengerTask.tasks, to: .documents, as: storageName)
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        if ScavengerTask.tasks.count == 0, Storage.fileExists(storageName, in: .documents) {
            let tasks = Storage.retrieve(storageName, from: .documents, as: [ScavengerTask].self)
            ScavengerTask.tasks = tasks
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if ScavengerTask.tasks.count == 0, Storage.fileExists(storageName, in: .documents) {
            let tasks = Storage.retrieve(storageName, from: .documents, as: [ScavengerTask].self)
            ScavengerTask.tasks = tasks
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        if ScavengerTask.tasks.count > 0 {
            Storage.store(ScavengerTask.tasks, to: .documents, as: storageName)
        }
    }


}
