# Grafana Loki Log Aggregation Setup

## 1. Overview

This implementation uses Grafana Loki for log aggregation, Promtail for Docker log collection, and Grafana for log visualisation.

The NGINX application is deployed using HashiCorp Nomad and runs as a Docker container.

## 2. Monitoring Architecture

NGINX Container → Docker Logs → Promtail → Loki → Grafana Explore

## 3. Components

| Component | Version | Purpose |
|---|---|---|
| Loki | 3.5.1 | Log storage and querying |
| Promtail | 3.5.1 | Log collection |
| Grafana | 11.5.2 | Log visualisation |

## 4. Starting the Monitoring Stack

From the project root:

```bash
docker compose -f monitoring/docker-compose.yaml up -d
```

Verify:

```bash
docker compose -f monitoring/docker-compose.yaml ps
```

Loki readiness:

```bash
curl http://localhost:3100/ready
```

## 5. Log Labels

The following labels are configured:

- job: nginx-app
- container: Docker container name
- service: nginx
- nomad_alloc_id: Nomad allocation identifier when exposed by Docker

## 6. Generating Test Logs

Successful requests:

```bash
curl http://localhost:NOMAD_PORT/
```

Missing page requests:

```bash
curl -i http://localhost:NOMAD_PORT/missing-page
```

The missing page request generates an HTTP 404 response.

## 7. LogQL Queries

All application logs:

```logql
{job="nginx-app"}
```

NGINX 404 responses:

```logql
{job="nginx-app"} |= " 404 "
```

Successful HTTP responses:

```logql
{job="nginx-app"} |= " 200 "
```

Missing-page requests:

```logql
{job="nginx-app"} |= "/missing-page"
```

## 8. Observed Results

Record the actual results obtained from Grafana Explore.

- Loki readiness: [Record actual result]
- Promtail log collection: [Record actual result]
- NGINX access logs: [Record actual result]
- HTTP 404 log query: [Record actual result]
- Service labels: [Record actual result]

## 9. Troubleshooting

Document the errors actually encountered and the solutions applied.

## 10. Screenshots

Grafana Explore screenshots are stored in:

`docs/screenshots/`

## 11. Limitations

This is a local assessment environment. Promtail is end-of-life and should be replaced with Grafana Alloy for a maintained production implementation.

The monitoring configuration does not include production-grade authentication, external object storage, high availability or long-term backup.