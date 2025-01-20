import SwiftUI

@freestanding(declaration)
public macro FakePreview(
    _ name: String? = nil,
    @ViewBuilder body: @escaping @MainActor () -> any View
) = #externalMacro(module: "FakePreviewMacros", type: "SwiftUIFakePreviewMacro")

#if canImport(UIKit)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, *)
@freestanding(declaration)
public macro FakePreview(
    _ name: String? = nil,
    traits: PreviewTrait<Preview.ViewTraits>... = [],
    body: @escaping @MainActor () -> UIViewController
) = #externalMacro(module: "FakePreviewMacros", type: "UIKitFakePreviewMacro")
#endif
