//
//  ConnectionIllustration.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 03.03.2022.
//

import SwiftUI

struct ConnectionIllustration: View {
    enum Kind {
        case success
        case failed

        var image: Image {
            switch self {
            case .success:
                return Images.checkmart
            case .failed:
                return Images.error
            }
        }

        var color: Color {
            switch self {
            case .success:
                return Colors.colorGreen
            case .failed:
                return Colors.colorMidGrey
            }
        }
    }
    let kind: Kind

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Rectangle()
                    .frame(width: 15, height: 15)
                    .foregroundColor(kind.color)
                    .rotationEffect(.degrees(45))

                Rectangle()
                    .frame(width: 2)
                    .foregroundColor(kind.color)

                Rectangle()
                    .frame(width: 15, height: 15)
                    .foregroundColor(kind.color)
                    .rotationEffect(.degrees(45))
            }
            .padding(.vertical, 80)

            kind.image

            VStack {
                Images.satellite

                Spacer()

                Images.device
            }
        }
        .frame(height: 300)
    }
}

struct ConnectionIllustration_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionIllustration(kind: .failed)
    }
}
