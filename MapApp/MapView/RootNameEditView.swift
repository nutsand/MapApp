//
//  RootNameEditView.swift
//  MapApp
//
//  Created by 内藤光博 on 2021/08/09.
//

import SwiftUI
import CoreLocation

struct RootNameEditView: View {
    @ObservedObject var vm: MapViewModel
    
    var body: some View {
        ZStack {
            Color.gray
                .opacity(0.5)
            VStack {
                Text("経路名を入力")
                    .font(.title2)
                TextField("経路名", text: $vm.rootName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Divider()
                Button("OK") {
                    vm.tapRootNameOK()
                }
                .frame(maxWidth: .infinity)
            }
            .frame(width: 250, height: 150)
            .background(Color.white)
            .cornerRadius(10.0)
        }
    }
}

struct RootNameEditView_Previews: PreviewProvider {
    static var previews: some View {
        RootNameEditView(vm: MapViewModel(manager: CLLocationManager(), isPreview: false))
    }
}
