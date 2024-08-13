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
            
            /// Padding.medium + Padding.nudge is the horizontal padding applied to the tags. Since it's applied to both sides of the label, we multiply by 2
            /// We must also add the padding applied between each tag, which is Padding.medium + Padding.nudge, and so (Padding.medium + Padding.nudge) / 2 per each tag
            /// If editable, then we must also account for the space taken up by the xmark, which is ~Padding.xlarge
            let textCushion = ((Padding.medium + Padding.nudge) * 2) + ((Padding.medium + Padding.nudge) / 2) + (editable ? Padding.xlarge : 0)
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
