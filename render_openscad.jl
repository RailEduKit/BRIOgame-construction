#! /usr/bin/env julia

using JSON
using Dates
using ArgParse

function parse_commandline()
    s = ArgParseSettings()

    @add_arg_table! s begin
        "input_dir"
            help = "Directory containing SCAD files"
            default = "_assets/scad"
        "--output_dir", "-o"
            help = "Directory for rendered PNG files (default: _assets/renderings)"
            default = "_assets/renderings"
        "--width", "-w"
            help = "Width of rendered images (default: 1024)"
            arg_type = Int
            default = 1024
        "--height", "-H"
            help = "Height of rendered images (default: 1024)"
            arg_type = Int
            default = 1024
        "--blacklist", "-b"
            help = "Comma-separated list of SCAD files to exclude"
            default = "template.scad,config.scad"
        "--timeout", "-t"
            help = "Timeout in seconds for each rendering (default: 300)"
            arg_type = Int
            default = 300
        "--force", "-f"
            help = "Force rebuild all renderings regardless of modification time"
            action = :store_true
    end

    return parse_args(s)
end

function detect_openscad_version(version_str::String)
    # Define supported versions and their detection patterns
    version_patterns = Dict(
        "2025" => "OpenSCAD version 2025",
        "2021" => "OpenSCAD version 2021",
        "2019" => "OpenSCAD version 2019"
    )
    
    # Check each line for version information
    for line in split(version_str, '\n')
        for (version, pattern) in version_patterns
            if occursin(pattern, line)
                @debug "Detected OpenSCAD version $version"
                return version
            end
        end
    end
    
    @warn "Unknown OpenSCAD version: $version_str"
    return "unknown"
end

function check_openscad_installed()
    try
        # Run OpenSCAD version command and capture output
        output = IOBuffer()
        run(pipeline(`openscad --version`, stdout=output, stderr=output))
        version_str = String(take!(output))
        
        # Detect version from output
        return detect_openscad_version(version_str)
    catch e
        error("OpenSCAD is not installed or not found in PATH. Please install OpenSCAD first.")
    end
end

function get_file_modification_time(file_path::String)
    return stat(file_path).mtime
end

function load_render_log(output_dir::String)
    log_path = joinpath(output_dir, "render_log.json")
    if isfile(log_path)
        return JSON.parsefile(log_path)
    end
    return Dict{String, Dict{String, Any}}()
end

function save_render_log(output_dir::String, log::Dict)
    log_path = joinpath(output_dir, "render_log.json")
    open(log_path, "w") do f
        JSON.print(f, log, 2)  # Pretty print with 2-space indentation
    end
end

function with_timeout(f, timeout_seconds)
    result_channel = Channel(1)
    error_channel = Channel(1)
    
    # Start the task
    task = @async begin
        try
            result = f()
            put!(result_channel, result)
        catch e
            put!(error_channel, e)
        end
    end
    
    # Set up the timeout
    timer = Timer(timeout_seconds) do _
        if !istaskdone(task)
            schedule(task, InterruptException(), error=true)
        end
    end
    
    try
        # Wait for either the result or an error
        if isready(error_channel)
            throw(take!(error_channel))
        end
        return take!(result_channel)
    finally
        close(timer)
    end
end

function parse_openscad_output(output_str::String)
    messages = Dict(
        "WARNING" => String[],
        "DEPRECATED" => String[],
        "TRACE" => String[],
        "ERROR" => String[],
    )
    
    # Split output into lines and process each line
    cleaned_lines = String[]
    for line in split(output_str, '\n')
        if startswith(line, "WARNING:") || startswith(line, "WARNING ")
            push!(messages["WARNING"], line)
        elseif startswith(line, "DEPRECATED:") || startswith(line, "DEPRECATED ")
            push!(messages["DEPRECATED"], line)
        elseif startswith(line, "TRACE:") || startswith(line, "TRACE ")
            push!(messages["TRACE"], line)
        elseif startswith(line, "ERROR:") || startswith(line, "ERROR ")
            push!(messages["ERROR"], line)
        else
            push!(cleaned_lines, line)
        end
    end
    
    # Join the cleaned lines back into a string
    cleaned_output = join(cleaned_lines, '\n')
    
    return messages, cleaned_output
end

