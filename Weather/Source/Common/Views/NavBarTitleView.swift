//
//  NavBarTitleView.swift
//  Weather
//
//  Created by jonathan saville on 26/04/2024.
//

import SwiftUI

struct NavBarTitleView: View {

    let title: String
    let imageName: String

    init(title: String = "Weather",
         imageName: String = "navBarIcon") {
        self.title = title
        self.imageName = imageName
    }

    var body: some View {
        Label {
            Text(title)
                .font(.headline)
                .foregroundColor(.defaultText)
        } icon: {
            Image(imageName)
                .renderingMode(.template)
                .resizable().frame(width: 20, height: 20)
                .foregroundColor(.accentColor)
        }
        .labelStyle(.titleAndIcon)
    }
}

struct NavBarTitleView_Previews: PreviewProvider {

    static var previews: some View {
        NavBarTitleView()
            .background(Color.black)
    }
}
