//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import CoreData

let persistentContainer: NSPersistentContainer = {
    guard let modelURL = Bundle.module.url(forResource: "Sequoia", withExtension: "momd") else {
        fatalError("Failed to find data model")
    }

    guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
        fatalError("Failed to create model from file: \(modelURL)")
    }

    let container = NSPersistentContainer(name: "Sequoia", managedObjectModel: model)

    #if canImport(Testing)
        container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
    #endif

    container.loadPersistentStores { _, error in
        if let error {
            assertionFailure(error.localizedDescription)
        }
    }
    return container
}()
