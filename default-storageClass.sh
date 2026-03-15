#!/bin/bash
oc patch storageclass ocs-storagecluster-ceph-rbd \
  -p '{"metadata": {"annotations": {"storageclass.kubernetes.io/is-default-class": "true"}}}'
