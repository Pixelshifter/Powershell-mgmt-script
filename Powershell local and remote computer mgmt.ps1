﻿function main {
    
    <# clear screen #>
    clear-host
    
    $noip = "TRUE"
    
    <# prompt user #>
    write-host ""
    write-host "########################################################"
    write-host "#                                                      #"
    write-host "#    Welcome, pick a option by pressing the number:    #"
    write-host "#                                                      #"
    write-host "#    1. Get information of remote host                 #"
    write-host "#                                                      #"
    write-host "#    2. Look up local computer information             #"
    write-host "#                                                      #"
    write-host "#    3. Check if a host has network connection         #"
    write-host "#                                                      #"
    write-host "#    4. Exit the application                           #"
    write-host "#                                                      #"
    write-host "########################################################"
    write-host ""
   
    <# call function according to input#>
    
    do { $input = read-host "Pick a number" }       
    until ($input -ge 1 -and $input -le 5)
    
    if ($input -eq 1) { remotesubmenu ($noip) }

    if ($input -eq 2) { hostsubmenu }

    if ($input -eq 3) { checkhostconn }

    if ($input -eq 4) { clear-host exit }
}

<# Remote host function #>
function remotesubmenu ($noip){
    
    <# clear screen #>
    clear-host
    
    if ($noip -eq "TRUE"){
        
        <# check if remote host is up and has Windows installed #>
        $hostaddress = read-host "Please give me an IP address or host name of remote host"
    }  
    
    <# if host is indeed up #>    
    if (test-connection -cn $hostaddress -count 2 -quiet){   
        
        <# clear screen #>
        clear-host
        
        <# prompt user #>
        write-host ""
        write-host "########################################################"
        write-host "#                                                      #"
        write-host "#    Choose an option:                                 #"
        write-host "#                                                      #"
        write-host "#    1. Look up and / or interact with services        #"
        write-host "#                                                      #"
        write-host "#    2. Look up and / or interact with processes       #"
        write-host "#                                                      #"
        write-host "#    3. Current logged in user (if any)                #"
        write-host "#                                                      #"
        write-host "#    4. Show log file entries                          #"
        write-host "#                                                      #"
        write-host "#    5. Go back to main menu                           #"
        write-host "#                                                      #"
        write-host "########################################################"
        write-host ""
        
        <# call function according to input#>
        do { $input = Read-host "Pick a number" }    
        until ($input -ge 1 -and $input -le 5)
            
        if ($input -eq 1) { services }

        if ($input -eq 2) { processes }

        if ($input -eq 3) { currentuser }

        if ($input -eq 4) { eventlog }

        if ($input -eq 5) { main }
            
    } else {

        <# else no valid ip or host name, wait and call function again #>
        clear-host
        
        write-host ""
        write-host "Invalid address / hostname, please try again." -foregroundcolor red
        write-host ""
        
        start-sleep -s 2
        
        remotesubmenu($noip)
    }    
}

<# local host function #>
function hostsubmenu {   
    
    $hostaddress = "localhost"
    
    <# clear screen #>
    clear-host
    
    <# prompt user #>
    write-host ""
    write-host "########################################################"
    write-host "#                                                      #"
    write-host "#    Choose an option:                                 #"
    write-host "#                                                      #"
    write-host "#    1. Look up and / or interact with services        #"
    write-host "#                                                      #"
    write-host "#    2. Look up and / or interact with processes       #"
    write-host "#                                                      #"
    write-host "#    3. Current logged in user(s) (if any)             #"
    write-host "#                                                      #"
    write-host "#    4. Show log file entries                          #"
    write-host "#                                                      #"
    write-host "#    5. Go back to main menu                           #"
    write-host "#                                                      #"
    write-host "########################################################"
    write-host ""
    
    <# call function according to input#>
    do { $input = Read-host "Pick a number" }    
    until ($input -ge 1 -and $input -le 5)
    
    if ($input -eq 1) { services }

    if ($input -eq 2) { processes }

    if ($input -eq 3) { currentuser } 

    if ($input -eq 4) { eventlog }

    if ($input -eq 5) { main }
}

