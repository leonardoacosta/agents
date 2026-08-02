# Network diagnostics

Treat a timeout as a symptom, not proof of a routing defect. Check name resolution, effective policy, routes, and endpoint state in both directions.

## Triage order

1. Resolve the destination name from the actual source environment and compare the result with the expected public or private address.
2. Confirm protocol, destination port, source address, and whether the application is listening.
3. Evaluate source outbound and destination inbound NSG rules in priority order, including subnet and NIC associations.
4. Inspect effective routes from a queryable running-VM NIC in the relevant virtual network.
5. Check peering, user-defined routes, firewall or appliance next hops, and return-path symmetry.
6. Verify private endpoint provisioning, approval, network-interface address, private DNS zone records, and VNet links.
7. Correlate Network Watcher, service health, and recent configuration changes when available.

## Interpret NSG behavior

An NSG deny commonly produces a silent drop: connection timeout and no useful trace response. That evidence does not distinguish an NSG rule from every routing or firewall cause.

```bash
az network nsg rule list \
  --nsg-name <source-nsg> \
  --resource-group <resource-group> \
  --query "[?direction=='Outbound'] | sort_by(@, &priority)" \
  --output table

az network nsg rule list \
  --nsg-name <destination-nsg> \
  --resource-group <resource-group> \
  --query "[?direction=='Inbound'] | sort_by(@, &priority)" \
  --output table
```

Evaluate the actual source and destination prefixes after service tags, application security groups, and default rules are applied.

## Inspect private endpoint routes safely

A private endpoint NIC may not expose an effective route table through the same query used for a running VM NIC. When direct inspection is unavailable, use a customer-controlled running-VM NIC in the same virtual network to inspect propagated `InterfaceEndpoint` routes, and record that this is indirect evidence.

```bash
az network nic show-effective-route-table \
  --name <running-vm-nic> \
  --resource-group <resource-group> \
  --query "value[?nextHopType=='InterfaceEndpoint']" \
  --output table
```

Managed service NICs can be outside the operator's queryable scope. Do not turn that permission boundary into a claim that a route is absent.

## Check DNS and endpoint state

Confirm the service hostname resolves to the intended private address from the failing source. Inspect private DNS records and VNet links, private endpoint connection approval, and the endpoint NIC address. Avoid testing only from an unrelated laptop or public resolver.

Escalate a suspected Azure fabric issue only after the available health, DNS, NSG, route, endpoint, firewall, and application-listener evidence has been documented.
