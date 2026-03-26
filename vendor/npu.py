#!/usr/bin/env python3

from pprint import pprint

try:
    from torch_npu.contrib import transfer_to_npu
except ImportError as e:
    print(f"{type(e).__name__}: {e}")
else:
    print("transfer_to_npu imported")
    import torch_npu
    print("torch_npu.__version__:", torch_npu.__version__)

def main():
    pass

if __name__ == '__main__':
    main()
