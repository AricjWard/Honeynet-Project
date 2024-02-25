﻿$serverName = "44.000.44.000" # SQL Server address
$databaseName = "master" 
$username = "Bogus-User" # username to attempt a login with.
$password = "bad_password_to_generate_auth_failures__"
$max_attempts = 30 # Number of attempts


# Build the connection string using Windows authentication.
$connectionString = "Server=$serverName;Database=$databaseName;Integrated Security=False;User Id=$username;Password=$password;"

$count = 0

while ($count -lt $max_attempts){
    $count++
    try {
        # Pause the script for 2 seconds to allow for processing
        Start-Sleep -Seconds 3

        # Open the connection
        $connection = New-Object System.Data.SqlClient.SqlConnection($connectionString)
        $connection.Open()
    
        # Define the SQL query to execute
        $query = "SELECT * FROM spt_monitor"
    
        # Create a command object and execute the query
        $command = New-Object System.Data.SqlClient.SqlCommand($query, $connection)
        $result = $command.ExecuteReader()
    
        # Process the query results
        while ($result.Read()) {
            Write-Host $result
        }
    
    } catch {
        # Handle any errors that occur
        Write-Host "Error: $($Error[0].Exception.Message)"
    } finally {
        # Close the connection
        if ($connection.State -eq "Open") {
            $connection.Close()
        }
    }
}
