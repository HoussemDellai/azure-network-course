# https://yetanotherprogrammingblog.medium.com/mitm-proxy-server-from-python-program-2caa3735689d
async def start_proxy():
    opts = Options(listen_host="127.0.0.1", listen_port=8080)
    proxy = DumpMaster(opts)
    proxy.addons.add(InterceptAddon())

    try:
        print("Starting mitmproxy...")
        await proxy.run()  # Run inside the event loop
    except KeyboardInterrupt:
        print("Stopping mitmproxy...")
        proxy.shutdown()

def main():
    asyncio.run(start_proxy())


if __name__ == "__main__":
    main()