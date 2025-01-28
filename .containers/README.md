# Standard Order of Parameters

Here’s a suggested order for parameters in Docker Compose service definitions:

    image - The image used to run the container.
    container_name - The name of the container.
    privileged - (optional) Grants extended privileges to the container.
    command - (optional) Command to run inside the container.
    hostname - (optional) The container's hostname.
    environment - (optional) Environment variables for the container.
    volumes - (optional) Volumes mounted inside the container.
    network_mode - (optional) The network mode for the container.
    networks - (optional) Networks to which the container should connect.
    ports - (optional) Ports exposed by the container.
    devices - (optional) Devices to expose to the container (e.g., /dev/dri:/dev/dri for GPU support).
    cap_add - (optional) Adds Linux capabilities to the container.
    depends_on - (optional) Defines service dependencies.
    restart - Defines the restart policy (unless-stopped, always, no, or on-failure).
syncthing
