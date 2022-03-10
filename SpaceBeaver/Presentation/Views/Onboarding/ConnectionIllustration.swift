//
//  ConnectionIllustration.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 03.03.2022.
//

import SwiftUI

struct ConnectionIllustration: View {
    var body: some View {
        ZStack {
            VStack() {
                Rectangle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Colors.colorGreen)
                    .rotationEffect(.degrees(45))

                Rectangle()
                    .frame(width: 2)
                    .foregroundColor(Colors.colorGreen)

                Rectangle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Colors.colorGreen)
                    .rotationEffect(.degrees(45))
            }
            .padding(.vertical, 80)

            VStack {
                Images.satellite

                Spacer()

                Images.checkmart

                Spacer()

                Images.device
            }
        }
    }
}

struct ConnectionIllustration_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionIllustration()
    }
}
