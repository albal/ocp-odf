#!/bin/bash
PV_SIZE=$(oc get pv -o jsonpath='{.items[?(@.spec.storageClassName=="localblock")].spec.capacity.storage}' | awk '{print $1}') && cat <<EOF | oc apply -f -
apiVersion: ocs.openshift.io/v1
kind: StorageCluster
metadata:
  name: ocs-storagecluster
  namespace: openshift-storage
spec:
  manageNodes: false
  monDataDirHostPath: /var/lib/rook
  storageDeviceSets:
    - name: ocs-deviceset
      count: 1
      replica: 3
      resources: {}
      placement: {}
      dataPVCTemplate:
        spec:
          storageClassName: localblock
          volumeMode: Block
          accessModes:
            - ReadWriteOnce
          resources:
            requests:
              storage: ${PV_SIZE}
EOF
echo "Created storage of ${PV_SIZE}"