<#service check function #>
function services {
    
    $noip = "FALSE"
    
    <# clear screen #>
    clear-host
    
    <# prompt user #>
    write-host ""
    write-host "####################################################"
    write-host "#                                                  #"
    write-host "#    Choose an option:                             #"
    write-host "#                                                  #"
    write-host "#    1. Show all services                          #"
    write-host "#                                                  #"
    write-host "#    2. Show all stopped services                  #"
    write-host "#                                                  #"
    write-host "#    3. Show all running services                  #"
    write-host "#                                                  #"
    write-host "#    4. Restart / stop / start service             #"
    write-host "#                                                  #"
    write-host "#    5. Go back to host menu                       #"
    write-host "#                                                  #"
    write-host "####################################################"
    write-host ""
    
    <# call function according to input#>
    do { $input = Read-host "Pick a number" }    
    until ($input -ge 1 -and $input -le 5)

    if ($input -eq 1){
       
        <# show all services of host #>
        clear-host
        get-service -cn $hostaddress | sort-object displayname | more
        
        write-host "Press enter to return to previous menu:" -foregroundcolor red
        read-host
        
        services
    }

    if ($input -eq 2){
        
        <# show all stopped services of host #>
        clear-host
        get-service -cn $hostaddress | where {($_.status -eq "stopped")} | sort-object displayname | more
        
        write-host "Press enter to return to previous menu:" -foregroundcolor red
        read-host
        
        services
    }

    if ($input -eq 3){
        
        <# show all running services of host #>
        clear-host
        get-service -cn $hostaddress | where {($_.status -eq "running")} | sort-object displayname | more
                
        write-host "Press enter to return to previous menu:" -foregroundcolor red
        read-host
        
        services
    }

    if ($input -eq 4){
        
        <# Ask user what i have to do with service #>
        clear-host
        write-host "####################################################"
        write-host "#                                                  #"
        write-host "#    Do you want to stop, start                    #"
        write-host "#    or restart a service?                         #"
        write-host "#                                                  #"
        write-host "#    Press the associated number:                  #"
        write-host "#                                                  #"
        write-host "#    1. Restart.       2. Stop.       3. Start.    #"
        write-host "#                                                  #"
        write-host "####################################################"
        write-host ""
 
        do { $input = read-host "Pick a number" }    
        until ($input -ge 1 -and $input -le 3)

        if ($input -eq 2){
            
            $echotype = "Stopping"
            $remservtype = "stopservice"
        }

        if ($input -eq 3){
            
            $echotype = "Starting"
            $remservtype = "startservice"
        }

        write-host ""
        $servicename = read-host "Please give me the service NAME and NOT the DISPLAYNAME"
        write-host "" 

        <# if user asked to restart service #>
        if ($input -eq 1){   
            
            clear-host
            write-host "Stopping service $servicename..."
            invoke-expression "get-wmiobject win32_service -filter `"name='$servicename'`" -computername $hostaddress | invoke-wmimethod -name stopservice | out-null" 
                 
            write-host ""
            write-host "Starting service $servicename..."
            write-host ""    
            invoke-expression "get-wmiobject win32_service -filter `"name='$servicename'`" -computername $hostaddress | invoke-wmimethod -name startservice | out-null"  
        }  
            
        <# else just stop or start #>    
        else {   
            clear-host
            write-host "$echotype service $servicename..."
            write-host ""
            invoke-expression "get-wmiobject win32_service -filter `"name='$servicename'`" -computername $hostaddress | invoke-wmimethod -name $remservtype | out-null"
        }      
        
        start-sleep -s 1

        get-service -cn $hostaddress -name $servicename | ft -auto
        write-host ""
        
        <# Ask user to go to certain menu #>
        write-host "####################################################"
        write-host "#                                                  #"
        write-host "#    To which menu do you want to go?              #"
        write-host "#                                                  #"
        write-host "#    Press the associated number:                  #"
        write-host "#                                                  #"
        write-host "#    1. The main menu.                             #"
        write-host "#                                                  #"
        write-host "#    2. Current host's main menu.                  #"
        write-host "#                                                  #"
        write-host "#    3. Current host's service menu.               #"
        write-host "#                                                  #"
        write-host "#    4. Or... Exit this script.                    #"
        write-host "#                                                  #"
        write-host "####################################################"
        write-host ""
        
        do { $input = read-host "Pick a number" }    
        until ($input -ge 1 -and $input -le 4)
            
        if ($input -eq 1) { main }
        
        if ($input -eq 2) { if ($hostaddress -eq "localhost") { hostsubmenu } else { remotesubmenu ($noip) } }

        if ($input -eq 3) { services }
        
        if ($input -eq 4) { exit } 
    }

    if ($input -eq 5){
        
        if ($hostaddress -eq "localhost") { hostsubmenu } else { remotesubmenu ($noip) }
    } 
}

<#processes check function #>
function processes {
    <# clear screen #>
    clear-host
    
    $noip = "FALSE"
    
    <# prompt user #>
    write-host ""
    write-host "####################################################"
    write-host "#                                                  #"
    write-host "#    Choose an option:                             #"
    write-host "#                                                  #"
    write-host "#    1. Show all processes.                        #"
    write-host "#                                                  #"
    write-host "#    2. Show all processes sorted by CPU usage.    #"
    write-host "#                                                  #"
    write-host "#    3. Show all processes sorted by MEM usage.    #"
    write-host "#                                                  #"
    write-host "#    4. Show all processes sorted by user.         #"
    write-host "#                                                  #"
    write-host "#    5. Kill a process (by process ID).            #"
    write-host "#                                                  #"
    write-host "#    6. Go back to host menu.                      #"
    write-host "#                                                  #"
    write-host "####################################################"
    write-host ""
    
    <# call function according to input#>
    do { $input = read-host "Pick a number" }    
    until ($input -ge 1 -and $input -le 6)
    
    if ($input -eq 1){
        
        <# show all processes of current host #>
        clear-host   
        
        <# if localhost #>
        if ($hostaddress -eq "localhost"){
             
             get-process | where {($_.id -ne 0 -AND $_.id -ne 4)} | select-object -property id, name | sort name | ft -auto | more
        }
        
        else { get-process -cn $hostaddress | where {($_.id -ne 0 -AND $_.id -ne 4)} | select-object -property id, name | sort name | ft -auto | more }    
        
        <# prompt user #>
        write-host "Press enter to return to previous menu:" -foregroundcolor red
        read-host
        
        processes
    }

    if ($input -eq 2){
        
        <# show all processes of current host, sorted by cpu usage #>
        clear-host
      
        <# define output array #>
        $output = @()

        <# inform user #>
        write-host "Busy polling data, one moment please..."
        write-host ""

        <# poll the computer 2 times #>
        for ($i = 1; $i -lt 3; $i ++) {
           
            <# poll computer #>
            $getprocesses = get-wmiobject win32_perfformatteddata_perfproc_process -cn $hostaddress | sort idprocess

            <# assign data to variable #>
            new-variable -name "poll$i" -value $getprocesses

            <# wait one sec for next poll #>
            start-sleep -s 2
        }
        
        <# loop over all processes #>
        for ($i = 0; $i -lt $poll2.length; $i ++){
            
            <# define avarage cpu #>
            $avgcpu = (($poll1[$i].percentprocessortime + $poll2[$i].percentprocessortime) / 2)

            <# assign headers and data #>
            $data = @{
                'PID' = $poll2[$i].idprocess
                'Name'= $poll2[$i].name
                'CPU usage (%)' = [math]::round($avgcpu, 2)
                }

            <# create new object with above data and append it to output variable #>
            $output += new-object -typename pscustomobject -property $data
        } 

        <# show output and do some filtering #>
        clear-host
        $output | where {($_.PID -ne 0 -AND $_.PID -ne 4)} | sort 'CPU usage (%)' -desc | ft -auto | more         

        <# prompt user #>
        write-host "Press enter to return to previous menu:" -foregroundcolor red
        read-host

        processes
    }

    if ($input -eq 3){
        
        <# show all processes of current host, sorted by mem usage (average) #>
        clear-host
   
        <# define output array #>
        $output = @()

        <# inform user #>
        write-host "Busy polling data, one moment please..."
        write-host ""

        <# poll the computer 2 times #>
        for ($i = 1; $i -lt 3; $i ++) {
            
            <# poll computer #>
            $getprocesses = get-wmiobject win32_perfformatteddata_perfproc_process -cn $hostaddress | sort idprocess

            <# assign data to variable #>
            new-variable -name "poll$i" -value $getprocesses

            <# wait one sec for next poll #>
            start-sleep -s 2
        }
        
        <# loop over all processes #>
        for ($i = 0; $i -lt $poll2.length; $i ++){
           
            <# define avarage mem #>
            $avgmem = (($poll1[$i].workingsetprivate + $poll2[$i].workingsetprivate) / 2)

            <# store header and data in hashtable #>
            $data = @{
                'PID' = $poll2[$i].idprocess
                'Name'= $poll2[$i].name
                'Memory usage (MB)' = [math]::round($avgmem / 1mb, 2)
                }

            <# create new object with above data and append it to output variable #>
            $output += new-object -typename pscustomobject -property $data
        } 

        <# show output and do some filtering #>
        clear-host
        $output | where {($_.PID -ne 0 -AND $_.PID -ne 4)} | sort 'Memory usage (MB)' -desc | ft -auto | more
           
        <# prompt user #>
        write-host "Press enter to return to previous menu:" -foregroundcolor red
        read-host

        processes
    }

    if ($input -eq 4){
        
        <# show all processes of current host, sorted by user owning the process #>
        clear-host
      
        <# define output array #>
        $output = @()

        <# inform user #>
        write-host "Busy polling data, one moment please..."
        write-host ""

        <# execute command  #>
        $poll = get-wmiobject win32_process -cn $hostaddress

        <# loop over all processes #>
        for ($i = 0; $i -lt $poll.length; $i ++){    
            
            <# dont get system and idle process #>
            if ($poll[$i].processid -ne 4 -AND $poll[$i].processid -ne 0){
                
                <# store header and data in hashtable #>
                $data = @{          
                    'Name'= $poll[$i].processname
                    'User' = $poll[$i].getowner().user
                    'PID' = $poll[$i].processid
                    'Domain' = $poll[$i].getowner().domain
                    }

                <# create new object with above data and append it to output variable #>
                $output += new-object -typename pscustomobject -property $data
            }        
        } 

        <# define how to sort #>
        $sort1 = @{ expression = 'PID'; Ascending = $true }
        $sort2 = @{ expression = 'Domain'; Descending = $true }
        $sort3 = @{ expression = 'User'; Descending = $true }

        <# show output and do some filtering and sorting #>
        clear-host
        $output | select-object PID, Name, Domain, User | sort $sort2, $sort1, $sort3 | ft -auto | more

        <# prompt user #>
        write-host "Press enter to return to previous menu:" -foregroundcolor red
        read-host 
        
        processes
    }
    
    if ($input -eq 5){
        
        <# kill process by PID #>
        clear-host
        write-host ""

        <# prompt user #>
        do { $processid = read-host "Please give me the process ID" }
        until ($processid -ne "") 

        <# check if process PID exists #>
        $process = get-wmiobject win32_process -computername $hostaddress -filter "processid = '$processid'" -erroraction 'silentlycontinue'
        $processname = $process.processname

        <# if there is no process found with given PID #>
        if (!$process){
           
            write-host ""
            write-host There is no process running on $hostaddress with this PID!
            write-host ""
            write-host "Press enter to return to previous menu:" -foregroundcolor red
            read-host
        
            processes

        } else {

            write-host ""
            write-host "Killing process $processname..."
            write-host ""

            <# invoke method to kill process #>
            $result = invoke-wmimethod -path $process.__path -name terminate

            <# execute #>
            $result | out-null
            
            <# on success #>
            if ($result.returnvalue -eq 0){ 
                
                write-host "Process killed succesfully!" 
                write-host "" 

            } else {

                write-host "Something went wrong killing your process."
                write-host "Are you running this script without admin rights?" 
                write-host ""
            }

            start-sleep -s 1
        
            <# Ask user to go to certain menu #>
            write-host "####################################################"
            write-host "#                                                  #"
            write-host "#    To which menu do you want to go?              #"
            write-host "#                                                  #"
            write-host "#    Press the associated number:                  #"
            write-host "#                                                  #"
            write-host "#    1. The main menu.                             #"
            write-host "#                                                  #"
            write-host "#    2. Current host's main menu.                  #"
            write-host "#                                                  #"
            write-host "#    3. Current host's process menu.               #"
            write-host "#                                                  #"
            write-host "#    4. Or... Exit this script.                    #"
            write-host "#                                                  #"
            write-host "####################################################"
            write-host ""
        
            Do {$input = read-host "Pick a number"}    
            until ($input -ge 1 -and $input -le 4)
            
            if ($input -eq 1) { main }
        
            if ($input -eq 2) { if ($hostaddress -eq "localhost") { hostsubmenu } else { remotesubmenu ($noip) } }

            if ($input -eq 3) { processes }
        
            if ($input -eq 4) { exit } 
        }  
    }
    
    if ($input -eq 6){
        
        if ($hostaddress -eq "localhost") { hostsubmenu } else { remotesubmenu ($noip) }
    } 
}

<#event log function #>
function eventlog {
   
    <# clear screen #>
    clear-host
    
    $noip = "FALSE"

    <# if days not has been set #>
    if (!$days){
        
        <# ask user from how far in the past i have to get data #>
        write-host "Please tell me how many days I should look in the past"

        do { $days = read-host "Pick a number positive number (1 or higher. Maximum 30 days)" }    
        until ($days -ge 1 -and [int]$days -le 30)
    }

    <# clear screen #>
    clear-host

    <# prompt user #>
    write-host ""
    write-host "####################################################################"
    write-host "#                                                                  #"
    write-host "#    Choose an option:                                             #"
    write-host "#                                                                  #"
    write-host "#    1. Show all error & critical messages from the past x days.   #"
    write-host "#                                                                  #"
    write-host "#    2. Show all warning messages from past x days.                #"
    write-host "#                                                                  #"
    write-host "#    3. Show all log file entries from the past X days.            #"
    write-host "#                                                                  #"
    write-host "#    4. Show all system logs from past X days.                     #"
    write-host "#                                                                  #"
    write-host "#    5. Show all application logs from past X days.                #"
    write-host "#                                                                  #"
    write-host "#    6. Show all setup logs from past X days.                      #"
    write-host "#                                                                  #"
    write-host "#    7. Show all logs from specific source.                        #"
    write-host "#                                                                  #"
    write-host "#    8. Show all logs with a specific event ID.                    #"
    write-host "#                                                                  #"
    write-host "#    9. Change x amount of days.                                   #"
    write-host "#                                                                  #"
    write-host "#    10. Go back to host menu.                                     #"
    write-host "#                                                                  #"
    write-host "####################################################################"
    write-host ""
    
    <# call function according to input#>
    do { $input = read-host "Pick a number" } 
    <# append $input with [int] because of two digits #>   
    until ($input -ge 1 -and [int]$input -le 10)
    
    <# set maximum history according to user input #>
    $history = (((get-date).adddays(-$days)).date)

    if ($input -eq 1){
        
        <# clear screen #>
        clear-host

        <# create filterhashtable #>
        $filter = @{

            <# how many days in the past we may look #>
            starttime = $history;

            <# only error and critical events #>
            level = @(1, 2);

            <# search all logs #>
            logname = "*"
            }

        <# store results in variable #>
        $events = get-winevent -cn $hostaddress -filterhashtable $filter
       
        <# call function to view event logs #>
        showeventlogs ($events)
    }

    if ($input -eq 2){
        
        <# clear screen #>
        clear-host

        <# create filterhashtable #>
        $filter = @{

            <# how many days in the past we may look #>
            starttime = $history;
            
            <# which logs we look into #>
            logname = @("system","application");

            <# only warning events #>
            level = 3;
            }
      
        <# store results in variable #>
        $events = get-winevent -cn $hostaddress -filterhashtable $filter
       
        <# call function to view event logs #>
        showeventlogs ($events)
    }

    if ($input -eq 3){
        
        <# clear screen #>
        clear-host

        <# create filterhashtable #>
        $filter = @{

            <# how many days in the past we may look #>
            starttime = $history;

            <# search all logs #>
            logname = "*";

            <# all log levels #>
            level = @(1, 2, 3);
            }
     
        <# store results in variable #>
        $events = get-winevent -cn $hostaddress -filterhashtable $filter 
       
        <# call function to view event logs #>
        showeventlogs ($events)

    }

    if ($input -eq 4){
        
        <# clear screen #>
        clear-host

        <# create filterhashtable #>
        $filter = @{

            <# how many days in the past we may look #>
            starttime = $history;

            <# which logs we look into #>
            logname = "system";

            <# all log levels #>
            level = @(1, 2, 3);
            }
     
        <# store results in variable #>
        $events = get-winevent -cn $hostaddress -filterhashtable $filter
       
        <# call function to view event logs #>
        showeventlogs ($events)
    }

    if ($input -eq 5){
        
        <# clear screen #>
        clear-host

        <# create filterhashtable #>
        $filter = @{

            <# how many days in the past we may look #>
            starttime = $history;

            <# which logs we look into #>
            logname = "application";

            <# all log levels #>
            level = @(1, 2, 3);
            }
     
        <# store results in variable #>
        $events = get-winevent -cn $hostaddress -filterhashtable $filter
       
        <# call function to view event logs #>
        showeventlogs ($events)
    }

    if ($input -eq 6){
        
        <# clear screen #>
        clear-host

        <# create filterhashtable #>
        $filter = @{

            <# how many days in the past we may look #>
            starttime = $history;

            <# which logs we look into #>
            logname = "setup";

            <# all log levels #>
            level = @(1, 2, 3);
            }
     
        <# store results in variable #>
        $events = get-winevent -cn $hostaddress -filterhashtable $filter
       
        <# call function to view event logs #>
        showeventlogs ($events)
    }

    if ($input -eq 7){
        
        clear-host

        $source = read-host "Please give me a source name"

         <# create filterhashtable #>
        $filter = @{

            <# how many days in the past we may look #>
            starttime = $history; 
            
            <# search all logs #>
            logname = "*";

            <# take input as providername #>
            providername = $source        
            }

        <# store results in variable #>
        $events = get-winevent -cn $hostaddress -filterhashtable $filter
  
        <# call function to view event logs #>
        showeventlogs ($events)   
    }

    if ($input -eq 8){
        
         clear-host

        $eventid = read-host "Please give me an event ID"
        write-host ""

        <# create filterhashtable #>
        $filter = @{

            <# how many days in the past we may look #>
            starttime = $history;

            <# take as id the input from user #>
            id = $eventid;
             
            <# search all logs #>
            logname = "*"
            }    

        <# store results in variable #>
        $events = get-winevent -cn $hostaddress -filterhashtable $filter

        <# call function to view event logs #>
        showeventlogs ($events)       
    }

    if ($input -eq 9){

        <# ask user from how far in the past i have to get data #>
        clear-host
        write-host "Please tell me how many days I should look in the past"
        write-host ""

        do { $days = read-host "Pick a number positive number (1 or higher. Maximum 30 days)" }    
        until ($days -ge 1 -and $days -le 30)

        write-host ""
        write-host "Days changed to: $days." -foregroundcolor green
        sleep -s 2

        <# call function again #>
        eventlog
    }

    if ($input -eq 10){ if ($hostaddress -eq "localhost") { hostsubmenu } else { remotesubmenu ($noip) }}
}

<# get logged in user(s) (if any) #>
function currentuser {
    
    <# clear screen #>
    clear-host
    
    $noip = "FALSE"

    <# get wmiobject computersystem #>
    # $object = get-wmiobject -cn $hostaddress -class win32_computersystem
    $users = invoke-expression "query user /server:$hostaddress"

    <# seeing as we got an object, we can access the username property #>
    if (!$users) {
        
        write-host ""
        write-host "There is no one logged in on $hostaddress." -foregroundcolor red
    
    } else {

        <# show table with users #>
        write-host "Hostname: $hostaddress"
        write-host ""
        $users
    }
  
    write-host ""
    write-host "Press enter to return to previous menu:" -foregroundcolor red
    read-host

    if ($hostaddress -eq "localhost") { hostsubmenu } else { remotesubmenu ($noip) }
}

<# check if host is up #>
function checkhostconn {
    
    <# clear screen #>
    clear-host

    <# check if remote host is up and has Windows installed #>
    $hostaddress = read-host "Please give me an IP address or host name of remote host"

    write-host ""

    if (test-connection -cn $hostaddress -count 2 -quiet) {
    
        write-host "This host is up!" -foregroundcolor green

    } else {
    
        write-host "This host is down or does not exist!" -foregroundcolor red
    }

    write-host ""
    write-host "Press enter to return to previous menu:" -foregroundcolor red
    read-host

    <# call main function #>
    main
}

<#####################################################################################

MISC FUNCTIONS 

#####################################################################################>

<# function to view event logs depending on which host this script is being run #>
function showeventlogs($events) {
    
    <# execute command with out-gridview #>
    try {

        if ($events){

            $events | out-gridview

        } else {

            write-host "There were no events with these properties."
            write-host ""
        }

    <# if went wrong, script is being ran on Core server (no GUI) then just output results in terminal screen it self #>
    } catch {

        $events | ft -auto -wrap

    <# finally prompt the user #>
    } finally {
        
        write-host "Press enter to return to previous menu:" -foregroundcolor red
        read-host

        <# call eventlog function again #>
        eventlog 
    }
}

<#####################################################################################

BEGIN SCRIPT, check if we are running with proper credentials

#####################################################################################>



<# let me handle errors my self #>
$erroractionpreference = "silentlycontinue"

<# call the main function to start script #>
main
  
