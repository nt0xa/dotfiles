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
  set -l container_home /home/linuxbrew

  # Separate env args from command
  set -l env_args
  set -l command

  while test (count $argv) -gt 0
    if test "$argv[1]" = "-e"
      set -a env_args -e $argv[2]
      set -e argv[1..2]
    else
      set command $argv
      break
    end
  end

  if docker container inspect -f "{{.State.Running}}" $container_name &>/dev/null
    docker exec -it $env_args $container_name $command
  else
    docker run -it --rm \
      --name $container_name \
      -w /code \
      -v $PWD:/code \
      -v $XDG_CONFIG_HOME/fish/config.fish:{$container_home}/.config/fish/config.fish:ro \
      -v $XDG_CONFIG_HOME/nvim/init.lua:{$container_home}/.config/nvim/init.lua:ro \
      -v $XDG_CONFIG_HOME/nvim/luasnippets:{$container_home}/.config/nvim/luasnippets:ro \
      -v $XDG_CONFIG_HOME/starship.toml:{$container_home}/.config/starship.toml:ro \
      -v {$DEV_CONTAINER_IMAGE}_data:{$container_home}/.local \
      -v {$DEV_CONTAINER_IMAGE}_cache:{$container_home}/.cache \
      -v {$DEV_CONTAINER_IMAGE}_github:{$container_home}/.config/github-copilot \
      -p 8000 \
      $env_args \
      $DEV_CONTAINER_IMAGE $command
  end
end

function dv --description "Run nvim in dev Docker container for the current directory"
  __dev_run_in_container nvim $argv
end

function ds --description "Run shell in dev Docker container for the current directory"
  __dev_run_in_container $argv fish
end

function de --description "Exec command in dev Docker container for the current directory"
  __dev_run_in_container $argv
end
