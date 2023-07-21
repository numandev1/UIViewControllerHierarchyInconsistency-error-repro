//
//  LiveActivityDynamicIsland.swift
//  LiveActivityDynamicIsland
//
//  Created by Numan on 21/03/2023.
//

import WidgetKit
import SwiftUI
import ActivityKit

struct SegmentedProgressView: View {
  var value: Int
  var maximum: Int = 4
  var height: CGFloat = 4
  var spacing: CGFloat = 6
  var selectedColor: Color = Color(red: 0.3137455881, green: 0.133320719, blue: 0.2392159104)
  var unselectedColor: Color = Color.secondary.opacity(0.3)
  var body: some View {
    HStack(spacing: spacing) {
      ForEach(0 ..< maximum) { index in
        Rectangle()
          .foregroundColor(index < self.value ? self.selectedColor : self.unselectedColor)
      }
    }
    .frame(maxHeight: height)
    .clipShape(Capsule())
  }
}


struct MyActivityAttributes: ActivityAttributes {
  
  public struct ContentState: Codable, Hashable {
    var subtitle: String
    var completedStepCount: String
    var title: String
    var orderId: String
  }
}

let infoDict = Bundle.main.infoDictionary
let urlTypes = infoDict?["CFBundleURLTypes"] as? [[String: Any]]
let urlSchemes = urlTypes?.first?["CFBundleURLSchemes"] as? [String]
let _urlScheme = urlSchemes?.first ?? "ananinja"

@main
@available(iOS 16.1, *)
struct LiveActivityDynamicIsland: Widget {
  var body: some WidgetConfiguration {
    
    ActivityConfiguration(for: MyActivityAttributes.self) { context in
    
      VStack{
          HStack{
              HStack{
                Image("NinjaIcon").resizable().frame(width: 25, height: 25).scaledToFit()
                  .cornerRadius(8)
                  HStack{
                      Text("Ninja |").fontWeight(.medium)
                      Text("نينجا").fontWeight(.medium)
                  }.padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0))
              }
              Spacer()
              Image("NinjaIcon").resizable().frame(width: 25, height: 25).scaledToFit()
                  .cornerRadius(8)
          }
          Text("Estimated Arrival").font(.callout).frame(maxWidth: .infinity, alignment: .leading).padding(EdgeInsets(top: -10, leading: 0, bottom: 0, trailing: 0))
          Text(context.state.title).font(.headline).bold().frame(maxWidth: .infinity, alignment: .leading).padding(EdgeInsets(top: 0, leading: 0, bottom: 2, trailing: 0))
          
        SegmentedProgressView(value: Int(context.state.completedStepCount)!)
          
          HStack{
              Text("🥷")
              Text(context.state.subtitle).bold().foregroundColor(Color(red: 0.3137455881, green: 0.133320719, blue: 0.2392159104)).padding(EdgeInsets(top: 4, leading: 2, bottom: 0, trailing: 0))
              Spacer()
          }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
         
      }.padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)).widgetURL(URL(string: "\(_urlScheme)://track?id=\(context.state.orderId)")!)
    } dynamicIsland: { context in
      DynamicIsland {
        DynamicIslandExpandedRegion(.leading) {
          VStack(spacing: 4) {
            Image("NinjaIcon")
              .resizable()
              .frame(width: 30, height: 30)
            Text("Estimated Arrival")
              .font(.footnote)
          }
        }
        DynamicIslandExpandedRegion(.trailing) {
          VStack(alignment: .leading) {
            Spacer()
            Text(context.state.title)
              .font(.footnote)
          }
        }
        DynamicIslandExpandedRegion(.center) {
        }
        DynamicIslandExpandedRegion(.bottom) {
          VStack{
            SegmentedProgressView(value: Int(context.state.completedStepCount)!)
            HStack {
              Text(context.state.subtitle)
                .font(.body)
              Spacer()
              Text("🥷").frame(width: 20, height: 20).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 2))
            }
          }
        }
      } compactLeading: {
        Image("NinjaIcon")
          .resizable()
          .frame(width: 30, height: 30)
      } compactTrailing: {
        Text(context.state.title)
          .font(.footnote)
      } minimal: {
        Text(context.state.title)
      }
      .keylineTint(.yellow)
      .widgetURL(URL(string: "\(_urlScheme)://track?id=\(context.state.orderId)")!)
    }
  }
}
