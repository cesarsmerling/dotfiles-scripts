# Docker Testing Environment

This directory contains Docker configurations for testing the installation scripts on both Ubuntu and Arch Linux in isolated environments.

## Key Feature

**Containers start directly in their respective scripts directory:**
- Ubuntu container → `/workspace/scripts/ubuntu`
- Arch container → `/workspace/scripts/arch`

This means you can run `./main.sh` immediately after entering the container!

## Structure

```
docker/
├── Dockerfile.ubuntu      # Ubuntu 22.04 test environment
├── Dockerfile.arch        # Arch Linux test environment
├── docker-compose.yml     # Orchestrates both containers
└── README.md              # This file
```

## Prerequisites

- Docker installed on your system
- Docker Compose installed (usually comes with Docker Desktop)

## User Credentials

Both containers use a non-root user for realistic testing scenarios:

- **Username**: `testuser`
- **Password**: `test`

This setup requires password authentication for sudo commands, allowing you to test `sudo -v` and other sudo-related functionality just like in a real environment.

## Quick Start

### Build the containers

From the `docker` directory:

```bash
cd docker
docker-compose build
```

### Run Ubuntu test environment

```bash
docker-compose run --rm ubuntu
```

### Run Arch Linux test environment

```bash
docker-compose run --rm arch
```

## Testing Scripts

Once inside a container, your project is mounted at `/workspace`, and **you'll start directly in the scripts directory** for your distribution:

- **Ubuntu container**: starts in `/workspace/scripts/ubuntu`
- **Arch container**: starts in `/workspace/scripts/arch`

### Ubuntu/Pop!_OS Scripts

```bash
# You're already in /workspace/scripts/ubuntu
# Make scripts executable (if not already)
chmod +x *.sh

# Run individual scripts directly
./01-update-upgrade.sh

# Or run the main script
./main.sh
```

### Arch Linux Scripts

```bash
# You're already in /workspace/scripts/arch
# Make scripts executable (if not already)
chmod +x *.sh

# Run individual scripts directly
./01-update-upgrade.sh

# Or run the main script
./main.sh
```

### Testing Sudo Authentication

Since the containers use password-protected sudo (password: `test`), you can test sudo-related functionality:

```bash
# Validate/refresh sudo credentials
sudo -v

# When prompted, enter: test

# Now run your scripts
./scripts/ubuntu/01-update-upgrade.sh
```

## Useful Commands

### Start a container and keep it running

```bash
docker-compose up -d ubuntu  # For Ubuntu
docker-compose up -d arch    # For Arch
```

### Execute commands in a running container

```bash
docker-compose exec ubuntu bash
docker-compose exec arch bash
```

### Stop containers

```bash
docker-compose down
```

### Rebuild containers (after changing Dockerfiles)

```bash
docker-compose build --no-cache ubuntu
docker-compose build --no-cache arch
```

### View logs

```bash
docker-compose logs ubuntu
docker-compose logs arch
```

## Container Details

Both containers include:
- Non-root user `testuser` with password-protected sudo (password: `test`)
- Basic tools: curl, wget, git
- Your project mounted at `/workspace`
- **Working directory set to `/workspace/scripts/<distro>`** (starts in the appropriate scripts folder)
- Clean slate for testing installations

### Ubuntu Container
- Based on Ubuntu 22.04
- Includes `apt` package manager
- Mirrors Pop!_OS package management

### Arch Container
- Based on latest Arch Linux
- Includes `pacman` package manager
- Includes `base-devel` for AUR packages

## Testing Workflow

1. **Build the container** (first time or after Dockerfile changes):
   ```bash
   docker-compose build ubuntu
   ```

2. **Run the container**:
   ```bash
   docker-compose run --rm ubuntu
   ```

3. **Test your scripts** inside the container (you'll already be in the scripts/ubuntu directory):
   ```bash
   # You're already in /workspace/scripts/ubuntu
   ./01-update-upgrade.sh
   ```

4. **Document any errors or issues** you encounter

5. **Exit and cleanup**:
   ```bash
   exit  # exits the container
   ```

6. **Repeat** for Arch Linux using the `arch` service

## Troubleshooting

### Permission issues
If you encounter permission issues with scripts:
```bash
chmod +x /workspace/scripts/ubuntu/*.sh
chmod +x /workspace/scripts/arch/*.sh
```

### Container won't start
Rebuild without cache:
```bash
docker-compose build --no-cache
```

### Changes not reflected
Make sure you're not running an old container. Stop and remove all containers:
```bash
docker-compose down
docker-compose run --rm ubuntu
```

### Check container status
```bash
docker ps -a
```

## Notes

- The containers are ephemeral - any changes inside the container (outside of `/workspace`) are lost when you exit
- This is perfect for testing as each run gives you a fresh environment
- All changes to files in `/workspace` persist (as it's mounted from your host)
- Scripts are run as `testuser` with sudo privileges, mimicking a real user setup
