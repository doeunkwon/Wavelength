//
//  TagsView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-12.
//

import SwiftUI

struct TagsView: View {
    
    let items: [String]
    let color: Color
    var groupedItems: [[String]] = [[String]]()
    let screenWidth = UIScreen.main.bounds.width
    let editable: Bool
    
    init(items: [String], color: Color, editable: Bool) {
        self.items = items
        self.color = color
        self.editable = editable
        self.groupedItems = createGroupedItems(items)
    }
    
    private func createGroupedItems(_ items: [String]) -> [[String]] {
        
        var groupedItems: [[String]] = [[String]]()
        var tempItems: [String] =  [String]()
        var width: CGFloat = 0
        
        for word in items {
            
            let label = UILabel()
            label.text = word
            label.sizeToFit()
            
            /// This value is added to the width of each label (tag) to account for padding or extra space around the text. It ensures that the tags do not appear cramped and have sufficient spacing inside the UI component.
            /// If editable, then we must also account for the space taken up by the xmark
            let textCushion = (Padding.medium * 2) + (Padding.xsmall * 2) + (editable ? Padding.large : 0)
            let labelWidth = label.frame.size.width + textCushion
            
            /// Makes sure width + labelWidth is less than screenWidth including the edges paddings
            if (width + labelWidth) < screenWidth - (Padding.large * 2) {
                width += labelWidth
                tempItems.append(word)
            } else {
                width = labelWidth
                groupedItems.append(tempItems)
                tempItems.removeAll()
                tempItems.append(word)
            }
            
        }
        
        groupedItems.append(tempItems)
        
        return groupedItems
        
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            ForEach(groupedItems, id: \.self) { subItems in
                HStack {
                    ForEach(subItems, id: \.self) { word in
                        
                        TagView(text: word, color: color, editable: editable)
                            .padding(Padding.xsmall)
                        
                    }
                }
            }
        }
                
    }
    
}

#Preview {
    TagsView(items: ["Hello", "World"], color: .blue, editable: true)
}
