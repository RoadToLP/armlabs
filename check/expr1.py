def calc(a, b, c, d, e):
    res1 = (a*c)//b
    res2 = (d*b)//e
    res3 = (c**2)//(a*d)
    print(hex(res1), hex(res2), hex(res3))
    return res1+res2-res3
