"Defines configuration and pinned versions for the GraalVM Rules project."

GRAALVM_VERSION = "20.0.2"

GRAALVM_SDK_VERSION = "23.0.1"

GRAALVM_DISTRIBUTION = "oracle"

GRAALVM_JAVA_VERSION = "20"

GRAALVM_SHA = None

RULES_JVM_EXTERNAL_TAG = "5.3"

RULES_JVM_EXTERNAL_SHA = "d31e369b854322ca5098ea12c69d7175ded971435e55c18dd9dd5f29cc5249ac"

PROTOBUF_VERSION = "3.20.1"

PROTOBUF_SHA = "8b28fdd45bab62d15db232ec404248901842e5340299a57765e48abe8a80d930"

GO_VERSION = "1.20.5"

MAVEN_ARTIFACTS = [
    "org.graalvm.nativeimage:svm:%s" % GRAALVM_SDK_VERSION,
    "org.graalvm.sdk:graal-sdk:%s" % GRAALVM_SDK_VERSION,
]

MAVEN_REPOSITORIES = [
    "https://maven.pkg.st",
    "https://maven.google.com",
    "https://repo1.maven.org/maven2",
]

GRAALVM_COMPONENTS = [
    "js",
    "llvm",
]
