//
//  InterestFieldView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-19.
//

import SwiftUI

struct InterestFieldView: View {
    
    let interests: [String]
    let tagColor: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(Strings.profile.interests)
                .font(.system(size: Fonts.subtitle))
                .padding(.bottom, 0.1)
            TagsView(items: interests, color: tagColor)
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
                        InterestTagView(interest: word, color: color)
                            .padding(2)
                    }
                }
            }
        }
    }
    
}

#Preview {
    InterestFieldView(interests: ["Programming", "Travelling", "Boxing", "EDM", "Reading"], tagColor: .wavelengthBlue)
}
