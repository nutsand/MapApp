//
//  RootViewModel.swift
//  MapApp
//
//  Created by 内藤光博 on 2021/08/06.
//

import Foundation
import CoreData

class RootViewModel: ObservableObject {
    let cdmanager: CoreDataManager
    @Published var roots: [Root] = []
    
    init(isPreview: Bool) {
        if isPreview {
            cdmanager = CoreDataManager.preview
        } else {
            cdmanager = CoreDataManager.shared
        }
    }
    
    func getRoot() {
        print("fetch Roots")
        let request = NSFetchRequest<Root>(entityName: "Root")
        do {
           roots = try cdmanager.context.fetch(request)
        } catch let error {
            print("fetch error...\(error.localizedDescription)")
        }
    }
}
