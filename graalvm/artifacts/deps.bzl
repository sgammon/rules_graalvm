"Provides Maven dependencies for downstream `rules_jvm_external` use."

SDK_VERSION_LATEST = "23.1.1"

# Baseline Maven dependencies.
MAVEN_DEPENDENCIES = [
    "org.graalvm.sdk:graal-sdk:%s" % SDK_VERSION_LATEST,
]

MAVEN_DEPENDENCIES_POLYGLOT = MAVEN_DEPENDENCIES + [
    "org.graalvm.polyglot:polyglot:%s" % SDK_VERSION_LATEST,
]

# Truffle-specific Maven dependencies.
MAVEN_DEPENDENCIES_TRUFFLE = MAVEN_DEPENDENCIES + [
    "org.graalvm.truffle:truffle-api:%s" % SDK_VERSION_LATEST,
]

# NFI-specific Maven dependencies.
MAVEN_DEPENDENCIES_TRUFFLE_NFI = MAVEN_DEPENDENCIES + [
    "org.graalvm.truffle:truffle-nfi:%s" % SDK_VERSION_LATEST,
]
