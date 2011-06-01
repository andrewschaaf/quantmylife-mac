
import os, re, json


def uvarintRead(f):
    bs = []
    while True:
        b = f.read(1)
        if not b:
            raise EOFError
        bs.append(b)
        if not (ord(b) & 128):
            return uvarintDecode(''.join(bs))

def uvarintDecode(x):
    return uvarint_pos_decode(x, 0)[0]

def uvarint_pos_decode(s, pos):
    result = 0
    shift = 0
    while True:
        
        b = ord(s[pos])
        pos += 1
        
        result |= ((b & 0x7f) << shift)
        shift += 7
        if not (b & 0x80):
            return (result, pos)

def uvarintsDecode(data):
    pos = 0
    while pos < len(data):
        x, pos = uvarint_pos_decode(data, pos)
        yield x


def nextOrNone(it):
  try:
    return it.next()
  except StopIteration:
    return None

def mergeIteratorsOnFirstOfTuple(X, Y):
  x = nextOrNone(X)
  y = nextOrNone(Y)
  while (x is not None) and (y is not None):
    if x[0] < y[0]:
      yield x
      x = nextOrNone(X)
    else:
      yield y
      y = nextOrNone(Y)
  while x is not None:
    yield x
    x = nextOrNone(X)
  while y is not None:
    yield y
    y = nextOrNone(Y)


