import os
from kubernetes import client, config
from rich.traceback import install
from rich.theme import Theme
from rich.console import Console


def main() -> int:
    # Install Rich
    install()

    custom_theme = Theme({"success": "green", "error": "bold red"})
    console = Console(theme=custom_theme)

    # Configs can be set in Configuration class directly or using helper utility
    config.load_kube_config()

    kbct = client.CoreV1Api()

    svc = kbct.read_namespaced_service(name="zeppelin-server", namespace="zeppelin")
    svc_ip = svc.spec.cluster_i_ps[0]

    with open('/usr/local/etc/dnsmasq.d/zeppelin.worldl.xpt.conf', 'w') as f:
        f.write(f"address=/.zeppelin.worldl.xpt/{svc_ip}")

    # Reload Dnsmasq configuration and clear cache
    assert os.system("sudo brew services restart dnsmasq") == 0
    assert os.system("dscacheutil -flushcache") == 0

    return 0


if __name__ == "__main__":
    exit(main())
