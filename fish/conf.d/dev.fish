# Configurable dev container image name
set -g DEV_CONTAINER_IMAGE dev

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

  set -l envs
  set -l ports
  set -l vols
  set -l command

  while test (count $argv) -gt 0
    if test "$argv[1]" = "-e"
      set -a envs -e $argv[2]
      set -e argv[1..2]
    else if test "$argv[1]" = "-p"
      set -a ports -p $argv[2]
      set -e argv[1..2]
    else
      set command $argv
      break
    end
  end

  # Support password managers SSH_AUTH_SOCK.
  if set -q SSH_AUTH_SOCK
    if string match -q "*Docker.app*" (realpath (which docker))
      set -a vols -v $SSH_AUTH_SOCK:/var/run/ssh-auth.sock
    else
      set -a vols -v /run/host-services/ssh-auth.sock:/var/run/ssh-auth.sock
    end
    set -a envs -e SSH_AUTH_SOCK=/var/run/ssh-auth.sock
  end

  # Pass variables from .env files.
  if test -e $PWD/.env
    set -a envs --env-file .env
  end

  set -a vols \
    -v {$DEV_CONTAINER_IMAGE}_home:{$container_home} \
    -v {$DEV_CONTAINER_IMAGE}_cache:{$container_home}/.cache

  # Mount only necessary things from dotfiles.
  for p in \
    fish/config.fish \
    nvim/init.lua \
    nvim/luasnippets \
    starship.toml
    set -a vols -v $XDG_CONFIG_HOME/{$p}:{$container_home}/.config/{$p}:ro
  end

  if docker container inspect -f "{{.State.Running}}" $container_name &>/dev/null
    docker exec -it $envs $container_name /docker-entrypoint.sh $command
  else
    docker run -it --rm \
      --name $container_name \
      -w /code/(basename $PWD) \
      -v $PWD:/code/(basename $PWD) \
      $vols $envs $ports \
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
