# ocp-odf

Scripts and manifests for deploying [OpenShift Data Foundation (ODF)](https://www.redhat.com/en/technologies/cloud-computing/openshift-data-foundation) on [OpenShift Container Platform (OCP)](https://www.redhat.com/en/technologies/cloud-computing/openshift) using local storage.

## Overview

This repository provides the resources needed to configure ODF with local block storage on an OpenShift cluster. It uses the [Local Storage Operator](https://docs.openshift.com/container-platform/latest/storage/persistent_storage/persistent_storage_local/persistent-storage-local.html) to discover and provision local disks as persistent volumes for the ODF storage cluster.

## Prerequisites

- An OpenShift Container Platform cluster (4.x)
- The **Local Storage Operator** installed in the `openshift-local-storage` namespace
- The **OpenShift Data Foundation Operator** installed in the `openshift-storage` namespace
- At least three worker nodes, each with one or more raw block devices of at least 256 GiB
- `oc` CLI configured and authenticated against the cluster

## Usage

Follow these steps in order:

### 1. Label the storage nodes

Label the worker nodes that will participate in the ODF storage cluster:

```bash
bash label-nodes-storage.sh
```

> **Note:** Edit `label-nodes-storage.sh` to replace `worker0 worker1 worker2` with the actual node names in your cluster.

### 2. Discover local devices

Apply the `LocalVolumeDiscovery` manifest to instruct the Local Storage Operator to scan for available block devices on the labeled nodes:

```bash
oc apply -f localVolumeDiscovery.yaml
```

### 3. Create the local volume set

Apply the `LocalVolumeSet` manifest to create a `localblock` StorageClass backed by the discovered disks:

```bash
oc apply -f localVolumeSet.yaml
```

> The `LocalVolumeSet` targets disks that are at least 256 GiB and exposes them as `Block` mode volumes using the `localblock` StorageClass.

### 4. Create the storage cluster

Once the local volumes have been provisioned, create the ODF `StorageCluster`:

```bash
bash storage-cluster.sh
```

The script automatically detects the size of the provisioned PersistentVolumes and creates the `StorageCluster` resource accordingly.

## File Reference

| File | Description |
|------|-------------|
| `label-nodes-storage.sh` | Labels worker nodes with the OCS storage node label |
| `localVolumeDiscovery.yaml` | `LocalVolumeDiscovery` CR — auto-discovers block devices on labeled nodes |
| `localVolumeSet.yaml` | `LocalVolumeSet` CR — creates the `localblock` StorageClass from discovered disks |
| `storage-cluster.sh` | Creates the ODF `StorageCluster` using the provisioned local volumes |

## License

This project is licensed under the [MIT License](LICENSE).
