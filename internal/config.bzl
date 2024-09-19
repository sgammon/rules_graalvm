"Defines configuration and pinned versions for the GraalVM Rules project."

GRAALVM_VERSION = "22.0.2"

GRAALVM_SDK_VERSION = "24.0.2"

GRAALVM_DISTRIBUTION = "ce"

GRAALVM_JAVA_VERSION = "22"

GRAALVM_SHA = None

GO_VERSION = "1.20.5"

LLVM_VERSION = "15.0.6"

NODE_VERSION = "20.5.0"

RULES_JVM_EXTERNAL_TAG = "5.3"

RULES_JVM_EXTERNAL_SHA = "d31e369b854322ca5098ea12c69d7175ded971435e55c18dd9dd5f29cc5249ac"

PROTOBUF_VERSION = "3.20.1"

PROTOBUF_SHA = "8b28fdd45bab62d15db232ec404248901842e5340299a57765e48abe8a80d930"

LLVM_TOOLCHAIN_TAG = "0.8.2"

LLVM_TOOLCHAIN_SHA = "3e251524b3e8f3b9ec93848e5267c168424f43b7b554efc983a5291c33d78cde"

HERMETIC_CC_TOOLCHAIN_VERSION = "v2.0.0"

HERMETIC_CC_TOOLCHAIN_SHA = "57f03a6c29793e8add7bd64186fc8066d23b5ffd06fe9cc6b0b8c499914d3a65"

MAVEN_ARTIFACTS = [
    "org.graalvm.nativeimage:svm:%s" % GRAALVM_SDK_VERSION,
    "org.graalvm.sdk:graal-sdk:%s" % GRAALVM_SDK_VERSION,
]

MAVEN_REPOSITORIES = [
    "https://maven.pkg.st",
    "https://maven.google.com",
    "https://repo1.maven.org/maven2",
]

TARGET_JAVA_VERSIONS = [
    "8",
    "11",
    "17",
    "19",
    "20",
    "21",
    "22",
]

GRAALVM_KNOWN_RELEASES = [
    "22.0.0",
    "21.0.1",
    "21.0.0",
    "20.0.2",
    "20.0.1",
    "17.0.8",
    "17.0.7",
]

GRAALVM_KNOWN_DISTS = [
    "oracle",
    "ce",
]

GRAALVM_KNOWN = struct(
    RELEASES = GRAALVM_KNOWN_RELEASES,
    DISTS = GRAALVM_KNOWN_DISTS,
)

ENABLE_FOREIGN_TOOLCHAINS = False
