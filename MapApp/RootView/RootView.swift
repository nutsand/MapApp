//
//  RootView.swift
//  MapApp
//
//  Created by 内藤光博 on 2021/08/01.
//

import SwiftUI
import CoreData

struct RootView: View {
    @StateObject var vm: RootViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.roots) { root in
                    NavigationLink(destination: RootMapView()) {
                        Text(root.rootnm)
                    }
                }
            }
            .navigationTitle("旅の記憶")
        }
    }
}

struct RootMapView: View {
    var body: some View {
        Text("RootMap")
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(vm: RootViewModel(isPreview: true))
    }
}

class RootViewModel: ObservableObject {
    let cdmanager: CoreDataManager
    @Published var roots: [Root] = []
    
    init(isPreview: Bool) {
        if isPreview {
            cdmanager = CoreDataManager.preview
        } else {
            cdmanager = CoreDataManager.shared
        }
        getRoot()
    }
    
    func getRoot() {
        let request = NSFetchRequest<Root>(entityName: "Root")
        do {
           roots = try cdmanager.context.fetch(request)
        } catch let error {
            print("fetch error...\(error.localizedDescription)")
        }
    }
}
