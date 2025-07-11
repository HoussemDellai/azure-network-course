# https://docs.mitmproxy.org/stable/addons/examples/#io-write-flow-file

"""
Generate a mitmproxy dump file.

This script demonstrates how to generate a mitmproxy dump file,
as it would also be generated by passing `-w` to mitmproxy.
In contrast to `-w`, this gives you full control over which
flows should be saved and also allows you to rotate files or log
to multiple files in parallel.
"""

import os
import random
import datetime
from typing import BinaryIO

from mitmproxy import http
from mitmproxy import io


class Writer:
    def __init__(self) -> None:
        # We are using an environment variable to keep the example as simple as possible,
        # consider implementing this as a mitmproxy option instead.
        now = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
        filename = os.getenv("MITMPROXY_OUTFILE", f"out-{now}.mitm")
        self.f: BinaryIO = open(filename, "wb")
        self.w = io.FlowWriter(self.f)

    def response(self, flow: http.HTTPFlow) -> None:
        if random.choice([True, False]):
            self.w.add(flow)

    def done(self):
        self.f.close()


addons = [Writer()]