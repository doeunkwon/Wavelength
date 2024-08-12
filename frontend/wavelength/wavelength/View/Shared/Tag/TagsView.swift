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
    
    @State private var isAddingTag: Bool = false
    @State private var newTagText: String = ""
    
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
            
            let labelWidth = label.frame.size.width + 30
            
            if (width + labelWidth + 55) < screenWidth {
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
        
        // If editable, add space for the plus button at the end of the last group
        if editable, var lastGroup = groupedItems.last {
            lastGroup.append("+")
            groupedItems[groupedItems.count - 1] = lastGroup
        }
        
        return groupedItems
        
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            ForEach(groupedItems, id: \.self) { subItems in
                HStack {
                    ForEach(subItems, id: \.self) { word in
                        if word == "+" {
                            ZStack {
                                Circle()
                                    .frame(width: Frame.xsmall)
                                    .foregroundColor(.wavelengthOffWhite)
                                    .shadow(
                                        color: ShadowStyle.standard.color,
                                        radius: ShadowStyle.standard.radius,
                                        x: ShadowStyle.standard.x,
                                        y: ShadowStyle.standard.y)
                                Button {
                                    print("Add new tag!")
                                    isAddingTag.toggle()
                                } label: {
                                    Image(systemName: Strings.icons.plus)
                                        .font(.system(size: Fonts.body))
                                        .accentColor(.wavelengthGrey)
                                }
                                .padding(.vertical, Padding.xsmall)
                                .padding(.horizontal, Padding.medium * 1.5)
                            }
                        } else {
                            TagView(interest: word, color: color, editable: editable)
                                .padding(Padding.xsmall)
                        }
                    }
                }
            }
        }
                
    }
    
}

#Preview {
    TagsView(items: ["Hello", "World"], color: .blue, editable: true)
}
