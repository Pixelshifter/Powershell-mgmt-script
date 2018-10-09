# Powershell-mgmt-script

## Background:
This is an interactive management script written in Powershell. The reason for this script was that I was managing a increasing bigger fleet of core-servers. Managing them through MMC became a pain, especially when checking log files on remote hosts.

## Features:

- Checking the network connection of a remote host (like ping but integrated in the script)
- All listed features can be run on the local AND remote hosts
- Stopping, starting, restarting & showing services
- Stopping & showing processes
- Show current logged in users (if any)
- Show log files based on the following criteria:
    - Shows logs based on how many days from today you want to look in the past
    - Shows logs based on impact (ERR, CRIT, WARN etc.)
    - Shows logs based on default sources (System, Security, Application)
    - Shows logs based on a specific source and / or event-ID (which can be user-supplied)
    - Or any combination of the above

    *Note: The log-module works on both GUI and Core OS'es. Depending on which OS you run, the logmodule will output everything in a seperate window OR in the powershell console itself. 

## Instructions

1. Make sure you have the proper credentials to run this script locally, but also to gather information about remote hosts.
2. Run the script and use the numbers to access any given function.
