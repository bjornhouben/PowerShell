Function ReverseFileNames($sourcepath,$filefilter)
{
    #Get files in the $sourcepath that match the $filefilter
    $fileswithreversedfilenames = Get-ChildItem -Path $sourcepath -Filter $filefilter

    Foreach($file in $fileswithreversedfilenames) #Process each file matching the filter
    {
        #Get information about the $file
        $filefullpath = $file.FullName
        $fileextension = $file.Extension
        $filebasename = $file.BaseName

        #Reverse the file basename
        $newfilebasename = $filebasename[-1..-($filebasename.length)] -join ''

        #Construct the new file name
        $newfilename = $newfilebasename + $fileextension 

        TRY #Try renaming the file
        {
            Rename-Item $filefullpath -NewName $newfilename -ErrorAction Stop
            Write-Host "Succesfully renamed $filefullpath to $newfilename" -ForegroundColor "Green"
        } #End of Try

        Catch #Catch errors
        {
            Write-Host "Failed to rename $filefulpath to $newfilename" -ForegroundColor "Red"
        } #End of Catch

    } #End of Foreach($file in $fileswithreversedfilenames)
} #End of function ReverseFileNames

#Example reverse the file names for files in "Z:\TV-02" starting with QoQ
ReverseFileNames "Z:\TV-02\" "QoQ*"
