Function New-SimpleGUIForm($FormTitleText,$FormWidth,$FormHeight,$Fieldnames,$fontName,$fontsize,$labelxlocation,$labelyspacing,$textboxxlocation,$textboxyspacing,$labelheight,$labelwidth,$TextboxHeight,$TextboxWidth,$ButtonText,$ButtonHeight,$ButtonWidth)
{
    <#
    This GUI includes only simple checkboxes. More advanced things are possible, but this is beyond the purpose of the script. 
    To get inspiration/help building a GUI with other things like dropdownboxes, checkboxes, etc. take a look at https://poshgui.com 
    
    Also keep in mind that when you leave a field empty, it is an empty string and not a $NULL value. Either convert it to a $NULL value later on or modify the functions you use the GUI for.
    #>

    $i = 0
    $TextboxVariables = @()

    #region Create and configure form
    Add-Type -AssemblyName System.Windows.Forms
    $Form = New-Object system.Windows.Forms.Form 
    $Form.Text = $Formtitletext
    $Form.TopMost = $true
    $Form.Width = $FormWidth
    $Form.Height = $FormHeight
    #endregion Create and configure form"

    Foreach($item in $Fieldnames)
    {
        $NameWithoutSpaces = $item.replace(' ','')

        #Create and configure Label
        $LabelYLocation = (($i+1)*$labelyspacing)
        $Label = New-Object system.windows.Forms.Label
        $Label.Text = $item
        $Label.Width = $labelwidth
        $Label.Height = $labelheight
        $Label.Location = new-object system.drawing.point($labelxlocation,$LabelYLocation)
        $Label.Font = "$FontName,$FontSize"
        $Form.Controls.Add($Label)
        Remove-Variable -Name 'Label'

        #Create and configure Textbox
        $TextBoxVariableName = "Textbox_$NameWithoutSpaces"
        $TextboxVariables += $TextBoxVariableName
        $TextboxYLocation = (($i+1)*$textboxyspacing)
        $Textbox = New-Variable -Name $TextBoxVariableName
        $Textbox = New-Object system.windows.Forms.Textbox
        $Textbox.name = $TextBoxVariableName
        $Textbox.Width = $TextboxWidth
        $Textbox.Height = $TextboxHeight
        $Textbox.Location = new-object system.drawing.point($textboxxlocation,$TextboxYLocation)
        $Textbox.Font = "$FontName,$FontSize"
        $Textbox.TabIndex = $i
        $Form.Controls.Add($Textbox)

        $i++
    }

    #region Create and configure button and actions when clicked

    $ButtonYlocation = (($i+1) *$textboxyspacing)
    $FormButton = New-Object system.windows.Forms.Button 
    $FormButton.Text = $ButtonText
    $FormButton.Width = $ButtonWidth
    $FormButton.Height = $ButtonHeight
    $FormButton.location = new-object system.drawing.point($textboxxlocation,$ButtonYlocation)
    $FormButton.Font = "$FontName,$FontSize,style=Bold"
    $FormButton.tabindex = $i
    $FormButton.Add_Click({ 
        #add here code triggered by the event
        $Form.Close()
    })
    $Form.controls.Add($FormButton)
    Remove-Variable -Name 'FormButton'

    #Show the form
    [void]$Form.ShowDialog()
    
    #Get the names and values of the Textbox controls, store these in a hashtable and output it.
    #The array output is converted to a hashtable to make it more easily accessible.
    $Output = @{}
    $Form.controls | Where-Object{$_.name -match 'Textbox_'} | ForEach-Object{$Output.Add($_.name,$_.text)}  
    $Output
}


#region example

#Define the parameters the function will be run with. In most cases it's sufficient to modify FormTitleText,FieldNames,ButtonText.
$Parameters = @{
    FormTitleText = 'Create new user'
    FieldNames = @('FirstName','LastName','ReferenceUser')
    ButtonText = 'OK'
    FormWidth = 666
    FormHeight = 666
    FontName = 'Microsoft Sans Serif'
    FontSize = 12
    labelxlocation = 25
    textboxxlocation = 380
    labelyspacing = 40
    textboxyspacing = 40
    labelheight = 20
    LabelWidth = 280
    TextboxHeight = 20
    TextboxWidth = 250
    ButtonHeight = 75
    ButtonWidth = 250
}

#Run the function with the defined parameters and store the result in the $result parameter
$Result = New-SimpleGUIForm @Parameters

#Show all texboxes and their values
$Result 

#Get the value of specific textboxes, optionally convert an empty string to $NULL and store the result in a variable to be used later on.
IF($Result.Textbox_FirstName -eq ''){$Firstname = $NULL}ELSE{$Firstname = $Result.textbox_Firstname}
IF($Result.Textbox_LastName -eq ''){$Lastname = $NULL}ELSE{$Lastname = $Result.textbox_Lastname}
IF($Result.Textbox_ReferenceUser -eq ''){$ReferenceUser = $NULL}ELSE{$ReferenceUser = $Result.Textbox_ReferenceUser}

#Optionally verify the values
Write-Output "First name value is : $Firstname"
Write-Output "Last name value is : $Lastname"
Write-Output "Reference user value is : $ReferenceUser"
Write-Output "Reference user value is `$NULL value : $($ReferenceUser -eq $NULL)" #Check if $NULL value
Write-Output "Reference user value is empty string : $($ReferenceUser -eq '')" #Check if empty string

#Use the values for your own functions.
#New-BHUser -Firstname $Firstname -Lastname $Lastname -ReferenceUser $ReferenceUser

#endregion example
