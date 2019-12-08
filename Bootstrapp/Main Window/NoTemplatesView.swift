//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import SwiftUI

struct NoTemplatesView: View {
    
    @EnvironmentObject var mainWindowState: MainWindowState
    @EnvironmentObject private var templatesViewModel: TemplatesViewModel
    
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
                Text(templatesViewModel.hasTemplates
                    ? "Select a template from the sidebar, or add more templates to this window."
                    : "Add templates to get started. Just drag them from Finder to this window.")
                    .font(.system(size: 15))
                    .frame(width: 280)
                    .animation(.none)
                    .padding(.bottom, 20)
                ZStack {
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
                            Text("Drop templates here")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(dropTargetForeground)
                        }
                    }
                    .opacity(mainWindowState.isHoveringOverDropZone ? 0 : 1)
                    .animation(!mainWindowState.isHoveringOverDropZone ? .none : Animation.easeInOut(duration: 0.5), value: mainWindowState.isHoveringOverDropZone)

                    GeometryReader { proxy in
                        VStack {
                            Text("Anywhere here is fine.")
                                .foregroundColor(self.dropTargetForeground)
                            ZStack {
                                Circle()
                                    .foregroundColor(self.dropTargetBackground)
                                    .frame(width: 100, height: 100)
                                Circle()
                                    .strokeBorder(self.dropTargetBorder, style: StrokeStyle(lineWidth: 2, dash: [8, 4], dashPhase: 9))
                                    .frame(width: 100, height: 100)
                            }
                        }
                        .scaleEffect(self.mainWindowState.isHoveringOverDropZone ? 1 : 0.01, anchor: UnitPoint(x: 0.5, y: 0.7))
                        .offset(self.calculateDropOffset(geometryProxy: proxy))
                        .opacity(self.mainWindowState.isHoveringOverDropZone ? 1 : 0)
                        .animation(self.mainWindowState.isHoveringOverDropZone ? .none : .easeInOut)
                    }

                }.frame(width: 280, height: 140)
            }
            .frame(width: 300)
            .padding(.bottom, 64)
        }
    }
    
    private func calculateDropOffset(geometryProxy: GeometryProxy) -> CGSize {
        let frame = geometryProxy.frame(in: mainWindowState.hoverSpace)
        let centerPoint = CGPoint(x: frame.midX, y: frame.midY)
        let offset = CGSize(width: mainWindowState.hoverLocation.x - centerPoint.x,
                            height: mainWindowState.hoverLocation.y - centerPoint.y - 106)
        return offset
    }
}

struct DropTargetShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: 0))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY - 6))
        path.move(to: CGPoint(x: rect.midX, y: 0))
        path.addLine(to: CGPoint(x: rect.midX - 7, y: 8))
        path.move(to: CGPoint(x: rect.midX, y: 0))
        path.addLine(to: CGPoint(x: rect.midX + 7, y: 8))
        path.move(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        return path
    }
}
