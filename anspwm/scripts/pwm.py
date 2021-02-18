#!/usr/local/bin/python3

import argparse, random, sys

def val(arr, i):
    if i < 0:
        return 0
    else:
        return arr[i]


def block(tgt, delta):
    tgt_adj = tgt + delta
    if tgt_adj > 0xffffffff:
      tgt_adj = 0xffffffff
    elif tgt_adj < 0:
      tgt_adj = 0

    trunc =  tgt_adj & 0xffff0000
    out = trunc >> 16
    diff = tgt_adj - trunc
    return out, diff


def round(target, N, debug):
    delta1 = 0
    delta2 = 0
    delta3 = 0
    delta4 = 0
    o1 = []
    o2 = []
    o3 = []
    o4 = []
    for i in range(N):
        out1, delta1 = block(target, delta1)
        out2, delta2 = block(delta1, delta2)
        out3, delta3 = block(delta2, delta3)
        out4, delta4 = block(delta3, delta4)
        o1.append(out1)
        o2.append(out2)
        o3.append(out3)
        o4.append(out4)
        #print("{} {} {} {}".format(out1, out2, out3, out4))

    sum = 0
    for i in range(N):
        c1 = val(o2, i) -   val(o2, i - 1)
        c2 = val(o3, i) - 2*val(o3, i - 1) +   val(o3, i - 2)
        c3 = val(o4, i) - 3*val(o4, i - 1) + 3*val(o4, i - 2) - val(o4, i - 3)
        res = o1[i] + c1 + c2 + c3
        if res > 0xffff:
            res = 0xffff
        elif res < 0:
            res = 0

        if debug:
            print("{0:2} {1:5} {2:5} {3:5} {4:5} {5:5}".format(i, res, o1[i], c1, c2, c3))
        sum = sum + res

    avg = 1.0*sum/N
    achieved = int(avg*65536)
    missed = target - achieved
    return (avg, achieved)



def specificnumbers(N, debug):
    numbers = [4294951171, 4294923131, 4294903131, 4294803131, 4294003131, 1234554321, 100]

    print("N: {}".format(N))
    print("Target      Achieved    Diff    Float")
    print("--------------------------------------------")
    for target in numbers:
        avg, achieved = round(target, N, debug)
        diff = target - achieved
        prec = diff /(2**32)
        print("{:10}  {:10}  {:6}  {:12.6f}  {:13.6e}".format(target, achieved, diff, avg, prec))


def randomsample(N):
    max = 0
    maxi = 0
    min = 0
    mini = 0
    for i in range(100000):
        myint = random.randint(1000000, 4294003131)
        #print("{}".format(myint))
        if i % 5000 == 0:
            print("{:7} max {}({}), min {}({})".format(i, max, maxi, min, mini))

        miss = round(myint, N, False)
        if miss > max:
            #print("new max ({}) for {}".format(miss, myint))
            max = miss
            maxi = myint
        if miss < min:
            #print("new min ({}) for {}".format(miss, myint))
            min = miss
            mini = myint



if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-t", help = "target value",
                       type = int, default = "1234554321")
    parser.add_argument("-n", help = "rounds",
                       type = int, default = 15)
    parser.add_argument('-s', help='specific numbers', action='store_true')
    parser.add_argument('-r', help='random', action='store_true')
    parser.add_argument('-d', help='debug', action='store_true')
    args = parser.parse_args()

    if args.r:
        randomsample(args.n)
    elif args.s:
        specificnumbers(args.n, args.d)
    else:
        avg, achieved = round(args.t, args.n, args.d)
        diff = args.t - achieved
        prec = diff /(2**32)
        print("{:10}  {:10}  {:6}  {:12.6f}  {:13.6e}".format(args.t, achieved, diff, avg, prec))
