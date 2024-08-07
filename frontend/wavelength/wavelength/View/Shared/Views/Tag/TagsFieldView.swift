//
//  TagsFieldView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-19.
//

import SwiftUI

struct TagsFieldView: View {
    
    let title: String
    let items: [String]
    let tagColor: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: Fonts.body))
                .foregroundColor(.wavelengthDarkGrey)
            TagsView(items: items, color: tagColor)
        }
    }
}

struct TagsView: View {
    
    let items: [String]
    let color: Color
    var groupedItems: [[String]] = [[String]]()
    let screenWidth = UIScreen.main.bounds.width
    
    init(items: [String], color: Color) {
        self.items = items
        self.color = color
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
            
            let labelWidth = label.frame.size.width + 32
            
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
        return groupedItems
        
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            ForEach(groupedItems, id: \.self) { subItems in
                HStack {
                    ForEach(subItems, id: \.self) { word in
                        TagView(interest: word, color: color)
                            .padding(Padding.xsmall)
                    }
                }
            }
        }
    }
    
}

#Preview {
    TagsFieldView(title: Strings.profile.interests, items: ["Programming", "Travelling", "Boxing", "EDM", "Reading"], tagColor: .wavelengthBlue)
}
