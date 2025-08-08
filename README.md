# Nautobot v2 Test Environment

This is a Docker Compose setup for Nautobot v2 with local development capabilities for configuration and custom jobs.

## About Nautobot

Nautobot serves as a **Single Source of Truth (SSoT)** for managing network infrastructure. It provides a centralized repository for device information, configuration management, compliance checks, automation, and vulnerability reporting. Nautobot can also synchronize with various third-party tools to enhance automation and management.

For more information about Nautobot's capabilities as the ultimate network CMDB, check out: [Nautobot: The Single Source of Truth (SSoT) for Network Automation](https://netdevops.it/nautobot_the_ultimate_network_cmdb/)

## Features

- **Local Configuration Editing**: Edit `nautobot_config.py` locally
- **Local Job Development**: Develop custom jobs in the `./jobs/` directory
- **Automatic Setup**: Helper script to copy files from container if needed
- **Full Stack**: Includes PostgreSQL, Redis, and Celery workers

## Getting Started

### Clone the Repository

```bash
git clone https://github.com/bsmeding/nautobot_job_development_environment.git
cd nautobot_job_development_environment
```

## Directory Structure

```
.
├── docker-compose.yml          # Main Docker Compose configuration
├── get_config.sh              # Helper script to copy files from container
├── config/
│   └── nautobot_config.py     # Nautobot configuration file (editable locally)
└── jobs/
    └── jobs/                  # Custom jobs directory
        ├── __init__.py        # Makes jobs a Python package
        └── example_job.py     # Example job template
```

## Quick Start

1. **First time setup** (if files don't exist locally):
   ```bash
   ./get_config.sh
   ```

2. **Start Nautobot**:
   ```bash
   docker-compose up -d
   ```

3. **Access Nautobot**:
   - URL: http://localhost:8080
   - Username: `admin`
   - Password: `admin`

## Local Development

### Configuration
- Edit `./config/nautobot_config.py` locally
- Changes are immediately reflected in the container
- Restart containers after major config changes: `docker-compose restart`

### Custom Jobs
- Add your custom jobs to `./jobs/jobs/`
- Each job should be a Python file with a class that inherits from `Job`
- See `./jobs/jobs/example_job.py` for a template
- Jobs are automatically loaded by Nautobot

### Job Development Workflow
1. Create a new Python file in `./jobs/jobs/`
2. Define your job class inheriting from `nautobot.extras.jobs.Job`
3. Implement the `run()` method
4. Save the file - it's automatically available in Nautobot
5. Test your job through the Nautobot web interface

## Services

- **nautobot**: Main Nautobot application (port 8080)
- **postgres**: PostgreSQL database
- **redis**: Redis cache and message broker
- **celery-beat**: Celery beat scheduler
- **celery-worker-1**: Celery worker for background tasks

## Troubleshooting

### If containers won't start:
1. Check if config file exists: `ls -la config/nautobot_config.py`
2. Run setup script: `./get_config.sh`
3. Check logs: `docker-compose logs nautobot`

### If jobs aren't loading:
1. Ensure jobs directory structure is correct
2. Check that `__init__.py` exists in `jobs/jobs/`
3. Verify job class inherits from `Job`
4. Check Nautobot logs for import errors

## Environment Variables

Key environment variables are set in `docker-compose.yml`:
- Database configuration
- Redis configuration
- Superuser credentials
- Security settings

## Notes

- The setup uses a custom Nautobot image: `bsmeding/nautobot:stable-py3.11`
- SSL is enabled but self-signed certificates are used
- Debug mode is enabled for development
- All data is persisted in Docker volumes
