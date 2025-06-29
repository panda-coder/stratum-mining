# Stratum V2 Mining Protocol Implementation

A complete Docker-based implementation of the Stratum V2 mining protocol stack, featuring all essential components for Bitcoin mining pool operations with integrated blockchain explorer and testing tools.

## Overview

This project provides a containerized environment for running a complete Stratum V2 mining setup, including:

- **Job Declaration Client (JDC)** - Handles job declaration and template negotiation
- **Job Declaration Server (JDS)** - Manages job distribution and coordination  
- **Pool Server** - Core mining pool functionality with Stratum V2 support
- **Template Provider** - Provides block templates for mining operations
- **Translator Proxy** - Bridges Stratum V1 and V2 protocols for compatibility
- **Bitcoin Core Node** - Full Bitcoin node with SV2 Template Provider support
- **CPU Miner** - Reference miner implementation for testing
- **Mining Device** - Stratum V2 compatible mining device simulator
- **BTC Explorer** - Web-based blockchain explorer for monitoring

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
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│ Mining Device   │    │  BTC Explorer   │    │ Bitcoin Core    │
│ (10.10.0.10)    │    │  (10.10.0.9)    │◄──►│ Node            │
│                 │    │                 │    │ (10.10.0.4)     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## Quick Start

### Prerequisites

- Docker and Docker Compose installed
- tmux (for the automated startup script)
- At least 4GB of available RAM
- 10GB of free disk space

### Running the Stack

#### Option 1: Automated Startup (Recommended)

Use the provided startup script that launches services in the correct order with proper delays:

```bash
# Make the script executable
chmod +x start-pool.sh

# Start all services in tmux sessions
./start-pool.sh
```

This script will:
1. Start the template provider first
2. Launch JDS (Job Declaration Server)
3. Start the pool server
4. Initialize JDC (Job Declaration Client)
5. Start the mining device
6. Launch the BTC Explorer

Each service runs in its own tmux window, and you'll be automatically attached to the session.

#### Option 2: Manual Docker Compose

1. Clone the repository:
```bash
git clone https://github.com/panda-coder/stratum-mining.git
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

### Accessing Services

- **BTC Explorer**: http://localhost:3002 - Web interface for blockchain monitoring
- **Template Provider RPC**: http://localhost:18443 - Bitcoin RPC interface
- **Template Provider API**: http://localhost:8442 - Template provider API

## Service Details

### Job Declaration Client (JDC)
- **IP Address**: 10.10.0.2
- **Port**: 34265
- **Purpose**: Negotiates mining jobs and handles job declarations
- **Config**: `.docker/stratum/jdc/cfg/`

### Pool Server
- **IP Address**: 10.10.0.5
- **Port**: 34254  
- **Purpose**: Core mining pool server handling miner connections with Stratum V2 support
- **Config**: `.docker/stratum/pool/cfg/`

### Job Declaration Server (JDS)
- **IP Address**: 10.10.0.6
- **Purpose**: Coordinates job distribution across the mining network
- **Config**: `.docker/stratum/jds/cfg/`

### Template Provider
- **IP Address**: 10.10.0.3
- **Ports**: 8442 (API), 18443 (RPC)
- **Purpose**: Provides block templates for mining operations with Bitcoin SV2 integration
- **Data**: `.docker/template-provider/data/`
- **Config**: `.docker/template-provider/cfg/`

### Translator Proxy
- **IP Address**: 10.10.0.7
- **Port**: 34255
- **Purpose**: Translates between Stratum V1 and V2 protocols for backward compatibility
- **Config**: `.docker/stratum/tproxy/cfg/`

### Bitcoin Core Node
- **IP Address**: 10.10.0.4
- **Port**: 18444
- **Purpose**: Full Bitcoin node for regtest operations with SV2 Template Provider support
- **Mode**: Regtest (for testing and development)

### CPU Miner
- **IP Address**: 10.10.0.8
- **Purpose**: Reference implementation for testing mining operations
- **Binary**: Based on pooler's cpuminer v2.5.1

### Mining Device
- **IP Address**: 10.10.0.10
- **Purpose**: Stratum V2 compatible mining device simulator for testing

### BTC Explorer
- **IP Address**: 10.10.0.9
- **Port**: 3002
- **Purpose**: Web-based blockchain explorer for monitoring transactions and blocks
- **Access**: http://localhost:3002

## Configuration

Each service can be configured by modifying the respective configuration files in the `.docker/` directory structure. The services use TOML configuration files with examples provided.

### Network Configuration

The services communicate over a custom Docker network (`mining-net`) with the subnet `10.10.0.0/24`. Each service has a static IP address for reliable inter-service communication:

| Service | IP Address | Purpose |
|---------|------------|---------|
| JDC | 10.10.0.2 | Job Declaration Client |
| Template Provider | 10.10.0.3 | Block Template Provider |
| Bitcoin Node | 10.10.0.4 | Bitcoin Core Node |
| Pool Server | 10.10.0.5 | Mining Pool Server |
| JDS | 10.10.0.6 | Job Declaration Server |
| Translator Proxy | 10.10.0.7 | Protocol Translator |
| CPU Miner | 10.10.0.8 | Reference Miner |
| BTC Explorer | 10.10.0.9 | Blockchain Explorer |
| Mining Device | 10.10.0.10 | Mining Device Simulator |

### Bitcoin Configuration

The Bitcoin node runs in regtest mode with the following default credentials:
- **RPC User**: username
- **RPC Password**: password
- **RPC Port**: 18443

### Tmux Session Management

The `start-pool.sh` script creates a tmux session named "mining-pool" with separate windows for each service:
- `templat-provider`: Template Provider service
- `jds`: Job Declaration Server
- `pool`: Pool Server
- `jdc`: Job Declaration Client
- `mining-device`: Mining Device Simulator
- `btc-explorer`: Blockchain Explorer

Navigate between windows using `Ctrl+b` followed by the window number or name.

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

# Rebuild miners
docker-compose build cpuminer mining-device

# Rebuild blockchain explorer
docker-compose build btc-explorer
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
docker-compose logs btc-explorer

# Follow logs in real-time
docker-compose logs -f template-provider
```

