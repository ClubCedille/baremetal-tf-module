#!/bin/bash

# Example: ./create-talos-disks.sh --out _out --talos_version "v1.3.7" --disk /dev/xvdc --endpoint kube-test.local.codegameeat.com --cluster_name test --xo_host 192.168.1.117 --disk_srs 533309a1-f95a-0c69-90e0-22b35e24bd18 --xo_token $XO_TOKEN --xo_artefact_suffix v2

# --out
# --disk
# --xo_host  --disk_srs  --xo_token  --xo_artefact_suffix v2
# --sidero_api --sidero_events_sink --sidero_logging

while [ $# -gt 0 ]; do

   if [[ $1 == *"--"* ]]; then
        param="${1/--/}"
        declare $param="$2"
   fi
  shift
done

mkdir -p $out

# Workaround, ideally we get the image from here: https://cedille.omni.siderolabs.io/image/talos-amd64-v1.4.5-omni-cedille.iso
# To avoid complete OIDC flow, we jsut copy the kernel parameters from there and apply them to the basic talos linux iso
# siderolink.api=https://cedille.siderolink.omni.siderolabs.io?jointoken=<jointoken> talos.events.sink=<> talos.logging.kernel=<>

# Main Talos Image
docker run --rm -i "ghcr.io/siderolabs/imager:$talos_version" iso --arch amd64 --tar-to-stdout --extra-kernel-arg siderolink.api=$sidero_api --extra-kernel-arg talos.events.sink=$sidero_events_sink --extra-kernel-arg talos.logging.kernel=$sidero_logging | tar xz -C $out

# Post drives to xen orchestra
if [[ -n "$xo_host" ]]; then
        curl --insecure \
         -X POST \
         -b authenticationToken=$xo_token \
         -T talos-amd64.iso \
         "https://$xo_host/rest/v0/srs/$disk_srs/vdis?raw&name_label=talos-amd64_$xo_artefact_suffix" \
         | cat
fi