//
//  LogsView.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 18.03.2022.
//

import SwiftUI

struct LogsView: View {
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var viewModel = SpaceBeaverManager.shared

    @State var selectedIndex = 0

    var presentedLogs: [LogMessage] {
        viewModel.logger.filter = [logTypes[selectedIndex]]
        return viewModel.logger.filteredData
    }

    var logTypes: [LogType] {
        LogType.allCases
    }

    var body: some View {
        VStack {
            Picker(selection: $selectedIndex, label: Text("Logs")) {
                ForEach(0 ..< logTypes.count) {
                    Text(self.logTypes[$0].rawValue)
                }
            }.pickerStyle(SegmentedPickerStyle())


            List(presentedLogs) { line in
                VStack(alignment: .leading) {
                    Text(line.time, style: .time)
                        .italic()
                    Text(line.message)
                        .lineLimit(nil)
                        .font(.caption)
                }
            }

            Button("Close", action: { dismiss() })
        }
    }
}

struct LogsView_Previews: PreviewProvider {
    static var previews: some View {
        LogsView()
    }
}
