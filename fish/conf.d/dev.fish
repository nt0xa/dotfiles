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
  set -l flags
  set -l command

  while test (count $argv) -gt 0
    if test "$argv[1]" = "-e"
      set -a flags -e $argv[2]
      set -e argv[1..2]
    else if test "$argv[1]" = "-p"
      set -a flags -p $argv[2]
      set -e argv[1..2]
    else
      set command $argv
      break
    end
  end

  # Support password managers SSH_AUTH_SOCK.
  if set -q SSH_AUTH_SOCK
    if string match -q "*Docker.app*" (realpath (which docker))
      set -a flags -v $SSH_AUTH_SOCK:/var/run/ssh-auth.sock
    else
      set -a flags -v /run/host-services/ssh-auth.sock:/var/run/ssh-auth.sock
    end
    set -a flags -e SSH_AUTH_SOCK=/var/run/ssh-auth.sock
  end

  # Pass variables from .env files.
  if test -e $PWD/.env
    set -a flags --env-file .env
  end

  if docker container inspect -f "{{.State.Running}}" $container_name &>/dev/null
    docker exec -it $env_args $container_name /docker-entrypoint.sh $command
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
      $flags \
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