### Tmux Session Management

When using the `start-pool.sh` script:

```bash
# List tmux sessions
tmux list-sessions

# Attach to the mining pool session
tmux attach-session -t mining-pool

# Detach from session (while inside tmux)
Ctrl+b, then d

# Kill the entire session
tmux kill-session -t mining-pool
```

### Python Scripts

The `py-scripts` directory contains utility scripts for interacting with the Bitcoin node:

```bash
cd py-scripts

# Install dependencies (using uv)
uv sync

# Run scripts
python main.py
python publicaddress.py
```

## Testing

### Automated Mining Test

The included miners can be used to test the mining setup:

1. Start all services using `./start-pool.sh`
2. The CPU miner and mining device will automatically connect and start mining
3. Monitor the pool logs to see mining activity
4. Check the BTC Explorer at http://localhost:3002 to view blockchain activity

### Manual Bitcoin Operations

Use the provided Bitcoin CLI commands for manual testing:

```bash
# Generate initial blocks (run inside template-provider container)
/app/bitcoin-sv2/bin/bitcoin-cli -regtest -rpcport=18443 -rpcuser=username -rpcpassword=password generatetoaddress 101 $(/app/bitcoin-sv2/bin/bitcoin-cli -regtest -rpcport=18443 -rpcuser=username -rpcpassword=password getnewaddress)

# Send test transaction
/app/bitcoin-sv2/bin/bitcoin-cli -regtest -rpcport=18443 -rpcuser=username -rpcpassword=password sendtoaddress $(
  /app/bitcoin-sv2/bin/bitcoin-cli -regtest -rpcport=18443 -rpcuser=username -rpcpassword=password getnewaddress
) 0.001
```

### Service Startup Order

The `start-pool.sh` script follows the correct startup sequence with 10-second delays:

1. **Template Provider** - Must start first to provide block templates
2. **JDS** - Job Declaration Server needs template provider
3. **Pool** - Pool server requires JDS to be running
4. **JDC** - Job Declaration Client connects to pool and JDS
5. **Mining Device** - Connects to the pool for mining
6. **BTC Explorer** - Web interface for monitoring

## Ports Reference

| Service | Port | Protocol | Purpose |
|---------|------|----------|---------|
| JDC | 34265 | TCP | Job Declaration Client |
| Pool | 34254 | TCP | Mining Pool Server |
| Template Provider | 8442 | TCP | Template API |
| Template Provider | 18443 | TCP | Bitcoin RPC |
| Bitcoin Node | 18444 | TCP | Bitcoin P2P |
| Translator Proxy | 34255 | TCP | Stratum Translation |
| BTC Explorer | 3002 | HTTP | Web Interface |

## Troubleshooting

### Common Issues

1. **Services fail to start**: Ensure Docker has sufficient resources allocated
2. **Port conflicts**: Check that the required ports are not in use by other applications
3. **Network connectivity**: Verify the Docker network is properly configured
4. **Tmux not found**: Install tmux using your system package manager

### Service Dependencies

Services must start in the correct order. The `start-pool.sh` script handles this automatically, but if starting manually:

1. Start `template-provider` first
2. Wait for it to be fully initialized
3. Start `jds`, then `pool`, then `jdc`
4. Finally start miners and explorer

### Checking Service Health

```bash
# Check if all containers are running
docker-compose ps

# Check network connectivity between services
docker-compose exec jdc ping template-provider

# View Bitcoin node status
docker-compose exec btc-node bitcoin-cli -regtest getblockchaininfo
```

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
- Check the service logs using `docker-compose logs [service-name]`
- Ensure all required ports are available
- Verify Docker and Docker Compose versions are up to date
- Use the BTC Explorer at http://localhost:3002 to monitor blockchain activity
- Check tmux sessions with `tmux list-sessions`

### System Requirements

- **Docker**: Version 20.10 or higher
- **Docker Compose**: Version 2.0 or higher  
- **tmux**: For automated startup script
- **RAM**: Minimum 4GB, recommended 8GB
- **Storage**: 10GB free space for blockchain data and containers
- **Network**: Ports 3002, 8442, 18443, 18444, 34254, 34255, 34265 must be available

## References

- [Stratum V2 Specification](https://github.com/stratum-mining/stratum)
- [Bitcoin Core](https://github.com/bitcoin/bitcoin)
- [SV2 Template Provider](https://github.com/stratum-mining/stratum)
- [Bitcoin Explorer](https://github.com/janoside/btc-rpc-explorer)
- [Pooler's CPU Miner](https://github.com/pooler/cpuminer)

## Project Structure

```
├── .docker/                    # Docker configurations
│   ├── bitcoin-core/          # Bitcoin Core node setup
│   ├── btc-explorer/          # Blockchain explorer setup
│   ├── cpuminer/              # CPU miner configuration
│   ├── stratum/               # Stratum V2 components
│   └── template-provider/     # Block template provider
├── py-scripts/                # Python utility scripts
│   ├── main.py               # Main utility script
│   ├── publicaddress.py      # Address generation utilities
│   └── pyproject.toml        # Python dependencies
├── docker-compose.yml         # Service orchestration
├── start-pool.sh             # Automated startup script
└── cmds.txt                  # Bitcoin CLI command examples
```