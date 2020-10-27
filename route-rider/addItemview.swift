//
//  addItemview.swift
//  route-rider
//
//  Created by Thaer Aldefai on 24.10.20.
//

import SwiftUI

struct addItemview: View {
    @State private var listItem = ""
    @Binding var showAddItemView: Bool
    
    var body: some View {
        
        NavigationView{
            
            
            Form {
                TextField("List Item", text: $listItem)
            }
            .navigationTitle("additem")
            .navigationBarItems(
                
                leading: Button("Save"){
                    showAddItemView = false
                },
                
                trailing: Button("Cancel"){
                    showAddItemView = false
                }
                
            )
            
        }
    }
    
    struct addItemview_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                addItemview(showAddItemView: .constant(false))
            }
        }
    }
}
