#!/bin/bash

# Get all node names
NODES=$(oc get nodes -o name | cut -d'/' -f2)

for NODE in $NODES; do
    # Target nodes with "storage" in the name
    if [[ "$NODE" == *"storage"* ]]; then
        echo "Updating Storage Node: $NODE"
        
        # Add the Storage Role
        oc label node "$NODE" node-role.kubernetes.io/storage= --overwrite
        
        # Add the OCS specific label
        oc label node "$NODE" cluster.ocs.openshift.io/openshift-storage="" --overwrite
        
        # Remove the generic worker role
        oc label node "$NODE" node-role.kubernetes.io/worker-
        
    # Target nodes with "infra" in the name
    elif [[ "$NODE" == *"infra"* ]]; then
        echo "Updating Infra Node: $NODE"
        oc label node "$NODE" node-role.kubernetes.io/infra= --overwrite
        oc label node "$NODE" node-role.kubernetes.io/worker-
    fi
done
