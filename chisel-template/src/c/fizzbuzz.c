char *fizzbuzz(int n, char *p, int size);

int main() {
#define N 10
#define cnt1(n) (((n) - (n)/3 - (n)/5))
#define cnt2(n) (((n) - (n)/3 - (n)/5) * 2 - cnt1(N>=10 ? 10 : N))
    char *p = fizzbuzz(N, (char *)0x2000, 256);
    int m = - (N / 15) * 1 + (N / 5) * 4 + (N / 3) * 4 + cnt2(N) + (N - 1) * 2;
    return p - (char *)0x2000 - m + 1;
}

char *fizzbuzz(int n, char *p, int size) {
    char *q = p + size;
    for (int i = 1; i <= n && p < q; i++) {
        for (int j = 0; j < 2 && p < q && i > 1; j++)
            *p++ = ", "[j];
        if (i % 15 == 0) {
            for (int j = 0; j < 9 && p < q; j++)
                *p++ = "Fizz Buzz"[j];
        } else if (i % 5 == 0) {
            for (int j = 0; j < 4 && p < q; j++)
                *p++ = "Buzz"[j];
        } else if (i % 3 == 0) {
            for (int j = 0; j < 4 && p < q; j++)
                *p++ = "Fizz"[j];
        } else {
            int c = 0;
            for (int x = i; x > 0; x /= 10, c++)
                ;
            char *r = p + c - 1;
            for (int x = i; x > 0; x /= 10, r--) {
                if (r < q) {
                    *r = 48 + x % 10;
                }
            }
            p = (p + c < q ? p + c : q);
        }
    }
    if (p < q)
        *p = 0;
    return p;
}
