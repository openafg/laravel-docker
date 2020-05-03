#!/bin/bash

# ----------------------------------------------------------------------
# Help function on commands.
# ----------------------------------------------------------------------
helpFunction()
{
  echo ""
  echo "Usage: $0"
  echo ""
  echo "Options: "
  echo "      -c           composer command"
  echo "      -n           npm command"
  echo "      -a           artisan command"
  echo ""
  echo "For example:"
  echo "If you want to run this command 'php artisan migrate' simply write this:"
  echo -e "\t -a migrate"
  exit 1
}

# ----------------------------------------------------------------------
# Run PHP artisan commands.
# ----------------------------------------------------------------------
artisanCommands()
{
  echo "Runnin php artisna $parameterA"
  docker exec app php artisan $parameterA
  exit 1
}

# ----------------------------------------------------------------------
# Run npm commands.
# ----------------------------------------------------------------------
npmCommands()
{
  echo "Runnin npm $parameterN"
  docker exec npm npm $parameterN
  exit 1
}

# ----------------------------------------------------------------------
# Run composer commands.
# ----------------------------------------------------------------------
composerCommands()
{
  echo "Runnin composer $parameterC"
  docker exec app composer $parameterC
  exit 1
}

while getopts "a:n:c:" opt
do
  case "$opt" in
    a ) parameterA="$OPTARG" ;;
    n ) parameterN="$OPTARG" ;;
    c ) parameterC="$OPTARG" ;;
    ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
  esac
done

# ----------------------------------------------------------------------
# Check parameter a for artisan commands.
# ----------------------------------------------------------------------
if [ "$parameterA" ]
then 
  artisanCommands
fi

# ----------------------------------------------------------------------
# Check parameter c for composer commands.
# ----------------------------------------------------------------------
if [ "$parameterC" ]
then 
  composerCommands
fi

# ----------------------------------------------------------------------
# Check parameter n for npm commands.
# ----------------------------------------------------------------------
if [ "$parameterN" ]
then 
  npmCommands
fi

# ----------------------------------------------------------------------
# Print helpFunction in case parameters are empty
# ----------------------------------------------------------------------
if [ -z "$parameterA" ] || [ -z "$parameterN" ] || [ -z "$parameterC" ]
then
  helpFunction
fi
