
//PersistentPicker.swift
//  Created by Casey Henderson on 30/07/2020.
//  Copyright © 2020 Casey Henderson. All rights reserved.
//

import SwiftUI
import Combine
enum Selection: String, CaseIterable {
    case One = "One"
    case Two = "Two"
    case Three = "Three"
    case Four = "Four"
    case Five = "Five"

    
}
struct PersistentPicker: View {
    @ObservedObject var settingsStore: SettingsStore = SettingsStore()
    @State var clubIndex = 1
    @State var selectedSelection: [Selection] = [.One, .Two, .Three, .Four, .Five]

    var body: some View {
        List {
            Text("Fav Selection: \(self.settingsStore.selectedSelection.rawValue)")
            // now: somehow pass this to the other view
            VStack(alignment: .leading, spacing: 20) {
                Text("Favourite Selection").bold()

                Picker("", selection: self.$settingsStore.selectedSelection) {
                    ForEach(self.selectedSelection, id: \.self) { Fav in
                        Text(Fav.rawValue).tag(Fav)
                    }
                }
                .pickerStyle(WheelPickerStyle())
            }
            .padding(.top)
            .padding(.top)
        }
    }
}
final class SettingsStore: ObservableObject {
    let theSelection = PassthroughSubject<Void, Never>()
    var selectedSelection: Selection = UserDefaults.selectedSelection {
        willSet {
            UserDefaults.selectedSelection = newValue
            print(UserDefaults.selectedSelection)
            theSelection.send()
        }
    }
}
extension UserDefaults {
    private struct Keys {
        static let selectedSelection = "selectedSelection"
    }
    static var selectedSelection: Selection {
        get {
            if let value = UserDefaults.standard.object(forKey: Keys.selectedSelection) as? String {
                return Selection(rawValue: value)!
            }
            else {
                return .One
            }
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Keys.selectedSelection)
        }
    }
}
struct PersistentPicker_Previews: PreviewProvider {
    static var previews: some View {
        PersistentPicker()
    }
}

