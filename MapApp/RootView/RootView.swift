//
//  RootView.swift
//  MapApp
//
//  Created by 内藤光博 on 2021/08/01.
//

import SwiftUI

struct RootView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        List() {
            
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
