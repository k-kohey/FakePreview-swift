import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

private func body(_ node: some FreestandingMacroExpansionSyntax) -> ClosureExprSyntax {
    if let trailingClosure = node.trailingClosure {
        trailingClosure
    } else if let closure = node.argumentList.first(where: { $0.label?.text == "body" })?.expression.as(ClosureExprSyntax.self) {
        closure
    } else {
        fatalError("Argument body is required")
    }
}

private func previewClass(name: TokenSyntax, _ injectedBody: () -> DeclSyntax) -> DeclSyntax {
    """
    class \(name) {
        @objc class func injected() {
            \(injectedBody())
        }
    }
    """
}

public struct SwiftUIFakePreviewMacro: DeclarationMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let className = context.makeUniqueName("className")
        return [
            previewClass(name: className) {
                """
                let v = Group \(body(node))
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                windowScene?.windows.first?.rootViewController = UIHostingController(rootView: v)
                """
            }
        ]
    }
}

public struct UIKitFakePreviewMacro: DeclarationMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let className = context.makeUniqueName("className")
        return [
            previewClass(name: className) {
                """
                let vc: UIViewController = \(body(node))()
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                windowScene?.windows.first?.rootViewController = vc
                """
            }
        ]
    }
}

@main
struct FakePreviewPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        SwiftUIFakePreviewMacro.self,
        UIKitFakePreviewMacro.self
    ]
}
