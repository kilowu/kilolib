#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>
#include <err.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>


#define PAGE_SHIFT              12
#define PAGE_SIZE               (1 << PAGE_SHIFT)
#define HPAGE_SIZE              (1 << 21)
#define NR_SMAPS_ENTRY_LINE     16
#define IS_BITSET(ent, bitn)    (((ent) & (1ull << bitn)) != 0)

#define PAGEMAP_PRESENT(ent)	IS_BITSET(ent, 63)
#define PAGEMAP_PFN(ent)	    ((ent) & ((1ull << 55) - 1))

#define KPAGEFLAGS_THP(ent)     (((ent) & (1ull << 22)) != 0)
#define KPAGEFLAGS_ANON(ent)    (((ent) & (1ull << 12)) != 0)
#define KPAGEFLAGS_NOPAGE(ent)  IS_BITSET(ent, 20)


void print_bytes(size_t const size, void const * const ptr)
{
    unsigned char *b = (unsigned char*) ptr;
    unsigned char byte;
    int i, j;

    for (i=size-1;i>=0;i--)
    {
        for (j=7;j>=0;j--)
        {
            byte = (b[i] >> j) & 1;
            printf("%u", byte);
        }
    }
    puts("");
}


void *initial_mmap(size_t len, void** map_start_addr) {
    void *ptr  = mmap(NULL, len + HPAGE_SIZE, PROT_READ | PROT_WRITE,
            MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
    if (ptr == MAP_FAILED) {
        perror("map failed");
        exit(1);
    }
    madvise(ptr, len, MADV_HUGEPAGE);
    (*map_start_addr) = ptr;
    if (((size_t) ptr) % PAGE_SIZE != 0) {
        // good to know if this happens
        fprintf(stderr, "Warning: mmap allocated memory is not page size aligned\n");
    }
    if (((size_t) ptr) % HPAGE_SIZE == 0) {
        fprintf(stderr, "Aligned to huge!\n");
    } else {
        ptr += HPAGE_SIZE - ((size_t)ptr % HPAGE_SIZE);
    }
    if (((size_t) ptr) % HPAGE_SIZE != 0) {
        fprintf(stderr, "failed to align\n");
        exit(1);
    }
    return ptr;
}


/*
 * Pinpoint addr in smaps and print its stats.
 */
void print_smaps_entry(void *addr)
{
    FILE *fp = fopen("/proc/self/smaps", "r");
    if (fp == NULL) {
        perror("Open smaps file failed");
        exit(1);
    }
    char c = 0;
    size_t start = 0;
    size_t end = 0;
    if (fscanf(fp, "%lx-%lx", &start, &end) == EOF) {
        fprintf(stderr, "Corrupted smaps content\n");
        exit(1);
    }
    int nr_lines = 0;    
    while ((size_t)addr != start) {
        nr_lines = 0;
        while (nr_lines < NR_SMAPS_ENTRY_LINE) {
            c = fgetc(fp);
            if (c == '\n') {
                nr_lines ++;
            } else if (c == EOF) {
                if (nr_lines < NR_SMAPS_ENTRY_LINE - 1) {
                    fprintf(stderr, "Corrupted smaps content\n");
                } else {
                    fprintf(stderr, "Page entry not found\n");
                }
                exit(1);
            }
        }
        if (fscanf(fp, "%lx-%lx", &start, &end) == EOF) {
            fprintf(stderr, "Corrupted smaps content\n");
            exit(1);
        }
    }
    printf("%lx-%lx ", start, end);
    nr_lines = 0;
    while ((c = fgetc(fp)) != EOF && nr_lines < NR_SMAPS_ENTRY_LINE) {
        if (c == '\n') {
            nr_lines ++;
        }
        putc(c, stdout);
    }
    fclose(fp);
}


int main(int argc, char **argv)
{
    void *p = NULL;    
    size_t len = 1 << 30;
    void *map_start_addr = NULL;
    void *ptr  = initial_mmap(len, &map_start_addr);
    for (p = ptr; p < ptr + len; p += HPAGE_SIZE) {
        if (mmap(p, HPAGE_SIZE, PROT_READ | PROT_WRITE,
                 MAP_FIXED | MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0) != p) {
            err(1, "mmap hugepage");
        }
        madvise(ptr, len, MADV_HUGEPAGE);
        *(volatile void**)p = p;
    }
    
    print_smaps_entry(map_start_addr);

    int pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
    if (pagemap_fd < 0) {
        err(1, "open pagemap");
    }
    // Caution: kpageflags can only be read by root users.
    int kpageflags_fd = open("/proc/kpageflags", O_RDONLY);
    if (kpageflags_fd < 0) {
        err(1, "open kpageflags");
    }
    uint64_t pagemap_ent = 0;
    uint64_t kpageflags = 0;
    int nr_thp = 0;
    int nr_anon = 0;
    int nr_nopage = 0;
    int nr_page_present = 0;    
    for (p = ptr; p < ptr + len; p += PAGE_SIZE) {
        if (pread(pagemap_fd, &pagemap_ent, sizeof(pagemap_ent), (uintptr_t)p >> (PAGE_SHIFT - 3))
                  != sizeof(pagemap_ent)) {
            err(1, "read pagemap");
        }
        uint64_t pfn = PAGEMAP_PFN(pagemap_ent);
        if (pread(kpageflags_fd, &kpageflags, sizeof(kpageflags), pfn << 3) != sizeof(kpageflags)) {
            err(1, "read kpageflags");
        }
        if (PAGEMAP_PRESENT(pagemap_ent)) {
            nr_page_present ++;
        }
        if (KPAGEFLAGS_THP(kpageflags)) {
            nr_thp ++;
        }
        if (KPAGEFLAGS_ANON(kpageflags)) {
            nr_anon ++;
        }
        if (KPAGEFLAGS_NOPAGE(kpageflags)) {
            nr_nopage ++;
        }
    }
    close(pagemap_fd);
    close(kpageflags_fd);

    printf("\nnr_page_present: %d, nr_thp: %d, nr_non: %d, nr_nopage: %d\n",
           nr_page_present*4, nr_thp*4, nr_anon*4, nr_nopage*4);
    // while (1) {
    //     sleep(1);
    // }
    return 0;
}