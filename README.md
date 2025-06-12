# Stratum Mining Protocol Implementation

A complete Docker-based implementation of the Stratum V2 mining protocol stack, featuring all essential components for Bitcoin mining pool operations.

## Overview

This project provides a containerized environment for running a complete Stratum V2 mining setup, including:

- **Job Declaration Client (JDC)** - Handles job declaration and template negotiation
- **Job Declaration Server (JDS)** - Manages job distribution and coordination  
- **Pool Server** - Core mining pool functionality
- **Template Provider** - Provides block templates for mining
- **Translator Proxy** - Bridges Stratum V1 and V2 protocols
- **Bitcoin Core Node** - Full Bitcoin node for blockchain interaction
- **CPU Miner** - Reference miner implementation for testing

## Architecture

The system uses a microservices architecture with the following network topology:

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   CPU Miner     │    │  Translator     │    │   Pool Server   │
│  (10.10.0.8)    │◄──►│   Proxy         │◄──►│  (10.10.0.5)    │
│                 │    │  (10.10.0.7)    │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                 │                       │
                                 ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│      JDC        │◄──►│      JDS        │◄──►│ Template        │
│  (10.10.0.2)    │    │  (10.10.0.6)    │    │ Provider        │
│                 │    │                 │    │ (10.10.0.3)     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                                       │
                                                       ▼
                                            ┌─────────────────┐
                                            │ Bitcoin Core    │
                                            │ Node            │
                                            │ (10.10.0.4)     │
                                            └─────────────────┘
```

## Quick Start

### Prerequisites

- Docker and Docker Compose installed
- At least 4GB of available RAM
- 10GB of free disk space

### Running the Stack

1. Clone the repository:
```bash
git clone <repository-url>
cd stratum-mining
```

2. Start all services:
```bash
docker-compose up -d
```

3. Monitor the logs:
```bash
docker-compose logs -f
```

4. Stop the services:
```bash
docker-compose down
```

## Service Details

### Job Declaration Client (JDC)
- **Port**: 34265
- **Purpose**: Negotiates mining jobs and handles job declarations
- **Config**: `.docker/stratum/jdc/cfg/`

### Pool Server
- **Port**: 34254  
- **Purpose**: Core mining pool server handling miner connections
- **Config**: `.docker/stratum/pool/cfg/`

### Job Declaration Server (JDS)
- **Purpose**: Coordinates job distribution across the mining network
- **Config**: `.docker/stratum/jds/cfg/`

### Template Provider
- **Ports**: 8442, 18443
- **Purpose**: Provides block templates for mining operations
- **Data**: `.docker/template-provider/data/`

### Translator Proxy
- **Port**: 34255
- **Purpose**: Translates between Stratum V1 and V2 protocols
- **Config**: `.docker/stratum/tproxy/cfg/`

### Bitcoin Core Node
- **Port**: 18444
- **Purpose**: Full Bitcoin node for regtest/testnet operations
- **Version**: Includes SV2 Template Provider support

### CPU Miner
- **Purpose**: Reference implementation for testing mining operations
- **Binary**: Based on pooler's cpuminer

## Configuration

Each service can be configured by modifying the respective configuration files in the `.docker/` directory structure. The services use TOML configuration files with examples provided.

### Network Configuration

The services communicate over a custom Docker network (`mining-net`) with the subnet `10.10.0.0/24`. Each service has a static IP address for reliable inter-service communication.

## Development

### Building Individual Services

To rebuild a specific service:

```bash
# Rebuild stratum components
docker-compose build jdc pool jds translator-proxy

# Rebuild Bitcoin node
docker-compose build btc-node

# Rebuild template provider
docker-compose build template-provider

# Rebuild CPU miner
docker-compose build cpuminer
```

### Logs and Debugging

View logs for specific services:

```bash
# View all logs
docker-compose logs

# View specific service logs
docker-compose logs jdc
docker-compose logs pool
docker-compose logs btc-node
```

## Testing

The included CPU miner can be used to test the mining setup:

1. Ensure all services are running
2. The CPU miner will automatically connect and start mining
3. Monitor the pool logs to see mining activity

## Ports Reference

| Service | Port | Protocol | Purpose |
|---------|------|----------|---------|
| JDC | 34265 | TCP | Job Declaration Client |
| Pool | 34254 | TCP | Mining Pool Server |
| Template Provider | 8442 | TCP | Template API |
| Template Provider | 18443 | TCP | Bitcoin RPC |
| Bitcoin Node | 18444 | TCP | Bitcoin P2P |
| Translator Proxy | 34255 | TCP | Stratum Translation |

## License

This project is licensed under the terms specified in the LICENSE file.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with the provided Docker setup
5. Submit a pull request

## Support

For issues and questions:
- Check the service logs using `docker-compose logs`
- Ensure all required ports are available
- Verify Docker and Docker Compose versions are up to date

## References

- [Stratum V2 Specification](https://github.com/stratum-mining/stratum)
- [Bitcoin Core](https://github.com/bitcoin/bitcoin)
- [SV2 Template Provider](https://github.com/stratum-mining/stratum)