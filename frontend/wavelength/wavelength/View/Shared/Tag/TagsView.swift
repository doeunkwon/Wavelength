//
//  TagsView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-12.
//

import SwiftUI

struct TagsView: View {
    
    let tags: [String]
    let color: Color
    var groupedItems: [[String]] = [[String]]()
    let screenWidth = UIScreen.main.bounds.width
    let editable: Bool
    let flag: String? /// Specifies whether the parent view is Values or Interests
    
    init(tags: [String], color: Color, editable: Bool, flag: String?) {
        self.tags = tags
        self.color = color
        self.editable = editable
        self.flag = flag
        self.groupedItems = createGroupedItems(tags)
    }
    
    private func createGroupedItems(_ tags: [String]) -> [[String]] {
        
        var groupedItems: [[String]] = [[String]]()
        var tempItems: [String] =  [String]()
        var width: CGFloat = 0
        
        for word in tags {
            
            let label = UILabel()
            label.text = word
            label.sizeToFit()
            
            /// This value is added to the width of each label (tag) to account for padding or extra space around the text. It ensures that the tags do not appear cramped and have sufficient spacing inside the UI component.
            /// If editable, then we must also account for the space taken up by the xmark
            let textCushion = ((Padding.medium + Padding.nudge) * 3) + (editable ? Padding.large : 0)
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
        VStack(alignment: .leading, spacing: Padding.medium + Padding.nudge) {
            
            ForEach(groupedItems, id: \.self) { subItems in
                HStack (spacing: Padding.medium + Padding.nudge) {
                    ForEach(subItems, id: \.self) { word in
                        TagView(text: word, color: color, editable: editable, flag: flag)
                    }
                }
            }
        }
                
    }
    
}

#Preview {
    TagsView(tags: ["Hello", "World"], color: .blue, editable: true, flag: nil)
}
