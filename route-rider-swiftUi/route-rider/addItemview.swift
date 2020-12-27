//
//  addILocatinView.swift
//  route-rider
//  
//  Created by Thaer Aldefai on 24.10.20.
//

import SwiftUI

struct addILocatinView: View {
    // @ObservedObject var locationService: LocationService
    @State private var listItem = ""
    @Binding var showAddItemView: Bool
    @ObservedObject var locationService: LocationService
    
    var body: some View {
        
        NavigationView{
            
            
            VStack {
                Form {
            
                        ZStack(alignment: .trailing) {
                            TextField("Search", text: $locationService.queryFragment)
                            // This is optional and simply displays an icon during an active search
                            if locationService.status == .isSearching {
                                Image(systemName: "clock")
                                    .foregroundColor(Color.gray)
                            }
                        }
                    
                    Section(header: Text("Results")) {
                        List {
                            // With Xcode 12, this will not be necessary as it supports switch statements.
                            Group { () -> AnyView in
                                switch locationService.status {
                                case .noResults: return AnyView(Text("No Results"))
                                case .error(let description): return AnyView(Text("Error: \(description)"))
                                default: return AnyView(EmptyView())
                                }
                            }.foregroundColor(Color.gray)
                            
                            ForEach(locationService.searchResults, id: \.self) { completionResult in
                                // This simply lists the results, use a button in case you'd like to perform an action or use a NavigationLink to move to the next view upon selection.
                                Text(completionResult.title)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Location Search")
            .navigationBarItems(
                
                leading: Button("Cancel"){
                    showAddItemView = false
                }
                
            )
            
        }
    }
    
    struct addILocatinView_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                addILocatinView(showAddItemView: .constant(false), locationService: LocationService())
            }
        }
    }
}



