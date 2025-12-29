# Configurable dev container image name
set -g DEV_CONTAINER_IMAGE devcontainer

# Generate container name based on current directory
function __dev_container_name
  set -l dir (basename $PWD)
  set -l hash (string sub -l 8 (echo -n $PWD | md5sum))
  echo {$dir}_{$hash}
end

# Run command in dev container (attach if running, start if not)
function __dev_run_in_container
  set -l container_name (__dev_container_name)
  set -l command $argv

  # Attach to running container or start fresh
  if docker container inspect -f "{{.State.Running}}" $container_name &>/dev/null
    docker exec -it $container_name $command
  else
    docker run -it --rm \
      --name $container_name \
      -w /code \
      -v $PWD:/code \
      -v $XDG_CONFIG_HOME:/home/linuxbrew/.config:ro \
      -v {$DEV_CONTAINER_IMAGE}_data:/home/linuxbrew/.local \
      -v {$DEV_CONTAINER_IMAGE}_cache:/home/linuxbrew/.cache \
      $DEV_CONTAINER_IMAGE $command
  end
end

function dv --description "Run nvim in dev Docker container for the current directory"
  __dev_run_in_container nvim $argv
end

function ds --description "Run shell in dev Docker container for the current directory"
  __dev_run_in_container fish
end
