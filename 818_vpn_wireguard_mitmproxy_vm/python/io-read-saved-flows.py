# https://docs.mitmproxy.org/stable/addons/examples/#io-read-saved-flows

#!/usr/bin/env python
"""
Read a mitmproxy dump file.
"""

import pprint

from mitmproxy import http, tcp, udp, io
from datetime import datetime

flows_file_path = 'out-2025-06-15_20-25-16.mitm'

with open(flows_file_path, "rb") as logfile:
    freader = io.FlowReader(logfile)
    pp = pprint.PrettyPrinter(indent=4)
    
    index = 0

    for flow in freader.stream():
        index += 1
        try:
            if isinstance(flow, http.HTTPFlow):        
                # convert timestamp to time
                print(f"Request {index} created at: {datetime.fromtimestamp(flow.request.timestamp_start).strftime('%Y-%m-%d %H:%M:%S')}")
                print(f"flow.request.method: {flow.request.method}")
                print(f"flow.request.pretty_url: {flow.request.pretty_url}")
                print(f"flow.request.port: {flow.request.port}")
                print(f"flow.client_conn: {flow.client_conn}")
                print(f"flow.request.query: {flow.request.query}")
                print(f"flow.request.cookies: {flow.request.cookies}")
                print(f"flow.request.text: {flow.request.text}")
                print(f"flow.request.headers: {flow.request.headers}")
                # print(f"flow.request.json(): {flow.request.json()}")
                # print(f"flow.request.url: {flow.request.url}")
                # print(f"flow.request.pretty_host: {flow.request.pretty_host}")
                # print(f"flow.request.authority: {flow.request.authority}")
                # print(f"flow.request.host_header: {flow.request.host_header}")

                if (flow.response):
                    print(f"flow.response.status_code: {flow.response.status_code}")
                    print(f"flow.response.content: {flow.response.content}")   

            if isinstance(flow, tcp.TCPFlow) or isinstance(flow, udp.UDPFlow):
                print(f"flow.type: {flow.type}")
                print(f"flow.messages: {flow.messages}")
                print("")

            print("")
            
            # Append formatted output to a file
            # If the file does not exist, it will be created
            with open(f'{flows_file_path}-formatted', 'a') as f:
                f.write(f"Request {index} created at: {datetime.fromtimestamp(flow.request.timestamp_start).strftime('%Y-%m-%d %H:%M:%S')}\n")
                f.write(f"flow.request.method: {flow.request.method}\n")
                f.write(f"flow.request.pretty_url: {flow.request.pretty_url}\n")
                f.write(f"flow.request.port: {flow.request.port}\n")
                f.write(f"flow.client_conn: {flow.client_conn}\n")
                f.write(f"flow.request.query: {flow.request.query}\n")
                f.write(f"flow.request.cookies: {flow.request.cookies}\n")
                f.write(f"flow.request.text: {flow.request.text}\n")
                f.write(f"flow.request.headers: {flow.request.headers}\n")
                if (flow.response):
                    f.write(f"flow.response.status_code: {flow.response.status_code}\n")
                    f.write(f"flow.response.content: {flow.response.content}\n")
                f.write("-----------------------------------------------------------------\n")
        except Exception as e:
            print(f"Error processing flow {index}: {e}")
            continue