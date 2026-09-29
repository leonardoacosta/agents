# Docker Swarm

Docker Swarm is Docker's cluster orchestrator. Komodo's **Swarm** resource connects to existing Swarm manager nodes represented as Komodo Servers with Periphery installed. Komodo then provides cluster-level visibility and actions for nodes, services, tasks and stacks. This Docker feature is unrelated to coding-agent swarms.

## Decide whether Swarm fits

Use a Swarm resource when Docker Swarm is already the intended scheduler and you need Komodo to manage or inspect that cluster. A single container belongs in a [Deployment](containers.md); a Compose project on one host belongs in a [Stack](compose.md). A Stack can target a Swarm for stack deployment, but a Stack resource does not turn a standalone Docker host into a Swarm.

Swarm membership and manager availability are prerequisites outside the Komodo resource. Komodo docs describe selecting one or more manager Servers; multiple managers provide alternate connection targets if one is unreachable. Manager lists do not themselves create cluster quorum or repair a broken Swarm.

## Services and stacks

Swarm services describe desired replicated or global workloads scheduled across eligible nodes. Tasks are the individual service instances placed by the cluster. A Swarm stack deploys a multi-service definition using Docker's stack model. Review node constraints, published ports, overlay networks, secrets/configs, volumes and placement before applying changes: cluster scheduling changes where a task runs, but does not make host-local paths or data portable between nodes.

Keep the distinction between ordinary Compose and Swarm stack semantics. Not every Compose option or local-host assumption transfers to `docker stack deploy`. Check Docker's compatibility guidance for the file format and features in use.

## Operational boundaries

A Swarm manager is a privileged control-plane endpoint. Only connect intended manager Servers and grant suitable Komodo resource permissions. Treat service updates, stack deployments, node operations and removal as cluster-level changes with impact beyond one host. Inspect the intended resource and workload before initiating a mutating action.

Komodo health visibility and alerts report state; they do not replace Docker-level availability design, application health checks, quorum planning or backups. Replicas are not a backup. Persist application data through an intentional storage design and back up data separately.

## Common pitfalls

- Assuming creating a Komodo Swarm resource initializes or joins Docker nodes.
- Treating a Swarm resource's alternate managers as a quorum mechanism.
- Using host bind paths as though the scheduler can move their contents with a task.
- Applying Compose assumptions to Swarm stack deployment without checking feature support.
- Confusing a Swarm service's desired state with the health or readiness of the application.

## Canonical sources

- [Komodo Swarm](https://komo.do/docs/swarm)
- [Komodo Docker Compose](https://komo.do/docs/deploy/compose)
- [Docker Swarm mode](https://docs.docker.com/engine/swarm/)
- [Docker stack deploy](https://docs.docker.com/reference/cli/docker/stack/deploy/)

## Refresh rules

Before generating cluster configuration or commands, check Komodo's current Swarm and Compose pages for resource schema, manager connection behavior, available actions and target semantics. Check the Docker docs for current scheduling, stack-file compatibility and command behavior. The reference is conceptual and does not certify a live cluster's membership, network, quorum or storage state.