function render_openscad_to_png(input_file::String; output_dir::String=".", width::Int=1024, height::Int=1024, timeout::Int=300)
    # Check if OpenSCAD is installed and get version
    version = check_openscad_installed()
    
    base_name = replace(basename(input_file), ".scad" => "")
    
    # Create a temporary file for the summary
    summary_file = joinpath(output_dir, "$base_name.summary.json")
    
    # Construct the OpenSCAD command based on version
    cmd = if version == "2021"
        `openscad
            --o $(joinpath(output_dir, "$base_name.png"))
            --render
            --viewall
            --autocenter
            --imgsize $(width),$(height)
            --export-format png
            --summary all
            --summary-file $summary_file
            $input_file`
    elseif version == "2019"
        `openscad
            --o $(joinpath(output_dir, "$base_name.png"))
            --render
            --viewall
            --autocenter
            --imgsize $(width),$(height)
            --export-format png
            $input_file`
    else
        `openscad
            --o $(joinpath(output_dir, "$base_name.png"))
            --backend Manifold
            --render
            --viewall
            --autocenter
            --imgsize $(width),$(height)
            --export-format png
            --summary all
            --summary-file $summary_file
            $input_file`
    end
    
    @debug("Running OpenSCAD command: $cmd")
    
    # Run the command and capture output
    output = IOBuffer()
    
    try
        # Start the process with merged output redirection
        process = run(pipeline(cmd, stdout=output, stderr=output), wait=false)
        
        # Set up a timer to kill the process if it takes too long
        timer = Timer(timeout) do _
            if process_running(process)
                @warn("Rendering of $input_file timed out after $timeout seconds - killing process")
                kill(process)
            end
        end
        
        # Wait for the process to complete
        wait(process)
        
        # Get the captured output
        output_str = String(take!(output))
        
        @debug("Process completed with exit code $(process.exitcode)")
        @debug("Output length: $(length(output_str))")
        
        # Try to read the summary file if it exists
        summary_json = ""
        if isfile(summary_file)
            try
                summary_json = read(summary_file, String)
                # Clean up the summary file
                rm(summary_file)
            catch e
                @warn("Failed to read summary file for $input_file: $e")
            end
        end
        
        if process.exitcode == 0
            @info("Successfully rendered $input_file to $output_dir/$base_name.png")
            return true, output_str, summary_json
        else
            if process.exitcode == -9  # SIGKILL
                @warn("Rendering of $input_file timed out after $timeout seconds")
                return false, output_str * "\nProcess timed out after $timeout seconds", summary_json
            else
                error("Failed to render OpenSCAD file. Exit code: $(process.exitcode)")
                return false, output_str, summary_json
            end
        end
    catch e
        @warn("Error processing $input_file: $e")
        return false, String(take!(output)) * "\nError: $e", ""
    finally
        close(output)
        # Clean up summary file if it exists
        if isfile(summary_file)
            rm(summary_file)
        end
    end
end

function update_render_log(output_dir::String, log::Dict, filename::String, entry::Dict)
    # Update the log with the new entry
    log[filename] = entry
    
    # Save the updated log
    save_render_log(output_dir, log)
end

function main(input_dir::String; output_dir::String=".", width=1024, height=1024, blacklist::Vector{String}=String[], timeout::Int=300, force::Bool=false)
    # Create output directory if it doesn't exist
    mkpath(output_dir)
    
    # Load previous render log
    render_log = load_render_log(output_dir)
    
    # Get all .scad files from input directory
    scad_files = filter(file -> endswith(file, ".scad"), readdir(input_dir))
    
    # Filter out blacklisted files
    scad_files = filter(file -> !(basename(file) in blacklist), scad_files)
    
    if isempty(scad_files)
        error("No .scad files found in $input_dir")
        return
    end
    
    @info("Found $(length(scad_files)) .scad files to process")
    
    # Process each .scad file
    for scad_file in scad_files
        input_path = joinpath(input_dir, scad_file)
        file_mtime = get_file_modification_time(input_path)
        
        # Initialize log entry for this file
        log_entry = Dict(
            "mtime" => file_mtime,
            "last_attempt" => time(),
            "success" => false,
            "output" => "",
            "messages" => Dict(
                "WARNING" => String[],
                "DEPRECATED" => String[],
                "TRACE" => String[],
                "ERROR" => String[]
            ),
            "summary" => Dict(),
            "timeout" => timeout
        )
        
        # Check if file needs to be rendered
        if force || !haskey(render_log, scad_file) || render_log[scad_file]["mtime"] < file_mtime
            try
                success, output_str, summary_json = render_openscad_to_png(
                    input_path, 
                    output_dir=output_dir, 
                    width=width, 
                    height=height,
                    timeout=timeout
                )
                log_entry["success"] = success
                messages, cleaned_output = parse_openscad_output(output_str)
                log_entry["messages"] = messages
                log_entry["output"] = cleaned_output
                if !isempty(summary_json)
                    try
                        # Parse the JSON into a temporary variable first
                        parsed_summary = JSON.parse(summary_json)
                        
                        # Ensure the parsed data is a dictionary
                        if parsed_summary isa Dict
                            log_entry["summary"] = parsed_summary
                        else
                            @warn("Summary JSON for $scad_file is not a dictionary: $parsed_summary")
                            log_entry["summary"] = Dict("error" => "Invalid summary format")
                        end
                    catch e
                        @warn("Failed to parse summary JSON for $scad_file: $e")
                        log_entry["summary"] = Dict("error" => "JSON parsing failed", "raw" => summary_json)
                    end
                end
            catch e 
                @warn("Could not process $scad_file: $e")
            end
        else
            @info("Skipping $scad_file - no changes detected")
            # Only preserve previous log data if we're not forcing a rebuild
            if !force
                log_entry["success"] = render_log[scad_file]["success"]
                log_entry["output"] = get(render_log[scad_file], "output", "")
                log_entry["messages"] = get(render_log[scad_file], "messages", Dict("WARNING" => String[], "DEPRECATED" => String[], "TRACE" => String[], "ERROR" => String[]))
                log_entry["summary"] = get(render_log[scad_file], "summary", Dict())
            end
        end
        
        # Update the log after each file is processed
        update_render_log(output_dir, render_log, scad_file, log_entry)
    end
end

# Main execution
if abspath(PROGRAM_FILE) == @__FILE__
    args = parse_commandline()
    
    # Convert comma-separated blacklist to array of Strings
    blacklist = String.(split(args["blacklist"], ","))
    
    # Call main function with parsed arguments
    main(
        args["input_dir"],
        output_dir = args["output_dir"],
        width = args["width"],
        height = args["height"],
        blacklist = blacklist,
        timeout = args["timeout"],
        force = args["force"]
    )
end
