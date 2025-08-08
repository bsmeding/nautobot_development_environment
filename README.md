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

### Plugin Configuration

This setup includes pre-configured plugins for advanced network automation. The plugins are configured in `./config/nautobot_config.py`:

#### Available Plugins

```python
PLUGINS = [
    "nautobot_bgp_models",              # BGP routing management
    "nautobot_capacity_metrics",        # Capacity monitoring
    "nautobot_data_validation_engine",  # Data validation and compliance
    "nautobot_design_builder",          # Network design patterns
    "nautobot_device_lifecycle_mgmt",   # Device lifecycle management
    "nautobot_device_onboarding",       # Automated device onboarding
    "nautobot_firewall_models",         # Firewall rule management
    "nautobot_floor_plan",              # Physical layout visualization
    "nautobot_golden_config",           # Configuration management
    "nautobot_plugin_nornir",           # Network automation integration
    "nautobot_secrets_providers",       # Secrets management
    "nautobot_ssot",                    # Single Source of Truth integrations
]
```

#### Plugin Configuration Example

```python
PLUGINS_CONFIG = {
    'nautobot_ssot': {
        'enable_sso': True,
        'enable_sync': True,
    },
    'nautobot_plugin_nornir': {
        'use_config_context': True,
        'connection_options': {
            'netmiko': {
                'extras': {
                    'global_delay_factor': 2,
                },
            },
            'napalm': {
                'extras': {
                    'optional_args': {
                        'global_delay_factor': 2,
                    },
                },
            },
        },
    },
    'nautobot_golden_config': {
        'enable_backup': True,
        'enable_compliance': True,
        'enable_intended': True,
        'enable_sotagg': True,
        'sot_agg_transposer': 'nautobot_golden_config.transposers.SoTaggTransposer',
        'backup_repository': 'backup_repo',
        'intended_repository': 'intended_repo',
        'jinja_repository': 'jinja_repo',
        'jinja_path_template': 'templates/{{ obj.platform.slug }}/{{ obj.platform.slug }}.j2',
        'backup_path_template': 'backup/{{ obj.platform.slug }}/{{ obj.name }}.cfg',
        'intended_path_template': 'intended/{{ obj.platform.slug }}/{{ obj.name }}.cfg',
        'backup_test_connectivity': False,
    },
    'nautobot_device_lifecycle_mgmt': {
        'enable_software': True,
        'enable_hardware': True,
        'enable_contract': True,
        'enable_provider': True,
        'enable_cve': True,
        'enable_software_image': True,
    },
    'nautobot_device_onboarding': {
        'default_platform': 'cisco_ios',
        'default_site': 'main',
        'default_role': 'switch',
        'default_status': 'active',
        'default_management_interface': 'GigabitEthernet0/0',
        'default_management_prefix_length': 24,
        'default_management_protocol': 'ssh',
        'default_management_port': 22,
        'default_management_timeout': 30,
        'default_management_verify_ssl': False,
        'default_management_auto_create_management_interface': True,
        'default_management_auto_create_management_ip': True,
    },
    'nautobot_data_validation_engine': {
        'enable_validation': True,
        'enable_compliance': True,
        'enable_reporting': True,
    },
    'nautobot_plugin_floorplan': {
        'enable_floorplan': True,
        'enable_rack_views': True,
        'enable_device_views': True,
    },
    'nautobot_firewall_models': {
        'enable_firewall_rules': True,
        'enable_firewall_zones': True,
        'enable_firewall_policies': True,
        'enable_firewall_services': True,
        'enable_firewall_addresses': True,
        'enable_firewall_address_groups': True,
        'enable_firewall_service_groups': True,
        'enable_firewall_rule_groups': True,
    },
    'nautobot_design_builder': {
        'enable_designs': True,
        'enable_design_instances': True,
        'enable_design_patterns': True,
    },
}
```

#### Adding New Plugins

To add a new plugin:

1. **Install the plugin** (if not already in the Docker image):
   ```bash
   docker exec nautobot pip install nautobot-your-plugin
   ```

2. **Add to PLUGINS list** in `./config/nautobot_config.py`:
   ```python
   PLUGINS = [
       # ... existing plugins ...
       "nautobot_your_plugin",
   ]
   ```

3. **Add configuration** to PLUGINS_CONFIG:
   ```python
   PLUGINS_CONFIG = {
       # ... existing config ...
       'nautobot_your_plugin': {
           'setting1': 'value1',
           'setting2': 'value2',
       },
   }
   ```

4. **Restart Nautobot**:
   ```bash
   docker-compose restart nautobot
   ```

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
