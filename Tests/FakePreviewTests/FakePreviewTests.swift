import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(FakePreviewMacros)
import FakePreviewMacros

let testMacros: [String: Macro.Type] = [
    "FakePreview": SwiftUIFakePreviewMacro.self,
]
#endif

final class FakePreviewTests: XCTestCase {
    #if canImport(FakePreviewMacros)
    func testFakePreviewMacro_with_trailingClosure() throws {
        assertMacroExpansion(
            """
            #FakePreview {
                ForEach(0 ..< 3) { i in
                    Text("\\(i)")
                }
            }
            """,
            expandedSource: """
            class __macro_local_9classNamefMu_ {
                @objc class func injected() {
                    let v = Group {
                        ForEach(0 ..< 3) { i in
                            Text("\\(i)")
                        }
                    }
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                    windowScene?.windows.first?.rootViewController = UIHostingController(rootView: v)
                }
            }
            """,
            macros: testMacros
        )
    }

    func testFakePreviewMacro_with_name_and_trailingClosure() throws {
        assertMacroExpansion(
            """
            #FakePreview("Hello, world!") {
                Text("Hello, world!")
            }
            """,
            expandedSource: """
            class __macro_local_9classNamefMu_ {
                @objc class func injected() {
                    let v = Group {
                        Text("Hello, world!")
                    }
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                    windowScene?.windows.first?.rootViewController = UIHostingController(rootView: v)
                }
            }
            """,
            macros: testMacros
        )
    }

    func testFakePreviewMacro_with_closure_as_argumet() throws {
        assertMacroExpansion(
            """
            #FakePreview(body: {
                Text("Hello, world!")
            })
            """,
            expandedSource: """
            class __macro_local_9classNamefMu_ {
                @objc class func injected() {
                    let v = Group {
                        Text("Hello, world!")
                    }
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                    windowScene?.windows.first?.rootViewController = UIHostingController(rootView: v)
                }
            }
            """,
            macros: testMacros
        )
    }

    func testFakePreviewMacro_with_name_and_closure_as_argumet() throws {
        assertMacroExpansion(
            """
            #FakePreview(
                "Hello, world!",
                body: {
                    Text("Hello, world!")
                }
            )
            """,
            expandedSource: """
            class __macro_local_9classNamefMu_ {
                @objc class func injected() {
                    let v = Group {
                            Text("Hello, world!")
                        }
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                    windowScene?.windows.first?.rootViewController = UIHostingController(rootView: v)
                }
            }
            """,
            macros: testMacros
        )
    }
    #endif
}
