#include <sys/ioctl.h>
#include <stddef.h>

static inline int ioctl_int(int fd, unsigned long request, int arg) {
    return ioctl(fd, request, arg);
}
