#include <stdio.h>
#include <stdlib.h>

#include "graal_isolate.h"
#include "libsharedapi.h"

int main(void) {
    graal_isolate_t *isolate = NULL;
    graal_isolatethread_t *thread = NULL;

    if (graal_create_isolate(NULL, &isolate, &thread) != 0) {
        fprintf(stderr, "graal_create_isolate failed\n");
        return 1;
    }

    int meaning = shared_api_meaning(thread);
    if (meaning != 42) {
        fprintf(stderr, "shared_api_meaning returned %d, expected 42\n", meaning);
        graal_tear_down_isolate(thread);
        return 2;
    }

    char buf[64];
    int n = shared_api_greet(thread, buf, (int)sizeof(buf));
    if (n <= 0) {
        fprintf(stderr, "shared_api_greet returned %d\n", n);
        graal_tear_down_isolate(thread);
        return 3;
    }

    printf("%s\n", buf);

    if (graal_tear_down_isolate(thread) != 0) {
        fprintf(stderr, "graal_tear_down_isolate failed\n");
        return 4;
    }
    return 0;
}
