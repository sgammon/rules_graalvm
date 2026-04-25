#include <stdio.h>

#include "graal_isolate.h"
#include "libsharedapi.h"
#include "libsharedapi2.h"

int main(void) {
    graal_isolate_t *iso1 = NULL;
    graal_isolatethread_t *t1 = NULL;
    if (graal_create_isolate(NULL, &iso1, &t1) != 0) return 1;

    int meaning = shared_api_meaning(t1);
    int doubled = shared_api2_double(t1, meaning);
    printf("dedup_ok meaning=%d doubled=%d\n", meaning, doubled);

    if (graal_tear_down_isolate(t1) != 0) return 2;
    return 0;
}
