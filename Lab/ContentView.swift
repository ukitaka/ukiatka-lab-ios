import SwiftUI

struct Feature: Identifiable {
    var id: String
    let name: String
    
    var code: String {
        """
        code **block** _is_
        
        
        ```swift
        print("hello world")
        ```
        """
    }
}

let features: [Feature] = [
    Feature(id: "A", name: "AAA"),
    Feature(id: "B", name: "BBB"),
    Feature(id: "C", name: "CCC"),
]

struct ContentView: View {
    var body: some View {
        NavigationSplitView {
            List(features) { item in
                NavigationLink {
                    let attrString = try? AttributedString(markdown: item.code)
                    Text(attrString ?? "error")
                } label: {
                    Text(item.name)
                }
            }
        } detail: {
            Text("detail")
        }
    }
}

#Preview {
    ContentView()
}
