/*
 * Two-shared-libs-in-one-consumer integration test.
 *
 * Each `native_image(--shared)` output ships its own SVM runtime, so an
 * `IsolateThread*` produced by one library's `graal_create_isolate` is not
 * portable into another library's entry point. We deliberately create one
 * isolate per shared library and use the matching thread for each call —
 * this validates link/header coexistence AND honors GraalVM's per-image
 * isolate semantics, so the test wouldn't silently pass if a future change
 * accidentally cross-wired the two runtimes.
 */
#include <stdio.h>

#include "graal_isolate.h"
#include "libsharedapi.h"
#include "libsharedapi2.h"

int main(void) {
    graal_isolate_t *iso1 = NULL;
    graal_isolatethread_t *t1 = NULL;
    if (graal_create_isolate(NULL, &iso1, &t1) != 0) return 1;

    graal_isolate_t *iso2 = NULL;
    graal_isolatethread_t *t2 = NULL;
    if (graal_create_isolate(NULL, &iso2, &t2) != 0) return 2;

    int meaning = shared_api_meaning(t1);
    int doubled = shared_api2_double(t2, meaning);
    printf("dedup_ok meaning=%d doubled=%d\n", meaning, doubled);

    if (graal_tear_down_isolate(t2) != 0) return 3;
    if (graal_tear_down_isolate(t1) != 0) return 4;
    return 0;
}
