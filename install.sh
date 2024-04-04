#!/usr/bin/env sh
requirements_satisfied () {
  # Check if node and yarn are installed
  hash node 2>/dev/null || { echo >&2 "Node is required but not installed. Aborting."; exit 1; }
  hash yarn 2>/dev/null || { echo >&2 "Yarn is required but not installed. Aborting."; exit 1; }
  echo "All Installation requirements are met. Continuing."
}

clean_project_dir () {
  echo "Cleaning up project directory."
  rm -rf ./node_modules
  rm -rf ./*.lock
}

install_dependencies () {
  echo "Installing all required dependencies using Yarn."
  yarn install
}

setup_supabase () {
  echo "Connecting to your Supabase project."
  yarn supabase login
  echo "Open your browser and grab your Supabase project reference."
  echo "Hint: You'll find your Project Reference ID from the Supabase Project Dashboard under Project Settings -> General"
  read -p "Press Enter to navigate to https://supabase.com/dashboard/projects now. "
  python3 -m webbrowser https://supabase.com/dashboard/projects
  echo "Paste your project url below (this is not your project URL): "
  read project_reference_id
  echo "Make sure you got your database password ready (can be set in your Supabase project as well)."
  yarn supabase link --project-ref $project_reference_id
  echo "Updating your Supabase project and pushing changes to your online Supabase repository."
  yarb supabase db push
}

main () {
  requirements_satisfied
  clean_project_dir
  install_dependencies
  setup_supabase
}

main