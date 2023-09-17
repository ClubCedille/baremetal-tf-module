omni_cluster_name = "cedille-cluster"
omni_cluster_endpoint = "https://cedille.kubernetes.omni.siderolabs.io"
omni_sa_kubeconfig = "../../cedille-cluster-tf-sa.kubeconfig.yaml"

network_config = {
  dns = "192.168.88.1"
  domain = "cedille.local"
  gateway = "192.168.88.1"
  network = "192.168.88.0/24"
}

router_host = "192.168.88.1"
router_user = "admin"
router_password = "Password1!"

vlan = 10

servers = [
    {
      controlplane = true,
      hostname = "cedille-controlplane-1",
      mac_addr = "54:9F:35:0D:9A:E4",
      switch_port = "ether7"
    },
    {
      controlplane = true,
      hostname = "cedille-controlplane-2",
      mac_addr = "54:9F:35:20:39:5C",
      switch_port = "ether3"
    },
    {
      controlplane = true,
      hostname = "cedille-controlplane-3",
      mac_addr = "54:9F:35:06:03:BE",
      switch_port = "ether5"
    },
    {
      controlplane = false,
      hostname = "cedille-worker-01",
      mac_addr = "4C:D9:8F:87:3F:FE",
      switch_port = "ether8"
    },
    {
      controlplane = false,
      hostname = "cedille-worker-02",
      mac_addr = "4C:D9:8F:8E:A9:B3",
      switch_port = "ether9"
    }
  ]