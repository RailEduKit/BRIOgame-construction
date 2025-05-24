#!/usr/bin/env sh

# Default list of repositories to install
DEFAULT_REPOS=(
    "https://github.com/BelfrySCAD/BOSL2.git"
    "https://github.com/dotscad/trains.git"
    "https://github.com/dotscad/dotscad.git"
)

# ===== Initialization Functions =====

# Function to check if OpenSCAD is available
check_openscad() {
    if ! command -v openscad >/dev/null 2>&1; then
        echo "Error: openscad is not installed or not in PATH"
        exit 1
    fi
}

# Function to get OpenSCAD User Library Path
get_library_path() {
    local path
    path=$(openscad --info | grep "User Library Path:" | awk '{print $4}')
    
    # Check if we got a result
    if [ -z "$path" ]; then
        echo "Error: Could not determine OpenSCAD User Library Path" >&2
        exit 1
    fi
    
    # Check if the path exists or can be created
    if [ ! -d "$path" ] && ! mkdir -p "$path" 2>/dev/null; then
        echo "Error: OpenSCAD User Library Path '$path' is not accessible" >&2
        exit 1
    fi
    
    # Return the absolute path
    echo "$(realpath "$path")"
}

# Function to check git availability
check_git() {
    if ! command -v git >/dev/null 2>&1; then
        echo "Error: git is not installed or not in PATH"
        exit 1
    fi
}

# ===== Utility Functions =====

# Show help message
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "Install or update SCAD dependencies."
    echo
    echo "Options:"
    echo "  -h, --help              Show this help message"
    echo "  -d, --directory DIR     Target directory for dependencies"
    echo "                          If not specified, uses 'User Library Path' from OpenSCAD"
    echo "  -f, --file FILE         Read repository URLs from file (one URL per line)"
    echo "                          If not specified, uses default repositories"
    echo
    echo "Example:"
    echo "  $0                      # Install default repos in OpenSCAD library path"
    echo "  $0 -d /path/to/deps     # Install in specified directory"
    echo "  $0 -f repos.txt         # Install repos listed in repos.txt"
    echo "  $0 -d /path/to/deps -f repos.txt  # Install repos from file in specified directory"
}

# Function to create target directory
create_target_dir() {
    local dir=$1
    if [ ! -d "$dir" ]; then
        echo "Creating directory: $dir"
        mkdir -p "$dir"
    fi
}

# Function to read repositories from file
read_repos_from_file() {
    local file=$1
    local -a repos=()
    
    if [ ! -f "$file" ]; then
        echo "Error: Repository file '$file' not found"
        exit 1
    fi
    
    echo "Reading repositories from $file"
    while IFS= read -r line || [ -n "$line" ]; do
        case "$line" in
            ""|\#*) continue ;;
            *) repos+=("$line") ;;
        esac
    done < "$file"
    
    echo "${repos[@]}"
}

# ===== Main Functions =====

# Function to clone or update repository
install_or_update() {
    local repo_url=$1
    local repo_name=$(basename "$repo_url" .git)
    
    if [ -d "$target_dir/$repo_name" ]; then
        echo "Repository $repo_name exists, updating..."
        cd "$target_dir/$repo_name"
        git fetch --depth 1
        git reset --hard origin/HEAD
        cd "$target_dir"
    else
        echo "Cloning $repo_name..."
        git clone --single-branch --depth 1 "$repo_url" "$target_dir/$repo_name"
    fi
}

# Parse command line arguments
parse_arguments() {
    local target_dir="$(get_library_path)"
    local repo_file=""
    
    while [ "$#" -gt 0 ]; do
        case "$1" in
            -h|--help)
                show_help
                exit 0
                ;;
            -d|--directory)
                if [ -z "$2" ]; then
                    echo "Error: Directory path required for -d/--directory option"
                    exit 1
                fi
                target_dir="$2"
                shift 2
                ;;
            -f|--file)
                if [ -z "$2" ]; then
                    echo "Error: File path required for -f/--file option"
                    exit 1
                fi
                repo_file="$2"
                shift 2
                ;;
            *)
                echo "Error: Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    echo "$target_dir:$repo_file"
}

main() {
    # Parse arguments and get target directory and repo file
    IFS=':' read -r target_dir repo_file <<< "$(parse_arguments "$@")"
    local -a repos
    
    # Initialize environment
    check_openscad
    check_git
    create_target_dir "$target_dir"
    
    # Get repositories list
    if [ -n "$repo_file" ]; then
        repos=($(read_repos_from_file "$repo_file"))
    else
        repos=("${DEFAULT_REPOS[@]}")
    fi
    
    # Install or update repositories
    for repo in "${repos[@]}"; do
        install_or_update "$repo"
    done
    
    echo "Dependencies updated successfully in '$target_dir'!"
}

# Run the script
main "$@" 