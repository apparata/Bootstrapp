//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import SwiftUI

struct NoTemplatesView: View {
    
    @EnvironmentObject private var mainWindowState: MainWindowState
    @EnvironmentObject private var templates: TemplatesModel
    
    private let dropTargetBackground = Color("dropTarget/background")
    private let dropTargetBorder = Color("dropTarget/border")
    private let dropTargetForeground = Color("dropTarget/foreground")

    var body: some View {
        ZStack {
            Color(NSColor.controlBackgroundColor)
                .edgesIgnoringSafeArea(.top)
            VStack(alignment: .leading) {
                Text("This is Bootstrapp")
                    .font(.title)
                    .bold()
                    .padding(.bottom, 20)
                Text(templates.hasTemplates
                    ? "Select a template from the sidebar, or drag a folder from Finder to set a new templates root folder."
                    : "Set a templates root folder to get started. Just drag it from Finder to this window.")
                    .font(.system(size: 15))
                    .lineSpacing(4)
                    .frame(width: 300)
                    .padding(.bottom, 20)
                ZStack {
                    dropTarget()
                    hoverMarker()
                }.frame(width: 300, height: 150)
            }
            .frame(width: 300)
            .padding(.bottom, 64)
        }
        .navigationSubtitle("No template selected")
    }
    
    private func dropTarget() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .frame(width: 280, height: 140)
                .foregroundColor(dropTargetBackground)
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(dropTargetBorder, style: StrokeStyle(lineWidth: 2, dash: [8, 4], dashPhase: mainWindowState.isHoveringOverDropZone ? 12 * 5 : 0))
                .opacity(mainWindowState.isHoveringOverDropZone ? 0 : 1)
                .animation(Animation.easeInOut(duration: 5.0).speed(16), value: mainWindowState.isHoveringOverDropZone)
                .frame(width: 280, height: 140)
            VStack(spacing: 20) {
                DropTargetShape()
                    .stroke(dropTargetForeground, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                    .frame(width: 22, height: 28)
                Text("Drop templates root folder here")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(dropTargetForeground)
            }
        }
        .opacity(mainWindowState.isHoveringOverDropZone ? 0 : 1)
        .animation(!mainWindowState.isHoveringOverDropZone ? .none : Animation.easeInOut(duration: 0.5), value: mainWindowState.isHoveringOverDropZone)

    }
    
    private func hoverMarker() -> some View {
        GeometryReader { proxy in
            VStack {
                Text("Anywhere here is fine.")
                    .foregroundColor(dropTargetForeground)
                ZStack {
                    Circle()
                        .foregroundColor(dropTargetBackground)
                        .frame(width: 100, height: 100)
                    Circle()
                        .strokeBorder(dropTargetBorder, style: StrokeStyle(lineWidth: 2, dash: [8, 4], dashPhase: 9))
                        .frame(width: 100, height: 100)
                }
            }
            .scaleEffect(mainWindowState.isHoveringOverDropZone ? 1 : 0.01, anchor: UnitPoint(x: 0.5, y: 0.7))
            .offset(calculateDropOffset(geometryProxy: proxy))
            .opacity(mainWindowState.isHoveringOverDropZone ? 1 : 0)
            .animation(mainWindowState.isHoveringOverDropZone ? .none : .easeInOut, value: mainWindowState.isHoveringOverDropZone)
        }
    }
    
    private func calculateDropOffset(geometryProxy: GeometryProxy) -> CGSize {
        let frame = geometryProxy.frame(in: mainWindowState.hoverSpace)
        let centerPoint = CGPoint(x: frame.midX, y: frame.midY)
        let offset = CGSize(width: mainWindowState.hoverLocation.x - centerPoint.x + 80,
                            height: mainWindowState.hoverLocation.y - centerPoint.y)
        return offset
    }
}
