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
                ForEach(self.vm.roots) { root in
                    NavigationLink(destination: RootMapView(root: root)) {
                        VStack {
                            Text(root.rootnm)
                        }
                    }
                }.onDelete(perform: { indexSet in
                    self.vm.deleteRoot(offsets: indexSet)
                })
            }
            .navigationTitle("経路一覧")
        }
        .onAppear(perform: {
            vm.getRoot()
        })
    }
}

struct RootMapView: View {
    let root: Root

    var body: some View {
        Map(vm: MapModel(points: root.coordinates, isTracking: true), isShowUserLocation: false)
            .navigationTitle(root.rootnm)
    }

}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(vm: RootViewModel(isPreview: true))
    }
}
